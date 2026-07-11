Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE6233F583
	for <linux-ext4@vger.kernel.org>; Sat, 11 Jul 2026 06:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783751910; cv=none; b=LFEUmoqQ8UJpmF5O+dHWHPNgCy51RlwydHihh3+LUu8s6NixGchhswb1UzMY0KB8mzgiS5gvngVCSLiQJFfMI/zR0nuZJ8q7g4riLTf5XJpa8Vn3GdFC0199sN6Vpx58FXovRnukKbTA7Z1633l18sW8aUiaD7+wXQTqNXK4z+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783751910; c=relaxed/simple;
	bh=dWWAMJSMfGrLurlCO2n/jTCqsh5B1l9WE2bnm0I5Roc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=UfVRCwpGx/Uzk9tLWQ6lpxeaubA+MbcGbmAh3uNSGH+ctuwVnxWJQnf4wVuiGo4W2tzamAPgR9oAdbfcFxvmSilY/hzvGqYl6zQHODSBKd2TVaQnDc2M+mO/w3G/SCLWRaeCpZvTuH4DiHLyTRGEM0ISmR3eilktz7fCnvO+dok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f3ykabJo; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f3ykabJo"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-493f4638f4aso14493145e9.3
        for <linux-ext4@vger.kernel.org>; Fri, 10 Jul 2026 23:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783751907; x=1784356707; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=/s+2rX7eEUkFVusG/7aG24rqZbgQVdZ6GO/PTTSZUO0=;
        b=f3ykabJoCg30VJgvb0yCbuxi1OZl1JJioLG/WRQarXjpIONGv449ncNhzMdRq/mGsM
         Uvy+D0rlbSRBIPEwQo6fH8/HJ7Us4DQHbbG2dtg6Y1cgpAJmIA/efTz7LVbS/rGRL0Tv
         hzx59wzpT9DAcZGgTykUOnPQXpKz17/WgVL/uTjcjZ3bkUmKvsXaCXOH9DGORpsOFxG6
         BmZUElA9kkQOtfhjcDV07LbyvbvxKjaqXzR8dPoCu2d7b/NV4cM5BHxcA5PwtkoYZNTT
         tlCRQbx5qTvN7IR8kSua7XGCncxyfOT6PDRIdIVJIrcZCJZDTi3pk6npcEvVXw4dhmDX
         17Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783751907; x=1784356707;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=/s+2rX7eEUkFVusG/7aG24rqZbgQVdZ6GO/PTTSZUO0=;
        b=UBGCl8ge7/JCJYu9A8NERz+tCWH3RosFVmbEkyLvB22Z9SCCnA9f6B9j3ac3O/fvXi
         2/fOZ3bqJgrWjCo5N8AjWo3Wph80erUc2BBN5Xgf09IjBFpOj5wEbq0X/EwHhxiduXHX
         rWDqyXjrBMKP8R+EVOKx34HmUGagpDbdHLUbHBfRTinOWnF1JQGxOHdymvJzHyVBKFxt
         l49SBv6w2W+AmdpjkUEyRBuuCc3I8VJCIKnATLfff/7Gk1HgcwHmGB8E9fB25c5QHgOQ
         0wsXvjcReZOhYhmUsNVCGiqM1qAqTS8GbiPWpgZx/Z2k6fAaL1OR3vqyAQHjGzwCmkZl
         P8qw==
X-Gm-Message-State: AOJu0Yyrt674pHCVXVI3T85p0eP66ZEb8G/3DYLPXG7GlYAAry/Zo+hP
	BwNFPUxqJM5lIAEVlHiOuUBU5Jk5gmy89e0bCwYzI4VesHvmG+NG+6G8bVUvmPXz
X-Gm-Gg: AfdE7clotm8wDcQFvsR5+GQPOocMtrvS38jvrkbUsUnme2Oo8KSCHndYE02prfsUo8u
	LB5qx22AZoPkaf+CaxK00wIs0ZKP0nqBCDCA23dKL0GFJS7AV7Tg1VkaAhV5NWhbQBnqlZKUaJ7
	6MGzAOQkmN8bjsrx7eq7E5jiqTcCpNbmRR2ViN3P2q9QloTaPYo6P/Jtl1r8neKkVl7LJQLSfYd
	klPt8DGudQT8q/E1l6extKrILLDBDXhulqpcONWwzf0M6JLGiKTAT4qiUp2KIrI8u53JQjWv03z
	SpR9TxXI8OyFvKba65pJrKUBqeRb0qGYJG3g773EG89iGTbItCIoT8JWjTN41LnDUvJMCs0Lnyl
	j2uZZ8K2nDULHQU7XTEtW86KZz3X3hF5TdP71Ke2D8N412HMsKwIEsa8qfgR1qE4FRX1lBbrwH1
	FkdbiNzBCOk4cq1cWTM4xdq/Wry5yDjVKRbMLOJJHdIJ/rjYRgSlciNAcg65CFuGtlOKR1fu7o+
	6H/MYWjrb7QB36SFhTgJPN2KR5xZ7T68xrn5te0p/AYOL9wb8coMn69hO3rxIrAhEbQ+5MBDDyL
	DTPtSQde/0fZmlgwDUkZ1dps85O7xTi7VgDpOfbpstw99HhiU0aC6g==
