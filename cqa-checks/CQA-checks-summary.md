# CQA checks summary
Created 2025-07-27

**File checks**

- Content type attribute missing or invalid
- ID missing
- Title longer than 10 words found
- '= ' header not followed by blank line
- Admonition with title found
- Image without description found

**Assembly checks**

- More than one '= ' header found
- '=== ' header found
- Block title ('.Text') found
- Nested assembly conditions
  - 'ifdef::context[:parent-context: {context}]' missing
  - 'ifdef::parent-context[:context: {parent-context}]' missing
  - 'ifndef::parent-context[:!context:]' missing

**Procedure module checks**

- '== ' header found
- Procedure longer than 10 steps foun
- Block title other than Prerequisites, Procedure, Troubleshooting, Next steps, Additional resources, or Verification found
- More than one procedure found
- Invalid Procedure title found
- Procedure not followed by list found

**Concept and reference module checks**

- Block title other than 'Next steps' or 'Additional resources' found
- '=== ' header found
