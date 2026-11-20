Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795186775;
	b=GkZlrTA86UJhTWp0rTHMT624Mq8UjYJnSfxkWqQ3xdJWyktDsXGCRYIX2bx19PYYfVLK
	 m/AKVX/cgRAcsCGDAocbntNDkHNgEyzEdO0xXUN/3X+CSEzUIrEkNZfQYkXElnyCn1lT1
	 FzDE+CNg1egJiiiYf6pkYF/RalcfzsvNKQy9JEP64wzCgrKs38tSz1E33sJgoxAOfbrOl
	 Ir44x/VExA/7rK4d06DxIoXRvhmwTW0RYVKXD8yF8DNitDoKjl6vj7IPgNR0j/mXQxIYk
	 orPZ80bFeYDympaDn95SM9+HKezofsytRvHOzv6tnOFCXmAL87B8phm6R+FkWsP2hYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795186775;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=/2B3N92JeCLp37cUkot9r5Ww3+X+aqaiHxpJjgbEt8g=;
	b=v3KcLw7uRHNU/ALSKP8CGgaWqOVaPNuJ5xgzhOOV/2C6A8wdlMNBIAARESrjAUobVo06
	 LRaTNtZ0mP5hp8QF5FcRc0KxuzLOiFfLQD0q9gC7d1zX/1fz8eQepwwttZO/y6HEkykxF
	 RtTj89DZL9AgQObPQAPMkn1QiHYllY1x23+UyIO3UFYQvd3JhTigENjbU8yaG5wVPFS6j
	 q2v7Qel+FAQodv1IlKZv2snQSBBs7BtzsMmZ+wyS9Gcj8cIz1GH6BMSa1i05smUWPK7Mo
	 ExWREVi17fNosINS//jHxhGe+Oxtk5Q2bJHfUJ5a7db8fVrU1G2dAoEIusowPeQHBZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VnHzZ7ZI;
	arc=none smtp.remote-ip=209.85.214.173
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB01F60A2606
	for <linux-ext4@vger.kernel.org>; Fri, 20 Nov 2026 14:59:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CB01F60A2606
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VnHzZ7ZI
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2f03f3631b2so5720065ad.2
        for <linux-ext4@vger.kernel.org>; Fri, 20 Nov 2026 06:59:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795186774; x=1795791574; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/2B3N92JeCLp37cUkot9r5Ww3+X+aqaiHxpJjgbEt8g=;
        b=VnHzZ7ZI36s1+djRXZvfUxzoDn/zbni1raIRXZL3Iea3xR3PFKmoSxDj/poAr2SnTX
         puxyyZWwl+1jYdFlin+O0YbOlVPdQd2mdtym8hpQJhj+Nck/q0gKDt6jpLfKaYPtqKx9
         vGC0YU8ENnX95i7CjSL8r0ev7OtBSpQV8mdt2cjrBm3BrmJqRZLICajoY9yzqgg8t/T6
         bTAlTQi/dS1HRGi0yoooBrbn43gSn6u5y021WA5H2baq6WcQF5Izfi4/domb7BTjnQmP
         ZOeG66OlL7pIbSg1v4oEdEqh+BbGMm9cN4WFnCXCt1D+WvvTOkmPjBq5PJyhc6j29w+S
         VlYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795186774; x=1795791574;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/2B3N92JeCLp37cUkot9r5Ww3+X+aqaiHxpJjgbEt8g=;
        b=F8byWkP1M/xRSHYVx9FqoU4/CDBpQ+D6SxnMIihOJEAVMNcjA1CC0nRWmILV/EdoG2
         4LsGCCpwaOrinm0E34xswn0mcuMdC3hAhtCyBy2ANHeuGKzYkWI3cBn3XfPTRY0SrBPA
         pllf8WdgZjEdV815ssUlzNizGaO5VEZ2SsFseadO6qLdr9gP2BLDNsiieJauwM4X7Drh
         7k5GCRmnipwVlBpPY4b0p8KA4Qtz4DN1zXXh41+nQDqjzsZ8IU7FJbcA0MhI4O87Xk64
         bdgtWGaA4iaD6N39yQf8ABNHS8gJKP9FqPjVT7e7tiHEoiaIS7L7ItwpqFSDI3y3+841
         Ry1w==
