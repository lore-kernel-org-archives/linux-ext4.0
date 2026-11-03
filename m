Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713824;
	b=1LKNnWKQprDkrl4GcwOgsnrzbtY8G4UK7NI5oB4gkdgLUFdUfChT0ubDg2WQqs679/lX
	 GwDNZcdNDoxDbdXJJAp+N9NSSBr/eQsZhuWGYKFNwh9kmc4X//a5QDSaTAJt7xOSyDyL1
	 ffFHnxbfd9B4vzYxKXzgsnb1JsxKzMqciSV8ogNBUvz8ZoUER5YzuO8sdlU5lPlyORSvQ
	 mC/dp7ZBonH9/LFNfycNSb5oO+376OAR+g5y4Fq6pqWFVjk4T+lvnj3Z9dzrHBLfX1K7Y
	 paxN5CpgaWcVXOky5+9c4fPdbrj4466ZgxE1BO3AKsgByKQ49ECdbz6VKZjP36q09ZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713824;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=bD/ELsJMj81SbIwRHimF7sCr4SYJAXX2Rp34VNAVrqw=;
	b=cKU/tiYdVRSyuaB+ICoQvELUSBnms0tpIK8trFRV+gZIdi41LeUOP6VcLUSwMxt2ZHh8
	 uPM7EAa9hMWOBuKmOu0Yy/Si2HQC8brivVY6QB3j0dX2HU8pX2d72gigUVIn6Badw1m7B
	 NMRUChzjXn67gvSIyJKVcdl2d9mo6k5vDh6OCKRYsZojt50wnLAANIx+JpDUWGidQkE0P
	 b/1ZLyoNoROUnVfdSgtLsOrJ1WXyruCuZZxbq/xeGfMBqnNBlhUGgQN+A2glGeOMk94r6
	 xaZ3MVehDKYJ6EEkEXH4oMaB55XIigkSChZ7K9A5fGGG7XYo/rsTpELvuUwyqXKlC4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yxvSNn2V;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5025606A331
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 13:50:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B5025606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yxvSNn2V
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a2069b9710so35761825e9.2
        for <linux-ext4@vger.kernel.org>; Tue, 03 Nov 2026 05:50:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793713822; x=1794318622; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bD/ELsJMj81SbIwRHimF7sCr4SYJAXX2Rp34VNAVrqw=;
        b=yxvSNn2V2DM7XbuHxkvVuFX77pLKrnFqeYi49IBn+xclYA+WbYIekWnps9I4NqC6cK
         4Bb5MAX2Jayyx3BGve76n8CivVHAfeI1nQys5dqJQWuyGMW/f3WvF4KrGw1NNwTq1TLc
         UsBQMIxt9IO2V6iw71o+ESO5Z7tjVh9NP8izgxdrPWwrRkaQR9gcOUB+tbQ4dZsjVaHX
         7WewkCYmvIO/7VrHzjd61L478u0Ygss8sEoAIA+Cl9oRJGsQLinqpItih5DAynSfSP+I
         iIVsZMKvWkCN9CauM4sQ1USutlOQuR/oCO76PPinLl9A9s95VrdPM/du2ZA1Kdg6m2oG
         GB/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793713822; x=1794318622;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bD/ELsJMj81SbIwRHimF7sCr4SYJAXX2Rp34VNAVrqw=;
        b=XeC/aAcdb80rzpZzMq/Fg2uGKKgp0UcAvICtdTqxydccduw1m0bbSERt9m2haeEb67
         ZfeaNFPdaTZQG0+jwXEI2Gf3wAUAqmuXKguoUueXDUMGeOU2wfl2maZ43X6jgYsISTT3
         BiD1ptnvnogsdEN5Po1BVGD4wwjuyCO6lK7czSNsNReSf91GEzpxGjEhv3rNwRSHaoqf
         2O7tZGJX5xcEJpWAz2o8P5hs+n+78l7AIDtIFDav/VTmgxrgzkxQ7a0e7caCPdVxB2fM
         KcM5lc1on3qK7GXGnQngTOkRXA2zmTKjNIAyS5aD0kC9hAnjXi6WetdS8eICXY8sWFqq
         Xs4w==
X-Gm-Message-State: APuU4Z8pKdUPmg7GRJRRGyFM0QA4dnPWwr00n7aOIvfOsWfSZa6F+7dB
	iJK/MZz4HRQs9rePKeclIJxJJYCs4v3CIlUYs6EiuQvqmoX3MEZU/J3ZvaBXd9IOtFs=
