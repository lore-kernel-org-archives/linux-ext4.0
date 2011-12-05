From: Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 2/5 resend] Thaw the journal when you unfreeze the fs.
Date: Mon,  5 Dec 2011 12:54:46 -0800
Message-ID: <1323118489-16326-3-git-send-email-kamal@canonical.com>
References: <1323118489-16326-1-git-send-email-kamal@canonical.com>
Cc: linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Surbhi Palande <csurbhi@gmail.com>,
	Valerie Aurora <val@vaaconsulting.com>,
	Kamal Mostafa <kamal@canonical.com>,
	Christopher Chaltain <christopher.chaltain@canonical.com>,
	"Peter M. Petrakis" <peter.petrakis@canonical.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Surbhi Palande <surbhi.palande@canonical.com>
To: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Matthew Wilcox <matthew@wil.cx>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:53757 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932366Ab1LEUzF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Dec 2011 15:55:05 -0500
In-Reply-To: <1323118489-16326-1-git-send-email-kamal@canonical.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Surbhi Palande <surbhi.palande@canonical.com>

Thaw the journal so that transactions can resume

BugLink: https://bugs.launchpad.net/bugs/897421
Signed-off-by: Surbhi Palande <surbhi.palande@canonical.com>
Cc: Kamal Mostafa <kamal@canonical.com>
Tested-by: Peter M. Petrakis <peter.petrakis@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ext4/super.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 5bfdc21..95f28b8 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4348,10 +4348,14 @@ static int ext4_freeze(struct super_block *sb)
  */
 static int ext4_unfreeze(struct super_block *sb)
 {
+	journal_t *journal;
 	if (sb->s_flags & MS_RDONLY)
 		return 0;
 
 	lock_super(sb);
+	journal = EXT4_SB(sb)->s_journal;
+
+	jbd2_journal_thaw(journal);
 	/* Reset the needs_recovery flag before the fs is unlocked. */
 	EXT4_SET_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
 	ext4_commit_super(sb, 1);
-- 
1.7.5.4

