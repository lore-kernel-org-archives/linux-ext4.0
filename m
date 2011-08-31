From: Ivan Shmakov <ivan@gray.siamics.net>
Subject: ext2fs_block_iterate (e2, EXT2_RESIZE_INO, ...) => EXT2_ET_FILE_TOO_BIG?
Date: Wed, 31 Aug 2011 17:52:35 +0700
Message-ID: <867h5tdf9o.fsf@gray.siamics.net>
Reply-To: Ivan Shmakov <oneingray@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:39448 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914Ab1HaKwv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 31 Aug 2011 06:52:51 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1QyiPa-0007ka-6s
	for linux-ext4@vger.kernel.org; Wed, 31 Aug 2011 12:52:50 +0200
Received: from gray.am-1.org ([188.120.231.229])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 12:52:50 +0200
Received: from oneingray by gray.am-1.org with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 12:52:50 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

	Curiosly enough, ext2fs_block_iterate () returns
	EXT2FS_BLOCK_ITERATE for EXT2_RESIZE_INO (the binary in question
	is statically linked against libext2fs, 1.41.12 debian 2):

(gdb) print ext2fs_block_iterate (e2, ino, 0, 0, db_add_block, (void *)sp)
$13 = 2133571410
(gdb) 

	Is it because the blocks belonging to this inode aren't supposed
	to belong to the filesystem itself, I wonder?

	TIA.

-- 
FSF associate member #7257	Coming soon: Software Freedom Day
http://mail.sf-day.org/lists/listinfo/ planning-ru (ru), sfd-discuss (en)

