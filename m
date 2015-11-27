From: Bo Branten <bosse@acc.umu.se>
Subject: found an error that e2fsck does not fix
Date: Fri, 27 Nov 2015 20:11:34 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1511272003250.1707@suiko.acc.umu.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.acc.umu.se ([130.239.18.156]:34583 "EHLO mail.acc.umu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754597AbbK0TTV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Nov 2015 14:19:21 -0500
Received: from localhost (localhost [127.0.0.1])
	by amavisd-new (Postfix) with ESMTP id 8CBF2344
	for <linux-ext4@vger.kernel.org>; Fri, 27 Nov 2015 20:11:35 +0100 (MET)
Received: from suiko.acc.umu.se (suiko.acc.umu.se [IPv6:2001:6b0:e:2018::162])
	by mail.acc.umu.se (Postfix) with ESMTP id C8717342
	for <linux-ext4@vger.kernel.org>; Fri, 27 Nov 2015 20:11:34 +0100 (MET)
Received: from localhost (localhost [127.0.0.1])
	by suiko.acc.umu.se (Postfix) with ESMTP id BA8D244B8B
	for <linux-ext4@vger.kernel.org>; Fri, 27 Nov 2015 20:11:34 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hello,

I am debugging an Windows driver for ext4 and when creating an zero length 
file the error below shows up on Linux, while this ofcause is an bug in 
the Windows driver (looks like it forgets to flush some metadata) I wanted 
to report here that every time I run fsck on this test volume it will mark 
it as clean again but without fixing the error, so if I mount and unmount 
the filesystem again it is again in need of fsck wich in turn will mark it 
clean witout fixing the problem.

Test case, testa and testb is created from Windows and only testb gets one 
character written to with notepad:

bo@ubuntu:~$ cd /mnt2/src
bo@ubuntu:/mnt2/src$ ls -l
ls: cannot access testa: Input/output error
total 4
drwxr-xr-x 15 bo bo 1024 Mar 13  1994 linux-1.0
drwxr-xr-x 13 bo bo 1024 Mar  7  1995 linux-1.2.0
drwxr-xr-x 15 bo bo 1024 Jun  9  1996 linux-2.0
-?????????  ? ?  ?     ?            ? testa
-rw-r--r--  1 bo bo    1 Nov 27 18:21 testb
bo@ubuntu:/mnt2/src$ dmesg|tail
[ 1657.016023] ieee80211 phy0: rt2x00queue_flush_queue: Warning - Queue 2 
failed to flush
[ 1773.388021] ieee80211 phy0: rt2x00queue_flush_queue: Warning - Queue 2 
failed to flush
[ 1774.908022] ieee80211 phy0: rt2x00queue_flush_queue: Warning - Queue 2 
failed to flush
[ 2254.276023] ieee80211 phy0: rt2x00queue_flush_queue: Warning - Queue 2 
failed to flush
[ 3064.029061] EXT4-fs (sdb5): mounted filesystem with ordered data mode. 
Opts: (null)
[ 3081.376794] EXT4-fs error (device sdb5): ext4_ext_check_inode:464: 
inode #3641: comm ls: bad header/extent: invalid magic - magic 0, entries 
0, max 0(0), depth 0(0)
[ 4097.233826] EXT4-fs (sdb5): mounted filesystem with ordered data mode. 
Opts: (null)
[ 4108.835169] EXT4-fs error (device sdb5): ext4_ext_check_inode:464: 
inode #3641: comm ls: bad header/extent: invalid magic - magic 0, entries 
0, max 0(0), depth 0(0)
[ 6333.410987] EXT4-fs (sdb5): mounted filesystem with ordered data mode. 
Opts: (null)
[ 6338.997450] EXT4-fs error (device sdb5): ext4_ext_check_inode:464: 
inode #3641: comm ls: bad header/extent: invalid magic - magic 0, entries 
0, max 0(0), depth 0(0)
bo@ubuntu:/mnt2/src$

