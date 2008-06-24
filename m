From: Gary Hawco <ghawco@cox.net>
Subject: Problem compiling 2.6.260rc6 with updated ext4-patch-queue
Date: Tue, 24 Jun 2008 10:26:59
Message-ID: <3.0.6.32.20080624102659.02429f60@pop.west.cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fed1rmmtao102.cox.net ([68.230.241.44]:38612 "EHLO
	fed1rmmtao102.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbYFXR1A (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Jun 2008 13:27:00 -0400
Received: from fed1rmimpo01.cox.net ([70.169.32.71])
          by fed1rmmtao102.cox.net
          (InterMail vM.7.08.02.01 201-2186-121-102-20070209) with ESMTP
          id <20080624172648.SFXX12709.fed1rmmtao102.cox.net@fed1rmimpo01.cox.net>
          for <linux-ext4@vger.kernel.org>; Tue, 24 Jun 2008 13:26:48 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Recently pulled and updated my ext4-patch-queue. Tried to compile the
2.6.26-rc6 after it patched cleanly. During make received the following error:

fs/ext4/inode.c: In function 'ext4_journal_dirty_data':
fs/ext4/inode.c:1297: error:  implicit declaration of function
'jbd2_journal_dirty_data'
fs/ext4/inode.c: In function 'ext4_da_writepages':
fs/ext4/inode.c:1759: error:  implicit declaration of function
'ext4_jbd2_file_inode'
make[2]: *** [fs/ext4/inode.o]  Error 1
make[1]: *** [fs/ext4] Error 2
make:  *** [fs] Error 2

Previously, as of the Add ext4-delalloc-bmap-support.patch by Mingming Cao
three days ago, the 2.6.26-rc6 kernel compiled cleanly, so I would guess
it's something in the last seven patches (listed from newest to oldest):

1. Fold ext4-Use-new-framework-for-data-ordered-mode-in-JBD.patch
2. Fix compile error in ext4_use_atomic-function-to-set-bh_stat-fix.patch
3. Added ext4_use_atomic-function-to-set-bh_stat-fix.patch
4. Update changelog for jbd2-Implement-data-ordered-mode-handling-via-
inode.patch
5. Fold ext4-delalloc-bmap-support.patch to delalloc writeback mode patch
6. Fold delalloc-ext4-reservation-for-nonextent-files.patch to delalloc
ENOSPC error handling patch, move it before reverse locking changes
7. Add delalloc-ext4-reservation-for-nonextent-files.patch

Gary


