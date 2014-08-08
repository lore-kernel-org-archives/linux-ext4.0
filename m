From: TR Reardon <thomas_reardon@hotmail.com>
Subject: journal recovery problems with metadata_csum, *non-64bit*
Date: Fri, 8 Aug 2014 15:31:12 -0400
Message-ID: <BLU436-SMTP84585FAA628776E190822AFDEE0@phx.gbl>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="20cf303a32f3e7637005002341a0"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from blu004-omc1s12.hotmail.com ([65.55.116.23]:59969 "EHLO
	BLU004-OMC1S12.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751061AbaHHThD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Aug 2014 15:37:03 -0400
Received: by mail-yk0-f174.google.com with SMTP id q9so4215240ykb.19
        for <linux-ext4@vger.kernel.org>; Fri, 08 Aug 2014 12:31:53 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--20cf303a32f3e7637005002341a0
Content-Type: text/plain; charset="UTF-8"

Kernel 3.16, e2fsprogs 1.43-WIP (1.42.11 compiled with metadata_csum
support), filesystems mounted with journal_async_commit.

This may be an fsck problem, hard to tell.  I consistently have
problems with journal recovery after hard reboot when filesystem has
metadata_csum.   Interestingly, no problems with 64-bit filesystems.

during journal replay, bogus block numbers are reported.  in this
case, a 128MB file was deleted on two filesystems where the only
difference is 64bit vs non-64bit.  This also happens with or without
bigalloc, though I only document bigalloc case here.

please see attached superblocks, dumped just prior to hard reboot.
disk8=sdm1, disk9=sdn1

dmesg:

[Fri Aug  8 15:16:28 2014] JBD2: Out of memory during recovery.
[Fri Aug  8 15:16:28 2014] JBD2: recovery failed
[Fri Aug  8 15:16:28 2014] EXT4-fs (sdm1): error loading journal
[Fri Aug  8 15:16:27 2014] EXT4-fs (sdn1): recovery complete
[Fri Aug  8 15:16:27 2014] EXT4-fs (sdn1): mounted filesystem with
ordered data mode. Opts: journal_async_commit


fsck:

#e2fsck -f -v /dev/sdm1
e2fsck 1.43-WIP (09-Jul-2014)
disk8: recovering journal
Error writing block 549755813991 (Invalid argument).  Ignore error<y>? yes
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Free blocks count wrong (11332304, counted=11365072).
Fix<y>? yes
Free inodes count wrong (177287, counted=177288).
Fix<y>? yes

disk8: ***** FILE SYSTEM WAS MODIFIED *****

        1656 inodes used (0.93%, out of 178944)
         260 non-contiguous files (15.7%)
           0 non-contiguous directories (0.0%)
             # of inodes with ind/dind/tind blocks: 0/0/0
             Extent depth histogram: 1280/363/5
   721201312 blocks used (98.45%, out of 732566384)
           0 bad blocks
         358 large files

        1267 regular files
         380 directories
           0 character device files
           0 block device files
           0 fifos
           0 links
           0 symbolic links (0 fast symbolic links)
           0 sockets
------------
        1647 files

--20cf303a32f3e7637005002341a0
Content-Type: application/octet-stream; name="disk8-dumpe2fs-postrm"
Content-Disposition: attachment; filename="disk8-dumpe2fs-postrm"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hylwn89n0

RmlsZXN5c3RlbSB2b2x1bWUgbmFtZTogICBkaXNrOApMYXN0IG1vdW50ZWQgb246ICAgICAgICAg
IC9tbnQvZGlzazgKRmlsZXN5c3RlbSBVVUlEOiAgICAgICAgICAwZGY4ODJhNS0xZGY2LTRkNTEt
YjAzNy1jMTMyZTMwOGUzNDEKRmlsZXN5c3RlbSBtYWdpYyBudW1iZXI6ICAweEVGNTMKRmlsZXN5
c3RlbSByZXZpc2lvbiAjOiAgICAxIChkeW5hbWljKQpGaWxlc3lzdGVtIGZlYXR1cmVzOiAgICAg
IGhhc19qb3VybmFsIGV4dF9hdHRyIHJlc2l6ZV9pbm9kZSBkaXJfaW5kZXggZmlsZXR5cGUgbmVl
ZHNfcmVjb3ZlcnkgZXh0ZW50IGZsZXhfYmcgc3BhcnNlX3N1cGVyIGxhcmdlX2ZpbGUgaHVnZV9m
aWxlIGRpcl9ubGluayBleHRyYV9pc2l6ZSBiaWdhbGxvYyBtZXRhZGF0YV9jc3VtCkZpbGVzeXN0
ZW0gZmxhZ3M6ICAgICAgICAgc2lnbmVkX2RpcmVjdG9yeV9oYXNoIApEZWZhdWx0IG1vdW50IG9w
dGlvbnM6ICAgIHVzZXJfeGF0dHIgYWNsCkZpbGVzeXN0ZW0gc3RhdGU6ICAgICAgICAgY2xlYW4K
RXJyb3JzIGJlaGF2aW9yOiAgICAgICAgICBDb250aW51ZQpGaWxlc3lzdGVtIE9TIHR5cGU6ICAg
ICAgIExpbnV4Cklub2RlIGNvdW50OiAgICAgICAgICAgICAgMTc4OTQ0CkJsb2NrIGNvdW50OiAg
ICAgICAgICAgICAgNzMyNTY2Mzg0ClJlc2VydmVkIGJsb2NrIGNvdW50OiAgICAgMApGcmVlIGJs
b2NrczogICAgICAgICAgICAgIDExMzMyMzA0CkZyZWUgaW5vZGVzOiAgICAgICAgICAgICAgMTc3
Mjg3CkZpcnN0IGJsb2NrOiAgICAgICAgICAgICAgMApCbG9jayBzaXplOiAgICAgICAgICAgICAg
IDQwOTYKQ2x1c3RlciBzaXplOiAgICAgICAgICAgICA2NTUzNgpSZXNlcnZlZCBHRFQgYmxvY2tz
OiAgICAgIDUzCkJsb2NrcyBwZXIgZ3JvdXA6ICAgICAgICAgNTI0Mjg4CkNsdXN0ZXJzIHBlciBn
cm91cDogICAgICAgMzI3NjgKSW5vZGVzIHBlciBncm91cDogICAgICAgICAxMjgKSW5vZGUgYmxv
Y2tzIHBlciBncm91cDogICA4CkZsZXggYmxvY2sgZ3JvdXAgc2l6ZTogICAgMTYKRmlsZXN5c3Rl
bSBjcmVhdGVkOiAgICAgICBUdWUgSmFuIDE1IDE3OjE4OjA3IDIwMTMKTGFzdCBtb3VudCB0aW1l
OiAgICAgICAgICBGcmkgQXVnICA4IDE0OjQ2OjAxIDIwMTQKTGFzdCB3cml0ZSB0aW1lOiAgICAg
ICAgICBGcmkgQXVnICA4IDE0OjQ2OjAxIDIwMTQKTW91bnQgY291bnQ6ICAgICAgICAgICAgICAx
Ck1heGltdW0gbW91bnQgY291bnQ6ICAgICAgLTEKTGFzdCBjaGVja2VkOiAgICAgICAgICAgICBG
cmkgQXVnICA4IDE0OjQzOjU4IDIwMTQKQ2hlY2sgaW50ZXJ2YWw6ICAgICAgICAgICAwICg8bm9u
ZT4pCkxpZmV0aW1lIHdyaXRlczogICAgICAgICAgNjAyMiBHQgpSZXNlcnZlZCBibG9ja3MgdWlk
OiAgICAgIDAgKHVzZXIgcm9vdCkKUmVzZXJ2ZWQgYmxvY2tzIGdpZDogICAgICAwIChncm91cCBy
b290KQpGaXJzdCBpbm9kZTogICAgICAgICAgICAgIDExCklub2RlIHNpemU6CSAgICAgICAgICAy
NTYKUmVxdWlyZWQgZXh0cmEgaXNpemU6ICAgICAyOApEZXNpcmVkIGV4dHJhIGlzaXplOiAgICAg
IDI4CkpvdXJuYWwgaW5vZGU6ICAgICAgICAgICAgOApEZWZhdWx0IGRpcmVjdG9yeSBoYXNoOiAg
IGhhbGZfbWQ0CkRpcmVjdG9yeSBIYXNoIFNlZWQ6ICAgICAgZTBmNDZjMTAtZWNlNi00M2E0LTk0
NjktYzBkODlkNjQ0YjBmCkpvdXJuYWwgYmFja3VwOiAgICAgICAgICAgaW5vZGUgYmxvY2tzCkNo
ZWNrc3VtIHR5cGU6ICAgICAgICAgICAgY3JjMzJjCkNoZWNrc3VtOiAgICAgICAgICAgICAgICAg
MHhmYTQ5MDQxNQpKb3VybmFsIGZlYXR1cmVzOiAgICAgICAgIGpvdXJuYWxfaW5jb21wYXRfcmV2
b2tlIGpvdXJuYWxfYXN5bmNfY29tbWl0IGpvdXJuYWxfY2hlY2tzdW1fdjIKSm91cm5hbCBzaXpl
OiAgICAgICAgICAgICAxMjhNCkpvdXJuYWwgbGVuZ3RoOiAgICAgICAgICAgMzI3NjgKSm91cm5h
bCBzZXF1ZW5jZTogICAgICAgICAweDAwMDAwMDdmCkpvdXJuYWwgc3RhcnQ6ICAgICAgICAgICAg
MQpKb3VybmFsIGNoZWNrc3VtIHR5cGU6ICAgIGNyYzMyYwpKb3VybmFsIGNoZWNrc3VtOiAgICAg
ICAgIDB4Y2ZiN2I0NWUKCg==
--20cf303a32f3e7637005002341a0
Content-Type: application/octet-stream; name="disk9-dumpe2fs-postrm"
Content-Disposition: attachment; filename="disk9-dumpe2fs-postrm"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hylwn8a01

RmlsZXN5c3RlbSB2b2x1bWUgbmFtZTogICBkaXNrOQpMYXN0IG1vdW50ZWQgb246ICAgICAgICAg
IC9tbnQvZGlzazkKRmlsZXN5c3RlbSBVVUlEOiAgICAgICAgICAxMTM5OTE4My00ZjQyLTRiMTQt
OGI1ZC0zN2NiZGEzOGIwMjkKRmlsZXN5c3RlbSBtYWdpYyBudW1iZXI6ICAweEVGNTMKRmlsZXN5
c3RlbSByZXZpc2lvbiAjOiAgICAxIChkeW5hbWljKQpGaWxlc3lzdGVtIGZlYXR1cmVzOiAgICAg
IGhhc19qb3VybmFsIGV4dF9hdHRyIGRpcl9pbmRleCBmaWxldHlwZSBuZWVkc19yZWNvdmVyeSBl
eHRlbnQgNjRiaXQgZmxleF9iZyBzcGFyc2Vfc3VwZXIgbGFyZ2VfZmlsZSBodWdlX2ZpbGUgZGly
X25saW5rIGV4dHJhX2lzaXplIGJpZ2FsbG9jIG1ldGFkYXRhX2NzdW0KRmlsZXN5c3RlbSBmbGFn
czogICAgICAgICBzaWduZWRfZGlyZWN0b3J5X2hhc2ggCkRlZmF1bHQgbW91bnQgb3B0aW9uczog
ICAgdXNlcl94YXR0ciBhY2wKRmlsZXN5c3RlbSBzdGF0ZTogICAgICAgICBjbGVhbgpFcnJvcnMg
YmVoYXZpb3I6ICAgICAgICAgIENvbnRpbnVlCkZpbGVzeXN0ZW0gT1MgdHlwZTogICAgICAgTGlu
dXgKSW5vZGUgY291bnQ6ICAgICAgICAgICAgICAxNzg5NDQKQmxvY2sgY291bnQ6ICAgICAgICAg
ICAgICA3MzI1NjYzODQKUmVzZXJ2ZWQgYmxvY2sgY291bnQ6ICAgICAwCkZyZWUgYmxvY2tzOiAg
ICAgICAgICAgICAgMTY3ODg2OTYwCkZyZWUgaW5vZGVzOiAgICAgICAgICAgICAgMTc3NjEyCkZp
cnN0IGJsb2NrOiAgICAgICAgICAgICAgMApCbG9jayBzaXplOiAgICAgICAgICAgICAgIDQwOTYK
Q2x1c3RlciBzaXplOiAgICAgICAgICAgICA2NTUzNgpHcm91cCBkZXNjcmlwdG9yIHNpemU6ICAg
IDY0CkJsb2NrcyBwZXIgZ3JvdXA6ICAgICAgICAgNTI0Mjg4CkNsdXN0ZXJzIHBlciBncm91cDog
ICAgICAgMzI3NjgKSW5vZGVzIHBlciBncm91cDogICAgICAgICAxMjgKSW5vZGUgYmxvY2tzIHBl
ciBncm91cDogICA4CkZsZXggYmxvY2sgZ3JvdXAgc2l6ZTogICAgMTYKRmlsZXN5c3RlbSBjcmVh
dGVkOiAgICAgICBUaHUgRGVjIDI2IDE5OjI5OjIxIDIwMTMKTGFzdCBtb3VudCB0aW1lOiAgICAg
ICAgICBGcmkgQXVnICA4IDE0OjQyOjU2IDIwMTQKTGFzdCB3cml0ZSB0aW1lOiAgICAgICAgICBG
cmkgQXVnICA4IDE0OjQyOjU2IDIwMTQKTW91bnQgY291bnQ6ICAgICAgICAgICAgICAxMApNYXhp
bXVtIG1vdW50IGNvdW50OiAgICAgIC0xCkxhc3QgY2hlY2tlZDogICAgICAgICAgICAgVGh1IEF1
ZyAgNyAwMTozNToyMCAyMDE0CkNoZWNrIGludGVydmFsOiAgICAgICAgICAgMCAoPG5vbmU+KQpM
aWZldGltZSB3cml0ZXM6ICAgICAgICAgIDI0MTMgR0IKUmVzZXJ2ZWQgYmxvY2tzIHVpZDogICAg
ICAwICh1c2VyIHJvb3QpClJlc2VydmVkIGJsb2NrcyBnaWQ6ICAgICAgMCAoZ3JvdXAgcm9vdCkK
Rmlyc3QgaW5vZGU6ICAgICAgICAgICAgICAxMQpJbm9kZSBzaXplOgkgICAgICAgICAgMjU2ClJl
cXVpcmVkIGV4dHJhIGlzaXplOiAgICAgMjgKRGVzaXJlZCBleHRyYSBpc2l6ZTogICAgICAyOApK
b3VybmFsIGlub2RlOiAgICAgICAgICAgIDgKRGVmYXVsdCBkaXJlY3RvcnkgaGFzaDogICBoYWxm
X21kNApEaXJlY3RvcnkgSGFzaCBTZWVkOiAgICAgIDc3NzgwZDc0LTU5YzktNDkxMC04OGMxLWZm
NTBjM2U5NTVjMQpKb3VybmFsIGJhY2t1cDogICAgICAgICAgIGlub2RlIGJsb2NrcwpDaGVja3N1
bSB0eXBlOiAgICAgICAgICAgIGNyYzMyYwpDaGVja3N1bTogICAgICAgICAgICAgICAgIDB4MjBm
MDk0MjUKSm91cm5hbCBmZWF0dXJlczogICAgICAgICBqb3VybmFsX2luY29tcGF0X3Jldm9rZSBq
b3VybmFsXzY0Yml0IGpvdXJuYWxfYXN5bmNfY29tbWl0IGpvdXJuYWxfY2hlY2tzdW1fdjIKSm91
cm5hbCBzaXplOiAgICAgICAgICAgICAxMjhNCkpvdXJuYWwgbGVuZ3RoOiAgICAgICAgICAgMzI3
NjgKSm91cm5hbCBzZXF1ZW5jZTogICAgICAgICAweDAwMDFlMTFiCkpvdXJuYWwgc3RhcnQ6ICAg
ICAgICAgICAgMQpKb3VybmFsIGNoZWNrc3VtIHR5cGU6ICAgIGNyYzMyYwpKb3VybmFsIGNoZWNr
c3VtOiAgICAgICAgIDB4OThkNzBiOTMKCg==
--20cf303a32f3e7637005002341a0--
