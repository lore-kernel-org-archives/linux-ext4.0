Return-Path: <SRS0=deMF=QS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA607C169C4
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 17:30:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAF7F2229F
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 17:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549906228;
	bh=O1s9QR+U5uXIM+tBQ7kbiZnh0426uIGCqpIneePqUCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=mccpLUCydacy+fHDT+HciZtMhorv3AifiyQIniAh6bNwBlI+z3RP2z/EEkOVGIiWr
	 8yTYn9h4RDkZW3pY0/1g00Rr/tQpx52KnOwLQfWy40DJL8yTrOZC3AtxwHUbs6oPPy
	 1qtm3c2I2+qaGZfrGzIaP+VcxlvEgtd/hX8LMmEc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731442AbfBKRaX (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 11 Feb 2019 12:30:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:46552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729811AbfBKR3l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 11 Feb 2019 12:29:41 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28F89222AA;
        Mon, 11 Feb 2019 17:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1549906180;
        bh=O1s9QR+U5uXIM+tBQ7kbiZnh0426uIGCqpIneePqUCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I55BPff+g6eSJjOYbO353oLgLkIqcf4lnaA0HwRjIdMMqK+IX3fG6fmGcC6r0TtOm
         E/lCqaFyqv90JMrLrphTyLR60l+OuxcfGeWDVGwBnUPy5tb/KQRkQak1mnBrwYeE3+
         OylpZcBvu8kovIa6/4QuiLSxBF0qKW45wEcGAYeY=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-api@vger.kernel.org,
        keyrings@vger.kernel.org, Satya Tangirala <satyat@google.com>,
        Paul Crowley <paulcrowley@google.com>
Subject: [RFC PATCH v2 08/20] fs/inode.c: export inode_lru_list_del()
Date:   Mon, 11 Feb 2019 09:27:26 -0800
Message-Id: <20190211172738.4633-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190211172738.4633-1-ebiggers@kernel.org>
References: <20190211172738.4633-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

When a filesystem encryption key is removed, we need all files which had
been "unlocked" (had ->i_crypt_info set up) with it to appear "locked"
again.  This is most easily done by evicting the inodes.  This can
currently be done using 'echo 2 > /proc/sys/vm/drop_caches'; however,
that is overkill and not usable by non-root users.

In preparation for allowing fs/crypto/ to evict just the needed inodes,
make inode_lru_list_del() non-static.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/inode.c         | 4 +---
 include/linux/fs.h | 1 +
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 0cd47fe0dbe5..037df483c9af 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -426,10 +426,8 @@ void inode_add_lru(struct inode *inode)
 		inode_lru_list_add(inode);
 }
 
-
-static void inode_lru_list_del(struct inode *inode)
+void inode_lru_list_del(struct inode *inode)
 {
-
 	if (list_lru_del(&inode->i_sb->s_inode_lru, &inode->i_lru))
 		this_cpu_dec(nr_unused);
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 70d929ac89f9..326cbb044596 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2986,6 +2986,7 @@ extern void unlock_new_inode(struct inode *);
 extern void discard_new_inode(struct inode *);
 extern unsigned int get_next_ino(void);
 extern void evict_inodes(struct super_block *sb);
+extern void inode_lru_list_del(struct inode *inode);
 
 extern void __iget(struct inode * inode);
 extern void iget_failed(struct inode *);
-- 
2.20.1

