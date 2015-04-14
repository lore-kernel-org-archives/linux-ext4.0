From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 96641] New: Oops in __d_lookup when accessing certain files
Date: Tue, 14 Apr 2015 18:13:44 +0000
Message-ID: <bug-96641-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:35321 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844AbbDNSNs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Apr 2015 14:13:48 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 74782201B9
	for <linux-ext4@vger.kernel.org>; Tue, 14 Apr 2015 18:13:47 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 3987920212
	for <linux-ext4@vger.kernel.org>; Tue, 14 Apr 2015 18:13:45 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=96641

            Bug ID: 96641
           Summary: Oops in __d_lookup when accessing certain files
           Product: File System
           Version: 2.5
    Kernel Version: 4.0.0
          Hardware: ARM
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: dannf@dannf.org
        Regression: No

My filesystem seems to be corrupted, causing random and frequent Oops's when
accessing certain regular files. My expectation is that the corrupted
filesystem should "crash" when corrupted, but that I should not see an Oops.

On one instance, I was able to reproduce everytime I ran:

'ls -l /usr/lib/python2.7/six.pyc'

But after a couple boots of different kernels, that file disappeared. Now I'm
reproducing using the find command below.

I have not tried fscking the filesystem as I don't want to accidentally clear
an error state that might be useful for diagnoses. I don't believe this is a
new issue - I went back to an earlier kernel (3.13 from Ubuntu - didn't try a
mainline 3.13) and the issue persists.

