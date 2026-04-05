Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151A0381AE1
	for <linux-ext4@vger.kernel.org>; Sun,  5 Apr 2026 19:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775418643; cv=none; b=Oz9OMN3hWnRGyB5G0l4N4FBMgLqACYP7MsuPA297GbdWJWgy3baumPc1TUbTZv/Ggk9W/eRqAN6ZwQXk4tWjnHN4n9lefRBne2XvWttA1tcOjCPTWRhE3q0V5zwpKovsUT/0Tc/0puqrnKXjtNkqwXeo4APxAB0sXRfp8wi4HpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775418643; c=relaxed/simple;
	bh=M3Pjhbze6h8AbWBgQKGzzirkBeW7ABl2/2UM8BAwgDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BMHfp9dIj99m/0D2Qj1xROfFXiHr5HpLv1iJTIONi+lIO5lxAw5VymT7Ju9R87YzvOHvvdc89dK9R5g/5TdkYo/2NncPhkKQhGZv1ufzkZc1rmEHycS80vh+4+/dQvFXZ1wGoTg47Lis0S4C9P44k2IA1mla1laJhbTfEiossio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MFGd3Z38; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MFGd3Z38"
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-46eca92a297so1675760b6e.0
        for <linux-ext4@vger.kernel.org>; Sun, 05 Apr 2026 12:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775418641; x=1776023441; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NEusXoSwED78w0vyJyU5i030iDxdLxYwqTLGcdoyW1Q=;
        b=MFGd3Z38AU/J7a2O6oIPMttJmmmN9rttQChMC6sOmnGQshaIseiIvJ0AU67UDhSlWb
         I2RLPiBpqVWhTTFZWGDBzI8bqhEMtCIQROjUWIzUmDBPFcThCyNEbelT0+5u4KDc+cfD
         YPc+JDCf9vTKTz3xjyUo7PW6X2t5EaTjRTQzH6qVgMRlwVbzeN0VBepiCNUzHB46JwcJ
         ppFBSMKNPLNXCO0oA5mRNinVThyOYF9vELDMQjmBEyWPP1edyOiz0O/UB4QX5xu5nrUJ
         UJOVxxzjQzd2P+1kH80hFE2RummrWZoczwBNN3kBsXLRepADMjd5XARKmyBA6DZgY5MC
         CWtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775418641; x=1776023441;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NEusXoSwED78w0vyJyU5i030iDxdLxYwqTLGcdoyW1Q=;
        b=qMcuBsEsfh87tflIUg0XW2nFB2a7pyvNZJ9JQyrXJ+GUVB1f5Z8bL1YpDVwOZUGevi
         CAzFW8EhtT7ZSjrggbl9DEV9sFhifPQAHE7U/ECnT+ZWKk6k+U1DAeNMmzizZhaLOh3W
         lJ3poW7CjUBEmq0lzxGVHazxx3zVhGJxEEaz3v6rQBR5nUdg+TwVgg05sBWInTjDNE4A
         uINp8KJT5mwRTFWk/fniGntiFCFRJoERJVGqHg7SLntAqnMCcFVlo/9nx3WsZKc3e5bQ
         wPUKXmHqUc5aCy9B2jTnsZbOSaWk0N/PNXdgYg860GQFx/l/GJhFSprPbJGmyzn5y5+8
         /qWg==
X-Gm-Message-State: AOJu0Yy3DAcQUyJ211n5rbjWgo+Cy1jGIHNtrMPI3onPRfrgg/tLDt6u
	qlBHh1eUou6/8VqzxREVRnHwUmxqWMoWBAa85KDpG7hDwQ3MlYx2LrfU
X-Gm-Gg: AeBDiet9aRJRJutsCHvuIEnvymkAoSM8BM0XQenlOVJFZV2IP2u60dLn46+k27Z2qK/
	Wiubi/0RaxQLQOQdKHYeoD/VqI3v3H0+Zxj7yhkUI45DTzhNoBZGzUOZyjuzWcHT+Dq0e4MF5c5
	jV2AuVOxH0sYl7FKuT/Wnw0oK5oToU5Kek/eNfKisv4UUI7WxOv5vOLA9rgLjFK7zxS4MO/QDhF
	GsmIAR3D4sfz85jLYeErLqo9H9W3vIjvxfnvySQ9a2sGeeNegnHzF7CUo6m/HAfVdw5GLN49H+G
	ok3+o6xgp7vrp5iC0jWb34UcF1QVu0R3CE4GrUry86j498r1eJ2jVXbEsQO3RV7GXID9eTSnRBI
	8EyjEDMr0MDaFloRsr97i9TwXeMYkeG5vxTtIyekutnIhoBDFqGtk/o7xbRcTWmXSVfTbNJmYuy
	LNZp0cFHcLB0ph2NepW1Gr/CC7m7i0eIq38y4r5EfflABr6hmhld4zyDVFLjKkSQE74Tl3XJXz3
	QfsMxBa4TgagA+VIYxmEx7bvQ==
X-Received: by 2002:a05:6808:5088:b0:468:1574:4cc1 with SMTP id 5614622812f47-46ef8d5bf29mr5189492b6e.3.1775418641053;
        Sun, 05 Apr 2026 12:50:41 -0700 (PDT)
Received: from localhost.localdomain (c-73-5-99-191.hsd1.la.comcast.net. [73.5.99.191])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-46f46160155sm4547428b6e.17.2026.04.05.12.50.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 12:50:39 -0700 (PDT)
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
Subject: [PATCH 4/6] ext4: add dedicated ptime field alongside i_crtime
Date: Sun,  5 Apr 2026 14:50:00 -0500
Message-ID: <20260405195007.1306-5-DefendTheDisabled@gmail.com>
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

