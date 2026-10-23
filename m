Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792736352;
	b=2qS3RACzT6IotBsAOhQ1X22aEmUpLzwAxuhCLtPdIsInPJFITN9zcF0G09hdDMp0D92Z
	 OGLf/SYWtLPrCjpajSrj2VrfdY39QGKCduFu5PUU1ZhX2ndlHShL+QzMuW3jjJEkswIpr
	 sygFpjIjI5q1hjohcjawzrL4aTcSpN95RIq3snNDx25A9nz7zTGuyhhJo4U89p8AdXJ8D
	 p+O82wlgXh1QuF10/ob0sj0AMVG8s4ZwBVsxB7ov8JoVBAJuHgH5uPK5ixb9VjMbqUVnI
	 DP9Q8wC1S6oYVSQC8QfQ1fIQ9b9K1qCY4y5vb+HRru9phShVsinqVeuF/vlXxIklR4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792736352;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=HuRIUuhc5zZjmFLINHqF93RSzl+wkEyXtP0aTouCCiI=;
	b=TR4NcjVbF27Pi8BrrOyGlJGe0tBE3zJKh9SLj2OVEQEQoEPqviq7jaesWHfWNhXp3sb3
	 NYimJMCPX9Hn3q+jRc48YtpyQbjCbP5ozGQ/d+ZZS/k5pbrkuu20H3jha0l0J5o+JnL+b
	 Um6CICohXyrQ+egZwZkKaXaoj+OMMjKOXiycTTKscxv7QO2dnXUD2RxEf7SeiC0pEUj6j
	 wN7TBaO0WCMWeFubhRuSMsm/UpZ7ulmUoOV1Hnk3gWfhGYXpb9yxvE6bz928jLhfC69yS
	 uZ7LQJG4mkYc564+yColkdW+0MFbOpXxslU79PsZyXInVLvSRttbPrX5hrUETAmjfXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=astOWP61;
	arc=none smtp.remote-ip=209.85.214.174
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62576606A31A
	for <linux-ext4@vger.kernel.org>; Fri, 23 Oct 2026 06:19:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 62576606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=astOWP61
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ea138a3497so2635825ad.2
        for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2026 23:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1792736351; x=1793341151; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HuRIUuhc5zZjmFLINHqF93RSzl+wkEyXtP0aTouCCiI=;
        b=astOWP617wnuUNIiSQrycAORPnB1Lg8Z+bkKDTOK4b46pkOViWIqoYqYqsxJwFuKNA
         Vlczb8giiB86dClqu7x9ubqqixeXEx5uR/xyUqyZuR2xB24iQNSWGM8lJaiaOwFBEeV5
         dsXwSQYKDi+kpTCSuxXGfgRxoa6B+yj3C8C6Wo5XYFQT+Du9zs2h85RfYEMEyjKGUhma
         tZSCJaHdUTykKS47R591YILRseYajJoM81YPxgL19ladNfMfSY009lkwoP6vVhHjjDcD
         Rrak55WMtfaP05C0wyGJMz5F3cX4UvJ0zjWS5aZqs33kSaP09JGX2IiNkbU7qSB1kFAn
         I0xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792736351; x=1793341151;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HuRIUuhc5zZjmFLINHqF93RSzl+wkEyXtP0aTouCCiI=;
        b=1+t0mQdA3bDu09APgNRHMcWdRSpIUyz98LX3MV4sf/5W8YUNGW8V9HTjJ/FNAKOXUE
         24SydIBk/qlB4gaIRK0gmLMtnX7cx+jQWtmVm64jxOmZsvMIIFTzz9THdZHObD++VCE3
         9+jNoM4fCpUzNgGDhva6o9sapmRQMLJf444idbODU9jyQgjeHUUJMf7M5WTeaLiN/5h/
         P/s++3sPBXG6XjuPN6aK9vuPAvIP8OXFOZecWIzac7BU6zGDN9LcJ0s2p23s9ICi9d/Y
         MCdHF9nmwyuvwSRlJitSGvsPgQYAp6mPGoMD8eUv3vaQasFk7SeEG4RSaNult1Hhj2wF
         KOEg==