X-Forwarded-Encrypted: i=1; AL+hErG/m9yblRb5St4syUrP9pUThyPCKmhVqX914LzG66q84LpgjaeUFYg6QOR2EtPioKaIxHOD6dbHHri9@vger.kernel.org
X-Gm-Message-State: APuU4Z8+clWPj2NqeQitLVb6lyCdOnX+At+YP+NMRdHzpZUe9T4oPSwY
	XXO6XoD9XAkpwehG8sReDtuRLokleo6UVMw7VFOEzexEhsNXhvonGsrp
X-Gm-Gg: AZFdTZeBz15Dyt53UvPWqZlqkEmhhDTsZ38zJlSA0g8OdmcxipEm1QwXhovL+Y4QIB+
	TmAz+VVR646m8GdoUEc6hgCERj2ABuRvRtNDbsRaNjmUPzYy6CwhIsvBu/c34eF/tGQokHUf4J4
	RtuFL/b36qw495kc4GW1Du+gXFSOP+ygsg0EkDQlR8C9HVVYNu/FheJX4Z/LdM4hoQk88H0LNKa
	oHCkHwNZI+1ZPqo8SDScCPtCQgo1+OiCXOP/qdxYCxI/07F5BbqnemUigRXZTK0DQ4SieeUEXae
	LETSHstrEHkZCSPvVD3EYf50C7LRTXOyWDlsgGuaM7jqgQDdtBSIOsaZf+kOHTek4fTZoq2oRyP
	VJu+gy84dA6lp/ujiFUN1k0bH6D+c3nG2X+bzmbg7XB0gv2hyWFCbGpEvAgfphCnFXg45R9AJUl
	+jdbJw68rBbntQvdrQQWw90xoIbHhVIRlcNZxRd6K+2V9lU1J0mdm7FwTFAtZx9MFQY7o6sFO21
	TIhTcEdac3TWMnc4m56L/fgSvCKZv/gXOajLg8sS0cCpX510bR2KnJelPk2mS2PIlD7s9LAdYTE
	sgJl5nIfw6nGaJ5EQYErYfgzDigNwS8WA2J+0CDGAc8CXq0NpiDaBBmroWwB3LVhPxAq0Ut3bQ=
	=
X-Received: by 2002:a17:903:2f90:b0:2df:ad58:cf54 with SMTP id d9443c01a7336-2f03f2158a7mr33050395ad.34.1795186773939;
        Fri, 20 Nov 2026 06:59:33 -0800 (PST)
Received: from ubuntu ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f0ddf40sm15264265ad.37.2026.11.20.06.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 06:59:33 -0800 (PST)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>
Subject: [PATCH v2] ext4: fix wrong unit of ratelimit_interval_ms sysfs attributes
Date: Fri, 20 Nov 2026 23:59:22 +0900
Message-ID: <20261120145923.1143594-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.53.0
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

The interval of ratelimit_state is in jiffies. But the
ratelimit_interval_ms sysfs attributes are read and written without
converting the interval, so the values are in milliseconds only if HZ
is 1000.

If HZ is 250, the default interval of 5 seconds is read as 1250, and
writing 5000 sets the interval to 20 seconds.

So use jiffies_to_msecs() and msecs_to_jiffies() when reading and
writing. Also reject values which are too large for the interval.

Fixes: efbed4dc5857 ("ext4: add ratelimiting to ext4 messages")
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
Changes from v1 [1]
- Add comment to EXT4_RATELIMIT_INTERVAL_MAX_MS suggested by Jan
- Add reviewed-by tag by Jan

[1] https://lore.kernel.org/all/20261116161701.3664310-1-ekffu200098@gmail.com/

---
 fs/ext4/sysfs.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
