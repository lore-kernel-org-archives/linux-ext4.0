Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793585030;
	b=CaPb+FWjTHVMNx8UulRXXUT9U0wvXsIy34iZ+/pJK7u+y00nsRi1fA7EElVFNZLg2iVI
	 KCfAJBid8hxiwpH1VaIRNykX63DaHUNoTQH5KUWTw9RWuXcUxFykt6fXQwpmf4eBEcgd9
	 Xv8AwbROpjUgN2MM4Y0oO/82XGAEkEjwrArbF75tZ8svOplObJJciU4ou5FVOUXPdsm0e
	 Zsx2gwopdNKH2dGRyz+neMt9ZjBSlShc3BHUPwbBPdM71po3BMgnHy/zFQHJS3HBQRx60
	 GEVr2jDGRRKm/f0+X3T0cb1epFlFIMyMYBfeyLBnUdFRXOahB0m0A/o9jtcLWlTYdiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793585030;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:Subject:Date:
	 Message-Id:MIME-Version:Content-Type:Content-Transfer-Encoding:To:Cc:
	 X-Mailer;
	bh=TosNnawzDPsGc04sRZxwMHLtTq8rVKPb8WELyOmoWoo=;
	b=YgJVd+6owNj2pDPsEvEcB86ZgQmpIvWDm45aFyK1UdHXl/JJiR+CjYrp8cxjTr4aOCxD
	 RXRU/n60mwUOxd1+GksW7lk7TNwf4RXCnZ975nXjuEnI92KclflHYrFW7qMZkFIAab1H7
	 ggOyshSRCFhk5G4KAhsb1mmoxIKDvQtJlWEWbbUI1XQGdOXq9PB6h7bsWeCNKZlOfYcMX
	 lLdMOD2aObE9wMa1j1aHKrWPRh7kBZNj6gexnfX695j38IahQjNx8VsFnUBQMWj+khj2P
	 2WWgFQtAGAwnx/96KSXOAg4gMR8CwGwzh3cTQjfiAErfjmOmfcRB/GWpUjqZQD70ejw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PSv9GLFT;
	arc=none smtp.remote-ip=74.125.82.43
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C862A606A326
	for <linux-ext4@vger.kernel.org>; Mon,  2 Nov 2026 02:03:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C862A606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PSv9GLFT
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-1931ff67a29so4264574c88.1
        for <linux-ext4@vger.kernel.org>; Sun, 01 Nov 2026 18:03:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793585029; x=1794189829; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=TosNnawzDPsGc04sRZxwMHLtTq8rVKPb8WELyOmoWoo=;
        b=PSv9GLFT1ZtVRmQvaE8bj+A3wyLLxPoH46yd2oRCfsYLUQy92TkfTZEla9NBNBdF+M
         1O7oze+DNm8E7cTg6oaK1GfS7cR7D/b8QHDX7b1wX8rhX33zYYuxAJtu84EcVQl3C1ST
         vSCFJ36v5dtGxqXF1ykGfOnZG9OYnWyZNfH1pXi1n37PIG0c9VMk2o6UD5zEJwilpvBm
         hgFcD23ZMau0EBGgCtmSEdUVsqbnr/sWyaaDYT+Jqz/fdCMPZswi7jE/JNfgwRYTvlA7
         ahy6bw3qHLCF2HCD8Og28vQkvRXCrBYFT41ptNBrfct2H+RBhOOignDfuFTbNG0q2Sza
         G0yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793585029; x=1794189829;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=TosNnawzDPsGc04sRZxwMHLtTq8rVKPb8WELyOmoWoo=;
        b=p9LWt71r1553bpnCGa7PLh5F51S68jpUZyNF95yYnMdpPES/rGoLS1s9o4H192ZCIb
         1QeMrDo/JnSQod3yEfj60OksFejDjCaIsLkMzumwjeDKvxcdjIG0vfo9x0BHjUz1robA
         NGJaW/QnVAEC6XB5ZEo3T/BTb3SSVhL0qy8IdzFRkdisE0EQxZUj+uR+LwGaVOYAqV2E
         zQpYCo61tbHW/XMl7Lyj2jB29UxejXYrgFg1Uoku6eDjZSL2TuDAPzMwOylIrXqTSeFi
         Yx2pG99YdHM4ZxkJ7YNjsga9i0p70atG/4CxkLiWM9ylfLWpHrzCs0aIetpIRXTHKjBA
         zdcQ==
X-Gm-Message-State: AFq9FYKU5ApRVo9O/rxmgce7sd2X1clbKpspxIl55IOfifip2343vLPa
	CZKQVWOlBIANOdFGoqcw6K4wfurYsaJQWzdW5nYEBsAMwA2SWdUGeN09+ZP6ZIWV