X-Gm-Message-State: AFq9FYISNh3IxZmEoA1Il4/wGMnOmUXFXch7BRtwasLmfXRt5N4NZjHR
	bzy0qvS1Bpohcgvrlz6KhaPy/kAEDnJaI/gnpFAsFhiP633Pl1Ind1bLYtsUwqdjSvAyQI8lW0h
	guKdLB9A=
X-Gm-Gg: AYBFou2Cwka7+WzS3yYYBiUIDAabCyI7z8X6lRsOaCSq7XV5ujPNDzEeZWi+3xMe3Yf
	CiSKfQhhli3tzVAcBKZPO60kPwv8w1+LRsdGzzgqTCccrT41aDn0dbOZCy2O5Dpyrw5cdMVaHWF
	GwKyKo6wI92wdtV200cyE2CgoKBOTYzo1TCwPpkG7UA9B2EvfAZDNdn4cAFmA9rk3r4FC6QNXJB
	D8vqfiXVOJZlvLZHG2FvbiALVtpbg7HnPZ6/9gLt2gSx6qwbeHZbBBwEzW+P6Q6I2u/k/f6cvAk
	jAjnmFqv71QgHbdPFq4tm7dugjg8l5eJkl78roWlrpaRhqhaBIhCG+GJi5VdkvA+1E14BmaNWHJ
	OEahIPbObEGV3fGVYavvWyCqW9Kkiuhh0zGWX/l26Ukf0MAHwOc6jry/lMYm4EcjPZ8yu1agyR7
	3+j2T8daklpHjETnz0j1FFsWfv1LugKY0QXfnTgBTSm17Mce/OrTjXe6KqqRUFEENX85yoBc/RU
	6JiJQwYVsKIf/ujQibs70Vm/Ptf2pVrQZKXsYtmsvyjVEsjZObwy/tVwvZOzyYR7AMn4cn+2vQq
	gXaBwA==
X-Received: by 2002:a17:902:ec85:b0:2e9:3dd2:a8fe with SMTP id d9443c01a7336-2ea7d0c9eb3mr13854295ad.21.1792736350506;
        Thu, 22 Oct 2026 23:19:10 -0700 (PDT)
Received: from localhost ([106.38.226.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea7b369900sm5824225ad.34.2026.10.22.23.19.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 23:19:09 -0700 (PDT)
From: Julian Sun <sunjunchao@bytedance.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	riteshh@linux.ibm.com
Subject: [PATCH v2 4/6] ext4: put folio on partial writeback validation failure
Date: Fri, 23 Oct 2026 14:18:49 +0800
Message-Id: <20261023061851.45579-5-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261023061851.45579-1-sunjunchao@bytedance.com>
References: <20261023061851.45579-1-sunjunchao@bytedance.com>
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

mpage_submit_partial_folio() takes a reference with filemap_get_folio(),
but returns without dropping it if the mapping position fails the
WARN_ON_ONCE() check. Release the lookup reference before returning
-EINVAL. Leave the folio locked for the caller's cleanup.

Fixes: ded2d726a304 ("ext4: fix stale data if it bail out of the extents mapping loop")
Cc: stable@vger.kernel.org
Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
---
 fs/ext4/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 81aac8744f3d..e1c69431e4dc 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2579,8 +2579,10 @@ static loff_t mpage_submit_partial_folio(struct mpage_da_data *mpd, bool fatal)
 	 */
 	pos = ((loff_t)mpd->map.m_lblk) << inode->i_blkbits;
 	if (WARN_ON_ONCE((folio_pos(folio) == pos) ||
-			 !folio_contains(folio, pos >> PAGE_SHIFT)))
+			 !folio_contains(folio, pos >> PAGE_SHIFT))) {
+		folio_put(folio);
 		return -EINVAL;
+	}
 
 	end = folio_next_pos(folio);
 	mpage_submit_folio(mpd, folio, fatal);
-- 
2.39.5

