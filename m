From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/4] Fix fsync on ext3 and ext4 (v2)
Date: Tue, 27 Oct 2009 13:48:45 +0100
Message-ID: <1256647729-29834-1-git-send-email-jack@suse.cz>
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:53090 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957AbZJ0Msq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Oct 2009 08:48:46 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


  Hi,

  this is a second try for a patchset which makes ext3 and ext4 properly force
a transaction commit when needed. We now do not rely on buffer dirty bits
(which does not work as pdflush can just clear them without forcing a
transaction commit) but rather keep transaction ids that need to be committed
for each inode.
  Since last version, I've implemented Aneesh's and Curt's comments and also
fixed a missing initialization of the fields. I've tested that now the patch
works correctly for uninitialized extents as well as for standard writes.  If
noone objects, would you merge the ext4 part Ted? I'll take care of the ext3
patch.

									Honza
