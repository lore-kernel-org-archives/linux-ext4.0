Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30151407563
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2026 11:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789730338; cv=none; b=WJBCHvHkiPdNl0+owqHJEyxt9pWdptsgqW8v8TqLmm34W5w7YxGaoXM1xKI3aip2qJAzSrW3XYOtGxaGXMpFD3jXblkjegFaZxXe8AZOsdWbR/QmSyihHvsTm1cNKWc2OaNvtWQEXmnP3864Avx7TTnfWbWxvzyQ+GAcyAxHLvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789730338; c=relaxed/simple;
	bh=Z7v4qnq8aw0x5iEmhBG1pSTK1bzA6es6jG4hCbsdcO8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AbgeWUG2LV5aoz777s2sUthcQsj+GYoHCSU8SRk9WF+sFhgqvqyXFBzr4TD3cLMVOWXouqhtXQx9WL6Dh1QmZtMDFachPOrt87SzQQv7047GV5u8VfKOUwIuSZ1c+o8vvrEIBiki8eTaClggH1sXJihUhDqT3tEZ9z4o4G+BtaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jt4xRAbb; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jt4xRAbb"
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d747ee1f38so5503275ad.2
        for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2026 04:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789730336; x=1790335136; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YmpCaksYD9t+NIH9u4y2WiH2f+2khrN9+kqRKuQHjsw=;
        b=Jt4xRAbbctTppsAM2zeCCehJYAGtEYYThv5H2h+0003MoCcIt4p1RinisTH1oyBMR4
         /0wtjqVra+G830fZOCHXG0X2cQvWWjZGHlv6BvqNJlS5t0IIDtjGePnmagMRqWQUEoKV
         8uXtqZnYbaKTTHAKwJoeswjtiKocqnE6NuOLo+9b93+Zw0EsE8pxM6m7j72zom27cqyP
         CVLGteegCGn7B9Y6BbRvkrTnon6+t4jmZDaifLL5gh1WU3w/GBwFg3GOh9R453uuNw1m
         UnoS/j93wYC+PP09AdayzVrcA6H0O8u2W2g5t79xWAMuFxRcc90FKp4xwXZnglVSdOLS
         KCHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789730336; x=1790335136;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YmpCaksYD9t+NIH9u4y2WiH2f+2khrN9+kqRKuQHjsw=;
        b=cz44Psd39FWi4nMemYFo7mvzZnH+tnzHK/x7lrHoIA9GuR5HVp1UD1ZM71Ee4F9Wor
         sDtm/2ijTUhVRjp5U9fV3st2P/K8GMqKjxqg+U4nEdt+pv7/Pr8Si2s/FPsbLSyeGXKp
         0zcvkky/pJfguVHEsx5xraOF3gS6vXB7bb1s3qJjULgSIndmsB0oMX2bMVMuDKhm3ib6
         x0Id89nYzrO9FL65zWinalgfx6jvFIqQOD7mPSGajyQzm+6v7VKNc+DUxZSujjbdy7oh
         Jc/6U44CXa9FatremxNfyd/EqIUA2rNR9WrP5TAPTrJr3ULiLtB/iftd/RCuZLg0wUaq
         8hXw==
X-Gm-Message-State: AFuF++lh2XEmh75k2GcCFVfCuDyLLu3FV6k+eS37MtNf9b7WRLLJm3yg
	warQwit7LueJFlYX5+Z6VFU1BoMCl2Cux4N1yhYB/ZYKSb4Dhlb8gDyP0+H6zRGr
