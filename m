From: Jan Kara <jack@suse.com>
Subject: [PATCH 00/19] e2fsprogs: Resizing rewrite
Date: Fri,  7 Aug 2015 12:51:10 +0200
Message-ID: <1438944689-24562-1-git-send-email-jack@suse.com>
Cc: Ted Tso <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Jan Kara <jack@suse.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39098 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535AbbHGKvm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Aug 2015 06:51:42 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

this patch series factors out large parts of resizing code into libext2fs.
The motivation of this is that handling of enabling / disabling of more and
more features requires moving blocks or inodes with rewriting all the
references and using resize2fs for that is not logical from user interface
POV.

The series is structured as follows.

* Patches 1-7 are various small cleanups and improvements.

* Patches 8-9 implement the main functionality. The functionality is
  implemented by two functions:

ext2fs_move_blocks() which gets filesystem and bitmap of blocks which it should
make free and the function takes care of everything needed to make the blocks
free.

ext2fs_move_inodes() which gets filesystem and bitmap of inodes which it should
make free and the function takes care of everything needed to make these inodes
free.

* Patch 10 implements enabling / disabling 64-bit feature in tune2fs where it
  is more logical

* Patches 11-13 add support for changing number of reserved inodes in e2fsprogs

* Patches 14-19 change resize2fs itself to use code from libext2fs to perform
  resizing.

I have tested the new code for various combinations of fs features to make sure
I didn't mess up anything but given this is effectively a rewrite of filesystem
resizing, please handle with care.

								Honza
