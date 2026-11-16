Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794845835;
	b=sv+mJmOawNnxKspuRKoCL1ee4kIWYiJiOqC9wT4uOirdha7OoyXMLLljUGuua014eepp
	 qE6Jtsjd5cy7aECYtdY5IfF4kwHTER4rjEOAwB6sP2q6qbaCoE5gz7UBXVVolZLuD/6j+
	 CZaCedjyXIWtBAI1g68U/poKgv9A4ddJW8qDjTVQcm6GgUpNdvMQrfw3xCuNMM5cC/Q7Y
	 ETixY1R4fojBwFzPVtVBvjD66kRbc078e28egaWq8mnUqFqWRDzzwRNAF1hnRoEA/sAJx
	 R92RiBPkE2qoAdqIOBjiQLyRQvFuQlsnHMcmXSZBJVK0i9/mr8oho+GWl8zDqbU+UgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794845835;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=LXLsnCGLn99Rii/zo7DVAR+4dbpEIfGn2iUPp4MhUNw=;
	b=gE+RKaWl9dZYzTv7A8IVzM2jW/dQnERdoA1WQoBm6d5rWufj9EdiiCRSrjAtDRwYvudY
	 s0yxW1gVksFiCvnzKxamgaiRjt79atZaAgYgx+3oUKbVehslpgDI/nJj6sT6CZaQIqsqG
	 JCY2F8x4Z9F1nV4kZslGhc0VZFmEce7L0O3PoQqyaoYpScWncyML/v64X9vLUr02iYkKZ
	 lS+4PErSYgZ0BRiRPx7ZDp3++PnHqibqGON7OhZ/dZq8tVjEiD2kB716u8TeHzFugbfPm
	 7v6DY141YSA38iQ7HY1dafXtfwuGx1u1TWMnvg3YIxCDmZg0YBzLtJaUhnZ9k8kf/FA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=S6ozuTIB;
	arc=none smtp.remote-ip=74.125.82.179
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E48606A31C
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2026 16:17:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 72E48606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=S6ozuTIB
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-3791619605cso6922719eec.0
        for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2026 08:17:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794845834; x=1795450634; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LXLsnCGLn99Rii/zo7DVAR+4dbpEIfGn2iUPp4MhUNw=;
        b=S6ozuTIBc4jmKCgCpHjbegl56ihuUma84uTM6KLF7Q4bWuVvPXW4q1EIWZv7B/CesT
         hPF65gopp7Q7DJbay9/J55sKPs8To25z0yJOzJ0T1oUeATVw/6BesyzORu4a/KKZ+yn5
         jR1IY+EhtfPyPY6NwKcpT/wDMJuJgjx5shaMJCHRy4XGkk/8YjUVJNOFwqYqGiof7qTM
         Z2Ey+1t1AWiagPEyX4MwMRYcq1uWwcEERnucwp5PI4QosEPQw0gM9kwWU6r/IZ7/m6uS
         F1OJUCfhLsovD4hKFJlikaX8jqjsm8riQFGjtMJ5mvrjOFFTrLBUxMpQJhykp7le5Vrg
         f+hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794845834; x=1795450634;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LXLsnCGLn99Rii/zo7DVAR+4dbpEIfGn2iUPp4MhUNw=;
        b=jXer8hg3NfWckI0OiqyY5O4OnuCRNo0pe3tk23u4gsM7kviHIOcik0HCet4Mxturu4
         nem/nWxb4//2i/HChAH++ZTIT61Se7t3Y/lOAVAN0GWKEdr0630/M3MTG7MaBdcsNW7h
         R1+QaBX5yu0LW+V6dUvKTlhA/kF5D8iMzeIQCNan3kFfuCYCc3+L/QsW/3OMGJe4UIty
         3uGqVAccFHrXsNzswX6Y5KXcJYyd24e3sLkilOtf2Mw7lndcYvUEc7U04DONElLDlBcl
         V2Mif6HWyyLU46uHgfP0PZxS52dqGvB3pkr34v6HHeULmJRVbyxuIMSJsUEkJK6mYuyC
         Sleg==
X-Forwarded-Encrypted: i=1; AL+hErGxQdJYaeXSB8DKpds/p/iQMVFMpYmzhP2MbfTP6XiykHQxbvu0w2GXXpmcBGgzoXbY4MI8n24iS4Io@vger.kernel.org
X-Gm-Message-State: APuU4Z9d2058KpTU0C48TC2mSwB3qZBJMqK9B4MX0HrEKkpRpUWLzzur
	0Mgvu8v3Q7rmLMSKiGzhp/wvPkiquy3AGhT9i2etfRd8//giVp/OQwvouxyFpQ==
