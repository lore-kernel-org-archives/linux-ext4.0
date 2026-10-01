Received: from mail-dy2-f43.google.com (mail-dy2-f43.google.com [74.125.229.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C230385D9D
	for <linux-ext4@vger.kernel.org>; Thu,  1 Oct 2026 07:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790840645; cv=none; b=rzr+MRnwqUoGeX4Bx7MIWfm0mzPdN8/btnGAwM+XGofldaSqJsLOZJoQ9C1XDJyJjl2JzAB95EVpG++OHBl3DMKCYFe87DGFDBNnbOteeMql7kkKPWoy/EGkdLozbd+DGbqYFK02N8KCuRvH1bCEIefaUDAZcv8gg4r9iv4akkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790840645; c=relaxed/simple;
	bh=2SCttNKC7O3FocUJg55oliDoHnVOooTYv/JgB5ERAK0=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=oBVEEjNaz/RZrThw33cwdre3HSX/LOXCfTYDt3XZJdRNSVE820Ez818ed9HbnbVo7Q9U9NW+OZj0pCz6kyXrjtCMhygW6Iz88zDwHCxM1DwT1MmRd6ANEIOQXRyS5F/6xbvWmake8C8HjZCCXOoZDnlqENZmkxvLZbpHHF8EsZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=piWRvOCT; arc=none smtp.client-ip=74.125.229.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="piWRvOCT"
Received: by mail-dy2-f43.google.com with SMTP id 5a478bee46e88-34b1743e9c7so1359147eec.3
        for <linux-ext4@vger.kernel.org>; Thu, 01 Oct 2026 00:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790840642; x=1791445442; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=TosNnawzDPsGc04sRZxwMHLtTq8rVKPb8WELyOmoWoo=;
        b=piWRvOCTZZ491WIHNpH8O47ceKcSSgSfywiq7uVO/f4pN/16Xgp0uisx8q9PDSjMxB
         zbBIhIP7ARs4028g19YDlmdexrIcC2qz7t+Nv5WiMDhVBfYl+SMnjo4cEcSODzIiKeoM
         UXHvRMDB1nPRIYbaMAQEMfatNrVwS97HZ1LHyBqBED2t1R2Jkdt09RRq5FjK5fp9iRtE
         r8kIlmVhMOOgBbQxMQVnOmSiC7YZwiLeS+1dps5z9h/M+lZ2U8OW6fCSD4IpamOq2CWx
         LmXdWut8kcvZ8NCL4qqrAdiWygBtb42j8G+wSAzHBXTho3a8FpWdU8XKmG2Xy7nxtHdG
         xMUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790840642; x=1791445442;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=TosNnawzDPsGc04sRZxwMHLtTq8rVKPb8WELyOmoWoo=;
        b=ftjVETI2vYtEBe1aO679Az1SnHirFc1V4A2yA7k4Gwu/37FqqsebquvIkIH1fVTMtL
         d5YW6tE/zdxebJo0TtyoMJAU46zG15IYFxnSTurKJ5IjpWaKmit38EN1xB9zp1nPv75T
         6YkfLvisB6ZlPK3OMKqne67Tv8Mt97EMi6WPT4acUFQUQ+N2mtqOBFJv4oMfCX3zD9VF
         nqCCG4R1G6ywMD4q3KeoOolj6nxKmj6sDhxmMq6b1mtMBoHE7mBqtJmv/H9uxrK39iuS
         iyludbrYk7zCPCRhgimmE9yjXZWN41v610kiv8KfhNqUHy5r519b4e64hyiCyEzTpxoo
         QPCQ==
X-Gm-Message-State: AFq9FYKDrF2g0QjZNBRFMGxdFeUK3xN0KKypPiU9FgCBe8omrMJCfJC/
	ubg8qIYy+HIaVuyYe9ZOUDKKGo1h4/Mb1enR3RAaEXGKTmJ+IjbROLa+
X-Gm-Gg: AYBFou1fsKDppmtLfLQv1lrhKcOueS0SzU3AmKWYOWCgLJnSWAHMbL7Xl//uj+i6pbG
	RKqZu4GeCFM78p9d8HeBLn7AAOTruYKQH1PfMiOs0pCzDtG9IJVjmYSOTi0UeGeTh+GzBl3HdzD
	iHOWU07sNeN4o5kCCvr+GsoFkc9o02L9/d6IYx3/Sa+rZWDzPqVS/OdOvfZPtOUyeyiQ++sJAwC
	D9Gpdk44/8RzgALMdoY2QtyKGQAglBZTZBKj1FJkx1aEpwGqe+fYQBYD37FytOh4TjsXvuxrjuM
	fa5kJqqNphpWl37m7axTsv2C+IzdTZpj40+yV2f0X+LDI2ydA67DhAEmNpBP8BVBOcJPCvO01Dv
	vvMLgryfDXZkcpgp8vwEB0gKdkEqrabg5nUBtz6y5uSGVXRWIF4t6vagjkO9pnCtD8B3nkKzbNb
	u5BG0hakPeRXwmHKvkMh7cpQjM/dwXMEKlWvNecFg62rwSqVuLkRRjAzfzAjOBOqOS2g==
X-Received: by 2002:a05:693c:87d6:20b0:34c:6942:8a47 with SMTP id 5a478bee46e88-34cdb8e6084mr3928132eec.8.1790840642073;
        Thu, 01 Oct 2026 00:44:02 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34db3e33b73sm4876955eec.18.2026.10.01.00.43.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 00:44:01 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Subject: [PATCH v4 0/2] ext4: fix shrinker scan budget accounting, plus a
 related cleanup
Date: Thu, 01 Oct 2026 15:43:55 +0800
Message-Id: <20261001-fix-ext4-es-scan-nr-scanned-v4-0-b13703714ce2@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADsPvmoC/43NwQ6DIAyA4VcxnNcFkCnutPdYdkAoSjJxAWNcj
 O8+9OR2MDs1f9N8nUnE4DCSazaTgKOLrvcpxCkjulW+QXAmNeGUF7TiEqybAKdBAEaIWnnwYZs
 eDVyULWkphC20IUl4BUznm35/pG5dHPrw3p6NbN3+544MGFTMSMm5rKmWt6ZT7nnWfUdWd+R7q
 zq2eLKsQGkLW9SyZr9WvrNyemzlQKFSaGmNsjT8y1qW5QO8EU6bXgEAAA==
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