X-Received: by 2002:a05:6000:26c7:b0:46d:55a5:8ec5 with SMTP id ffacd0b85a97d-47f2dcf9e3emr1466458f8f.33.1783751907045;
        Fri, 10 Jul 2026 23:38:27 -0700 (PDT)
Received: from [192.168.1.187] ([2a02:8308:4092:11f0::f9f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47a9de1e736sm70744243f8f.7.2026.07.10.23.38.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 23:38:26 -0700 (PDT)
From: Joshua Crofts <joshua.crofts1@gmail.com>
Date: Sat, 11 Jul 2026 08:38:18 +0200
Subject: [PATCH] ext4: use str_plural() instead of custom macro
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260711-remove-plural-macro-v1-1-b3dcd44e4068@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MQQqDMBBG4avIrDuQuGjaXkVcDPGPDkQjEyqCe
 PeGLr/FexdVmKLSp7vIcGjVsjX4R0dxkW0G69RMveufLnjPhrUc4D1/TTKvEq1wQEzyCu8UBdT
 K3ZD0/F+H8b5/3i6w9mUAAAA=
X-Change-ID: 20260711-remove-plural-macro-7ecfa879fcae
To: Theodore Ts'o <tytso@mit.edu>, 
 Andreas Dilger <adilger.kernel@dilger.ca>, 
 Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
 Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Zhang Yi <yi.zhang@huawei.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Joshua Crofts <joshua.crofts1@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783751906; l=1303;
 i=joshua.crofts1@gmail.com; s=20260530; h=from:subject:message-id;
 bh=dWWAMJSMfGrLurlCO2n/jTCqsh5B1l9WE2bnm0I5Roc=;
 b=lmuVrHFGc/gjExIXjwRFMNDC8aAsJm6goNGOpZnR7co1i4kdwNxQZLrsUIVxkUNcL+xVweE1E
 leVj2NQNZ19BjuCP2jSpN0sCTRcAnYrtDZhI4Wjp1BIci7Y4eX4oh+8
X-Developer-Key: i=joshua.crofts1@gmail.com; a=ed25519;
 pk=RTDOoVwgeL4oFdASj9U+cxJuIjXuXk73zkjnGOJKbEo=

Remove the custom PLURAL() macro and use str_plural() from
string_choices.h instead.

Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>
---
 fs/ext4/orphan.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/orphan.c b/fs/ext4/orphan.c
index 64ea47624233..e307d6d55451 100644
--- a/fs/ext4/orphan.c
+++ b/fs/ext4/orphan.c
@@ -4,6 +4,7 @@
 #include <linux/fs.h>
 #include <linux/quotaops.h>
 #include <linux/buffer_head.h>
+#include <linux/string_choices.h>
 
 #include "ext4.h"
 #include "ext4_jbd2.h"
@@ -486,14 +487,13 @@ void ext4_orphan_cleanup(struct super_block *sb, struct ext4_super_block *es)
 		}
 	}
 
-#define PLURAL(x) (x), ((x) == 1) ? "" : "s"
 
 	if (nr_orphans)
 		ext4_msg(sb, KERN_INFO, "%d orphan inode%s deleted",
-		       PLURAL(nr_orphans));
+			 nr_orphans, str_plural(nr_orphans));
 	if (nr_truncates)
 		ext4_msg(sb, KERN_INFO, "%d truncate%s cleaned up",
-		       PLURAL(nr_truncates));
+			 nr_truncates, str_plural(nr_truncates));
 #ifdef CONFIG_QUOTA
 	/* Turn off quotas if they were enabled for orphan cleanup */
 	if (quota_update) {

---
base-commit: c143957520c6c9b5cd72e0de8b52b814f0c576fe
change-id: 20260711-remove-plural-macro-7ecfa879fcae

Best regards,
-- 
Kind regards

CJD