index 923b375e017f..a005c6fea48c 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -33,6 +33,7 @@ typedef enum {
 	attr_mb_order,
 	attr_feature,
 	attr_pointer_pi,
+	attr_pointer_pi_msecs,
 	attr_pointer_ui,
 	attr_pointer_ul,
 	attr_pointer_u64,
@@ -215,6 +216,12 @@ static struct ext4_attr ext4_attr_##_name = {			\
 #define EXT4_RW_ATTR_SBI_PI(_name,_elname)      \
 	EXT4_ATTR_OFFSET(_name, 0644, pointer_pi, ext4_sb_info, _elname)
 
+/* Limit value so that we fit into int after a conversion to jiffies */
+#define EXT4_RATELIMIT_INTERVAL_MAX_MS	(INT_MAX / DIV_ROUND_UP(HZ, MSEC_PER_SEC))
+
+#define EXT4_RW_ATTR_SBI_PI_MSECS(_name, _elname)	\
+	EXT4_ATTR_OFFSET(_name, 0644, pointer_pi_msecs, ext4_sb_info, _elname)
+
 #define EXT4_RW_ATTR_SBI_UI(_name,_elname)	\
 	EXT4_ATTR_OFFSET(_name, 0644, pointer_ui, ext4_sb_info, _elname)
 
@@ -258,11 +265,11 @@ EXT4_RW_ATTR_SBI_UI(mb_stream_req, s_mb_stream_request);
 EXT4_RW_ATTR_SBI_UI(mb_max_linear_groups, s_mb_max_linear_groups);
 EXT4_RW_ATTR_SBI_UI(extent_max_zeroout_kb, s_extent_max_zeroout_kb);
 EXT4_ATTR(trigger_fs_error, 0200, trigger_test_error);
-EXT4_RW_ATTR_SBI_PI(err_ratelimit_interval_ms, s_err_ratelimit_state.interval);
+EXT4_RW_ATTR_SBI_PI_MSECS(err_ratelimit_interval_ms, s_err_ratelimit_state.interval);
 EXT4_RW_ATTR_SBI_PI(err_ratelimit_burst, s_err_ratelimit_state.burst);
-EXT4_RW_ATTR_SBI_PI(warning_ratelimit_interval_ms, s_warning_ratelimit_state.interval);
+EXT4_RW_ATTR_SBI_PI_MSECS(warning_ratelimit_interval_ms, s_warning_ratelimit_state.interval);
 EXT4_RW_ATTR_SBI_PI(warning_ratelimit_burst, s_warning_ratelimit_state.burst);
-EXT4_RW_ATTR_SBI_PI(msg_ratelimit_interval_ms, s_msg_ratelimit_state.interval);
+EXT4_RW_ATTR_SBI_PI_MSECS(msg_ratelimit_interval_ms, s_msg_ratelimit_state.interval);
 EXT4_RW_ATTR_SBI_PI(msg_ratelimit_burst, s_msg_ratelimit_state.burst);
 #ifdef CONFIG_EXT4_DEBUG
 EXT4_RW_ATTR_SBI_UL(simulate_fail, s_simulate_fail);
@@ -434,6 +441,9 @@ static ssize_t ext4_generic_attr_show(struct ext4_attr *a,
 		if (a->attr_ptr == ptr_ext4_super_block_offset)
 			return sysfs_emit(buf, "%u\n", le32_to_cpup(ptr));
 		return sysfs_emit(buf, "%u\n", *((unsigned int *) ptr));
+	case attr_pointer_pi_msecs:
+		return sysfs_emit(buf, "%u\n",
+				  jiffies_to_msecs(*((unsigned int *) ptr)));
 	case attr_pointer_ul:
 	case attr_err_report_sec:
 		return sysfs_emit(buf, "%lu\n", *((unsigned long *) ptr));
@@ -509,6 +519,14 @@ static ssize_t ext4_generic_attr_store(struct ext4_attr *a,
 			return -EINVAL;
 		*((unsigned int *) ptr) = t;
 		return len;
+	case attr_pointer_pi_msecs:
+		ret = kstrtouint(skip_spaces(buf), 0, &t);
+		if (ret)
+			return ret;
+		if (t > EXT4_RATELIMIT_INTERVAL_MAX_MS)
+			return -EINVAL;
+		*((unsigned int *) ptr) = msecs_to_jiffies(t);
+		return len;
 	case attr_pointer_ui:
 		ret = kstrtouint(skip_spaces(buf), 0, &t);
 		if (ret)

base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
-- 
2.53.0

