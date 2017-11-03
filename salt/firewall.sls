
iptables-persistent:
  pkg:
    - installed

ssh port:
  iptables.insert:
    - position: 1
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - match: state
    - connstate: NEW
    - dport: 22
    - proto: tcp
    - save: True

loopback:
  iptables.insert:
    - position: 2
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - in-interface: lo
    - save: True

http ports:
  iptables.insert:
    - position: 3
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - match:
        - state
        - multiport
    - connstate: NEW
    - dport: 80,443
    - proto: tcp
    - save: True

allow established:
  iptables.append:
    - table: filter
    - chain: INPUT
    - match: state
    - connstate: ESTABLISHED
    - jump: ACCEPT

default to reject:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: REJECT


