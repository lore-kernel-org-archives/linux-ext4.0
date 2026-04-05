Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2F837F015
	for <linux-ext4@vger.kernel.org>; Sun,  5 Apr 2026 19:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775418648; cv=none; b=K9TXlbK6Gks7/wKPBwqCfRbrCt1f+2DQAJmV6LpbggJtSCSpKp/Z6jFDfLvHtB7BN9qf7n2Yvvs6bldRJ10jVcPe/W+A6ezmXgjD71isAQu2Wigoss8eiDcjVF9c8CRy2XWH8dfohcccJNM8vGIr8H77HnQW4k53nc/1IbXDl8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775418648; c=relaxed/simple;
	bh=Y0VePmfDKqj2Wr4uBDtOu+PZcxWOL70k8AGZMMUQvs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TfUVY7k3Md6X0MBRhzjLVn14DZIi5hnbiTphsqJOvhFiqWnW4xHLiot7N/bdQD29sU9nxInuHtn4qjGtMOsWv2ew4UDhCNvlkoCqoIFc1DsFUAaBlIwFYxfTGFgkViGesud4uhzKW6J0eQLNgHoxz9fMJp20SHrG1EwtnkbgYbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XdDrRQQ5; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XdDrRQQ5"
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-470145d7e6fso433608b6e.2
        for <linux-ext4@vger.kernel.org>; Sun, 05 Apr 2026 12:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775418646; x=1776023446; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K8lGtdviJ/yNeFObSgzOPOsYD9zf1PXG9ZhAjN6EY4Q=;
        b=XdDrRQQ5qPYkH9zR2x/+NtoWTga+XHyaTfGu1QNncVF0j2P77Okxr4pSiPY5tVZ1XK
         2eV4SZrhm1H7mdLog/K+3uJqJ8MwfupaNM0WfLwj0hV6rwZzzGKUv5gq+7j4dn1J1rRG
         Lx+PUov62S0/fA0CNBAT+tn5RjkXh+UarmL6Nj40U+N5kYOp+Z2fsSjLtMUBbS3RmLVv
         zsHg78reMJJuXVPkHgVXT/jF0GyodEaZCMktPIBj4wCWdrB+Hf/s3w7hNhFS3vjI7UQ3
         EZRt4JkHYq/34JFuYw0TKcAog1ZpCcLAVCD3CTPUajc5sl6NAIsdyJnpZSAccg4KNZDz
         LxvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775418646; x=1776023446;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=K8lGtdviJ/yNeFObSgzOPOsYD9zf1PXG9ZhAjN6EY4Q=;
        b=EwP85Wnj3jkA1LNE6/q7tf1vgH2KWmqFuUL28ubJeaSu2aQoMoqRJkTCkWwa5kZNN5
         ZLaYbxgcVrqahgtqT2HRO/tfJ3V5SqlaZDQy/0J8LV+020MTiQph9e7eoI7aHA4/7XDP
         iVQHvHLVXzEVTJqxopTpWFKJevNPYUr2ElsRKzN0wdEnk0YCEYEzpJsIkVtWGcC79dh+
         CSgr58TqHlv9jVjAdM2SwGSfOgHB8j+D6Q8gumF+JRXR0uLtd7a/1vCZ0XjCfBlNzM8B
         G3KT78uuaBtP2wCtkkgcT+KGXj1U+cwiok/M4ct7uNezlrziJjZQ5Ho0l4JhM4JWBXeD
         q7Rw==
X-Gm-Message-State: AOJu0YwwXspoLpSD4ErJ+n2LNE0y81hw4gXHiX1UESx6hSClS/c4gsMY
	rBwEEvJpLWmSa7eRnW0CrJa1bvSM/nkWQXys+KHsXmO51+fIjlcWpmag
X-Gm-Gg: AeBDietq0UPWr/UCI/4P8NVuIGC9ZKuUkvDfVEu++QZcrkyj9Ury4DaoYQ90l7Tn61e
	p7EsgWZcFRQ2w0+vlbhGSBrqgj2HTc40TVsXsr1/pbt2LDreeJNTnRRFw8ujWRkPrEWBobnGLPY
	+IvoZga0K4W/VEuLLGG2htkWZHoOv2PoDKmq17jYky1ZIxS5UlU9NQ69wUi/wf4wGSKOAAjVCf/
	NC6vX3g9iIdyJpL7jdKZ6UeFhNHp8ED8np/J44NiD26z3TLvoEWONHaiFFkk3Qz/kaQjUMsyFY3
	ZaBOxFummzzpG7FLO8tkLU0tUtBmTW8O9lXFm1OvshxP9hONRD3I1o1J0H6xK7opvAR66jSUU5T
	Fd7vKHI/9Iu39qHL4/fClfo/+L3KOtUgn44aiucWWd9+6s05ATvjf5RiCtEM7df1I3aJBOvj6RV
	zP1Y1Dj2Mrtv4d7UfqqUHBWSki8gdcDcKK7atpLWaMVGosMDCoZ70kI1cE6faYmyqRikxXJRfAF
	Y9HvwYMss2dykg=