X-Gm-Gg: AYBFou3LGJfH4/3JWQ8gQu9nabkFhlS3hrikKSLBLANSMC50kvVrpWrgo9ZXUaKeq1Y
	S94xvWZ8EcCYAwPiCuP94CrEebP+TQaXkiBLFQaUVxIwxKoyIipP9Bq9/hiWvGfzGotPUfA+exF
	Gw2jwsrob7sYDzMLtFikSWPKZOo1JB5TujT6oFS0hoREzje+cyrVAJKNti4m4s5kS6Gxr87Vs7h
	7AnI5V3OT8pWnLcCCK5s6iySKS8bRA5nZyVPUac1B3KrP7nW0/jFThy7FKFBu+I5axVbH9wgAbz
	N7oWZFkm12F+OSBElU6BtVrMUA/m+Aeobo8mXTrGN/KGf/a71TYf8ZheD6h/X6pN0VBzz5H0i1n
	qnITJN4w6tHhLmCWTLmDkQXKUVaIkO3pv+N95qpVh1KHj3vkDMWYr/vikRgb2gLSfzPc6Yr/E7S
	wigqSFnvTwNKjejzulvmx2UkvnRj55sI3jWoGaj67IaCASW87zixQk49xMgazXH1eYB0BKvQxnC
	GqsbkiCDJyxx/31gJ34nVRbq90wHNkh3/h+LaftbLWY6nPIZWkq/ehr9J3MIDzdeMY98BSynAqj
	HeXX0uqkBeSZTLdl6TWllzYU
X-Received: by 2002:a05:7022:1117:b0:195:49ee:94c7 with SMTP id a92af1059eb24-1ac5a0b579emr12094810c88.8.1793585028691;
        Sun, 01 Nov 2026 18:03:48 -0800 (PST)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac1b38ac58sm28456015c88.23.2026.11.01.18.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 18:03:48 -0800 (PST)
From: Qiliang Yuan <odys.yuan@gmail.com>
Subject: [PATCH RESEND v4 0/2] ext4: fix shrinker scan budget accounting,
 plus a related cleanup
Date: Sun, 01 Nov 2026 21:03:43 -0500
Message-Id: <20261101-fix-ext4-es-scan-nr-scanned-v4-0-1290a288f5ea@gmail.com>
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
To: Theodore Ts'o <tytso@mit.edu>, 
 Andreas Dilger <adilger.kernel@dilger.ca>, 
 Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
 Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Zhang Yi <yi.zhang@huawei.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Qiliang Yuan <odys.yuan@gmail.com>, stable@vger.kernel.org
X-Mailer: b4 0.13.0

This reverts the v3 simplification of the ext4_es_scan() shrinker
scan-budget fix, keeping the unrelated locked_ei cleanup from v3.

Patch 1 keys SHRINK_STOP off nr_scanned (extents actually examined)
again instead of nr_shrunk (extents actually freed). Jan Kara pointed
out that a batch finding every extent still referenced and freeing
none of it is still real, useful aging progress, not "nothing left to
reclaim"; Sashiko AI review independently flagged the same issue.
This restores Jan Kara's v1 Reviewed-by: the diff in ext4_es_scan()
and __es_shrink() is unchanged from what he reviewed there (only the
explanatory comment reads differently).

Patch 2 is unchanged from v3: it removes __es_shrink()'s locked_ei
parameter, which Zhang Yi noted is dead since its sole caller always
passes NULL. It keeps Jan Kara's Reviewed-by from v3, which still
applies unchanged.

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
V3 -> V4:
- Revert the v3 simplification in patch 1: key SHRINK_STOP off
  nr_scanned (extents actually examined) again, not nr_shrunk
  (extents actually freed). Jan Kara rejected v3 on exactly this
  point; Sashiko AI review independently flagged the same issue.
  Restore Jan Kara's v1 Reviewed-by on patch 1, since the diff is
  unchanged from what he reviewed there. Patch 2 is untouched by
  this revert and keeps Jan Kara's Reviewed-by from v3.
- Re-measure patch 1's test data against the reverted fix
  (239 -> 1 calls with nr_scanned == 0, vs v3's 238 -> 1 with
  nr_shrunk == 0).

V2 -> V3:
- Drop the sc->nr_scanned computation entirely; just return
  SHRINK_STOP when __es_shrink() frees nothing (Zhang Yi, Sashiko AI
  review).
- Add patch 2/2: remove the now-dead locked_ei parameter (Zhang Yi).
- Add a Fixes: tag for the commit that split count_objects()/
  scan_objects() apart, and Cc: stable, matching the equivalent jbd2
  fix.
- Re-measure test data against the simplified fix (429 -> 238 calls).

V1 -> V2:
- Correct the comment and commit message: nr_scanned == 0 is not
  only reachable when sbi->s_es_list is genuinely empty, also when
  every inode walked was skipped or had nothing currently
  shrinkable. No code or test data changes.

v3: https://lore.kernel.org/r/20260930-fix-ext4-es-scan-nr-scanned-v3-0-9aef0be87d21@gmail.com
v2: https://lore.kernel.org/r/20260929-fix-ext4-es-scan-nr-scanned-v2-1-f4e8f6f6b8b1@gmail.com
v1: https://lore.kernel.org/r/20260928-fix-ext4-es-scan-nr-scanned-v1-1-91d88228b0c8@gmail.com

---
Qiliang Yuan (2):
      ext4: fix shrinker scan budget accounting in ext4_es_scan()
      ext4: remove unused locked_ei parameter from __es_shrink()

 fs/ext4/extents_status.c | 37 +++++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 8 deletions(-)
---
base-commit: 502d801f0ab03e4f32f9a33d203154ce84887921
change-id: 20260928-fix-ext4-es-scan-nr-scanned-5af70744f6cd

Best regards,
-- 
Qiliang Yuan <odys.yuan@gmail.com>

