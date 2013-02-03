From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 0/4] Clean up ext4's mount option parsing code
Date: Sat,  2 Feb 2013 23:44:02 -0500
Message-ID: <1359866646-29876-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46692 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741Ab3BCEoN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 Feb 2013 23:44:13 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The first three patches are from a patch series which Jan Kara submitted
back in April 2012, forward ported to modern kernels.  The last patch
addresses the feature which Carlos suggested, but I've implemented it as
a flag in the mount options parsing, instead of using the mount option
flags.  This allows us to disallow features which don't involve setting
a mount option flags.

						- Ted

Jan Kara (3):
  ext4: move several mount options to standard handling loop
  ext4: make mount option parsing loop more logical
  ext4: print error when argument of inode_readahead_blk is invalid

Theodore Ts'o (1):
  ext4: check incompatible mount options while mounting ext2/3

 fs/ext4/super.c | 261 +++++++++++++++++++++++++++++++-------------------------
 1 file changed, 143 insertions(+), 118 deletions(-)

-- 
1.7.12.rc0.22.gcdd159b

