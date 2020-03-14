Return-Path: <SRS0=MTsr=5A=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F7BDC5ACC0
	for <linux-ext4@archiver.kernel.org>; Sun, 15 Mar 2020 01:39:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C7FE2076E
	for <linux-ext4@archiver.kernel.org>; Sun, 15 Mar 2020 01:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584236354;
	bh=BekzoYGRaAG7hdnMIHYnXydLgmN0afGG/lRCyAbxsow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ulGXAxmm22QT4GtpnhO+pRpuTjyVJ1YpPov6RpO9sAKRCYv7ALIbNee0fyFGEPuKc
	 gHdQJgS0vh47wAV4Udp1lW6oYwYI13BB2WAXz8xhffOlF6FHhsfPyhEDrMIXTOjucE
	 CJ7vrwapbJb9LRKLTqsyR9l1w0DK/HjGzV0CIX20=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgCOBjN (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 14 Mar 2020 21:39:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726689AbgCOBjM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 14 Mar 2020 21:39:12 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A39620792;
        Sat, 14 Mar 2020 20:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584219194;
        bh=BekzoYGRaAG7hdnMIHYnXydLgmN0afGG/lRCyAbxsow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DxtA5FndvEQrWYJ1lLT38U6RoCkJTTKARYiBRkYMxyhpzJqs9rlw1ebJKhqeONoVc
         PrGI+9cNJaMxe/l32l3G3sElzfnTGKgS9d3i70orWJl/g5fzCmYnfWgQhCRW8GsDd3
         AUxOd5Pk7uahYWHoTpKyZYZRStA9y4nu6SuMdczo=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: [PATCH 4/4] ubifs: wire up FS_IOC_GET_ENCRYPTION_NONCE
Date:   Sat, 14 Mar 2020 13:50:52 -0700
Message-Id: <20200314205052.93294-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200314205052.93294-1-ebiggers@kernel.org>
References: <20200314205052.93294-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

This new ioctl retrieves a file's encryption nonce, which is useful for
testing.  See the corresponding fs/crypto/ patch for more details.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ubifs/ioctl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ubifs/ioctl.c b/fs/ubifs/ioctl.c
index d49fc04f2d7d4..3df9be2c684c3 100644
--- a/fs/ubifs/ioctl.c
+++ b/fs/ubifs/ioctl.c
@@ -208,6 +208,9 @@ long ubifs_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case FS_IOC_GET_ENCRYPTION_KEY_STATUS:
 		return fscrypt_ioctl_get_key_status(file, (void __user *)arg);
 
+	case FS_IOC_GET_ENCRYPTION_NONCE:
+		return fscrypt_ioctl_get_nonce(file, (void __user *)arg);
+
 	default:
 		return -ENOTTY;
 	}
@@ -230,6 +233,7 @@ long ubifs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case FS_IOC_REMOVE_ENCRYPTION_KEY:
 	case FS_IOC_REMOVE_ENCRYPTION_KEY_ALL_USERS:
 	case FS_IOC_GET_ENCRYPTION_KEY_STATUS:
+	case FS_IOC_GET_ENCRYPTION_NONCE:
 		break;
 	default:
 		return -ENOIOCTLCMD;
-- 
2.25.1

