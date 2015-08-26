From: Jan Kara <jack@suse.com>
Subject: [PATCH 00/21 v2] e2fsprogs: Resizing rewrite
Date: Wed, 26 Aug 2015 18:22:15 +0200
Message-ID: <1440606156-5754-1-git-send-email-jack@suse.com>
Cc: Ted Tso <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Jan Kara <jack@suse.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33532 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756924AbbHZQWv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Aug 2015 12:22:51 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

this patch series factors out large parts of resizing code into libext2fs.
The motivation of this is that handling of enabling / disabling of more and
more features requires moving blocks or inodes with rewriting all the
references and using resize2fs for that is not logical from user interface
POV.

The series is structured as follows.

* Patches 1-4 are various small cleanups and improvements.

* Patches 5-6 implement the main functionality. The functionality is
  implemented by two functions:

ext2fs_move_blocks() which gets filesystem and bitmap of blocks which it should
make free and the function takes care of everything needed to make the blocks
free.

ext2fs_move_inodes() which gets filesystem and bitmap of inodes which it should
make free and the function takes care of everything needed to make these inodes
free.

* Patches 7-8 implements enabling / disabling 64-bit feature in tune2fs where
  it is more logical and update tests to use tune2fs instead of resize2fs.

* Patches 9-14 add support for changing number of reserved inodes in e2fsprogs,
  update tests to reflect changed default number of reserved inodes and also
  add some basic testing of the new functionality.

* Patches 15-16 remove some now undeeded code

* Patches 17-21 change resize2fs itself to use code from libext2fs to perform
  resizing.

I have verified that all the tests in e2fsprogs now pass so things should be
working reasonably but since this is basically a complete rewrite of the
resizing code which is pretty complex, there may be bugs still lurking...

								Honza