X-Received: by 2002:a05:6808:1511:b0:46a:738f:7666 with SMTP id 5614622812f47-46ef7a12be7mr5024308b6e.36.1775418645800;
        Sun, 05 Apr 2026 12:50:45 -0700 (PDT)
Received: from localhost.localdomain (c-73-5-99-191.hsd1.la.comcast.net. [73.5.99.191])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-46f46160155sm4547428b6e.17.2026.04.05.12.50.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 12:50:44 -0700 (PDT)
From: Sean Smith <defendthedisabled@gmail.com>
X-Google-Original-From: Sean Smith <DefendTheDisabled@gmail.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	tytso@mit.edu,
	dsterba@suse.com,
	david@fromorbit.com,
	brauner@kernel.org,
	osandov@osandov.com,
	almaz@kernel.org,
	hirofumi@mail.parknet.co.jp,
	linkinjeon@kernel.org,
	Sean Smith <DefendTheDisabled@gmail.com>
Subject: [PATCH 5/6] fat: map ptime to FAT creation time with rename-over
Date: Sun,  5 Apr 2026 14:50:01 -0500
Message-ID: <20260405195007.1306-6-DefendTheDisabled@gmail.com>
X-Mailer: git-send-email 2.51.0.windows.1
In-Reply-To: <20260405195007.1306-1-DefendTheDisabled@gmail.com>
References: <20260405195007.1306-1-DefendTheDisabled@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Map ptime to the FAT/VFAT creation time field. Only active on VFAT
(long filename) mounts since plain FAT12/FAT16 lack creation time.
FAT32 creation time has 2-second precision.

Getattr: report creation time as ptime (VFAT only, via isvfat check).
Setattr: write ptime to i_crtime.
Rename-over: save target creation time before detach, restore to
  source after attach. Preserves creation time across atomic saves.

Signed-off-by: Sean Smith <DefendTheDisabled@gmail.com>
---
 fs/fat/file.c       |  6 ++++++
 fs/fat/namei_vfat.c | 20 ++++++++++++++++++--
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/fs/fat/file.c b/fs/fat/file.c
index 4fc49a614..9d1fcc554 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -413,6 +413,10 @@ int fat_getattr(struct mnt_idmap *idmap, const struct path *path,
 		stat->result_mask |= STATX_BTIME;
 		stat->btime = MSDOS_I(inode)->i_crtime;
 	}
+	if (sbi->options.isvfat && (request_mask & STATX_PTIME)) {
+		stat->result_mask |= STATX_PTIME;
+		stat->ptime = MSDOS_I(inode)->i_crtime;
+	}
 
 	return 0;
 }
@@ -564,6 +568,8 @@ int fat_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 		fat_truncate_time(inode, &attr->ia_mtime, S_MTIME);
 	attr->ia_valid &= ~(ATTR_ATIME|ATTR_CTIME|ATTR_MTIME);
 
+	if (attr->ia_valid & ATTR_PTIME)
+		MSDOS_I(inode)->i_crtime = attr->ia_ptime;
 	setattr_copy(idmap, inode, attr);
 	mark_inode_dirty(inode);
 out:
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index 47ff083cf..f1e2eadf8 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -975,8 +975,24 @@ static int vfat_rename(struct inode *old_dir, struct dentry *old_dentry,
 	}
 	inode_inc_iversion(new_dir);
 
-	fat_detach(old_inode);
-	fat_attach(old_inode, new_i_pos);
+	/* ptime rename-over: save target creation time */
+	{
+		struct timespec64 saved_crtime = {};
+		bool inherit_crtime = false;
+
+		if (new_inode && S_ISREG(old_inode->i_mode) &&
+		    S_ISREG(new_inode->i_mode) && old_inode->i_nlink == 1) {
+			saved_crtime = MSDOS_I(new_inode)->i_crtime;
+			inherit_crtime = true;
+		}
+
+		fat_detach(old_inode);
+		fat_attach(old_inode, new_i_pos);
+
+		if (inherit_crtime)
+			MSDOS_I(old_inode)->i_crtime = saved_crtime;
+	}
+
 	err = vfat_sync_ipos(new_dir, old_inode);
 	if (err)
 		goto error_inode;
-- 
2.53.0

