From: Chris Mason <chris.mason@oracle.com>
Subject: [PATCH RFC] ext3 data=guarded v3
Date: Wed, 15 Apr 2009 13:22:36 -0400
Message-ID: <1239816159-6868-1-git-send-email-chris.mason@oracle.com>
To: Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet13.oracle.com ([148.87.113.125]:42931 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457AbZDORX7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Apr 2009 13:23:59 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello everyone,

Here is another version of the data=guarded work for ext3.  The main
difference between this code and yesterday's is the guarded writepage
function now sends any newly allocated block through the old data=ordered code.

This is important because at the time we're walking the buffers, the page
may be unlocked, so we can't trust anything inside the page.  In general,
any allocation done by writepage is to fill a hole, so the old data=ordered
is what we want anyway.

This passed a longer stress test and generally seems to be working.  I
don't think anyone would recommend it as a default for 2.6.30, but it
may be a good idea to have a review party and decide if it is safe enough
to include so people can experiment with it.

Overall diffstat of the series:

 fs/buffer.c                 |   45 ++-
 fs/ext3/Makefile            |    3
 fs/ext3/fsync.c             |   12
 fs/ext3/inode.c             |  546 +++++++++++++++++++++++++++++++++++++++++++-
 fs/ext3/namei.c             |    3
 fs/ext3/ordered-data.c      |  318 +++++++++++++++++++++++++
 fs/ext3/super.c             |   48 +++
 fs/jbd/transaction.c        |    1
 include/linux/buffer_head.h |    3
 include/linux/ext3_fs.h     |   33 ++
 include/linux/ext3_fs_i.h   |   44 +++
 include/linux/ext3_fs_sb.h  |    6
 include/linux/ext3_jbd.h    |   11
 include/linux/jbd.h         |   10
 mm/filemap.c                |    1

-chris


