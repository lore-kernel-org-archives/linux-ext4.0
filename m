Return-Path: <SRS0=PpJq=SM=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2A9AC10F11
	for <linux-ext4@archiver.kernel.org>; Wed, 10 Apr 2019 20:26:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C075821741
	for <linux-ext4@archiver.kernel.org>; Wed, 10 Apr 2019 20:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554927971;
	bh=WV51qsVI19+rWykitwrkiRjpaVEoV6Twv7Glfb8itQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=r/FcofdRoEuHfWdWmHtB6gWlgL65FIswY4+gb87EbKHKkddyf3RDSv8oxsfk/X5mP
	 DYRsXWujnbClLhAQr304EgAPQctyMpkAYQEdSaWfYup5C2RORUmI/eynbMi0tn/QLC
	 lv77aN6kWRxJdtrgjTQ1KDXMuiIstU7+/PxO5hRk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbfDJU0K (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 10 Apr 2019 16:26:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:47048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726677AbfDJU0J (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 10 Apr 2019 16:26:09 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C26A420850;
        Wed, 10 Apr 2019 20:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554927969;
        bh=WV51qsVI19+rWykitwrkiRjpaVEoV6Twv7Glfb8itQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TLsC90CWn6BBuZQXN6eNs6BNi0rHwyBrgSkYQwEg2mGZRkGIHnmImjSkYrJASyr23
         0pjoO75x7cLXu9538m1MMXV+1XJ0vOXefRT+psfazoQHIMUdCxhwQXgFQjLXqjMWsb
         yZBuC//8QyuZqXnjWEKTjcpclltl3/16bbrfXDXk=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH v2 1/2] vfs: use READ_ONCE() to access ->i_link
Date:   Wed, 10 Apr 2019 13:21:14 -0700
Message-Id: <20190410202115.64501-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0.392.gf8f6787159e-goog
In-Reply-To: <20190410202115.64501-1-ebiggers@kernel.org>
References: <20190410202115.64501-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Use 'READ_ONCE(inode->i_link)' to explicitly support filesystems caching
the symlink target in ->i_link later if it was unavailable at iget()
time, or wasn't easily available.  I'll be doing this in fscrypt, to
improve the performance of encrypted symlinks on ext4, f2fs, and ubifs.

->i_link will start NULL and may later be set to a non-NULL value by a
smp_store_release() or cmpxchg_release().  READ_ONCE() is needed on the
read side.  smp_load_acquire() is unnecessary because only a data
dependency barrier is required.  (Thanks to Al for pointing this out.)

Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/namei.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index dede0147b3f6e..2855de004c1a9 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1066,7 +1066,7 @@ const char *get_link(struct nameidata *nd)
 		return ERR_PTR(error);
 
 	nd->last_type = LAST_BIND;
-	res = inode->i_link;
+	res = READ_ONCE(inode->i_link);
 	if (!res) {
 		const char * (*get)(struct dentry *, struct inode *,
 				struct delayed_call *);
@@ -4729,7 +4729,7 @@ int vfs_readlink(struct dentry *dentry, char __user *buffer, int buflen)
 		spin_unlock(&inode->i_lock);
 	}
 
-	link = inode->i_link;
+	link = READ_ONCE(inode->i_link);
 	if (!link) {
 		link = inode->i_op->get_link(dentry, inode, &done);
 		if (IS_ERR(link))
-- 
2.21.0.392.gf8f6787159e-goog

