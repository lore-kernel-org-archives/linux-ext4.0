Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207FA414A01
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 21:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785186846; cv=none; b=jHojOf3qNI4ij2MEF8lijC/q4NahIO+BR0ElQbpnjc2EuLXEGcdLJWetoTibnb/9eXNxfOjMF5Tco3q7Hai8W/kPTsDcartUUMTM0NEuBLryOdZGlHKDwXwoJptvgUIjXkrJKT8IQMLIju15FqlSzYIEndxs/BHf304WK335l/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785186846; c=relaxed/simple;
	bh=lh7MRD1UV5yEqV0jXLYfz/fai7rSL6aSn8lxGZ/csZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aPIVg00WPYOTJ17GLoOS5uIewDJZ5rjIOCu1HO3faQ/xZGCYS51bmvbzwji1ZEO0+0hc6tVzteYZWqvAIZdqUOGhgir6rDrmtBHxKVmWwZS+wiYtze0OsmDpgoCnI2CjrbimrTnE0BriVjOOClqIPlHQB2idfMbnJaexulqprOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MXCP+3Va; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MXCP+3Va"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-47df43bfb07so616574f8f.1
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 14:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785186843; x=1785791643; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lH8v1499fvdeochppTxPEeisAMVBGkn9LmnoU945IP8=;
        b=MXCP+3Va756UxsfsTTaCIp8EuxyvcCl8rxSAYDeEVe2Z2HD5hLdQhDlRwAF7mlvaM7
         eT9yORgL6efNwo3rbJ7O62azs4LOzWEY8/SaVXYYJl2g5ghe8TTlq7ww+vZ8f8f7eHou
         0bt/T3fnSe0kXmEkv+0PL+lIt84hZx+w1BouHpo0Y0kPqYu0WDRGjE3TeYu4KK3IL+sG
         jwXzQHWk+ZW1J8bCRVQSYQfOIy0TTp7sEpBxe65vEKUyl3BbSpx0SH88Vc5WpnRMdmZj
         DE7oBaUkcr2bau+RdqggGIcVqYGyLnUg7BX2KZynOxguPX+Sl7tGXjmzqd0nBkj6oTZd
         jqNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785186843; x=1785791643;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lH8v1499fvdeochppTxPEeisAMVBGkn9LmnoU945IP8=;
        b=ghmFrpYyCASJcseUntLzy7ox0iWxPFZPdpxvs8Vz/TZezKgH8UI9Mxcd51mKkXEQAz
         h0s/e1fqHDjzJh0+hV5IV6FiFafxzMuQJWB+z60jC5wsWGihWD+ZZm2FIQ5Q5fqhDk5F
         /e++OOdvhqxYnHK0glll5pHonwk+BgYxUZ397IrfClTObkrVcVDbee1jZyX1RPis1Fns
         oyT6iwvwDB0gFPG0Ytw+Kk5X9GUE7Crx6lMa2+vkDP1ZV5QtV0K3IU5QP9ClMSS8Mde7
         Sg/Zc6Ax1yXnPadeD9HaXX3keXFJHsHRcQ5owSmllEk9qVPHks+l+ZaX/RMT2xf2tugd
         xisg==
X-Gm-Message-State: AOJu0YyVQwCbFP0nRLHdZYfwW0QxqZzEcvy2t79KGxpEYWcDY/56MfQb
	I0rK0f0C4ojNlhCdVh2EMWQeB01lEJf4upTUPvovtPCMmqSA3f0aSgB71c84SVg1
X-Gm-Gg: AR+sD12iOoKMmEfKi8P2yNbI5lR2ec+T+2GD/IznWJpHDDQOZNc5m1W/h4WwdZlp4mX
	bS7EFXdZR5lvlChsIZJ6sBenhN0Vfg4kZILf8LjThWtyq9rKE1xtLYW+B9NUUnmH0kUA3b6gAyy
	nejhOkE/Uu9r7+VAarre+Q0ktK6kxpVBZ7EM7hZwmdQOYkVNewM4YR4aVl19xQ9OFQijIlPq/4A
	YdUfqagt8TCeLnYmXW2ZluyWCOggEXDDeXKKfgmnmEbtt2C819nKjx2XUnUiAjgue8rpr/3EAK7
	L+dpaKATJ6379Ulx6571/4SvQ7JDhb1O6QgZwMxRHUS0M+JUlx2lnWSvykpfNyHJFbHbg4aGQOP
	rIZL2QmAt7oMQ+vFfiO/rLsMES1VExB/jwbTn17S4kyXHRvFUqTAUA+aJHjJQH4iK9j2CXFxI+S
	g/3qLKNZThBH2nJ/LKPNgVrLwPBI6luCBb+Q==
X-Received: by 2002:a05:6000:26c4:b0:474:3b3b:5e5f with SMTP id ffacd0b85a97d-47fafa65dfcmr830760f8f.16.1785186843371;
        Mon, 27 Jul 2026 14:14:03 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c67339sm54987049f8f.31.2026.07.27.14.14.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:14:02 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Disha Goel <disgoel@linux.ibm.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Zorro Lang <zlang@kernel.org>
Subject: [RFC PATCH v4 03/11] common/defrag: skip defrag tests on DAX-enabled filesystems
Date: Mon, 27 Jul 2026 17:13:37 -0400
Message-ID: <20260727211353.19736-6-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260727211353.19736-1-ablagodarenko@thelustrecollective.com>
References: <20260727211353.19736-1-ablagodarenko@thelustrecollective.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Disha Goel <disgoel@linux.ibm.com>

Online defragmentation is not supported on ext4 DAX-enabled filesystems.
The ext4 defrag ioctl (EXT4_IOC_MOVE_EXT) returns EOPNOTSUPP when used
on DAX files.

Add an ext4-specific check in _require_defrag() to skip tests when DAX
is enabled, avoiding false failures on ext4/301-304, ext4/308, and
generic/018.

XFS defrag works with DAX, so this check is ext4-specific.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Disha Goel <disgoel@linux.ibm.com>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Reviewed-by: Zorro Lang <zlang@kernel.org>
Signed-off-by: Zorro Lang <zlang@kernel.org>
---
 common/defrag | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/common/defrag b/common/defrag
index 055d0d0e..baf05d94 100644
--- a/common/defrag
+++ b/common/defrag
@@ -13,6 +13,8 @@ _require_defrag()
         DEFRAG_PROG="$XFS_FSR_PROG"
 	;;
     ext4)
+        __scratch_uses_fsdax && _notrun "ext4 online defrag not supported with DAX"
+
 	testfile="$TEST_DIR/$$-test.defrag"
 	donorfile="$TEST_DIR/$$-donor.defrag"
 	bsize=`_get_block_size $TEST_DIR`
-- 
2.43.7

