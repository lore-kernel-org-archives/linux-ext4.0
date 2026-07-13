Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71F3353A7A
	for <linux-ext4@vger.kernel.org>; Mon, 13 Jul 2026 05:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783921309; cv=none; b=FooRRXPsTFMMLSUyihI64AI3KY18QjYgVUbSMPr5SueErblRgG+EjerB8jWn8gvEt3AeNmGic8x5+MLWCu3dr7uByN+xYXxhz2dzCATIiHa1K4yyDyxwHFuKkmELOlMoRPoXwMmEhwiERt9I0JLgnv+uGp215D/PczOQhE8t0Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783921309; c=relaxed/simple;
	bh=vhE0DTpJk3pDcfnSQjFf44X9BEXctBL+YSbVfWF7nr0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=pswoYTu2wVsjlmSg+Hq05KVbN8iJQQh+fc17v4bp02UuNMBQAaZroYkiJrdoZFW99kEjuBmAAV/KHiyOITy6CZvusBV3zXRfpWIZZkVKBsjlvXTUcdXF/qnqoCAXB4xHdYEP9jl5Nm50IvPRbt3C0A+UYfaSAnPXd2ulrt1EP+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jZhOlycx; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jZhOlycx"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-493c19bad03so23818345e9.2
        for <linux-ext4@vger.kernel.org>; Sun, 12 Jul 2026 22:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783921306; x=1784526106; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=fbf/ZFkAJS0G5xHmbYIZKb6SzasbIoKQxo/OZxrw+lE=;
        b=jZhOlycxj+FPp4K/WZmYLNBjhUiTmmx/2cylBdcSSdUJZo5KhIZIfWm3gO7weO+lfB
         VuioTJ5HyNiwVq7qrPNRlBdDq0hSoREyD54jGZ1RBEoNSbHJyWwlMt7vir3WZYWEHUo8
         Xv+bmbpYLoGBm+Kn2MB8Xx/d8KLHZq/DDGgl+ZBL1Ltxa4pGf/XMkeAHHcEZWReQq8yO
         wFQksfMlr4ghC6LTQniYYArqFUmNIZltTeKQNQyYEGluK+ouB2rdNh36T3mxfZ9/FeC1
         hP5TcYAwQ8UwAguWIp526hlWRvj1tUYIL2e25scNX8u9hAmXKBDAXvfH6CEcstwJWIiU
         ft3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783921306; x=1784526106;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=fbf/ZFkAJS0G5xHmbYIZKb6SzasbIoKQxo/OZxrw+lE=;
        b=QN5l4ztZsIKKS7oEj362i4aPkLghjzzpGaogB0lCG+WUZf1tVjNfP61Lbex39onSxC
         5jjxu+WqUCzLYBuPzbOs6LiFpQIyEi7I92ItVEfhWRmDMXYfdkYNKql06FnPeXfNTHSW
         2fiPmpFuOjbym8+s6wgpBd7SzXHsD6gYsaiyfJ/nbW3k0zOC2hqXt/hDA4Dw1HE6AeEn
         mp+9S2Yhq+pYo+5GxbvR+xsLNZi055v+IXaL2RldrCdXxxRMc2SCTb/XW4SgaZvALLbT
         o6AZnxoMC8YZ9r1sx9gyo+9lKns3rKHyWBl3rIRz7IxexV2fvTBOQed9A1yXZrFDVLTl
         UUeg==
X-Gm-Message-State: AOJu0YxiIeMDujv1mPNh2fcSMPMrFb2IYVdI7Bs2JREtAXHF/6sLiiAF
	Cc/etWV6ROoICfjf4QlCHZIz+G9xWU3W7ibw/tXj1weVLiQepl/Jrd23
