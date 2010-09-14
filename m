From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/2] ext3 in-inode xattr handling fix for reserved inodes
Date: Tue, 14 Sep 2010 14:32:44 +0200
Message-ID: <1284467566-12661-1-git-send-email-jack@suse.cz>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Andrew Morton <akpm@linux-foundation.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:60780 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943Ab0INMdn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Sep 2010 08:33:43 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


  Hi,

  the first patch in this series fixes a bug where we could lose extended
attributes for ino 11 if lost+found was deleted and inode used again.
The second patch makes kernel accept in-inode xattrs even for reserved
inodes if they look sane as Andreas suggested. This way we could in theory
remove the special casing sometime in future. I'm personally not convinced
this is worth the effort since the time when we could remove the special
casing is at least several years in future (for example I switch to 2.6.16
or even older kernels on our test machines) but I'm throwing the patch
in so that people can express their opinions...

								Honza
