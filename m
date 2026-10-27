Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793135391;
	b=4Tp7Z0jhPfLJz2dVRurFLiUIIUEQ5NH1Pk0EwdHqkYBMGrob57RNMevSogx84lzAFOiN
	 h5TzsxVpZhHSHFVeSV1p+PQkklawjEU+kljxhQmYGWVLjQweV9vYkmrGCCUZli5SdVZnS
	 iWOdbVr+37ToqYHGlAEtU1zt8ZC+vmuTs3TRq7yn1j/qrBZizg00kaETAbMFcCUh0JDdq
	 JgFrvFCq4Dt1hBo2q+eRpxeLrZNtvXVzCqaiz6IhBky7isRPYhNcCYljYG84VoAYz9XEC
	 eB0UyyyzX40B2ohP4qLygSqq+sXsyFDODGuEMid6NMAs5amT44+avmZW20NyDtKoYgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793135391;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=IpMKT1cwbF2BM7+4MFg5CQwWFq73xTe9BXIlwTOQUCI=;
	b=KZh/8ibnJkdoqQlXZFoZgu0GPIRYhujw+gDcFYoDhccw5Ouy0pnKH3n4hNAfKnCiUhyY
	 hUK+Ih+/IjO+VXJPDMeVu71R7KwHNorE12/5wi37cVftfVrGJHnMrcu1KwlHkrLq2YhgE
	 FMY9/18NFeh5kvqyc285TDnj3Sp9hcsZnmg/WSa4XOMqOe6dR76HhOF24ZneoDLCl5UOk
	 cv0qPXzOIVNvnDLZscU8LtX3gPHBaiqEwrK6a0DfPLLU6zdI6PsruDklAPpHgVeqDqd6i
	 P9aHMKkXzMRtNCIO4RjS+ZItldBhFtbftLE39SGRpwj+0O+oqRuTMuHggxZrS2QdbIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=WnvvvdTc;
	arc=none smtp.remote-ip=209.85.160.171
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A5260A2610
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2026 21:09:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 01A5260A2610
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=WnvvvdTc
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5365d26ccbdso5211561cf.0
        for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2026 14:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793135390; x=1793740190; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IpMKT1cwbF2BM7+4MFg5CQwWFq73xTe9BXIlwTOQUCI=;
        b=WnvvvdTc7G1nfaWX/xZKKnrICsgfAqeL0R9qFWLgI1Lu6RxgO3Y0j6JpA78kzWjYYF
         KyHoApYnqdtPpwWqfZAw1ZHZJU+FOrbBiHwQmZ71f/p1rv0nSKVSrveRfhtfsUqhDK77
         whvi1LUz+/OAAEmIQmJJBuXgJAoalPNrMrCHO8ICLrteLjaaazmRhnuZZB8693EsvC0P
         aFtcYWZhs+cUyb6MfKJ7TpwPzncqeXWQlaRPzHPMlLHVg9VuV/+ATMzV6LYkGnffpwU0
         nteEG1kjc7zbUoS7e89EOLrDTDoYhaVC660ZHf2WhRhQ+FzhUdOwf98TItMqyoculpUQ
         Q7lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793135390; x=1793740190;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IpMKT1cwbF2BM7+4MFg5CQwWFq73xTe9BXIlwTOQUCI=;
        b=mt2iWb3AC7sM6deO6ZhfoWUZuJW9ZzrXZGxlHBbEwqi3r/AXBWzMr0KdZDEB/VWnm4
         vUkmQoycEQkQv3yx7xg7wSOvovpBDnPe4H4w/Z8ouS0ldViQYYEafeuS9R3uHdbFs73v
         1JwIlePxLUxUCrlLILE3RAAt+BOIjBi9tNZVHmriKRg0ReUuuksTTI0xn9EHMU8XY3Q0
         tR+GawUluz+tcLdGi5BN0CoPKy40hBXE9c3Rzrt25SANcR6Ma6cu8Va95ROMQOPZ0Tet
         uGJ9+qDschCme0I0wn7i+0gkSN+opX1+2mGlA2FydLQjsirwEb0D+2GD5vZNEhAwRu6K
         J2kw==