X-Gm-Gg: AfdE7ckY6+toiay3SN5jRRnOFzPlRQ1ByZaAnieUZX2S5NTM4HUw3hz+evO7CEEMZUe
	5e8upxFIY+cJJXkOYltU99o7ILJZKo232+23K6Fk1ibtW8ygXZgZIAmK9tuZZEkO3fWjw+fyaYs
	QsGyr2RLPkRTvWCJk6ZynEHGesXSXWXsJrCJoTnqWUGqj9528dJW4nfy017bd+1JUtN65Yo1yMf
	HHtu6rubPR/eeq8bGd1kZAeZD653fV2plCHE/N5yjpyPHodUYuxUFIRZlamWjwx/mJDBl+M7XxF
	A75ENBomOCCGMlnmrafk+/7VSGlHt9nSOvyIZiKh7e8VVY0h/ZD+y2emsmv4XMIThoSyux7KCDZ
	Bl/EJom4TYg5HTZv02Ezhmh8kUqD8G1vIZzgs0nDmBScuKqV4QdWlm1N6dtMdLpizcQqI4Yuw1d
	0jY+klMePmVSRp5BLHG7vcsdZvgPo+hryoRKiUh9KjHJWxrvo/ZukLOHemV9WuCCUk8n+ZoYXTt
	MKNh/0qvph2gLD2ACS6TbCOFAd9lrHgwxHFaulXUOOk4BI8ryEKHh8PzIaM5IGEozIoAXHh5F4B
	yKQB3LZHJBgis/ROAOpnxqkLWC5AMqg7D6HqIS/S+UjYA8T6/DqG4Q==
X-Received: by 2002:a05:600c:4e88:b0:493:bc4a:d5f5 with SMTP id 5b1f17b1804b1-493f883be51mr77458135e9.39.1783921305958;
        Sun, 12 Jul 2026 22:41:45 -0700 (PDT)
Received: from [192.168.1.187] ([2a02:8308:4092:11f0::f9f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493f2c8de2asm246858205e9.1.2026.07.12.22.41.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 22:41:45 -0700 (PDT)
From: Joshua Crofts <joshua.crofts1@gmail.com>
Date: Mon, 13 Jul 2026 07:41:29 +0200
Subject: [PATCH v2] ext4: use str_plural() instead of custom macro
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260713-remove-plural-macro-v2-1-424e1536ac10@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/32NQQ6CMBBFr0Jm7RiKhKIr7mFY1DKFSSglU200h
 LtbOYDL95L//gaRhCnCrdhAKHHksGSoTgXYySwjIQ+ZoSqrptRKoZAPiXCdX2Jm9MZKQE3WmVZ
 fnTUEebkKOX4f1XufeeL4DPI5TpL62f+9pFDh4zLYoa6pLpu2G73h+WyDh37f9y+nT6ZOtgAAA
 A==
X-Change-ID: 20260711-remove-plural-macro-7ecfa879fcae
To: Theodore Ts'o <tytso@mit.edu>, 
 Andreas Dilger <adilger.kernel@dilger.ca>, 
 Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
 Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Zhang Yi <yi.zhang@huawei.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Baokun Li <libaokun@huawei.com>, Joshua Crofts <joshua.crofts1@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783921305; l=1547;
 i=joshua.crofts1@gmail.com; s=20260530; h=from:subject:message-id;
 bh=vhE0DTpJk3pDcfnSQjFf44X9BEXctBL+YSbVfWF7nr0=;
 b=6JJiSmPB9uHpUYQP6f4jNtN3obVrwZGotR3s9vMq54HZmtBE0epIiGov0mdGhjDgAEl6uxpMK
 tH6QRfIvgo+Cz6zgUXnAlbym1wcHMBDhry2Cji+0uflrlIM9/vGryyr
X-Developer-Key: i=joshua.crofts1@gmail.com; a=ed25519;
 pk=RTDOoVwgeL4oFdASj9U+cxJuIjXuXk73zkjnGOJKbEo=

Remove the custom PLURAL() macro and use str_plural() from
string_choices.h instead.

Reviewed-by: Baokun Li <libaokun@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>
---
Changes in v2:
- Remove redundant blank line
- Link to v1: https://lore.kernel.org/r/20260711-remove-plural-macro-v1-1-b3dcd44e4068@gmail.com
---
 fs/ext4/orphan.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/orphan.c b/fs/ext4/orphan.c
index 64ea47624233..373c1333af48 100644
--- a/fs/ext4/orphan.c
+++ b/fs/ext4/orphan.c
@@ -4,6 +4,7 @@
 #include <linux/fs.h>
 #include <linux/quotaops.h>
 #include <linux/buffer_head.h>
+#include <linux/string_choices.h>
 
 #include "ext4.h"
 #include "ext4_jbd2.h"
@@ -486,14 +487,12 @@ void ext4_orphan_cleanup(struct super_block *sb, struct ext4_super_block *es)
 		}
 	}
 
-#define PLURAL(x) (x), ((x) == 1) ? "" : "s"
-
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
Kind regards,
Joshua Crofts