Add i_ptime (__le32) and i_ptime_extra (__le32) to the ext4 on-disk
inode structure after i_projid. Total: 8 bytes in the extended inode
area. i_crtime remains untouched as immutable birth time.

This is a native-ptime implementation: ptime and btime are separate
fields. On 256-byte inodes (modern default), both fit easily. On
128-byte inodes, ptime is silently unavailable (same graceful
degradation as i_crtime via EXT4_FITS_IN_INODE).

Uses existing EXT4_EINODE_GET_XTIME/SET_XTIME macros for read/write.
Rename-over: when a file with ptime=0 replaces a file with ptime set,
inherit target ptime (same zero-sentinel logic as Btrfs).

Signed-off-by: Sean Smith <DefendTheDisabled@gmail.com>
---
 fs/ext4/ext4.h  |  3 +++
 fs/ext4/inode.c | 14 ++++++++++++++
 fs/ext4/namei.c | 13 +++++++++++++
 3 files changed, 30 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index f1c476303..5c2812637 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -860,6 +860,8 @@ struct ext4_inode {
 	__le32  i_crtime_extra; /* extra FileCreationtime (nsec << 2 | epoch) */
 	__le32  i_version_hi;	/* high 32 bits for 64-bit version */
 	__le32	i_projid;	/* Project ID */
+	__le32	i_ptime;		/* Provenance time */
+	__le32	i_ptime_extra;	/* extra Provenance time (nsec << 2 | epoch) */
 };
 
 #define EXT4_EPOCH_BITS 2
@@ -1136,6 +1138,7 @@ struct ext4_inode_info {
 	 * struct timespec64 i_{a,c,m}time in the generic inode.
 	 */
 	struct timespec64 i_crtime;
+	struct timespec64 i_ptime;
 
 	/* mballoc */
 	atomic_t i_prealloc_active;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 625cfbf61..15b6b6dc6 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4753,6 +4753,7 @@ static int ext4_fill_raw_inode(struct inode *inode, struct ext4_inode *raw_inode
 	EXT4_INODE_SET_MTIME(inode, raw_inode);
 	EXT4_INODE_SET_ATIME(inode, raw_inode);
 	EXT4_EINODE_SET_XTIME(i_crtime, ei, raw_inode);
+	EXT4_EINODE_SET_XTIME(i_ptime, ei, raw_inode);
 
 	raw_inode->i_dtime = cpu_to_le32(ei->i_dtime);
 	raw_inode->i_flags = cpu_to_le32(ei->i_flags & 0xFFFFFFFF);
@@ -5409,6 +5410,7 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 	EXT4_INODE_GET_ATIME(inode, raw_inode);
 	EXT4_INODE_GET_MTIME(inode, raw_inode);
 	EXT4_EINODE_GET_XTIME(i_crtime, ei, raw_inode);
+	EXT4_EINODE_GET_XTIME(i_ptime, ei, raw_inode);
 
 	if (likely(!test_opt2(inode->i_sb, HURD_COMPAT))) {
 		u64 ivers = le32_to_cpu(raw_inode->i_disk_version);
@@ -6061,6 +6063,9 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	if (!error) {
 		if (inc_ivers)
 			inode_inc_iversion(inode);
+		if (attr->ia_valid & ATTR_PTIME)
+			EXT4_I(inode)->i_ptime = attr->ia_ptime;
+
 		setattr_copy(idmap, inode, attr);
 		mark_inode_dirty(inode);
 	}
@@ -6114,6 +6119,15 @@ int ext4_getattr(struct mnt_idmap *idmap, const struct path *path,
 		stat->btime.tv_nsec = ei->i_crtime.tv_nsec;
 	}
 
+	/* Report ptime from dedicated field, not crtime */
+	if ((request_mask & STATX_PTIME) &&
+	    EXT4_FITS_IN_INODE(raw_inode, ei, i_ptime) &&
+	    (ei->i_ptime.tv_sec || ei->i_ptime.tv_nsec)) {
+		stat->result_mask |= STATX_PTIME;
+		stat->ptime.tv_sec = ei->i_ptime.tv_sec;
+		stat->ptime.tv_nsec = ei->i_ptime.tv_nsec;
+	}
+
 	/*
 	 * Return the DIO alignment restrictions if requested.  We only return
 	 * this information when requested, since on encrypted files it might
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index c4b5e252a..1bfe4df24 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3942,6 +3942,19 @@ static int ext4_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 	 * rename.
 	 */
 	inode_set_ctime_current(old.inode);
+
+	/* ptime rename-over: preserve ptime across atomic saves */
+	if (new.inode && S_ISREG(old.inode->i_mode) &&
+	    S_ISREG(new.inode->i_mode) && old.inode->i_nlink == 1 &&
+	    !(flags & RENAME_WHITEOUT)) {
+		struct ext4_inode_info *old_ei = EXT4_I(old.inode);
+		struct ext4_inode_info *new_ei = EXT4_I(new.inode);
+
+		if (!old_ei->i_ptime.tv_sec && !old_ei->i_ptime.tv_nsec &&
+		    (new_ei->i_ptime.tv_sec || new_ei->i_ptime.tv_nsec))
+			old_ei->i_ptime = new_ei->i_ptime;
+	}
+
 	retval = ext4_mark_inode_dirty(handle, old.inode);
 	if (unlikely(retval))
 		goto end_rename;
-- 
2.53.0

