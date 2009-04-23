From: Curt Wohlgemuth <curtw@google.com>
Subject: Question on block group allocation
Date: Thu, 23 Apr 2009 09:41:50 -0700
Message-ID: <6601abe90904230941x5cdd590ck2d51410326df2fc5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:58795 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbZDWQl4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Apr 2009 12:41:56 -0400
Received: from zps77.corp.google.com (zps77.corp.google.com [172.25.146.77])
	by smtp-out.google.com with ESMTP id n3NGfqGI025834
	for <linux-ext4@vger.kernel.org>; Thu, 23 Apr 2009 17:41:54 +0100
Received: from qyk32 (qyk32.prod.google.com [10.241.83.160])
	by zps77.corp.google.com with ESMTP id n3NGfLD9020213
	for <linux-ext4@vger.kernel.org>; Thu, 23 Apr 2009 09:41:50 -0700
Received: by qyk32 with SMTP id 32so1339864qyk.0
        for <linux-ext4@vger.kernel.org>; Thu, 23 Apr 2009 09:41:50 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi:

I'm seeing a performance problem on ext4 vs ext2, and in trying to
narrow it down, I've got a question about block allocation in ext4
that I'm having trouble figuring out.

The test in question just does random reads of several rather large
files (4.5GB and 10GB) in a single thread.  All files are created in
the top-level directory.  Looking into the block layout for the
various files, I'm struck by the wide separation of the extents in
some of the files.

As a simple example, I formatted/mounted a new ext4 partition with
default parameters (with the exception of "-O ^has_journal", but this
shouldn't make a difference); the FS has 5585 block groups of 4K
blocks.

Using dd, I created (in this order) two 4GB files and a 10GB file in
the mount directory.

The extent blocks are reasonably close together for the two 4GB files,
but the extents for the 10GB file show a huge gap, which seems to hurt
the random read performance pretty substantially.  Here's the output
from debugfs:

BLOCKS:
(IND):8396832, (0-106495):8282112-8388607,
(106496-399359):11241472-11534335, (399360-888831):20482048-20971519,
(888832-1116159):23889920-24117247, (1116160-1277951):71665664-
71827455, (1277952-1767423):78678016-79167487,
(1767424-2125823):102402048-102760447,
(2125824-2148351):102768672-102791199,
(2148352-2621439):102793216-103266303
TOTAL: 2621441

Note the gap between blocks 79167487 and 102402048.  I was lucky
enough to capture the mb_history from this 10GB create:

29109 14       735/30720/32758@1114112 735/30720/2048@1114112
735/30720/2048@1114112  1     0     0  1568  M     0     0
29109 14       736/0/32758@1116160     736/0/2048@1116160
2187/2048/2048@1116160  1     1     0  1568        0     0
29109 14       2187/4096/32758@1118208 2187/4096/2048@1118208
2187/4096/2048@1118208  1     0     0  1568  M     2048  4096

I've been staring at ext4_mb_regular_allocator() trying to understand
why an allocation with a goal block of 736 ends up with a best found
extent group of 2187, and I'm stuck -- at least without a lot of
printk messages.  It seems to me that we just cycle through the block
groups starting with the goal group until we find a group that fits.
Again, according to dumpe2fs, block groups 737, 738, 739, ... all have
32768 free blocks.  So why we end up with a best fit group of 2187 is
a mystery to me.

Can anybody give me an insight to what's happening here?

Thanks,
Curt