X-Forwarded-Encrypted: i=1; AKwUvBxYfDeQBNLus+FS2sEhftisJPnX+Mzhetji8i1RVWo9YMSShjxEZMQ8J9qpma5hHIY4he1hgh/xYlwb@vger.kernel.org
X-Gm-Message-State: AFq9FYIIb0y6bL8kKR0ZCDSTA/+rVnUsDeuhOhRaZ5aBODwjC5YOBssQ
	OfjNrDS6ms7B6tROKr71aHkmPidhRUGmk1WfCSjWsq4skTvnstODGwnIUzzmNBJG8q4=
X-Gm-Gg: AYBFou0iLGBUis7DB9QFB0o05c6Rdwm9bxMCxEBZiNe3G7LO0ZWxzAMmw1HNxviOIm4
	J1Gi23+duHtc45N2VTe5DWm6Psmj1OCZoylKucXevgScvICfEG9P26Ytc22uTNwxJWwumW29pUK
	a1gOT34phFakKtAr5gJ2qysN470xXu1EmMrDLLJk0Oc0d6CfvdKmeVSdUx9kKr4dJma2xckEAcQ
	cYimRIHYEK3feqo8S0FHH0Q3EZbJjqEmtKiHwq9TPlZopeY7kDQimyy4+fvzXaRM7pJ4zKfTmBA
	CHiFZmh2sDIzescEC7OjMW4pIZf8G78VYWrQJKz1VC9c8CVXtV4Dr0VLgZ6PewXrBRvPYYD8JKn
	hYYkeajXXzayySSpHAa0LD1VhiJx61rXtwe/MVyENcWh0sVRUG1TkQbZ9i0qEEG0omig5MZMa5J
	dbb6N6uj8RQYekkOhnRh2cypW6vLOQMXoTtGoiL6TKDQhZee6a8GIDUA7AuzPYIsdWHW9HilrNf
	r6TbnFVAgrGBJM1SbYe5kP25nRmLZ2/hEonc+x0uVhs8AIkeGsFLr35fzQMGk/2LGtoAr7SByNw
	/9aU1X1eozfhreyFRg==
X-Received: by 2002:a05:622a:8b08:b0:535:d7e:dbe with SMTP id d75a77b69052e-53fcbee4226mr9184971cf.12.1793135390022;
        Tue, 27 Oct 2026 14:09:50 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.255])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53838cf2dbfsm88162341cf.2.2026.10.27.14.09.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 14:09:49 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 27 Oct 2026 21:09:29 +0000
Subject: [PATCH 03/10] xfs: set SB_I_OVL_USE_SYNC_FS
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
Message-Id: <20261027-b4-ovl-containerized-sync-v1-3-802e512379a6@toxicpanda.com>
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
X-Developer-Signature: v=1; a=openssh-sha256; t=1793135381; l=709;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=1Z5502S4N9+PxpDJ24MamzJyZyNagTbtfNLwpblShXA=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QDJutvjNlSBU/eOcQ9wQNaWwYhbQ0y1uFYtQSeQkyDonWymvy92FRNAyiqlerkJRJJxNhvaXRz7
 8R+gU7AP+DQw=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

All metadata is logged, xfs_fs_sync_fs() forces the log, and there is no
->write_inode().

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/xfs/xfs_super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 5a06132aa384..2f09d48b7e6f 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1924,7 +1924,7 @@ xfs_fs_fill_super(
 		sb->s_time_max = XFS_LEGACY_TIME_MAX;
 	}
 	trace_xfs_inode_timestamp_range(mp, sb->s_time_min, sb->s_time_max);
-	sb->s_iflags |= SB_I_CGROUPWB | SB_I_ALLOW_HSM;
+	sb->s_iflags |= SB_I_CGROUPWB | SB_I_ALLOW_HSM | SB_I_OVL_USE_SYNC_FS;
 
 	set_posix_acl_flag(sb);
 

-- 
2.55.0

