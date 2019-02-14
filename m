Return-Path: <SRS0=5TFS=QV=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7149EC10F04
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Feb 2019 10:01:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40C6C222A1
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Feb 2019 10:01:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="KBigOq3G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438174AbfBNKBO (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 14 Feb 2019 05:01:14 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41716 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438162AbfBNKBL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Feb 2019 05:01:11 -0500
Received: by mail-pl1-f194.google.com with SMTP id k15so2897212pls.8
        for <linux-ext4@vger.kernel.org>; Thu, 14 Feb 2019 02:01:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d+8KZV8DZGLRgOGveg0J5W9rdB86sPJhcL3c0ZOutP4=;
        b=KBigOq3GMXA46Jf89YvNpjxlwERRxbxOiixUCSXyzVypgfz18m0TnCHmw1LyIEsxR4
         u6CDoAfa4rQ7KY/p2gcWjJ1ObjGVOW3ndV/O1b2WxLe6RXzRJL/NzNrCBqafIlJ2aOkD
         p1rSTMbHQlWEAH6xxKIC7HjRBeUfOO/OF/1RI60Wax/m60qqEMkaBcjKkonAp2tKzI3y
         wEXdVnN0IFQ1ApKeOt118c68aubGz8o/bcxwq+WwMYe02S6SaHSWHwIOSzs8jfA/6fFo
         ze21Yp4QeNw1EvEH8PPzRIVKuRm+9Erw+MntpM8yfHD+Z66bffp5tU+lqClAB13QjgeH
         IbLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d+8KZV8DZGLRgOGveg0J5W9rdB86sPJhcL3c0ZOutP4=;
        b=VA2fQpsIbNvLxPgAYsSoSQNYNaooMU+OGVrAVlvWx3/x0osxZfN9AKNheadawtpgeX
         HfDs6apCtafiYzlklzZal+u7+KzOTHJAPE96/4PUTr1qohBljaj730JM0k+kC2cUPcSX
         jx1U5MnsyD7WPEWeYawTCcfgEop399oTbNi5X+5O/4Jpl6b8TO0LDv8ToLfDy7EfbCzG
         Yj3gpl210fUmI/pjMMcGAqDEa+/vffo7OtZ9mLxRkhxvIfCD+Ukrc8Azg2sm4y6UUKcr
         she7Wz8Kuw8ML4Wjr5eOrLzqEQ2lRZHtxw0vp0OATSM7Th7CVsbg1cLE9gwApfCYhR+P
         ibHQ==
X-Gm-Message-State: AHQUAuZ6nfd2q3Nvs4JKXLCqltuzbWbSs5KvTNwm4NscN4SQcYNxw7Sg
        KkSKEasrEg5GVF4mdT5ga1ZBDpo5JW8=
X-Google-Smtp-Source: AHgI3IZogSV5UwpjCxYG7lGfREUHa8OCIB5+L9KpQ00X2q5DUXho0Vqz3KaP7xFD8o20aziCZ1rMAg==
X-Received: by 2002:a17:902:8303:: with SMTP id bd3mr3361013plb.10.1550138470199;
        Thu, 14 Feb 2019 02:01:10 -0800 (PST)
Received: from vader.thefacebook.com ([2620:10d:c090:180::1:5849])
        by smtp.gmail.com with ESMTPSA id i184sm2686952pfc.41.2019.02.14.02.01.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 02:01:09 -0800 (PST)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Cc:     kernel-team@fb.com, linux-api@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org
Subject: [PATCH] utimensat2: document AT_UTIME_BTIME
Date:   Thu, 14 Feb 2019 02:00:15 -0800
Message-Id: <4717a88b238f1f03272598295942ebe8f24c2939.1550138203.git.osandov@fb.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1550136164.git.osandov@fb.com>
References: <cover.1550136164.git.osandov@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 man2/utimensat.2 | 38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/man2/utimensat.2 b/man2/utimensat.2
index d61b43e96..3b7c62181 100644
--- a/man2/utimensat.2
+++ b/man2/utimensat.2
@@ -211,7 +211,7 @@ is ignored.
 .PP
 The
 .I flags
-field is a bit mask that may be 0, or include the following constant,
+field is a bit mask that may be 0, or include the following constants,
 defined in
 .IR <fcntl.h> :
 .TP
@@ -220,6 +220,36 @@ If
 .I pathname
 specifies a symbolic link, then update the timestamps of the link,
 rather than the file to which it refers.
+.TP
+.B AT_UTIME_BTIME
+Also update the file's "creation time" (\fIbtime\fP). If
+.I times
+is not NULL, then its length must be at least 3, and
+.IR times [2]
+specifies the new creation time. The
+.I tv_nsec
+field may be
+.BR UTIME_NOW
+or
+.BR UTIME_OMIT ;
+this has the same meaning as for the first two timestamps.
+If
+.I times
+is NULL, then the creation time is set to the current time.
+.IP
+Not all filesystems store the file creation time; if a filesystem does not, an
+error is returned. At least the following filesystems store the creation time:
+.RS
+.IP * 3
+Btrfs
+.IP *
+ext4, if the filesystem was created with an inode size of at least 256
+.IP *
+F2FS, if the filesystem was created with the inode_crtime feature
+.IP *
+XFS, if the filesystem was created with the v5 format (i.e., with CRCs enabled)
+.HP
+Support for this flag was added in Linux 5.2.
 .SH RETURN VALUE
 On success,
 .BR utimensat ()
@@ -359,6 +389,12 @@ or, one of the prefix components of
 .I pathname
 is not a directory.
 .TP
+.B EOPNOTSUPP
+.I flags
+contains
+.BR AT_UTIME_BTIME
+but the filesystem does not store the file creation time.
+.TP
 .B EPERM
 The caller attempted to change one or both timestamps to a value
 other than the current time,
-- 
2.20.1