X-Gm-Gg: AYBFou00CkdyDmkP/+tsQMuLAM0sJ6O8qG28eNkwZvzpeUD5b+Wt2niGAxfZEarV8lM
	qQDWvfvY3Hmf46iCVJP///XH/iq7d+mBBLvobl/3dJbCCSDjkhQlud06df7cOmhYMTk1gFsNSbC
	FL0PP4Ia+kc/3ORtuFb2Qtix9ivrEswnyf4iwgvHcCtuDwwsZ8PZ3Y7qkg+au0964oIb56XXSJI
	9v9HyEytiPnCDW7t8vGnncaEcmLeDhrYC0k0m6GVk2WbxPBAwTdvQ7KT4XrSndN0cXBrVpdg8iz
	0Cz7BDDTXOLvDJ9xkvP4q2M/KgW0panuJmAOmXsN5H1IbobGOvC0S/jZbNU2aQ3FFyYhqgJYTr6
	F0PkcfEPW6/y8j/dkyeRB73gre7kh3WO4tyCCbGm+BAsYQzY/bUT9vGTENhpvvsqzjdOxZ+Pnph
	x+Aj3fGc649AwfgKqYpOLq60vMGCJjCmhXvWjfoLJPlD+M2FD102bg++g7L8Gf7WIYG/0pdAtwF
	NnslbO3kaQZjmB9OFgMF2BtrS3jRY6CWqs5Or0yzfBdmFuhPUD2NaqkGrBbgQUG5J+iJ9KkEZhC
	vqrU/4Y9puxHA4cOkpG3Feio25E1yXkyG//4+gWu+vdLcokrLq0JT+HgcCI2
X-Received: by 2002:a05:600c:3556:b0:4a7:6bc7:f778 with SMTP id 5b1f17b1804b1-4ac1932a355mr282976405e9.30.1793713822058;
        Tue, 03 Nov 2026 05:50:22 -0800 (PST)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abeb77af8csm457146785e9.1.2026.11.03.05.50.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:50:21 -0800 (PST)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	jack@suse.cz,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH v14 02/12] ext4: use the e2fsck limit for htree index nodes
Date: Tue,  3 Nov 2026 13:49:09 +0000
Message-ID: <20261103134921.610047-3-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261103134921.610047-1-ablagodarenko@thelustrecollective.com>
References: <20261103134921.610047-1-ablagodarenko@thelustrecollective.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Artem Blagodarenko <artem.blagodarenko@gmail.com>

Since commit 471fbbea7ff7 ("ext4: handle casefolding with encryption"),
dx_node_limit() passes the directory to ext4_dir_rec_len(), which for a
casefolded+encrypted directory reserves 8 bytes for a hash in the fake
dirent at the start of an index node.  That dirent never holds a name or
a hash, and e2fsck computes the limit without it.  e2fsck also only
treats a block as an index node when its limit has that value.

As a result, on a casefolded+encrypted directory deep enough to have
index nodes, e2fsck reports the index nodes the kernel wrote as corrupt
leaf blocks ("directory corrupted"), and the kernel refuses the index
nodes that e2fsck -D wrote ("dx entry: limit 510 != node limit 509",
4k blocks with metadata_csum).

Compute the limit without the hash, as e2fsck does, and keep accepting
the old value so that directories written by older kernels can still be
read.  Older kernels already reject index nodes written by e2fsck -D;
they will reject those written by this kernel in the same way.

Fixes: 471fbbea7ff7 ("ext4: handle casefolding with encryption")
Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Assisted-by: Claude:claude-opus-5-5
---
 fs/ext4/namei.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 76b9aa3fb03c..3d69b6739cfe 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -593,16 +593,37 @@ static inline unsigned dx_root_limit(struct inode *dir, unsigned infosize)
 	return entry_space / sizeof(struct dx_entry);
 }
 
-static inline unsigned dx_node_limit(struct inode *dir)
+static inline unsigned int __dx_node_limit(struct inode *dir,
+					   const struct inode *hash_dir)
 {
 	unsigned int entry_space = dir->i_sb->s_blocksize -
-			ext4_dir_rec_len(0, dir);
+			ext4_dir_rec_len(0, hash_dir);
 
 	if (ext4_has_feature_metadata_csum(dir->i_sb))
 		entry_space -= sizeof(struct dx_tail);
 	return entry_space / sizeof(struct dx_entry);
 }
 
+/*
+ * The fake dirent at the start of an index node never holds a name, so no
+ * room is reserved for a casefold+fscrypt hash in it.  This is the limit
+ * e2fsck computes and expects.
+ */
+static inline unsigned dx_node_limit(struct inode *dir)
+{
+	return __dx_node_limit(dir, NULL);
+}
+
+/*
+ * Older kernels did reserve the hash in casefolded+encrypted directories,
+ * so their index nodes have a limit one smaller.  Accept those too.
+ */
+static inline bool dx_node_limit_ok(struct inode *dir, unsigned int limit)
+{
+	return limit == dx_node_limit(dir) ||
+	       limit == __dx_node_limit(dir, dir);
+}
+
 /*
  * Debug
  */
@@ -924,7 +945,7 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 
 		entries = ((struct dx_node *) frame->bh->b_data)->entries;
 
-		if (dx_get_limit(entries) != dx_node_limit(dir)) {
+		if (!dx_node_limit_ok(dir, dx_get_limit(entries))) {
 			ext4_warning_inode(dir,
 				"dx entry: limit %u != node limit %u",
 				dx_get_limit(entries), dx_node_limit(dir));
-- 
2.52.0

