From: Girish Shilamkar <girish@clusterfs.com>
Subject: [Patch] Improve e2fsck heuristics for detecting corrupted inodes
Date: Thu, 07 Jun 2007 15:12:46 +0530
Message-ID: <1181209366.3870.21.camel@dhcp9.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>
To: Ext4 Mailing List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:44137 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbXFGJmh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Jun 2007 05:42:37 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,
     The present e2fsck code checks the inode, per field basis. It
doesn't take into consideration to total sanity of the inode. This may
cause e2fsck turning a garbage inode into a sane inode.
	The following patch adds a heuristics to detect the degree of badness
of an inode. icount mechanism is used to keep track of the badness of
every inode. The badness is increased as various fields in inode are
found to be corrupt. Badness above a certain threshold value results in
deletion of the inode. The default threshold value is 7, it can be
specified to e2fsck using "-E inode_badness_threshold=<value>"

Any suggestions/comments are welcome.

Thanks & Regards,
Girish


Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
Signed-off-by: Girish Shilamkar <girish@clusterfs.com>

diffstat patches/e2fsprogs-badness-counter.patch 
 e2fsck/e2fsck.8.in                      |    7 +
 e2fsck/e2fsck.c                         |    4 
 e2fsck/e2fsck.h                         |   19 +++
 e2fsck/pass1.c                          |  155
++++++++++++++++++++++++--------
 e2fsck/pass1b.c                         |    4 
 e2fsck/pass2.c                          |   83 +++++++++++++----
 e2fsck/pass4.c                          |    1 
 e2fsck/problem.c                        |    5 +
 e2fsck/problem.h                        |    3 
 e2fsck/unix.c                           |   16 ++-
 lib/ext2fs/icount.c                     |   18 +++
 tests/f_bad_disconnected_inode/expect.1 |   14 --
 tests/f_bad_disconnected_inode/expect.2 |    2 
 13 files changed, 253 insertions(+), 78 deletions(-)
