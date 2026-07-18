Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C891B86C7
	for <linux-ext4@vger.kernel.org>; Sat, 18 Jul 2026 06:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784355169; cv=none; b=RH5WCKxBXrnFwcYfDeZdN3QHT3FNOuGVSaF+6F5G01hnNZsW1Cn2D+ymMI6hhwclkH/nMqAjVPGRnj8cakV3T71hZtTncXRIJfKrI773RTSzFFozEPL1k0UsIYQMj4uqcegG3bOGJipUb7I4bUCJIZr4L4XRp9FKkB4szmTtYYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784355169; c=relaxed/simple;
	bh=NLo3I+oZZyEewRNeK63+aIuUyjiWKnnyHm42+GXFVdU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mQBETf2FGPzgqbenjg79K3R0G/I6kFrX42JCS9Y2pVlQ4c6jC8gRtSa0Fr8xTgrYLoNnO+gYT6N6NIFZZ4HwrgmjLCHIqt1ot6+yYnYvrsE3IzyM0ddzg7eZWVXBTOpJg+1nbo76QNI40wt/cAZ9OiGXpvB0c5oSoE0iBBfwmi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SiPplVAR; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SiPplVAR"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-caf707e3a70so1379305a12.1
        for <linux-ext4@vger.kernel.org>; Fri, 17 Jul 2026 23:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784355168; x=1784959968; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=y2Z2iNsbJ6ytU6rjVo3MfoAErunYwfv2u8/ZImRbAoY=;
        b=SiPplVARWTl48IjBv5oxh21kFnTrP8fDjQXUigBWfh5rmX+7Fv1AV9P1VFdcYdB1rC
         RNTWlTxheAdWcuyYmgP89tsiP3hwoGpjShHmBY7yIAgVG9nJbHZoKlN9SpQN3g38t+NM
         E4jIVj/BA2z/d1wpL6Bj/SDWRphabmysXPmEQLIUGz4qS73w93lOExtiritwSC7ITo9S
         PfLds+Q13qGoZdhmmf0XEDicPFd2B8xuI6EZI9isl3IR9B/66nkscttMYWXdRr6v264K
         w/BO4vF/dVat7f2quhGbq1i9f4mHvhyW4+6KiDzY2wmFLFix9uYzOSzbhLspcdQQnuc8
         Ck0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784355168; x=1784959968;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=y2Z2iNsbJ6ytU6rjVo3MfoAErunYwfv2u8/ZImRbAoY=;
        b=i4L3Ox/NslBPjTGAUrP+o0xEyVF+8CY6cr7imtYrQvwTZF3u/Rbh8MujRWq3K9ZBn7
         uw76u/r+VhGKNYZb03UevUMgEDJxpXzPS/yDgtgaCDLlrjQ1zN6NVzEa0RX/7jrGWoiR
         neWfcrqAxvRfM0iKzCanNFNF3unphdMnwLjMSAHNvcctTDxmkEK3dGymuZoJKYLFmfIX
         jeVUNjcxNA9srstqHMqohkELilZr/1xenC+5j9hRYEW0iFCIJQVQKpgWXXlAg8PKgIC8
         GQaHsSc+Fvy73D0FW/K7T5MzjWtPtIsuAr2nXMvHwC/020DiIx3MhbtB+WdaVYOx4EQI
         9NVw==
X-Gm-Message-State: AOJu0Yy68dPOKxiHmepFnga59h5fACti2k+fUMOgLgKb7OOwXIkjLjUt
	5ccB0nfn42T96ydHnjZTIcQKiP+n7pY7jcJdXQx5oR9rXd1AqSQWhe2I
X-Gm-Gg: AfdE7cn7KEFPtOFRNaB6f7XSNm+BMp1JdV95gSWSsm6PjRIqS2UW9d4KSzOpPBBDG6d
	2NXduIJvP90vPvdFO/zDbukWmn4YAM27+was7omU8OWgFY83H3pOkJXen9C9gy2BZZxTN/WX1Um
	xHqRnyL1AqzTKiYvjnwiQw3iwp5Nxj40Tdv7Ci1pjfmQg5KS7EVCXxBrSrdfz1N3RQRXQZv+dns
	oGSmndBGKZbIpd4dtbNdYxIXGUMLxEbK35IvHmNVM77N0/4R/ULhQqjhwu1ITVSfcjaUk9ILlah
	MGPY1chBIo2849rUZHsS2tdCq8hHbw/oqFn3RZ+RlIEx9BI4pvfFBax46hrytBQSHGTRVYJY4wT
	5zLGPObVG+zS3gazQrDg/jvEHtm1xvpZ42cs8Mid9GSsZ7ezhMNkrKQKqlFdlArfkxKxyQDPGYV
	Ief51rw7prh8wR5GRlp2OfeQHi4shVYlLJGQ5abPYakmJJKWPv5orD+08I8A==
X-Received: by 2002:a05:6a20:d492:b0:3c3:750f:3cf9 with SMTP id adf61e73a8af0-3c38d90c927mr11987195637.11.1784355167620;
        Fri, 17 Jul 2026 23:12:47 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:383f:ac40:5d70:cf7c:d0ce])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3142a1dd90fsm13604277eec.22.2026.07.17.23.12.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 23:12:46 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+293a57918b36cfae3d48@syzkaller.appspotmail.com
Subject: [PATCH] ext4: defend against inline-to-block conversion race in write completion
Date: Sat, 18 Jul 2026 11:42:38 +0530
Message-ID: <20260718061238.50827-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace BUG_ON(!ext4_has_inline_data(inode)) with defensive error handling
in ext4_write_inline_data_end(). A file can be converted from inline to block
storage by concurrent paths while a write completion is in flight.

Lock-based synchronization is impractical here since multiple conversion paths
use different locks. Defensive check with proper cleanup
handles all races uniformly and safely.

Reported-by: syzbot+293a57918b36cfae3d48@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=293a57918b36cfae3d48
Tested-by: syzbot+293a57918b36cfae3d48@syzkaller.appspotmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
 fs/ext4/inline.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 8045e4ff270c..53d783235da9 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -812,7 +812,14 @@ int ext4_write_inline_data_end(struct inode *inode, loff_t pos, unsigned len,
 			goto out;
 		}
 		ext4_write_lock_xattr(inode, &no_expand);
-		BUG_ON(!ext4_has_inline_data(inode));
+		/* File may have been converted to block storage by concurrent path */
+		if (!ext4_has_inline_data(inode)) {
+			ext4_write_unlock_xattr(inode, &no_expand);
+			brelse(iloc.bh);
+			folio_unlock(folio);
+			folio_put(folio);
+			return -EIO;
+		}
 
 		/*
 		 * ei->i_inline_off may have changed since
-- 
2.43.0

