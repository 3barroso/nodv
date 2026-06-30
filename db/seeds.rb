# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create Audience Type objects
puts "~~~~~~ Creating Audience Type Objects ~~~~~~"
[ 'Family', 'Friend', 'Self', 'Case Manager' ].each do |type|
  AudienceType.find_or_create_by!(name: type)
end

# ==============================================================================
# USERS AND AUTHORS
# ==============================================================================

puts "~~~~~~ Creating Users and Authors ~~~~~~"

users_data = [
  { email: "admin@nodv.org", password: "hello", admin: true, authors: [ "Admin Author" ] },
  { email: "sarah@nodv.org", password: "password123", admin: false, authors: [ "Sarah Mitchell", "S. M. Writer" ] },
  { email: "james@nodv.org", password: "password123", admin: false, authors: [ "James Chen", "J.C. Resources" ] },
  { email: "maya@nodv.org", password: "password123", admin: false, authors: [ "Maya Patel" ] },
  { email: "david@nodv.org", password: "password123", admin: false, authors: [ "David Thompson", "D. T. Contributor" ] }
]

users = {}
users_data.each do |user_data|
  email = user_data[:email]
  user = User.find_or_create_by!(email: email) do |u|
    u.password = user_data[:password]
    u.password_confirmation = user_data[:password]
    u.admin = user_data[:admin]
  end

  users[email] = user

  # Create authors for this user
  user_data[:authors].each_with_index do |pen_name, index|
    author = user.authors.find_or_create_by!(pen_name: pen_name) do |a|
      a.primary = (index == 0) # First author is primary
      a.information = "Author bio for #{pen_name}"
    end
  end

  puts "  ✓ Created user: #{email} with #{user_data[:authors].length} author(s)"
end

# ==============================================================================
# PHASES AND SUB-PHASES
# ==============================================================================

puts "~~~~~~ Creating Phases and Sub-Phases ~~~~~~"

phase_data = [
  {
    name: "Phase 1: Foundation",
    description: "Building the foundational knowledge and skills",
    sub_phases: [
      { name: "Sub-Phase 1.1: Introduction", description: "Getting started with basics" },
      { name: "Sub-Phase 1.2: Core Concepts", description: "Understanding key principles" }
    ]
  },
  {
    name: "Phase 2: Assessment",
    description: "Evaluating current status and needs",
    sub_phases: [
      { name: "Sub-Phase 2.1: Initial Assessment", description: "Baseline evaluation" },
      { name: "Sub-Phase 2.2: Needs Analysis", description: "Identifying specific requirements" }
    ]
  },
  {
    name: "Phase 3: Planning",
    description: "Strategic planning and goal setting",
    sub_phases: [
      { name: "Sub-Phase 3.1: Goal Definition", description: "Setting clear objectives" },
      { name: "Sub-Phase 3.2: Strategy Development", description: "Creating action plans" },
      { name: "Sub-Phase 3.3: Resource Allocation", description: "Assigning resources and timeline" }
    ]
  },
  {
    name: "Phase 4: Implementation",
    description: "Putting plans into action",
    sub_phases: [
      { name: "Sub-Phase 4.1: Execution", description: "Executing the plan" },
      { name: "Sub-Phase 4.2: Monitoring", description: "Tracking progress" }
    ]
  },
  {
    name: "Phase 5: Learning",
    description: "Building knowledge and skills",
    sub_phases: [
      { name: "Sub-Phase 5.1: Training", description: "Formal training activities" },
      { name: "Sub-Phase 5.2: Skill Development", description: "Hands-on skill building" },
      { name: "Sub-Phase 5.3: Knowledge Sharing", description: "Collaborative learning" }
    ]
  },
  {
    name: "Phase 6: Support",
    description: "Providing guidance and assistance",
    sub_phases: [
      { name: "Sub-Phase 6.1: Ongoing Support", description: "Regular assistance and guidance" },
      { name: "Sub-Phase 6.2: Mentoring", description: "One-on-one mentoring" }
    ]
  },
  {
    name: "Phase 7: Evaluation",
    description: "Assessing outcomes and results",
    sub_phases: [
      { name: "Sub-Phase 7.1: Progress Review", description: "Reviewing milestones achieved" },
      { name: "Sub-Phase 7.2: Impact Assessment", description: "Measuring overall impact" },
      { name: "Sub-Phase 7.3: Feedback Collection", description: "Gathering feedback for improvement" }
    ]
  },
  {
    name: "Phase 8: Integration",
    description: "Integrating learning and achievements",
    sub_phases: [
      { name: "Sub-Phase 8.1: Documentation", description: "Recording lessons learned" },
      { name: "Sub-Phase 8.2: Integration", description: "Integrating into daily practice" }
    ]
  },
  {
    name: "Phase 9: Sustainability",
    description: "Ensuring long-term success",
    sub_phases: [
      { name: "Sub-Phase 9.1: Maintenance", description: "Maintaining progress and skills" },
      { name: "Sub-Phase 9.2: Continuous Improvement", description: "Ongoing enhancement" }
    ]
  },
  {
    name: "Phase 10: Reflection & Closure",
    description: "Reflecting on the journey and closing the cycle",
    sub_phases: [
      { name: "Sub-Phase 10.1: Reflection", description: "Reflecting on experiences and growth" },
      { name: "Sub-Phase 10.2: Closure", description: "Concluding the process" }
    ]
  }
]

