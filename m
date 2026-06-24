Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F2938B7D6
	for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 13:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782308287; cv=none; b=N28OHLomCMt87PFs6rbqiVWChduJn7uo9NXg47ajTOt+++jCTfK7IiqntY8uHAacfhzqmjSfo/uTrnSeVg1jwBVcRsBByg32e9BgM9CyzYzm+CqlfZwu0VJPtRp3/yA88ZAJYHnnLAkmx+1b8BeklqSy+sP6+qpiX4Lf/o4IebM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782308287; c=relaxed/simple;
	bh=mMwmh8CunMxX79/11+cozJ4+J2RN0zZKe8Q4zjY9iCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IjOHkfQsg4OK3Ley3sTG6k+sf2i61WsxuHSbcTadrdVLu7jac4v549bdRh/EVtUIu1h8Y94aRctnbX+/HA+bxr8AI9tv9rSntraNF3Fha9/QnZ3WL6cvppzgeZpQTzNRRco4z+8/FlmIgCYhdM7nKmSGmH2u+57sSfa6kxAVLeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=o7VnsvcV; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o7VnsvcV"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-45ef6565cfdso518938f8f.0
        for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 06:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782308284; x=1782913084; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wFueboZLPWAkgNDj6HQNTjnIe1s16kAVfyJgzcPKDFk=;
        b=o7VnsvcVZfTdzA4+/AhU/Ppw2XzY4gh2kFh+zUYu/idABRtXh5tm02wMI1x9XKApBP
         B5pClElCdfd2a7qVWLWrkBsA2jAfb2Z7V7gVu0HbZurvVxunsVOTqvejEAbj4D25SurY
         ZSQm1Fif4P44/eZLe/Z2g/0aax9k6vjTAuiEybans2RZvHSgUZYG880p884fPL43dvf6
         gV03js0m8neaEZHg1v9BfiYFFJJ0jr1rRLI95UzZNyvvQ/2fUc3IXufQjfjs1mT+WFbK
         LftppzE9DQ51iQuyHTM5EeX2ZPfzXohwOev3shMRQFV21B80vsU+oX4u/stSPKsesM9v
         Jicg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782308284; x=1782913084;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wFueboZLPWAkgNDj6HQNTjnIe1s16kAVfyJgzcPKDFk=;
        b=KbJvkagiBnjcxctrllBXizIiBobjhIXO0cj9blOOVJjFy49QdlZ03Tu/l3JSVvJcZl
         pe7GT3lTS+oo8JXaaXOh9Ds8wi18Pg2fmxEF1FqwF0BOdBiqNdYbnR3iLB0iSYt1F1L5
         8IVCyrl77Q3dtsSoQJhd88d9c7hnx6o3vS65Wi/WzygDRabJyPZGnzhi9rYNXZ3X3hzH
         OuDlCMLjoINSbuK9uZmXuxct0aYwQa0XqT/yNWvL7fEafahX+Ck3wn2NheAfyTp5hGAi
         a6WVl2JsxVAIUjJV9bOu9IkDuby9V62QEZ2mQrzKsHOeW6VRW5VYC6Y6EWjxVE0r7zUJ
         1DCw==
X-Gm-Message-State: AOJu0YxV/cOJnl6PmFiCCpvZWBeGFjusntlwpFwn/RloU38RVQT+PYGj
	okS/s+QB4m0Dl2tqYfjPx3nyWB/Hzmh+qww0CFd6GAlHqvb0KtjjN9NUtfv8N9cq2KE=
X-Gm-Gg: AfdE7cmha0qDaebeDxUDJAFXuKUR85Pt3ag3sfBgIsJPCyLsO7yHDTeNI4bIxBt+oIJ
	/aTNj9IqWw4AyN0RWrtGohwX131guXcB2QmLZx6Zmw3/Rpof8Iy+t6EXal6csf/ok0RGgzAL/1M
	8ryGs2mB5lOqhIfWGYr2YxrKMDTObbwavI2bjEWf5JpLPnqhTjsDNMY7LvC+OJXy/qXEpA3PzQn
	0Xoj4rInLJC+8szpDgHcbnvcSj/94mFEmNjtcPieB/0xb5svNpq0Brb+XnWB7O1MzGUkaQdEea2
	8TBQMsJwiJ/NbLld6jP3vNCf8z7P+bRK0cuSxZPXhLw++c/HLry9SxmU5pzywTTR4irVotybIVW
	YnbDo8jacLiWUfqKXQtKDrv7vcxfLCSu0gjbGIhC9tzZCOsGeyEj5IWXvrRnw0Vf4xAfmktI0Rf
	S5rHIi7zXkCZLlnlZ3g18byNsDK8Y9BWXs+uSyddyE6l9Y
X-Received: by 2002:a05:600c:8b4c:b0:490:be1e:6ce6 with SMTP id 5b1f17b1804b1-4924908ab39mr291233625e9.9.1782308284274;
        Wed, 24 Jun 2026 06:38:04 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:8ee:1201:acf4:9ddd:6ede:2d9a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4923fd33dafsm501416155e9.8.2026.06.24.06.38.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 06:38:03 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <ablagodarenko@thelustrecollective.com>,
	xiaowu.417@qq.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH v4 01/11] ext4: validate count against limit in ext4_dx_csum_verify/_set
Date: Wed, 24 Jun 2026 09:36:30 -0400
Message-ID: <20260624133642.18438-2-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260624133642.18438-1-ablagodarenko@thelustrecollective.com>
References: <20260624133642.18438-1-ablagodarenko@thelustrecollective.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dx_countlimit's count field was read from disk and used directly to
compute the checksummed range (count_offset + count * sizeof(dx_entry))
without ever being checked against limit -- only limit itself was
bounds-checked against the block size. A corrupted or maliciously
crafted filesystem image that sets count to a large value (e.g. 65535)
makes ext4_chksum() read far past the end of the directory block
buffer, hitting adjacent slab objects.

Reported-by: xiaowu.417@qq.com
Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
---
 fs/ext4/namei.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index cc49ae04a6f6..a283e285937a 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -477,6 +477,10 @@ static int ext4_dx_csum_verify(struct inode *inode,
 		warn_no_space_for_csum(inode);
 		return 0;
 	}
+	if (count > limit) {
+		EXT4_ERROR_INODE(inode, "dir seems corrupt?  Run e2fsck -D.");
+		return 0;
+	}
 	t = (struct dx_tail *)(((struct dx_entry *)c) + limit);
 
 	if (t->dt_checksum != ext4_dx_csum(inode, dirent, count_offset,
@@ -506,6 +510,10 @@ static void ext4_dx_csum_set(struct inode *inode, struct ext4_dir_entry *dirent)
 		warn_no_space_for_csum(inode);
 		return;
 	}
+	if (count > limit) {
+		EXT4_ERROR_INODE(inode, "dir seems corrupt?  Run e2fsck -D.");
+		return;
+	}
 	t = (struct dx_tail *)(((struct dx_entry *)c) + limit);
 
 	t->dt_checksum = ext4_dx_csum(inode, dirent, count_offset, count, t);
-- 
2.43.7

