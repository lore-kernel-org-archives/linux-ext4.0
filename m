Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54AF36B055
	for <linux-ext4@vger.kernel.org>; Fri, 17 Apr 2026 21:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776461859; cv=none; b=kMrUsiM0lgNv4z7HhV5n+r0te6QwKab19XNwONKGmHlu5LpgrblCwKfvGaiDJhTnjd8ZTq/N5VnvbwAzdym2uRfoZ1jLVv75r3DnZGSEd81KKMq47F3AoJJIbg5VqFofwvBXpA+0vgPCk1SWN1v3gaQfJ/whdha/SqhgXFWfeEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776461859; c=relaxed/simple;
	bh=szVce4wQS2Tus8893iUOEGqqdB942CWC7lstPcqiC68=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ATtoEgWz1PxBrimXVbtBiC1X2V2pmm/VIYfkYPEOmBUo947enE6cE/W1gghG7yrS2SOXhcyai2W6h7/EStVWhJ/otQLQi12iAPO/8bNxkKfpHdhTRqvNUJ5LlWiOXUCSy1M//PnEyY455UbjOTPn6U0OmCkWPQXLhH7aLTVr9K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J/JKW0qI; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J/JKW0qI"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-483487335c2so10641295e9.2
        for <linux-ext4@vger.kernel.org>; Fri, 17 Apr 2026 14:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776461856; x=1777066656; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/aw+GnZfBjiNbqAft/y6b0x9R0OvQnjTvEPgGvyPO/k=;
        b=J/JKW0qIZb1rQZbjcTzMh0WVbowlSoutKkxHI79SqLIUJegyat7PaNpTSV0hq8xkny
         YqDdZxq9J7y7v3MBtOpgwdWFwWCQL9KdmCOPym96rOnz8hm8VTpaS6x8bJcoJML6bq20
         QqZz2HDkRACef/Zg1Fpk0SVOQW0LShsUvGUpovh15hClC9zWdwA0bZRqhy1sYlcAlG/Z
         h7kObTg8GtecpMF6sAZ0BjlranPyZ4FzvErtDiH47T3WUHdTJ10LyPD/7L+vCalKXr3o
         S8Qi1m8hOsVn0LDgPyPh60jLO13al9lflejJ13y9ZYW2LoFQTEs/xYBF1jirlV22Z81Y
         FxQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776461856; x=1777066656;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/aw+GnZfBjiNbqAft/y6b0x9R0OvQnjTvEPgGvyPO/k=;
        b=qCQpBQilOh8LBkZxmD6hl26hCWE2tHBDDKaO9CQutvfreUCPAcSeMHDnivQ3SeM3GA
         NCf2sa7dt9eAsaxmWOXosbA+mlhmrpWLdgjseGyYN6n5rfZd7YG+sT13W0hj4D1gSpIk
         O1DnpPU+I4FHF8RhnJj6CqTenEk6RGnxQZQvlfvmRWzJF/D26hbRpj2OymCduwLmsOy3
         Mv/zy2bQBVR6Hdf5rSWdd3VaNkO2WQLWrVJkwMc+GL/Xk3apPtImoC5n5rMItxE7pvd+
         WdwvPoB//9tslSBZJ5Q0uCQLhcogmyQ2OKy+JhezSc34ke8srkMqIZeXIfJ4Tm9pMbNz
         u0MQ==
X-Gm-Message-State: AOJu0YzWcOcXFr3csW4G0C9v3dAEUXaZgkKJKo5ryfWCkgArV0FLY078
	4n+bnEW3nfRyYygHumsBy04gRe1pnVfrF0pOSQOBxvlVjmS61uTd6UST4mwX7Q==
X-Gm-Gg: AeBDieuMkU1Pn80ZDvhCLCkUInEAq9tNpGEjTbhekh1FS8uklzPGCZrY5fBjRvN+nLg
	/tXcEDSiNRjD/TB+X1Mzm4fPp8S3B/HG8Fwfx6YZ/AGfE0duARr7Eyk1wfWuTEfaJZihmAMLnxK
	X+b36L89DpBaGXhwvQUwDOcxKvHY2OjwQU/K+uYGfvbNevOcp8xDoJNPNqmyZRn6TADztJfP78S
	ep3hYlM0RX3Sj+ip4NLfZI10DtqOwNFblNsttJ7M9Ho8h4L+8wcSPBLyNCpAr/MDuVgUh8AX6Qa
	SN5zUApLAWBPIOmO1IZdi9cMcoc/RIx/dTb5YmKuC33+jTDI0uCHRSvTmAZf2rc8suTwjPv8TwO
	s6IGZUpqNAWclipgrCj0XRUSig4cEuGWwHW0kxhaJd0fyASWsZGjgG7181pEqaxreLnWY7OYsmj
	1gffzriCdAfL5AFCya4N9Z+tVUE64NF1o56zj786ZF76RF3F8HaAHqPhnXhP0Whwcmp+Z5cftlv
	nglW97taAI7
X-Received: by 2002:a05:600c:a416:b0:483:8062:b2f with SMTP id 5b1f17b1804b1-488fb73b31dmr52074235e9.6.1776461855857;
        Fri, 17 Apr 2026 14:37:35 -0700 (PDT)
Received: from localhost.localdomain ([2a00:23c7:90c1:9201:f5b4:1568:453c:b849])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fb762f56sm25725645e9.15.2026.04.17.14.37.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2026 14:37:35 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH 0/3] Data in direntry (dirdata) feature
Date: Fri, 17 Apr 2026 22:37:17 +0100
Message-ID: <20260417213723.74204-1-artem.blagodarenko@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

EXT4 currently stores a hash in the directory entry
(dirent) immediately after the file name to support
simultaneous fscrypt and casefold functionality.

It has been discussed within the EXT4 community that
this hash could instead be stored in dirdata. This
would make it the second (or third, in the case of
64-bit inode counts) user of dirdata.

At the same time, the existing format—where the hash
is placed after the file name—must continue to be
supported. With these patches, EXT4 can handle the
hash in both formats.

The first user of this feature, LUFID, has been
tested in the Lustre filesystem backend (LDISKFS)
[1].

Support for fscrypt and case-insensitive directories
with dirdata enabled has been verified using a
dedicated xfstest submitted to the EXT4 community as
a separate patch.

e2fsprogs support is provided in a separate patch.

[1] https://review.whamcloud.com/c/fs/lustre-release/+/64439

Artem Blagodarenko (3):
  ext4: make dirdata work with metadata_csum
  ext4: add dirdata support structures and helpers
  ext4: dirdata feature

 fs/ext4/dir.c    |   9 +-
 fs/ext4/ext4.h   | 169 +++++++++++++++++++--
 fs/ext4/inline.c |  22 +--
 fs/ext4/namei.c  | 379 ++++++++++++++++++++++++++++++-----------------
 fs/ext4/super.c  |   4 +-
 fs/ext4/sysfs.c  |   2 +
 6 files changed, 422 insertions(+), 163 deletions(-)

-- 
2.43.5

