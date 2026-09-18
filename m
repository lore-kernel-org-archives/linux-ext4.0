Received: from mail-pj2-f31.google.com (mail-pj2-f31.google.com [74.125.227.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A0937BE64
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2026 01:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789693577; cv=none; b=SwyCfS+cbWmdO+oleKxYl0hZfIf6VIx/+dZ71botkU6jH+6citCumU4r9RJFIOv28dFbwRLBVTyQinqTSaeg6PlZkuuQ7vz71SBXkrXfrXL88G06L7WdvBLVQwF5eHqbMVl6o/fCSfkou7OdvOdmhPkJ7ssFRSSuW+zTI6eu4lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789693577; c=relaxed/simple;
	bh=yBIGT8BXOLPPjlnisUuvjv8aqjnLGGAervT2GKtRzBY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u5Ryly3Ohpb9wea0RMlOwiHdKeISE0Y3iltMcySUOirc/ht9NBihqs0hoIIvnTQ6DOvGrbfpOjng2FcGESH8yoFmNGsIdJfVb+ZyQ9AgWIrfYf8fnS7pcDYtfXmQdtRzhp92/982deevRVW+dozrakWA0mF2ElnQdFubhj+Hegg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c5zgM1uQ; arc=none smtp.client-ip=74.125.227.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c5zgM1uQ"
Received: by mail-pj2-f31.google.com with SMTP id d9443c01a7336-2dd53691be5so1659385ad.1
        for <linux-ext4@vger.kernel.org>; Thu, 17 Sep 2026 18:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789693570; x=1790298370; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=iFcT2DOyxQDtRKBeD9Hf0Svlfti42z1k3EuEK/szEUM=;
        b=c5zgM1uQko+aMmYYWP6nQJUg8b/MUMPqc2xOpbsnCgyP9hKVgPdTpB4qg6IknQrAjg
         gdu+eiGS5CFGNaRaMC8xvX2YYRv5Gr1WY4pWxRtu7/bRTIOcFcc7Qwg6TZbaVzSMuyaV
         js8h+r8f8wzp/qZKzmjeC86hDrbywkBjSXf9RIJScGn9KUz1Z09DslR/AaVKAqGMYyhI
         56fREe+4Ga8lKD20G4Te38V2Ak3MUVQ1hUtzrmII/M++ydxXVm3kb7UgRD2o0054Bepn
         v4eI2kA98zk4G8CHGmPLFWfJh/Z3/OEplw8Sfuozoj/l3YO0tsNTOA33XlDLjYk68bX4
         FSHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789693570; x=1790298370;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iFcT2DOyxQDtRKBeD9Hf0Svlfti42z1k3EuEK/szEUM=;
        b=mxWHV+Sv/+FWmpgRbyJI0E0NsQ7TmaKgHk9KeMzJhQqapgfUqS39hnyciB7l1+e8b0
         /MYdkGMLwDYlAP3esUca6Rn2VXN5lNrVhzmrXowZuuUKUbVxd0P19PYvV2PxApQZBNyC
         zTVC4EYC0AvSW80l7Kr/t/cJ5JRLmCjbQ1DagLCyg6Q654ULkFCaE5+zf37h5vwDIYtn
         tNhTcm1yj9AiJqWOJXTLEJL82RWoJ567ayebvMIONlgvYXyRKUMRSao5fZz5sZG4fYiu
         35r5NGIZQv0vVa7WHX6TcOYz+R2KDxBDB5vgRJ5r0mNSKJtha4k9fmS6qOOL+Iutkl7c
         0hLA==
X-Forwarded-Encrypted: i=1; AKwUvBzbx+Sj/aAtURk0M+Ac/kk7zuo7PWcBLynsQsql3D+b8kVIKE+rvfJn7uRo0XKzQvL3ooZ+XKvoMb4I@vger.kernel.org
X-Gm-Message-State: AFuF++l5uNH7bfvHLAT80wsnH0L27jRK+EU0kBslqSvLKxWFbB2xRJwo
	I8ngVGzXLlRLwAyTg5S0f4/0cg0s/wO0vV0tkmcm+9wx59j/QDU5/ZXS
X-Gm-Gg: AYBFou3bKjuyhuBXr0KPuc/DKGsResj9gzx3HVBXB+a+kAQ+2uweYz5r2hLcPNaNy75
	V6rQWc3sIG2T/Z7fiSLvSFXcLHLH08reaJZBsSjGxHalEnlODqjk4/odhT4PGs43RkQ23Dw6dM7
	aMHQYsKDhYUWWBYZJNplXS4FLF/QpU8SGD43YEO8Ct5czFB7HsNwMMANsAWNbZXrydhjHVIqTew
	Eo6dhq5yphsAtccmOo+MeFh/PN2nzOTSPzmLK240uH7pFM828s6UA7qKjXMTqa4PfwgFPHNoXeJ
	4EJwx1cG2s/nILLPw5KKhgwc5/OZcGbnUmbHNlhOOuCwAGuyRVcCMb5U8sDMMZDKh2OoaUMGmEE
	kCwn/ByJbm2NlPDYlPLQ0D90Z8upe/FqhiGN20FTBKEbT+rtiRDF7LMsqb5jLYeRsR4hN/7Rjjw
	jqRKX1nL0KqKC82/TVDrv8RtbjR6f8kuZusqSv8lAJc/2ENYbuX+OtsN4A7vtu1bRyHGE4KOZ2t
	sLVEUKjZdkjebmzYY7W4w1RWcSgEL/eGfh3y6X72A8vmd+nz5d2TeiJkAxpUZOy
X-Received: by 2002:a17:902:f687:b0:2db:2413:87d2 with SMTP id d9443c01a7336-2ddb1ac954dmr19438205ad.4.1789693569827;
        Thu, 17 Sep 2026 18:06:09 -0700 (PDT)
Received: from deepanshu-Legion-Pro-5-16AFR10.. ([2405:201:682f:383f:5d30:2332:ca7b:eac1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd89f338a9sm33460655ad.83.2026.09.17.18.06.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 18:06:08 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com
Cc: boyu.mt@taobao.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+085a394c92518a04fd09@syzkaller.appspotmail.com
Subject: [PATCH] ext4: add bounds check for e_value_offs in ext4_read_inline_data
Date: Fri, 18 Sep 2026 06:35:58 +0530
Message-ID: <20260918010558.8210-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ext4_read_inline_data() reads the location of an inline data xattr
value directly from entry->e_value_offs without validating it against
the actual bounds of the inode's xattr area. A corrupted filesystem
image can set e_value_offs to an out-of-range value, causing the
subsequent memcpy() to read from an address far outside the inode
buffer, including memory that has already been freed and reused for
something else. This mirrors the check already performed in
ext4_xattr_ibody_get(), which is missing here.

Add a bounds check on the computed source pointer against the end of
the inode's xattr area before the memcpy, and reject the read with
-EFSCORRUPTED if it would go out of bounds.

Fixes: 67cf5b09a46f ("ext4: add the basic function for inline data support")
Reported-by: syzbot+085a394c92518a04fd09@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=085a394c92518a04fd09
Tested-by: syzbot+085a394c92518a04fd09@syzkaller.appspotmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
 fs/ext4/inline.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index ceee69a66482..2e60ab3e0db5 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -187,6 +187,8 @@ static int ext4_read_inline_data(struct inode *inode, void *buffer,
 	struct ext4_xattr_ibody_header *header;
 	int cp_len = 0;
 	struct ext4_inode *raw_inode;
+	void *end, *p;
+	u16 offset;
 
 	if (!len)
 		return 0;
@@ -205,13 +207,21 @@ static int ext4_read_inline_data(struct inode *inode, void *buffer,
 		goto out;
 
 	header = IHDR(inode, raw_inode);
+	end = ITAIL(inode, raw_inode);
 	entry = (struct ext4_xattr_entry *)((void *)raw_inode +
 					    EXT4_I(inode)->i_inline_off);
 	len = min_t(unsigned int, len,
 		    (unsigned int)le32_to_cpu(entry->e_value_size));
 
-	memcpy(buffer,
-	       (void *)IFIRST(header) + le16_to_cpu(entry->e_value_offs), len);
+	offset = le16_to_cpu(entry->e_value_offs);
+	p = (void *)IFIRST(header) + offset;
+
+	if (unlikely(p + len > end)) {
+		EXT4_ERROR_INODE(inode, "corrupt inline xattr entry");
+		return -EFSCORRUPTED;
+	}
+
+	memcpy(buffer, p, len);
 	cp_len += len;
 
 out:
-- 
2.43.0

