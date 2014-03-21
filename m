From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 71641] Unreasonable performance degradation in ext4 with full
 data journaling
Date: Fri, 21 Mar 2014 08:48:34 +0000
Message-ID: <bug-71641-13602-WpDXOgp3Ot@https.bugzilla.kernel.org/>
References: <bug-71641-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:50114 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754089AbaCUIsi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Mar 2014 04:48:38 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 05E1B202B8
	for <linux-ext4@vger.kernel.org>; Fri, 21 Mar 2014 08:48:37 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 12863202A1
	for <linux-ext4@vger.kernel.org>; Fri, 21 Mar 2014 08:48:36 +0000 (UTC)
In-Reply-To: <bug-71641-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=71641

Chia-Hung Chang <fredchang.tc@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Kernel Version|3.4.6                       |3.11

--- Comment #5 from Chia-Hung Chang <fredchang.tc@gmail.com> ---
(In reply to Theodore Tso from comment #4)
> Could you retry your measurements using the latest kernel?  At least 3.11,
> and preferably 3.13.
> 
> We significantly optimized the write path for the nodelalloc case in 3.11. 
> That should fix the average size being so small for the nodelalloc case:
> 
> 

Thanks for your advice. The kernel version is changed from 3.4 to 3.11.  The
write throughput of data=journal is still only 40% of data=order. Do you think
what may be wrong in this mode ?
---------------------

Test environment--  
CPU: Intel(R) Xeon(R) CPU E3-1225 v3 @ 3.20GHz
RAM:8GB
Filesystem:Ext4
Linux version: ubuntu-saucy with kernel 3.11

128MB ramdisk is used as journaling area

RAID0 are composed of 6 x 1TB HD
Command: time dd if=/dev/zero of= Write_File bs=1M count=5120


data=journal               -> 398MB/s
data=ordered               ->1.1GB/s
data=ordered ,nodelalloc   -> 1G/s

blktrace results can be downloaded in
https://dl.dropboxusercontent.com/u/32959539/blktrace_with_3_11.7z

btt results can be downloaded in
https://dl.dropboxusercontent.com/u/32959539/BTT_with_3_11.7z


For linux 3.4, the write throughputs are  

data=journal               -> 397MB/s
data=ordered               -> 937MB/s
data=ordered ,nodelalloc   -> 863MB/s*

*PS. the previous data is mistaken, please use this version.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
