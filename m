Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793135393;
	b=49cN9yYWXFJl2QpFz/eOh58KVHnEFu4KAtYFarZ2nn0WfGorFC1+k/VUToKo1O+WP9UJ
	 bpCGnzB6n5Mb7J+89o5/EiVwo1+ZrrU5nggo9UwGQYyCDNT6rixHkHvLD8bKOisHHLc/g
	 FcKInD4Pq0itwKCLSlgwtMPemWdVcpYLFNT1csK1NeOne2GU7ycaW0m1UZakeOdEeHRl8
	 EeLjYguNhz8/yU7Q3ljx0BF1ucGR34RFaKdN5lC6TGJVRMZpGDvdXsw2gbD89z+XCDttg
	 NCYZU/UXdB4udsc/cTOl1+EI6G7mzzd1efXHQuRhizTLDsRScd5p7JahwNaLJSr7rIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793135393;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=HAhPDfSNI1m9jMsgOVCEGKYJnC7ZRumB7Co5M2j8QiA=;
	b=QOwZApnr0IRB8Hh66kagcxb+YK9emn9b4126amhN6hEdkoPAtciH1stTZEA5g5bEHvnG
	 wReHniH5RyqS+Nj3liSwt7QmJf3M0YUkppz3ph6aNevfA1gJgEDrxThbZXvHbnGuj8jkS
	 inkO7mEtOgqJi1U9bVQAZhml27Lnnc+vqz1wwSFqxstfQ0wuZ4HGF46qdoedkGUthVTWR
	 KtMHAOEWU7ZQla3BHM3SOlxfmpHq5jZIdw1aaNECGsfqGUfHX3pbzklxNKz+5BmKjb4Lq
	 9sBWbr0yA7Rvtwo0SbTXig8kpDJmEL/tRaZCGQWGuqdJQ+vB4AoMZZ5/OdHEWX+3/mQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=hOU79HFU;
	arc=none smtp.remote-ip=209.85.219.53
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA83060A262E
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2026 21:09:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BA83060A262E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=hOU79HFU
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-91bb5795792so3681736d6.2
        for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2026 14:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793135392; x=1793740192; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HAhPDfSNI1m9jMsgOVCEGKYJnC7ZRumB7Co5M2j8QiA=;
        b=hOU79HFUF5XVQIP1i0LutIU/umJRpfeIAGlIU85PQ+VvN8AhJ2xV/+Ckj7hUn0FiXT
         Vo7Bqt5A2O7gVi2FXZ7LR1GJBkC3682be/KrfbJUx3Oze79iZ02cF+nWdL8HAMH+TkA/
         RqJRdc529Hs/8A6MizbL1tlCPDHiaNo4rAfVeS4PCd+pYvNB8GiE3hhXUKHhQVK+xtN8
         JXcziCJ3xyZB8L1d8uSyg8o8tM/93MhtFnhO+nATDdlG/gpAAJwbl8XdWTjLI3geZAFt
         Fqe9NEA86+d0c+71frtm+HrDiotx5CzEsaAF6tQp+yTnBApEwLxl6fqpDPD3/OU7RekT
         j33Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793135392; x=1793740192;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HAhPDfSNI1m9jMsgOVCEGKYJnC7ZRumB7Co5M2j8QiA=;
        b=A6EiVt2lqUacWRcePpWdySwJ6C82nD2+QXgq/HAAvXBLVmifEM2FEPbJUBMOa/22ER
         wA1l6x4EuY6wRiPLx+JhzTT2Z3sAJ0BB1QqOUU32a0sJms1A8V75pUmRAUuCQVAq0pAa
         qrNMbSklKaXNv+9KBa+cXtGnSiqHMBGH62u/Aye5xrJBvZ9Z//N+i8f5inTzycGxaKc9
         kT53pHjLTnb3GGanpau7gR2YGvTxZPKtn7CFvJbvYESqbXdFNj2H/OPDmJoP+BRW9VUQ
         I09VyXDzzH9bHAtBUshKwM3Qib2N4/V2r57LA0Xzv1q+Bejc8HpZR1lDNZZX6EXNwixU
         r0Pg==
