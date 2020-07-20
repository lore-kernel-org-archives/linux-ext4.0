Return-Path: <SRS0=Unkk=A7=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.6 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69A50C43464
	for <linux-ext4@archiver.kernel.org>; Mon, 20 Jul 2020 23:38:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4475A2080D
	for <linux-ext4@archiver.kernel.org>; Mon, 20 Jul 2020 23:38:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lw5TetxA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbgGTXiA (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 20 Jul 2020 19:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728098AbgGTXhv (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Jul 2020 19:37:51 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 168D5C0619D5
        for <linux-ext4@vger.kernel.org>; Mon, 20 Jul 2020 16:37:51 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id q5so11341069plr.14
        for <linux-ext4@vger.kernel.org>; Mon, 20 Jul 2020 16:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ORAQciKgJGVxLPMl88O8FRaS7Y2vfgBBYDIN8L834Cw=;
        b=lw5TetxAIlCI7U6av5shkKyjO6ThYv7yDbySa3SgWcGSwSgPPaWjP++XkjFPG4OI6Z
         zWsLpvD626keD3tI0jFOivGvaW9+0l5eZ4l7hYSrpPYOPlwsi9MGB5ODpbI/7AA04Zb6
         tCC6woja7XRBkrAJHy6DcRwqP6vgX9nv2QZPhmI0hiNoTeqEbeuJdvn+TgYDZ0U60y3g
         wohrCT9NyZKibcZkl+RWiaSOHqiofv/sVgqViMF4tlhAtCQWBZ6HI7L1fDpq7bbcky5t
         iAtFFwrxXVO/FU54Nfq5i3XKHkcF5DMzbZKLz73/s51/PlZliyzBh0FjxR+L3S2QGwsQ
         HjDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ORAQciKgJGVxLPMl88O8FRaS7Y2vfgBBYDIN8L834Cw=;
        b=HYNQ+G5HfG2ru2MbR5ORsDDVx2LazV+RzjpJsneJzUrw6m3flhd3ZXOs30mmQwxRQ+
         cdhyncxnA2mrbACv7K5upeH2VkwrcL9xd3xkNmJ64oM7Gow2X5vvnCPbQ1MGQkAtKXVc
         UZsRYIsRetIuo7AvRY/KegAtX/y2bedpaNIbOvLpZMXGf9UWa7qprIG2UPAT/hiSQbVZ
         CAkjvt+PuBGpGFovlGD04fvKselgS0g/HStDYxpTah6WSweWjDSCjzw9uRJNDa75LCSB
         Nsg9JIiDUVWl1gWI7xKc/OAX7IsuF3FrLY9zSlsrfR3231MZiDjbXfwGrHUnPrdSMKV/
         dgAA==
X-Gm-Message-State: AOAM532TeW5Ne0/ze6j9ThCyho+hU9RHW06TK7zY5GZEQvEQf7XxGNPw
        GyH6BOfomPfb2hmH7wHL1U98PiTOJsk=
X-Google-Smtp-Source: ABdhPJzbpOkXCUZlTjezDtyNTQJ78cDjswr6o9ZRsmmCMJPX/pJ7vOwFhl9AcEfTreNpJVDB8ZhoYLeMtXM=
X-Received: by 2002:a17:90b:358e:: with SMTP id mm14mr1889035pjb.54.1595288270643;
 Mon, 20 Jul 2020 16:37:50 -0700 (PDT)
Date:   Mon, 20 Jul 2020 23:37:37 +0000
In-Reply-To: <20200720233739.824943-1-satyat@google.com>
Message-Id: <20200720233739.824943-6-satyat@google.com>
Mime-Version: 1.0
References: <20200720233739.824943-1-satyat@google.com>
X-Mailer: git-send-email 2.28.0.rc0.105.gf9edc3c819-goog
Subject: [PATCH v4 5/7] f2fs: support direct I/O with fscrypt using blk-crypto
From:   Satya Tangirala <satyat@google.com>
To:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Satya Tangirala <satyat@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Wire up f2fs with fscrypt direct I/O support. direct I/O with fscrypt is
only supported through blk-crypto (i.e. CONFIG_BLK_INLINE_ENCRYPTION must
have been enabled, the 'inlinecrypt' mount option must have been specified,
and either hardware inline encryption support must be present or
CONFIG_BLK_INLINE_ENCYRPTION_FALLBACK must have been enabled). Further,
direct I/O on encrypted files is only supported when I/O is aligned
to the filesystem block size (which is *not* necessarily the same as the
block device's block size).

Signed-off-by: Eric Biggers <ebiggers@google.com>
Co-developed-by: Satya Tangirala <satyat@google.com>
Signed-off-by: Satya Tangirala <satyat@google.com>
---
 fs/f2fs/f2fs.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index b35a50f4953c..978130b5a195 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -4082,7 +4082,11 @@ static inline bool f2fs_force_buffered_io(struct inode *inode,
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	int rw = iov_iter_rw(iter);
 
-	if (f2fs_post_read_required(inode))
+	if (!fscrypt_dio_supported(iocb, iter))
+		return true;
+	if (fsverity_active(inode))
+		return true;
+	if (f2fs_compressed_file(inode))
 		return true;
 	if (f2fs_is_multi_device(sbi))
 		return true;
-- 
2.28.0.rc0.105.gf9edc3c819-goog