dannf@mustang:~/git/linux-2.6$ find . -type f -exec file {} \; > /dev/null      
[13177.242811] Unable to handle kernel paging request at virtual address
4000008
[13177.250520] pgd = ffffffc3e41c1000                                           
[13177.253933] [40000000000018] *pgd=00000043e82e7003, *pud=00000043e82e7003,
*0
[13177.262724] Internal error: Oops: 96000004 [#3] SMP                          
[13177.267576] Modules linked in: xt_conntrack ipt_REJECT nf_reject_ipv4
ebtablt
[13177.310290] CPU: 7 PID: 11789 Comm: find Tainted: G      D         4.0.0+ #1 
[13177.317301] Hardware name: APM X-Gene Mustang board (DT)                     
[13177.322585] task: ffffffc0f9640000 ti: ffffffc3e40b8000 task.ti:
ffffffc3e400
[13177.330032] PC is at __d_lookup+0x8c/0x198                                   
[13177.334106] LR is at d_lookup+0x3c/0x64                                      
[13177.337921] pc : [<ffffffc0002283e8>] lr : [<ffffffc000228530>] pstate:
00005
[13177.345276] sp : ffffffc3e40bbba0                                            
[13177.348572] x29: ffffffc3e40bbba0 x28: ffffffc0009bf560                      
[13177.353875] x27: ffffffffffffffff x26: ffffffc3e40bbcc8                      
[13177.359179] x25: 0000000000000005 x24: ffffffc3e40bbcb8                      
[13177.364483] x23: ffffffc3edc04300 x22: ffffffc3edc04300                      
[13177.369786] x21: 000000006feb2772 x20: 003ffffffffffff8                      
[13177.375088] x19: 0040000000000000 x18: 0000000000000000                      
[13177.380391] x17: 00000000004412a0 x16: ffffffc000216cf8                      
[13177.385694] x15: 0000000000000028 x14: ffffffc0f939f700                      
[13177.390997] x13: ffffffc0f93ae3c0 x12: 0000000000000000                      
[13177.396300] x11: ffffffc000791810 x10: ffffffc000791814                      
[13177.401604] x9 : 0000000000000000 x8 : 0000000000000005                      
[13177.406905] x7 : 0000000000000005 x6 : 0000000000000005                      
[13177.412209] x5 : 00000000fffffff7 x4 : 000000000000000a                      
[13177.417512] x3 : 0000000000000020 x2 : 000000000000000b                      
[13177.422816] x1 : 0000000000f6b428 x0 : ffffffc3eec00000                      
[13177.428119]                                                                  
[13177.429600] Process find (pid: 11789, stack limit = 0xffffffc3e40b8028)      
[13177.436179] Stack: (0xffffffc3e40bbba0 to 0xffffffc3e40bc000)                
[13177.441895] bba0: e40bbc00 ffffffc3 00228530 ffffffc0 000004aa 00000000
00b60
[13177.450030] bbc0: e40bbcb8 ffffffc3 edc04300 ffffffc3 ee0b2620 ffffffc3
00000
[13177.458164] bbe0: 009e5c70 ffffffc0 e47a5e80 ffffffc3 f9640440 ffffffc0
009b0
[13177.466299] bc00: e40bbc30 ffffffc3 002285b0 ffffffc0 e40bbcb8 ffffffc3
edc03
[13177.474434] bc20: 00003307 00000000 e47a5e80 ffffffc3 e40bbc50 ffffffc3
00270
[13177.482569] bc40: 00000000 00000000 e40bbcc8 ffffffc3 e40bbce0 ffffffc3
000b0
[13177.490703] bc60: ed0d7080 ffffffc3 e40bbe78 ffffffc3 00003307 00000000
00000
[13177.498837] bc80: 00b4da40 ffffffc0 00b62080 ffffffc0 00c1b1e8 ffffffc0
e8e73
[13177.506972] bca0: f9640440 ffffffc0 e40b8000 ffffffc3 e8e740e8 ffffffc3
6feb5
[13177.515106] bcc0: e40bbcc8 ffffffc3 36303331 ffff0033 ed0d7080 ffffffc3
dc8bf
[13177.523241] bce0: e40bbd50 ffffffc3 000b9874 ffffffc0 ed0d7080 ffffffc3
e40b3
[13177.531375] bd00: 00003307 00000000 00000010 00000000 00b62000 ffffffc0
e4223
[13177.539510] bd20: 000003e8 00000000 e8e73f00 ffffffc3 f9640440 ffffffc0
e40b3
[13177.547645] bd40: ed0d7080 ffffffc3 008ef8c8 00000000 e40bbdc0 ffffffc3
000b0
[13177.555780] bd60: ed0d7080 ffffffc3 e40bbe78 ffffffc3 f9640000 ffffffc0
e40b3
[13177.563915] bd80: e40bbea0 ffffffc3 00b62080 ffffffc0 fffffff6 00000000
00000
[13177.572050] bda0: e40bbdc0 ffffffc3 000ba098 ffffffc0 00000000 00000000
00000
[13177.580185] bdc0: e40bbe30 ffffffc3 000bb340 ffffffc0 00000004 00000000
e47a3
[13177.588319] bde0: caf55d54 0000007f 00000000 00000000 00000000 00000000
00000
[13177.596454] be00: 0000011a 00000000 00000104 00000000 00782000 ffffffc0
000b0
[13177.604588] be20: 00000000 00000000 f96404d0 ffffffc0 caf55cd0 0000007f
00080
[13177.612723] be40: 00000000 00000000 00003307 00000000 ffffffff ffffffff
b0d6f
[13177.620857] be60: 00000000 00000000 00000000 00000000 00800002 ffff81b4
00004
[13177.628991] be80: e47a5e80 ffffffc3 00000000 00000000 caf55d54 0000007f
00000
[13177.637126] bea0: 00000000 00000000 f9640000 ffffffc0 000b8e90 ffffffc0
e4223
[13177.645260] bec0: e422e328 ffffffc3 fffffff6 00000000 00003307 00000000
caf5f
[13177.653394] bee0: 00000000 00000000 00000000 00000000 00000000 00000000
b0e0f
[13177.661529] bf00: 00000000 00000000 b0e11000 0000007f 00000104 00000000
00000
[13177.669665] bf20: 00000000 00000000 7f7f7f7f 7f7f7f7f 01010101 01010101
00000
[13177.677799] bf40: 00000008 00000000 00000028 00000000 00441410 00000000
b0d6f
[13177.685934] bf60: 00000000 00000000 29c243c8 00000000 00003307 00000000
29c20
[13177.694069] bf80: 29c243c0 00000000 00441000 00000000 29c243c8 00000000
29c20
[13177.702205] bfa0: 00000014 00000000 00000000 00000000 00000000 00000000
caf5f
[13177.710338] bfc0: 00406a74 00000000 caf55cd0 0000007f b0d69140 0000007f
00000
[13177.718473] bfe0: 00003307 00000000 00000104 00000000 00000000 00000000
00000
[13177.726606] Call trace:                                                      
[13177.729041] [<ffffffc0002283e8>] __d_lookup+0x8c/0x198                       
[13177.734151] [<ffffffc00022852c>] d_lookup+0x38/0x64                          
[13177.739003] [<ffffffc0002285ac>] d_hash_and_lookup+0x54/0x6c                 
[13177.744634] [<ffffffc00027bf44>] proc_flush_task+0x9c/0x198                  
[13177.750178] [<ffffffc0000b8fb0>] release_task+0x60/0x480                     
[13177.755462] [<ffffffc0000b9870>] wait_consider_task+0x4a0/0xc04              
[13177.761350] [<ffffffc0000ba0d0>] do_wait+0xfc/0x25c                          
[13177.766202] [<ffffffc0000bb33c>] SyS_wait4+0x80/0xf0                         
[13177.771139] Code: 14000003 f9400273 b4000213 d1002274 (b9402282)             
[13177.777226] ---[ end trace a64a384267db7dd1 ]---                             
Segmentation fault

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
