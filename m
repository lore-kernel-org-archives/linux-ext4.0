Received: from out203-205-221-235.mail.qq.com (out203-205-221-235.mail.qq.com [203.205.221.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BDCE2931C0
	for <linux-ext4@vger.kernel.org>; Wed,  9 Sep 2026 01:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788916393; cv=none; b=nG876fjF5dES4xKz8xi95TB84RqNzamQ2Ftq/UM6AC13AIlQ/cy/WWkpqHPv2ATa1sq0b24qfjkX2FaDOb4d4RQ+WoWBGzEJC6NyGnRYhs1Vn/h2dN5RovtHyoQWNDSbGiFkuIeK29m5LA9py03gbyjh4eSEFLEGhQuUDcaACro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788916393; c=relaxed/simple;
	bh=O1UXyOkDZpAj+uBP0pUkWNe6jM/Ex8dAmZJZZ+v1ZZE=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=tOQyEKpVjzv9LWSdM4dnFeNxHTipdFa7EeWXXSsSyY2sV1VMZdfTxwQZK7hOEE2juwFTLoJUreQlAAM38zuQe/zNMNH+UHafZ4WDkTCzuEJ/sH/dx2R/gUOYdZ0JL1tMhqJW/6lJ0dKz7736JLzMqHUAPbHLTK7HNNaPl2EsTNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=vlP8IeGN; arc=none smtp.client-ip=203.205.221.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="vlP8IeGN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1788916386; bh=7OdN3Y5+lolTtz8GmisWMH/KuSZVdJ3XdVKF+q1aKi0=;
	h=From:To:Cc:Subject:Date;
	b=vlP8IeGNmWeJI8cPSOpj4FUnOIdTCn0TwuB8j2UIbwwSFBZNefEbaLr8MjAgPy94C
	 ThMd4FpHyZMazJHcgHK42GvpggO3tRC3eu1kUik0rE3PMzx90AHScl2nyvsbRCr9l8
	 /1xykGby1OPoia0TFzrEpAjOXWZVy/SLkjGfdN7Y=
Received: from DESKTOP-AT5F202.lan ([183.242.244.64])
	by newxmesmtplogicsvrszc56-0.qq.com (NewEsmtp) with SMTP
	id 3430604D; Wed, 09 Sep 2026 09:13:03 +0800
X-QQ-mid: xmsmtpt1788916383tsjgccahb
Message-ID: <tencent_CD1AF9C3A7875C42F2187B57D74A1C5EE609@qq.com>
X-QQ-XMAILINFO: M1SmS9is3/+CbD2cBjN/AKP5rq+Ww07kN4S6oZf0HQCkSDk51S1MMlFJoptph3
	 0LIbMNdtkVfp7gZWYNcUDHghNG26T9tnEATgYBcTyqi8k/cKu5KqZsO4XXiDNG/tphph6xSXw8Hy
	 39Hk+gVI2aKpVcUuK+MVK4tOTJENTVJmrn1A+uP7o0L3XlFqnfK0+zt6L6AMih/ttV1CPACXlzhl
	 EKaKl1zCeNmtw+7p74pQ7epQLFfGhCaLq29QaPOl6apV2uoXKL/nTz8x8VseB45cmpkT4zvOm3XK
	 MHCXD8rLQUC1rySzXnA0DegwWGj6hJsJ0lWvJFNJDWqpV9hH7HndcABKhqCMC5I26SrlQbEpDKzS
	 y6hKev3QHTtEUMNYcaKTBsddAtcHIRXmyc+x+3Q8LppTqreNvbDs9J+bgfyV6BpDes/Jqsx+F6sI
	 aYAvFyh8d+bu1LTYKJXxszN4BZBaFCtsuhcYCWkOM83dPXWIVY9BsGCkE8DNwoMaS5k84LiAiAEC
	 zpyypx/6Ly9x17Sc834ihNdK8IsHUVZIrXhcZ+IydciitQ+iQUK/dodRrHdPy38f7BqlV0D68ViL
	 zrD5i9siyacbg3GWkoDzm073zapeI7RyDKephACXv2T79BBGH/PhG0qL+ktFMjkSfjyvqCdJJsYl
	 /vQMZU+pbXy9Gtb3/177nYWxLFpuCGPny1rb1FOz8zS5GAaBx/+eKazrDNx5HzQ+Z/Ys8XSjE54a
	 YAIOIV07W/I4LyNjAqbVNNeRiUPvxK5etnfUfCzZJ7EhNaRSBlTp0DysZ+5MKJAPtCC0aLH3oMPm
	 YbNJcMNjsPscRKIXi1V4o1dkG/Guv9EdkrvrV09H0UDqosF9ckmTTMmfYXjTubXKnZ2nA7+BuRft
	 t0PIGuDKpK+sYDHhfNjGFfMhzI8jdo5nh/uiRxadzchAjvrsEBi8auQZ3BE2QPkFTTC2CTywLN2K
	 mzE8h3ndOomhk9NVvr12g/0C6FmFv1WoNk3sfebWMrq0TG7FwT7J72BybgPLAgCWb2WZv7J7zUsW
	 wBzyluBjLL/o2nDAf5BViJo308U2RBynTPcxqce2JCK9Q6cPXjxwflnW/lWYtwJVdyg/YQRg==
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
From: shuo chen <1289151713@qq.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	yi.zhang@huawei.com,
	linux-ext4@vger.kernel.org,
	shuo chen <1289151713@qq.com>
Subject: [PATCH] ext4:Fix the initial value of not_found in ext4_destroy_inline_data_nolock
Date: Wed,  9 Sep 2026 09:12:35 +0800
X-OQ-MSGID: <20260909011234.373390-2-1289151713@qq.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If a file has EXT4_INODE_INLINE_DATA set but lacks the
EXT4_STATE_XATTR flag, ext4_xattr_ibody_find() will exit early without
modifying is.s.not_found. This may cause ext4_xattr_ibody_set()
to behave incorrectly.

Signed-off-by: shuo chen <1289151713@qq.com>
---
 fs/ext4/inline.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index ceee69a66482..3398208f3e66 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -437,7 +437,7 @@ static int ext4_destroy_inline_data_nolock(handle_t *handle,
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	struct ext4_xattr_ibody_find is = {
-		.s = { .not_found = 0, },
+		.s = { .not_found = -ENODATA, },
 	};
 	struct ext4_xattr_info i = {
 		.name_index = EXT4_XATTR_INDEX_SYSTEM,
-- 
2.55.0

