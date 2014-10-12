From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 82201] ext4 crash in ext4_superblock_csum
Date: Sun, 12 Oct 2014 12:03:28 +0000
Message-ID: <bug-82201-13602-Mbm4dkGSbS@https.bugzilla.kernel.org/>
References: <bug-82201-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:51898 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbaJLMDa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 12 Oct 2014 08:03:30 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E2027201B4
	for <linux-ext4@vger.kernel.org>; Sun, 12 Oct 2014 12:03:29 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 6381C20173
	for <linux-ext4@vger.kernel.org>; Sun, 12 Oct 2014 12:03:28 +0000 (UTC)
In-Reply-To: <bug-82201-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=82201

--- Comment #4 from Dmitry Monakhov <dmonakhov@openvz.org> ---
AFAIU I've accidentally directly write some crap to SB and later 
ext4_superblock_csum_set() performs check s_es which was crewed-up,
and it try to recalculate csum, but sbi->s_chksum_driver == NULL
So it looks like we have to guard all direct checks of 
EXT4_HAS_RO_COMPAT_FEATURE(sb,EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
with extra check that csum_context was created on mount.
Likely that other places where we make similar assumptions.

Patch likely will be simple but large, so we should figure out quick crunch for
stable releases, how about this ugly one?
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b0c225c..d4f0dd1 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1749,6 +1749,10 @@ static inline u32 ext4_chksum(struct ext4_sb_info *sbi,
u32 crc,
        } desc;
        int err;

+       if (unlikely(!sbi->s_chksum_driver)) {
+               WARN_ON_ONCE(1);
+               return 0xDEADBEEF;
+       }
        BUG_ON(crypto_shash_descsize(sbi->s_chksum_driver)!=sizeof(desc.ctx));

        desc.shash.tfm = sbi->s_chksum_driver;

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