X-Forwarded-Encrypted: i=1; AKwUvBzzQ6eN+UB/t6I2a4F7rzHPYeNy2uUjnQo5BUUiODhx3znDCildOn5yX0VR6Jg99gQA7CMID2hSZn6x@vger.kernel.org
X-Gm-Message-State: AFq9FYKTxAs/GoYEPgQeBxCmjL1vTl0DcxEJM2NvsZJ+elk30pVpekD5
	E5KHzrX+DQK0dTrq+w37qhIyYAKIRa8oydB5KEAmEL3Xfv9L1Qy5ADk9E82UAAsocX4=
X-Gm-Gg: AYBFou2X94XH718sUuwFwR5JrxwJueXb2jBhRT61d8cPbKILUOdtDKEmrU8pRZzH2ZJ
	mIGHepXoAeXUiNkr92HXGc3Py9fubzK38pEX6m5XWcXjAg7lES+p5aCzkMNi8iBJ0w+25tytwDw
	JZ9ZjD2VmodWn8LCrxpluXJMjK11aZsJ5u/oF2VsoQfFPYid3TlisHZ1Lw+kUeCbAe0nkn29pBU
	6GzWHxrZtLMJCwOSNQP0cf/E5aJWJkvpt2YrTAu2xG2bNiTYUnmKwgPsXji6lxGPbMIDYgI+Vp7
	5JOgdGTA6/JIMl3ebuLO+jCMoIb5Bx9RrmrMzmoRBhW3B9sohrG/mTATrtlgCR0uVa4dZyfFp0X
	SBHMdEwJqitnfrWgPSzUcTuki0THD1SVOLhh5D2j83iyuAqHamztM/eZUQQwfrT/bmqIUBC92Dm
	JIRUmR6qRo1EL4h1yZCxurnhIdLjK6pl421D9NYE+duuS93rbX4X+nRTlLcj5HF9PbBtZyVcIR1
	JR8fOo2hS2C6nmogctbNp8ZBr1pQLcq5liGpB6E8OD3JSlx2oSvFQgsx2APGw/WyusHAgAHLQUE
	UEzGWgUxFL/XX0O9UQ==
X-Received: by 2002:a05:622a:8887:b0:535:92a6:22f2 with SMTP id d75a77b69052e-53fcb20dfd5mr9618051cf.15.1793135391683;
        Tue, 27 Oct 2026 14:09:51 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.253])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-538394c565esm88811961cf.6.2026.10.27.14.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 14:09:51 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 27 Oct 2026 21:09:30 +0000
Subject: [PATCH 04/10] btrfs: set SB_I_OVL_USE_SYNC_FS
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-b4-ovl-containerized-sync-v1-4-802e512379a6@toxicpanda.com>
References: <20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com>
In-Reply-To: <20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Theodore Ts'o <tytso@mit.edu>, Carlos Maiolino <cem@kernel.org>, 
 David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793135381; l=741;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=KS+Jdp4IcUSZ6tCav8kl7acTQpMUNvtXOKDv7b4wQHs=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QJlIHMWE4mD9Fg4D+/nCw/fqbncWcTX25kEPMy8XebnWW9mJFVsO6uNMHNrIavR2Gh6YLS/9QxQ
 cP8BX8zQgBQ0=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

Metadata is changed in a transaction, and btrfs_sync_fs() waits for the
ordered extents and commits it.  There is no ->write_inode().

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 7fabb775d4e3..cdecf90bdae0 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -981,7 +981,7 @@ static int btrfs_fill_super(struct super_block *sb,
 #endif
 	sb->s_xattr = btrfs_xattr_handlers;
 	sb->s_time_gran = 1;
-	sb->s_iflags |= SB_I_CGROUPWB | SB_I_ALLOW_HSM;
+	sb->s_iflags |= SB_I_CGROUPWB | SB_I_ALLOW_HSM | SB_I_OVL_USE_SYNC_FS;
 
 	ret = super_setup_bdi(sb);
 	if (ret) {

-- 
2.55.0