X-Gm-Gg: AYBFou08mW80JpzP/DTX5rZ0OPVVFi7DeyIiVwYOe01/Q9d5xFOSlDNMTRiBJV1yeAQ
	nbcEiA7HrS6ZBFmEMIkmc1+6aI3aBnTg//OPfPQgFoakNRHJ2VRlbPzFecxFbuXBpEs2ZWpBLkK
	s2E4UJk49mQVCx/Jl1eQY1qPrT5VzRLZXFMPo9CWioCrSPgwZnfA3N5t75r590Nd8p1UfcBmiu+
	o+5b4b5aL6csCYfg5rpO3nFG+k90WJEYhWW8LfMJwmAhcd4RYY0e5pUkAFXMnrYSstA5zMLmmXE
	nhozgZxTH167SCrQkLey1amlcpswuWXdri4wIhbTdfRo62oj2tJ+N2j2kSabUFNv8hKNZVge6y9
	3lI2g5R6ASRTySKOr6HfJB+BXl3O9WnjQ/IRbBIOMsVTNNkmqs+o0o+1asY1qd8nvGKAtpyuXSr
	8phxppywcycu1JsqD0CJ3q0GepyPa6c5LXHTDatIjQ6mCBHD3oO8fyUPd62gAfmv/jf6KJjHY1k
	Zd/980Vh2458UZW+yhd6tE=
X-Received: by 2002:a17:902:e803:b0:2d6:fd55:3a9d with SMTP id d9443c01a7336-2ddb1b7a160mr42116225ad.3.1789730336227;
        Fri, 18 Sep 2026 04:18:56 -0700 (PDT)
Received: from csl-conti-dell7859.ntu.edu.sg ([155.69.199.57])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ddb75c1f25sm5984955ad.68.2026.09.18.04.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 04:18:55 -0700 (PDT)
From: MarkLee131 <kaixuanli0131@gmail.com>
X-Google-Original-From: MarkLee131 <kaixuan.li@ntu.edu.sg>
To: linux-ext4@vger.kernel.org
Cc: Kaixuan Li <kaixuanli0131@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] ext4: don't read past the UAPI struct in GROUP_ADD
Date: Fri, 18 Sep 2026 19:17:42 +0800
Message-Id: <20260918111742.827428-1-kaixuan.li@ntu.edu.sg>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260917151441.413135-1-kaixuan.li@ntu.edu.sg>
References: <20260917151441.413135-1-kaixuan.li@ntu.edu.sg>
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
ioctl returns EFAULT when those bytes are unmapped.  The two structs have
differed in size for as long as I can see back -- v6.12.9, v7.2.4 and
current master all have 40 against 48 -- so the copy has been over-reading
the UAPI object throughout.

The first 40 bytes of the two structs have identical layout, so copying
that much fills every field the UAPI defines.  Zero the rest:
free_clusters_count is overwritten by verify_group_input() anyway, and
mdata_blocks is read only by ext4_resize_fs(), which builds its own
group_data array.

Reproducible on v6.12.9 and v7.2.4 by placing a 40-byte struct at the end
of a mapped page whose successor is unmapped: the ioctl returns EFAULT.

Signed-off-by: Kaixuan Li <kaixuanli0131@gmail.com>
---
v2: done the way you suggested -- one struct on the stack, one copy, and a
memset of the tail, rather than v1's second struct and six field
assignments.  The only change from your sketch is the cast in the memset
address: &input is a struct ext4_new_group_data *, so &input +
sizeof(*uinput) would advance by 40 * 48 bytes.

Built fs/ext4/ioctl.o warning-free with W=1 on x86_64 (clang 21), and
checkpatch-clean.  The EFAULT reproducer behaves as before on v6.12.9 and
v7.2.4; the fix itself was not runtime-tested.

 fs/ext4/ioctl.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1674,12 +1674,15 @@
 	}
 
 	case EXT4_IOC_GROUP_ADD: {
+		struct ext4_new_group_input __user *uinput = (void __user *)arg;
 		struct ext4_new_group_data input;
 
-		if (copy_from_user(&input, (struct ext4_new_group_input __user *)arg,
-				sizeof(input)))
+		if (copy_from_user(&input, uinput, sizeof(*uinput)))
 			return -EFAULT;
 
+		memset((char *)&input + sizeof(*uinput), 0,
+		       sizeof(input) - sizeof(*uinput));
+
 		return ext4_ioctl_group_add(filp, &input);
 	}
 
