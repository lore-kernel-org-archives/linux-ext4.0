From: Curt Wohlgemuth <curtw@google.com>
Subject: ext4 inode corruption
Date: Wed, 23 Sep 2009 09:27:11 -0700
Message-ID: <6601abe90909230927m6d45cd75wef3525fc23837110@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:49623 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235AbZIWQ1M (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Sep 2009 12:27:12 -0400
Received: from spaceape7.eur.corp.google.com (spaceape7.eur.corp.google.com [172.28.16.141])
	by smtp-out.google.com with ESMTP id n8NGREwU016009
	for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2009 17:27:14 +0100
Received: from pxi15 (pxi15.prod.google.com [10.243.27.15])
	by spaceape7.eur.corp.google.com with ESMTP id n8NGRBHJ032158
	for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2009 09:27:12 -0700
Received: by pxi15 with SMTP id 15so689985pxi.25
        for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2009 09:27:11 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We've been seeing sporadic inode corruption on our ext4 partitions which
we've been trying to analyze, without much success.  I'm wondering if
anybody might have some clues as to where things might be going wrong.

We find out about the corruption via a BUG firing in ext4_ext_get_blocks():

	/*
	 * consistent leaf must not be empty;
	 * this situation is possible, though, _during_ tree modification;
	 * this is why assert can't be put in ext4_ext_find_extent()
	 */
	BUG_ON(path[depth].p_ext == NULL && depth != 0);

Of course, this fires long after the inode in question is corrupted.  With
some diagnostics added in front of this bug, we can find the inodes; they
all have characteristics like this:

Output from debugfs' stat command:

   Inode: 1195575   Type: regular    Mode:  0600   Flags: 0x80000
   Generation: 2821101782    Version: 0x00000001
   User: 35800   Group:  5000   Size: 8400896
   File ACL: 0    Directory ACL: 0
   Links: 1   Blockcount: 8
   Fragment:  Address: 0    Number: 0    Size: 0
   ctime: 0x4a9f8009 -- Thu Sep  3 01:36:25 2009
   atime: 0x4a9f7ff7 -- Thu Sep  3 01:36:07 2009
   mtime: 0x4a9f8009 -- Thu Sep  3 01:36:25 2009
   EXTENTS:

Note that no data blocks are printed out here.

Following the actual extent tree, it always looks like this:

   in-inode extent header:
     eh_magic: 0xf30a
     eh_entries: 1
     eh_max: 4
     eh_depth: 1

   in-inode extent index 0:
     ei_block: 0
     ei_leaf_lo: 36738577
     ei_leaf_hi: 0

      leaf node header (at block 36738577):
        eh_magic: 0xf30a
        eh_entries: 0
        eh_max: 340
        eh_depth: 0

The i_size value of the inode will vary, from 8192 to 8400896.  But the
i_blocks value is *always* 8.

The extent tree always has depth of 1 in the in-inode header, and a valid
leaf node header; but the leaf node header always has 0 entries.  This is
what's causing the BUG above to fire.

We believe the general pattern of user space calls to create these files is
something like this:

   open(O_DIRECT)
   fallocate(fd, FALLOC_FL_KEEP_SIZE, 0, 8400896)
   < various writes to the file >
   fallocate(fd, 0, 0, actual_size + BLOCK_SIZE)
   ftruncate(fd, actual_size)

The second fallocate() call without KEEP_SIZE allows the following
ftruncate to actually truncate the file -- a known issue recently fixed by
Jiaying Zhang (but her fix is not in our kernel yet).  "actual_size" can be
0 at times.

I can't think of any actions that would cause the i_size to be so large, yet
the i_blocks always be 8.  Looking at the code in

   ext4_ext_remove_space()
   ext4_ext_rm_leaf()
   ext4_ext_rm_idx()

I don't see a way for the extent tree to take the shape above.  There are no
errors that I can see around the time the corrupted inodes are created.  It
*seems* as though the corruption is coming during truncation, but all our
efforts to reproduce this with small test cases have so far failed.

We're using a 2.6.26 code base, with most of the latest ext4 patches
applied.

Any insights/ruminations/guesses as to what might be happening are welcome.

Thanks,
Curt
