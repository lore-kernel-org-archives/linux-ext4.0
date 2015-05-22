From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/3 v2] ext4: Speedup orphan file handling
Date: Fri, 22 May 2015 13:21:53 +0200
Message-ID: <1432293717-24010-1-git-send-email-jack@suse.cz>
Cc: Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57186 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756038AbbEVLWJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 May 2015 07:22:09 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id B63D4AD31
	for <linux-ext4@vger.kernel.org>; Fri, 22 May 2015 11:22:07 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

This is the second version of my patches to speed up orphan inode handling
in ext4.

Orphan inode handling in ext4 is a bottleneck for workloads which heavily
excercise truncate / unlink of small files as they contend on global
s_orphan_mutex (when you have fast enough storage). This patch set implements
new way of handling orphan inodes - instead of using a linked list, we store
inode numbers of orphaned inodes in a file which is possible to implement in a
more scalable manner than linked list manipulations. See description of patch
2/3 for more details.

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

The kernel part of the feature is complete, I have also implemented full
support in e2fsprogs. That still needs some debugging (especially the e2fsck
part) but support in mke2fs or tune2fs is fine. I'll post these as a separate
patch so that people can try this out.

For now I'm using inode 9 for orphan file. I know that is reserved as
EXT2_EXCLUDE_INO but at least for the sake of testing that should be fine.

								Honza

Changes since v1:
* orphan blocks have now magic numbers
* split out orphan handling to a separate source file
* some smaller updates according to review
