Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65AF403AF9
	for <linux-ext4@vger.kernel.org>; Mon, 10 Aug 2026 15:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786374736; cv=none; b=dHDPhlkK9CIlQmQRrbv3lW1ao1muwHF3dOEf0zaJlAshW5T4+OQmkiqF2LvUEL2P4qLQMU43spYwbY1fz+m9D2P74/h1N10QqgqfU0aFhxBUQuRU6J/3nwn/D9TtqCzogmYzXoNWyNIZVY9j7eY5KypawHnzmQqjVWaHAeE1tvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786374736; c=relaxed/simple;
	bh=a/s/YPLDFQF7KULWTXcHJRBQx4jWQPH7Uu3b9bsySwY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KZsBiMqcsrVhnu7CYGPL37AQlOEQ2Aa13hjTzkKt3Iqp7f5xAe+6T9BYIAn1MFZfrgekGHztmnsHgquKzcMdzYaZbmdmog1bHSHwN8vp5QjVODgf9vAIgoz2Ie7mliuvs+6KZit714LmoEjRNUF4eLYjZDKk+X8bCbQ7/JGImM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=csyU+SCr; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="csyU+SCr"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-38101f85591so3964037a91.1
        for <linux-ext4@vger.kernel.org>; Mon, 10 Aug 2026 08:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786374733; x=1786979533; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=w8RyNvaah3FCOAzqxtftiLKU42GLXlNmR8aNo1U11oQ=;
        b=csyU+SCrw1ieK5idWNSNF+nxBquyxfctKgdn5PU/fJw81gjmA+aPHMP6hPfc7qkSNS
         N2nsUbv4g+sT5BPOft5lxJm5sSIlcr9IUvMUz3GHkw1XNwVBjoLFpGI5tUCv5nmAQ66Y
         1X0LJDIAaWyunKQzHoh3eJFyI7aXFojNdQoRMc8braWbm9w+iesAyBThnYfhlKtWsTk9
         HjptAL7YyVuT1wSa25GSAs8fOeyuPxdzBXhNEcm814PAVUSw9MnzLwVCf9MZSPSwXX96
         v9LDcpiL6XwXNx2nTGFidgiUCN9n3eZo9Jc6guY2icE0N6+ibhsBybc+bYZYXUoHRnUU
         SwJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786374733; x=1786979533;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w8RyNvaah3FCOAzqxtftiLKU42GLXlNmR8aNo1U11oQ=;
        b=mY7IlGOjFn46+cNFcUJPgR3/xSestdQr9mkTto8xIpi4HqO1a+iAM9rur59pRMvxi2
         giHNyNCfySopu/VebCNczoEGf9e24wzfWZ9eapdj7/AUmTfZ379PudB+kq6fzRFzpn6a
         YDDMnobjZ1P479ZBKuqdE7PghkQprpMwBy9tq67j0628yeSUolfOWNcm0aT4mn3jdkgw
         HxVZN/dwJ1lLK/UebzbtG1vDkLl0tYkkJBmU5hYKlrKEaqGEylTrbS9V+inYbOdQduV9
         Kh0JH1xz0D/yn8mV8m3iq16d3JbNKJ4mQpRn2lhBz7a/IKMyJMQw2iW6VQldQMDpYT1R
         jtSA==
X-Forwarded-Encrypted: i=1; AHgh+RrqGy7CN/P1iP9vQM3MeE7t5Wgxm7T76H8sU7L0bXvSX+esBo/7aeDDWGucoWCJ1rNt6LTg0T1qTzaJ@vger.kernel.org
X-Gm-Message-State: AOJu0YymrMo8s4q+3zO7lzttruLTo/Hfm+k6oQgWYgVm2BAna4fAe1qi
	2rX8ploY7SDQcPbS7cr4z2aqKysWvIsGHyfG+p6OyKBc63FFl4Tv8IA7
X-Gm-Gg: AR+sD13w5hYXP5xS+3a5pK3ozAK4jEBwwl3ZFTshlEtNXpFCz+aBsKCDF1pB2/sTat8
	EBNbxP+141IIqGA2ny9Es4hw5yOILgCA8v4JGmkRJ3O/xgBdbVY1qXlFKuLAaa0D6lrs6HkMo0Y
	Jh22e2R0auIZXLMSzHA/1OUqaU+2ivTr1JJ86PhHlR0u4/55vc0PGTJz+pmCyt6mqJbvVHRmlua
	ma2nIge1T259eJSqI59i+Kn9mdugJNi5Zdj9A8zwlel9ZZc+b+cZixf8oUy449n69OU4AFJo7C/
	aQCmioYGfTgs2Ya8ikoaVE9N0WeJuyDZQgzGjxfsN9kmxyPbcfZMp9qyuexAc4EIpevWFFD6YEs
	9vCtXnc72ubrfODc2FhGfE3ZBirrXq+VtgI7l2KUxierRfXuLo8UlJxS5HhzbSLoyE/1rzhj842
	zhqU/26c2YOzA1EjdEYt/d7TKIOymT3ErGao2HOrMv3Wt7QnAl5chEgECpOzqVrkUynySKTxKby
	PhUE1g=
X-Received: by 2002:a17:90b:2e4d:b0:38e:4e61:c9e with SMTP id 98e67ed59e1d1-392847a9bc6mr9243225a91.21.1786374732777;
        Mon, 10 Aug 2026 08:12:12 -0700 (PDT)
Received: from n232-175-066.byted.org ([36.110.163.106])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3925fd95270sm13065069a91.5.2026.08.10.08.12.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 08:12:12 -0700 (PDT)
From: guzebing <guzebing1612@gmail.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	djwong@kernel.org,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	guzebing <guzebing1612@gmail.com>
Subject: [PATCH] ext4: only update tune mount options when requested
Date: Mon, 10 Aug 2026 23:12:00 +0800
Message-Id: <20260810151200.1405562-1-guzebing1612@gmail.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

EXT4_IOC_SET_TUNE_SB_PARAM uses set_flags to indicate which superblock
fields the caller wants to update. ext4_sb_setparams() checks set_flags
before updating the other supported fields, but always copied mount_opts
into the on-disk s_mount_opts field.

As a result, callers that do not set EXT4_TUNE_FL_MOUNT_OPTS can still
clear or alter the on-disk default mount options through their unused
mount_opts buffer. This can affect subsequent mounts by changing the
filesystem's stored default mount options.

Only copy mount_opts into s_mount_opts when EXT4_TUNE_FL_MOUNT_OPTS is set,
matching the set_flags semantics used by the other tuneable superblock
fields.

Fixes: 04a91570ac67 ("ext4: implemet new ioctls to set and get superblock parameters")
Signed-off-by: guzebing <guzebing1612@gmail.com>
---
 fs/ext4/ioctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index c8387e6a2c6e9..1f6d7afb62ec7 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1362,7 +1362,8 @@ static void ext4_sb_setparams(struct ext4_sb_info *sbi,
 		es->s_encoding = cpu_to_le16(params->encoding);
 	if (params->set_flags & EXT4_TUNE_FL_ENCODING_FLAGS)
 		es->s_encoding_flags = cpu_to_le16(params->encoding_flags);
-	strscpy_pad(es->s_mount_opts, params->mount_opts);
+	if (params->set_flags & EXT4_TUNE_FL_MOUNT_OPTS)
+		strscpy_pad(es->s_mount_opts, params->mount_opts);
 	if (params->set_flags & EXT4_TUNE_FL_EDIT_FEATURES) {
 		es->s_feature_compat |=
 			cpu_to_le32(params->set_feature_compat_mask);
-- 
2.20.1

