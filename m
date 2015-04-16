From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/3 RFC] ext4: Speedup orphan file handling
Date: Thu, 16 Apr 2015 17:42:54 +0200
Message-ID: <1429198977-5637-1-git-send-email-jack@suse.cz>
Cc: Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38020 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644AbbDPPnJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Apr 2015 11:43:09 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id D7C73AC92
	for <linux-ext4@vger.kernel.org>; Thu, 16 Apr 2015 15:43:07 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

orphan inode handling in ext4 is a bottleneck for workloads which heavily
excercise truncate / unlink of small files as they contend on global
s_orphan_mutex (when you have fast enough storage). This patch set implements
new way of handling orphan inodes - instead using a linked list, we store inode
numbers of orphaned inodes in a file which is possible to implement in a more
scalable manner than linked list manipulations. See description of patch 2/3
for more details.

The patch set achieves significant gains both for a micro benchmark stressing
orphan inode handling (truncating file byte-by-byte, several threads in
parallel) and for reaim new_fserver workload. As a highlight, microbenchmark
runtime for 128 threads is reduced from original 160 s down to 71 s, which
is also the time it takes the benchmark to run when orphan inode handling
is completely disabled. For full numbers you can check commit logs of
patches 2/3 and 3/3. You can also check my presentation from Vault at
http://events.linuxfoundation.org/sites/events/files/slides/ext4-scaling.pdf
for graphs from tests.

I'm happy for any review, thoughts, ideas about the patches.

The kernel part of the feature is complete, the thing missing is support for
enabling the feature in mke2fs and tune2fs. Since I need one reserved inode
(currently that's hacked up and I simply use inode number 12 for simplicity
of testing) that depends on how exactly we decide to deal with the issue that
we ran out of old limit on reserved inodes.

1) I can implement support in tune2fs to increase s_first_ino by moving inodes
   that are allocated in the range we want reserved. Then we can just continue
   to use reserved inodes as we did previously. I kind of like this for its
   simplicity, no need for ondisk format change, no need for kernel changes.

2) Implement "system directory" for reserved inodes as we spoke at Ext4 meeting
   at LSF.

But before I spend time on this, I'd like to hear some thoughts on how to
deal with reserved inodes from other developers...

								Honza
