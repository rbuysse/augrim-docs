---
tags: [Mermaid]
mermaid: true
---

# ETAOIN SHRDLU

Quis autem vel eum iure reprehenderit, qui in ea voluptate velit esse, quam 
nihil molestiae consequatur, vel illum, qui dolorem eum fugiat, quo voluptas 
nulla pariatur?

<div class="mermaid">
sequenceDiagram
    participant CE as Coordinator Component
    participant C as Coordinator Algorithm
    participant P as Participant Algorithm
    participant PE as Participant Component


    CE->>+C: Start(value)
    rect rgb(180, 200, 255)
    Note over C,P: Vote Phase
    C->>+P: VoteRequest(epoch, value)
    P->>+PE: RequestForVote(value)
    PE-->>-P: Vote(vote=true)
    P-->>-C: VoteResponse(epoch, vote=true)
    end
    rect rgb(180, 200, 255)
    Note over C, P: Commit Phase
    C->>+CE: RequestForVote()
    CE-->>-C: Vote(vote=true)
    C->>P: Commit(epoch)
    end
    C-->>-CE: RequestForStart()
</div>