X-Gm-Gg: AZFdTZcQftqphIZnhONEDAl5u+WPW8stGaoFF3gDzJYZDTTEkyOyoipqpTUCaYAZMaM
	m66Xxk9IsafyIE2up4FY04/jNlzqRL4aHwLCzDFWbZ40/epSPWRL2Enj3ZgaSBLSICJ4LbvqRrd
	Bfw5vNC5tuTZMTUoqOx7V+OrDXp82WRAAKqdSJuJtHMiKKye+3/8LuUJ6aKUf4/kuIJYi7gg9Tc
	NuE1FMhfKe4A8c3Yk1iRLtjOFKjHji8+EId9m3HvssAqVQtIlYeeevFIYw1F/WOBjTPIicO5tOH
	0dVqL8HuzF2igN8BxvtnSC6ZbyJFTUO4Yj5DYxRYpUHKMhuMMg0X5tG/dJRGSEMRmLe13pHQAGc
	ozG4aWA4bXKIwpJHE4X4lGFqHiMZOpTizvE9Y1JG9FUBOGh5jggCJ5h6bO7MITS4ULpDmuQHvHQ
	yUNildbzfa0ThQAXR373nlHxVb3J5UBb0pxkJP0DBhzIO1gYxwkRQgeB4NiZ5hwkRHPtoL5oT5T
	FBqZabbXpodXBc0N5WqRCB1GlIH9iicy09jjDMZ96UnF2szEUWfOF+W4cv5WW3bzIR6f8IHrs2/
	xvrIJ7Ribl7Suw3pESzNsEgyykxTL/iGfa2liXTlX0qMwH4i7pk8
X-Received: by 2002:a05:693c:829b:20b0:374:ba43:ae2e with SMTP id 5a478bee46e88-3796628d568mr12354359eec.14.1794845833484;
        Mon, 16 Nov 2026 08:17:13 -0800 (PST)
Received: from ubuntu ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37955332ae7sm53896543eec.8.2026.11.16.08.17.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 08:17:12 -0800 (PST)
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
Subject: [PATCH] ext4: fix wrong unit of ratelimit_interval_ms sysfs attributes
Date: Tue, 17 Nov 2026 01:17:00 +0900
Message-ID: <20261116161701.3664310-1-ekffu200098@gmail.com>
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
---
 fs/ext4/sysfs.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
index 923b375e017f..7cc3a2e663f0 100644
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
@@ -215,6 +216,11 @@ static struct ext4_attr ext4_attr_##_name = {			\
 #define EXT4_RW_ATTR_SBI_PI(_name,_elname)      \
 	EXT4_ATTR_OFFSET(_name, 0644, pointer_pi, ext4_sb_info, _elname)
 
+#define EXT4_RATELIMIT_INTERVAL_MAX_MS	(INT_MAX / DIV_ROUND_UP(HZ, MSEC_PER_SEC))
+
+#define EXT4_RW_ATTR_SBI_PI_MSECS(_name, _elname)	\
+	EXT4_ATTR_OFFSET(_name, 0644, pointer_pi_msecs, ext4_sb_info, _elname)
+
 #define EXT4_RW_ATTR_SBI_UI(_name,_elname)	\
 	EXT4_ATTR_OFFSET(_name, 0644, pointer_ui, ext4_sb_info, _elname)
 
@@ -258,11 +264,11 @@ EXT4_RW_ATTR_SBI_UI(mb_stream_req, s_mb_stream_request);
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
@@ -434,6 +440,9 @@ static ssize_t ext4_generic_attr_show(struct ext4_attr *a,
 		if (a->attr_ptr == ptr_ext4_super_block_offset)
 			return sysfs_emit(buf, "%u\n", le32_to_cpup(ptr));
 		return sysfs_emit(buf, "%u\n", *((unsigned int *) ptr));
+	case attr_pointer_pi_msecs:
+		return sysfs_emit(buf, "%u\n",
+				  jiffies_to_msecs(*((unsigned int *) ptr)));
 	case attr_pointer_ul:
 	case attr_err_report_sec:
 		return sysfs_emit(buf, "%lu\n", *((unsigned long *) ptr));
@@ -509,6 +518,14 @@ static ssize_t ext4_generic_attr_store(struct ext4_attr *a,
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