phases = {}
phase_data.each do |phase_info|
  phase = Phase.find_or_create_by!(name: phase_info[:name]) do |p|
    p.description = phase_info[:description]
    p.summary = phase_info[:description].truncate(100)
  end
  phases[phase.name] = phase

  # Create sub-phases
  phase_info[:sub_phases].each do |sub_info|
    sub_phase = Phase.find_or_create_by!(name: sub_info[:name], parent_id: phase.id) do |p|
      p.description = sub_info[:description]
      p.summary = sub_info[:description].truncate(100)
    end
  end

  puts "  ✓ Created phase: #{phase.name} with #{phase_info[:sub_phases].length} sub-phases"
end

# ==============================================================================
# RESOURCES
# ==============================================================================

puts "~~~~~~ Creating Resources ~~~~~~"

resource_names = [
  "Getting Started Guide",
  "Best Practices Handbook",
  "Case Study: Success Story",
  "Quick Reference Card",
  "Video Tutorial Series",
  "Interactive Worksheet",
  "Assessment Tool",
  "Implementation Checklist",
  "FAQ Document",
  "Resource Library Index"
]

audience_types = AudienceType.all

resource_count = 0
users.each do |email, user|
  user.authors.each do |author|
    # Each author creates 5-10 resources
    num_resources = rand(5..10)

    num_resources.times do |i|
      resource_name = "#{resource_names[i % resource_names.length]} - #{author.pen_name}"

      resource = Resource.find_or_create_by!(name: resource_name, author_id: author.id) do |r|
        r.description = "A comprehensive resource created by #{author.pen_name} covering important information and guidance."
        r.status = Resource.statuses[:published]
      end

      # Assign to random phases and sub-phases
      phases_to_assign = Phase.all.sample(rand(2..4))
      phases_to_assign.each do |phase|
        PhaseResource.find_or_create_by!(phase_id: phase.id, resource_id: resource.id)
      end

      # Assign to random audience types
      audience_types_to_assign = audience_types.sample(rand(1..3))
      audience_types_to_assign.each do |audience_type|
        ResourceAudienceType.find_or_create_by!(resource_id: resource.id, audience_type_id: audience_type.id)
      end

      resource_count += 1
    end

    puts "  ✓ Created #{num_resources} resources for author: #{author.pen_name}"
  end
end

# ==============================================================================
# SUMMARY
# ==============================================================================

puts "\n~~~~~~ Seed Data Summary ~~~~~~"
puts "✓ Users: #{User.count}"
puts "✓ Authors: #{Author.count}"
puts "✓ Phases: #{Phase.where(parent_id: nil).count} top-level, #{Phase.where.not(parent_id: nil).count} sub-phases"
puts "✓ Resources: #{Resource.count}"
puts "✓ Phase Resources: #{PhaseResource.count}"
puts "✓ Audience Types: #{AudienceType.count}"
puts "✓ Resource Audience Types: #{ResourceAudienceType.count}"
puts "\n✅ Seed data successfully loaded!"
