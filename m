Received: from mail-pz2-f16.google.com (mail-pz2-f16.google.com [74.125.228.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E1F599A22
	for <linux-ext4@vger.kernel.org>; Thu, 17 Sep 2026 15:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658106; cv=none; b=sWkVSdJgU9YVy57cU0+PezqWfCwF/asfCQ4Hiygsstp6AULaghGFg75ufaJiZafZJ/hrTl9Le7KXeRE7csvriF0Uk9zxB2/CFTmT0n1EpLwPfUWv4UvYuQkg04OXwlHFzUxn8McrrB05W9nbC4+3DWbg+fDyNP1l7RGyp/e4YuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658106; c=relaxed/simple;
	bh=d6UKzQKyPiGJsGM+Qu7tJG56YQxLOxqIMP9yGCsnkHs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lzxrdIi/VbvuPulUT5q8y1z9Q7ryOVrlyHD1z1pdSrzcCO6Sv20HtqukXpjrfQPzSGOE2BE/ae1kLsJOyrnBCqa2M+MTkSgnd0rNtmpcQ1z71wztc+4MyXIWaPLPTQ78DDBF2qXNA1lPccQw+SEy8xGqxnnpGZjDBnw/CqhpJF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gSOdclJR; arc=none smtp.client-ip=74.125.228.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gSOdclJR"
Received: by mail-pz2-f16.google.com with SMTP id 41be03b00d2f7-cc4d2fe2056so626837a12.2
        for <linux-ext4@vger.kernel.org>; Thu, 17 Sep 2026 08:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789658095; x=1790262895; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rh2mXdJ4Gx0vDgozfrCs3n1I8ixRE20WMk7/6kOasWU=;
        b=gSOdclJR0V/29vw/cXtzcSqZ7ML754aPOdcdxqZ3SUsmMrc7RZLXUOdgvdAypqoMdR
         vqBvDYhnHtaUsIbla/38YGegMKDn51ycdplqKY5Bj1GCat9SwqT/75WBEigKSsoYD+hi
         rdbKOhdWkDodYUEaYJZZJZzxh3nd+LeMYp/ddXvHgF5bgGYeSF5OTFFJcDFg213HH/ra
         SPn+GQo2JX0ASebRqyw8wZl1TovpfiD/8CtuF2rWiMBhc7pwz/3KWjc61YZsfpOgFNxG
         d+D4S0UG7UMYXtiBGDhygMQe3UGTLA5Ax0HtEvplebXT8Bgkb+ny5OhyLc0i5TLcVO0m
         StWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789658095; x=1790262895;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rh2mXdJ4Gx0vDgozfrCs3n1I8ixRE20WMk7/6kOasWU=;
        b=m8i91zbwxsM8VqUVSBgyMqSM8CTCH0RNZnuKggSb+1ZoX41JMx3LF9RYFUxzRGq7ig
         0bhyXHi4IBpx9tfltWjP9AefTknva9vvtpC0iq+Y33zPy0Ubwu8JP5cR4D4dp1FBDE0j
         CICW/lj/julR1bySWTUE93LOaRLoNCeBy4eW96FmeNUKmQ8lcLgNEjAjl6Di53dbwjYa
         cgA6XS7+MfURbw4BW8mOWk7sUQHMqs0l4pm6acicKmzFIWgnh0UIu4V64VyWVJ/VlUqZ
         ezPDK9B0I7lbKx4HhHw+Xb2OPNycnLkVB/DWAaoAsry+omenLgsYxHrtndAGn9q75Lqh
         ueMg==
X-Forwarded-Encrypted: i=1; AKwUvBw3Wl+VctS/xaVaxvDf+Y8+XlhfnnqLYGxApn90ToqYInNFg+g/2Zy5CIbXryS84t7hGJPFfU12YPzF@vger.kernel.org
X-Gm-Message-State: AFuF++kGNOnKc9Kj8te3OuSGmlOWcLQoZ48sduuZez1dUd82iE+f3yAV
	bnHJu5TjxxIJ4CA2p3m6/mBwEU8z0gVybHNSQjAlC78bm/0tSNg3hem6
X-Gm-Gg: AYBFou0EQbzVMjo/Efn2OUmc48wquqTfhr0yoJqI6mu7NmZzHRn+yv6zjl48hMaGMcG
	DasC+AstdkB3vNUFCmzmQslZv/bvpUFystzhsl9OsDdpwy4kiGbz/0HUhpClL31oUXAy7ylp7PD
	+RIOMD6ZM9AOb3t+RN35Dq+lyKF3pNdIyg3FFFqlOmtABh/o3xPA1Jt6F9+8dlz3nXI+uU9KzAF
	L9wmbKIa6ROX/nvCWUSb+tgpUWiX2aq/4Bv6rPLvkR3fS31uO2RpBVB6MC+yXFy4RKverpfJP30
	TIh+iX6fJoJYCnFHXt7RAH5DK6z7ps7NY8NCflBq2rqJ/LUasX8LXnLphwwj5C5E5aMtQmBGsh6
	aFovrAW3ZiD10nYSHO1Rcj8Qnycih8F6RGDvi5cTYsrBWSbB/XT57XzKrsKCQcy8glsvqoCFwBo
	0TVVxk3HbP0O+7ot0vjbaXzhtg7qaw76J4YC3O52iLCX5ccnxwj2f3qaAWKf5RFLRTGiZE5t/Yy
	jv6lxm+d/3Vv3xxR4xr4vX9wJmuJ4gcx/c=
X-Received: by 2002:a05:6a20:6a0c:b0:3d3:adbf:777d with SMTP id adf61e73a8af0-3dd5f79059emr17452137637.25.1789658094318;
        Thu, 17 Sep 2026 08:14:54 -0700 (PDT)
Received: from csl-conti-dell7859.ntu.edu.sg ([155.69.199.57])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc50abc400bsm3523663a12.29.2026.09.17.08.14.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 08:14:53 -0700 (PDT)
From: MarkLee131 <kaixuanli0131@gmail.com>
X-Google-Original-From: MarkLee131 <kaixuan.li@ntu.edu.sg>
To: kaixuanli0131@gmail.com,
	linux-ext4@vger.kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ext4: don't read past the UAPI struct in EXT4_IOC_GROUP_ADD
Date: Thu, 17 Sep 2026 23:14:41 +0800
Message-Id: <20260917151441.413135-1-kaixuan.li@ntu.edu.sg>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kaixuan Li <kaixuanli0131@gmail.com>

EXT4_IOC_GROUP_ADD casts the user pointer to struct ext4_new_group_input,
its UAPI type, but sizes the copy by struct ext4_new_group_data, the
internal type:

	struct ext4_new_group_data input;

	if (copy_from_user(&input, (struct ext4_new_group_input __user *)arg,
			sizeof(input)))

The UAPI struct is 40 bytes, the internal one 48.  A caller that follows
the UAPI and allocates 40 bytes gets 8 bytes read past its object, and the
ioctl returns EFAULT when those bytes are unmapped.  The internal struct
has carried the extra fields since ext4 was split from ext3, so the copy
has always over-read the UAPI object.

The two extra fields are not used from this path: free_clusters_count is
overwritten by verify_group_input(), and mdata_blocks is used only by
ext4_resize_fs(), which builds its own group_data array.  The compat path
already copies the six UAPI fields individually; the native path does not.

Copy the UAPI struct, then set the internal fields from it.

Reproducible on v6.12.9 and v7.2.4 by placing a 40-byte struct at the end
of a mapped page whose successor is unmapped: the ioctl returns EFAULT.

Signed-off-by: Kaixuan Li <kaixuanli0131@gmail.com>
---
Built fs/ext4/ioctl.o warning-free (W=1, x86_64 defconfig) and checkpatch-clean.
The bug (EFAULT on a conforming 40-byte object) was reproduced under QEMU on
v6.12.9 and v7.2.4; the fix itself was not runtime-tested.
 fs/ext4/ioctl.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index c8387e6a2c6e..ea3cd8cdae25 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1674,12 +1674,22 @@ static long __ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	}
 
 	case EXT4_IOC_GROUP_ADD: {
+		struct ext4_new_group_input uinput;
 		struct ext4_new_group_data input;
 
-		if (copy_from_user(&input, (struct ext4_new_group_input __user *)arg,
-				sizeof(input)))
+		if (copy_from_user(&uinput,
+				   (struct ext4_new_group_input __user *)arg,
+				   sizeof(uinput)))
 			return -EFAULT;
 
+		memset(&input, 0, sizeof(input));
+		input.group		= uinput.group;
+		input.block_bitmap	= uinput.block_bitmap;
+		input.inode_bitmap	= uinput.inode_bitmap;
+		input.inode_table	= uinput.inode_table;
+		input.blocks_count	= uinput.blocks_count;
+		input.reserved_blocks	= uinput.reserved_blocks;
+
 		return ext4_ioctl_group_add(filp, &input);
 	}
 
-- 
2.34.1

