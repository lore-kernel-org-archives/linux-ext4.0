Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E513C4B91
	for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 19:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785354873; cv=none; b=m7skf8/uO7lwNCedQpCid8pj0HskHtoPm8uxdfGb0h5CVG0Su0r5gOWUUf9Lx7acGqFqrVV2vPKcve24D3llX2nyKUW08s1rRvogkopO7IF906/6IvC0mfZFAk0dsinuyZGP53i1PLzjToIJmsXykKVR3g2s9EnT+e+TWvo7cvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785354873; c=relaxed/simple;
	bh=mMwmh8CunMxX79/11+cozJ4+J2RN0zZKe8Q4zjY9iCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XcGPKtAlN9gU+hZUWB7JHOW77oLHMGqweYqOiBZzo5Rg+ESBpVllZ80T+EdKlgFyI7LmdU6Dr7fEZEUTPrTkAYzSJqG5WKvag1pveLxSbitwZKG3ghF5orRML68bResGsFZYhzo6ZyfOBNKjGZBGgpZy6IJxnSXX0YVuCXM5NTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UiGMlm+Q; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UiGMlm+Q"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4954aff6088so13330085e9.3
        for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 12:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785354870; x=1785959670; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wFueboZLPWAkgNDj6HQNTjnIe1s16kAVfyJgzcPKDFk=;
        b=UiGMlm+Qt4VmXwyVQVLeN0VC2QYpEjaISudCL742fy2NLvn+JxGHj4RQFJGw8UUYec
         tHBiMCcaNbqier7dBfxSniWsvj8r089HbGsIl+RD74BkJHfvb2wSyfYwa9TGr0tegmx3
         daikPRkQleCDWLXhzNQuku0NiNphjwA0Bem9S/5muD/QXEOyyg9QrABc+dUNF+NBxmPd
         Tx7kHGwMRgntU4/XdpuQEjCoSMC/7GyBK6ZPemxFW46fLp+Ayjyo3tzQEmopfcDE4it7
         s8p+lqZa4PpbqYI0i2Dmv+b3Sv1G8Moh2rMMzt7IIcIVGpLu/WkpfwDutn8cWQvgHeqn
         OOvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785354870; x=1785959670;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wFueboZLPWAkgNDj6HQNTjnIe1s16kAVfyJgzcPKDFk=;
        b=EWhYL0VqY3ACWxnD9Gxz9dd8OanQ785i4KCXO3H70kMAC+oZfEEATPno5Ili9Z4bAV
         wt2xUFRhvWjKyjpQbSfInd5SfyMAbCZxJi+NrsMaga8yMgzf4jXrF0TAuTdDNjFfmwt8
         ToT+oWsuFqcSNUShShINV/wQIj5JbanaqmV9w2XtbHaLeWEvhLXpxjlO3L1D8opXOxA7
         Xn9qC4fz1ygMOnsr0yv6K+XPQUtt6gsRWdPxHcWX+c6DOyUUuBFo1NGHLsoZuz56CitV
         bZ3MYQf1i5t3XWVfP3nhVxGugj1k7UUIcyW/Pz14Cf2VMqbjemDS2nv0P4UBuX9rcgxp
         /MYw==
X-Gm-Message-State: AOJu0YzArMpOktGCC0qEWJCJxf+QWwPp9n51hjfwMXeHhMI5sFlNXM8x
	b8gXyjBDY9f1+QtKoBkv/BhKckwXt83ffjqUAVWzkX7SYqypuTnu6if+CJ6oXoHH
X-Gm-Gg: AR+sD11DkHSi5Ku1sPWdTuRB8ITzT4l+Y707Y2pKKuZUQQcxXMHRfZSjBnzEp4VzTCu
	8Wox+upUE777r5oaB3BjwClh7jB43IG7i9traCr243SZ2ELAPJgErK3XDhfR1Yl6U6YKY/kqQY7
	PfRKeykQXHZUDmhXj9bkCiHbPnp3wEfpxV13rz9LJs5zZxyMnDLQeeuCgeO4u38hRRGDwQZf1ra
	B5n31mQxUvu4oYIKOn95uHEmixC7f/EhFicXOs5Ic8Ec1P0rJXfw35mX5ScZ4ub/9PJ0dIKka7N
	fI0+Jn1+4IqON2JWpRYfEoX4gjJaoWXp8HqEQihhx5ONQsixZanjziyBLV8+3i4CbqlWuRrVwdc
	35yOkmqyyjC7QgJkAxcqXhXo5MqGRCctnolRNSnzutwlMw54sZJVdu9oz6I9spaRyMqs3lceqjo
	BayISMmg3VVOCaE+C5qR5yKD0Zw/gvBFigVbAPGjS83qZBg7KRL34o9QsijGOQfye7Sd9uK6OWR
	29mgH1aUdPfCH9iJlSv
X-Received: by 2002:a05:600c:1384:b0:495:6e68:5df2 with SMTP id 5b1f17b1804b1-496c643be67mr91072435e9.12.1785354869479;
        Wed, 29 Jul 2026 12:54:29 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4976bd6d226sm82076865e9.10.2026.07.29.12.54.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 12:54:29 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <ablagodarenko@thelustrecollective.com>,
	xiaowu.417@qq.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH v8 01/11] ext4: validate count against limit in ext4_dx_csum_verify/_set
Date: Wed, 29 Jul 2026 15:53:19 -0400
Message-ID: <20260729195333.20626-2-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260729195333.20626-1-ablagodarenko@thelustrecollective.com>
References: <20260729195333.20626-1-ablagodarenko@thelustrecollective.com>
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

