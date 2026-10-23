Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792736336;
	b=er81JFUws9wZGQzj3D2N/toQ4Mn0ZgEeROcx/uqiTWOPj8fSRc5LJOyu26h4K9AOPKQq
	 gFw+leaw3evfAKbi2Xxl5EsnuAuHVsDC2CxRNZpwje0rcXZUOvC7uSn/2H9fOHjMpWCVe
	 qdsLz2vkjHv5sDquso07ZohW7FFms2q+Y8boCTFjsexuJUm4n0pdwxRMa3aNfoqPHJeHK
	 SMv97lKrkmxt7SA82QD30U5YUCAfu9fmdYu9KIj5i8RqRQSfZdYSJvKQA/SS9kut/Mfl1
	 Dos8trZv/DXuvhPwvc4BCAMQ+AChZsmMrr9J6xEMJiyf07L5vxTuEr8OiNmc5QUfcUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792736336;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=wjkgT8QsAT2N6SrSFKW1W65LY1NUOxe8FlZzHCYOc1M=;
	b=PJWqRZNWiOkZTeyLxSc2UJb2yjZkaAIaDZYd/v4N2lMbm9WgxgbB1uRba61YVNAVUuyS
	 jffi7pE3kAWbAaqY/X84U8gKEtdDHiZeEaUSbp+cPcAWAG6oX1nwQTORXqnQzogGChOJt
	 UjA/JPxlv0/EoGQ2PqRqS2wTTqRmHuI3DEiWqgX551Pmn9sRxAXIEexQDZgrTICCl0Mzw
	 sVlO+bvIsOg1QLNRjfHbRpzl5IMolqr6ggCoiT8QPnVeZr7HqUtTIN0jmfjqG60UoJWZA
	 geEZwyewhRJPxjQeSV+BGV2I2Rpr5bJhSorGB4lzt254noNCDaY8+1TcanaNcCR0w/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b="kZUr/BUq";
	arc=none smtp.remote-ip=209.85.214.179
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFFA8606A31A
	for <linux-ext4@vger.kernel.org>; Fri, 23 Oct 2026 06:18:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EFFA8606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=kZUr/BUq
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2dd76b1361dso2451145ad.1
        for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2026 23:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1792736335; x=1793341135; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wjkgT8QsAT2N6SrSFKW1W65LY1NUOxe8FlZzHCYOc1M=;
        b=kZUr/BUq7WAZJxXXXIjbVqsM4TzhC1A6D/qQ7lvCBHUohJBwqsU8IG5zhAqNZSFAOw
         eHwXWKhToUSNYfgiebk1pJs+QcwbW3OnDznLZAlu118d3GLtDuCdkdNWM7p9FmF1hWTQ
         bI7tismOI2FLT8LjOp9pWlX62HQ9tqcY+DOST4XhklgH7cv45CKPXo/x3gnOOTddwjdM
         gUbxGcf2cajh4r4lNzxBQfau/eqUJN8xEDnYhtXcv1Iie7bahkQUODPrTfShes3GJv84
         Pf/AeIcMUbQLF2RlY1yENhphkP5c1a0iXHkirP5E01bKu+0WV9rBlF1ouqVLohYgpCIj
         O5rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792736335; x=1793341135;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wjkgT8QsAT2N6SrSFKW1W65LY1NUOxe8FlZzHCYOc1M=;
        b=Cv7yqui/RS+sOW+W75AFjbNSRciTS7nVyZSe+7X7H+NMNm3HcMD5v+OBZ6Ptcn/Wli
         85lBNZfS6ivLtyRA4ealaZwIuUnUjw9zzxepocgEjSZ55be4qBR+VQHY2TBbF20njOUV
         rDcOUEhR2S9Qe4kHUEQcgrbimuL3YEke2sjhGcILlKFePk04xJaIUnPiDfxTPjIup9HU
         FGOibzP3MI0AMzqDVqfClsvB7grGdnhqf7u+FSMR5hVmT3NBCpT1VVE/cHzHmvBsi5pt
         TcaehHLH5NwRzsP+kE2tIpGqUVkuzO8bCIihkCEGYH2RSMew/DyzC+ZrLfOvt3yB8fGg
         NtkA==
X-Gm-Message-State: AFq9FYIslZAwmTc8fcjlavRy7Slv65L7OCorEfqx26d2XvCtqHEV4DrF
	xuoMdMCIjSt9nge2Y4xIAzEwYZogbVZhzy0Qi2SwrOeerO+xWPf4Qw5Y7jreCZmVZB/Auk4Flv1
	glq1qxmo=
X-Gm-Gg: AYBFou2ZxeK9/dXafLc7PDa5Vkdrbp9NwVV7PHpc0s+58qTXhNfZoW6qxhG8aaa4RWb
	TF7eIGJyaLQ16U0YoOJoQmN+QiLCohh/CuH8FraZfbO8wzDZs2TQ02hG0hZVLFxGugHEjDXmjVU
	z1y8QDn+xx06RVamJCDqfc+8b2rOs6nV1yz7omixFy+1zlXyTlYZM3Ro5s5xaadc11A8kQjJwG+
	O7E8dcKtYMY7CEtGxd0HIO4V9/ZyCK0eIHGLDH4l25WShXfazxOi62PmOg0TTvW+7EMKYVN+Yks
	rmrR6dCMMODc596yVMs+esVVI31XymwKaigq07vQjWqjnsayuc9Ec9bClJhjoxD/jCARVpL+eAW
	9QTDMQrcGkU1JHHqqzfzf0nyODPIHzGfSDH/GCOq72beXK+jwjVZc2xLmBC8th7uO7fI4kBzTuM
	nJ8kLVPmgDEcY7Lc+S2+n0B93nSgrGQTPBv7c/zyJsLyzN+fQGuDmfAtrm3ScP+xPY/uQ2RGS/U
	L5OtIgZgKG/7it7YBp0lipeur1onUmiDuE68vENDHpTQNFEseVLrgZkP9Y=
X-Received: by 2002:a17:90b:3b44:b0:3ac:c005:cf07 with SMTP id 98e67ed59e1d1-3adce08329dmr1089701a91.42.1792736335058;
        Thu, 22 Oct 2026 23:18:55 -0700 (PDT)
Received: from localhost ([106.38.226.27])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ada48ed719sm7440105a91.5.2026.10.22.23.18.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 23:18:54 -0700 (PDT)
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
Subject: [PATCH v2 0/6] ext4: fix buffered writeback error handling
Date: Fri, 23 Oct 2026 14:18:45 +0800
Message-Id: <20261023061851.45579-1-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
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

This series fixes error handling in ext4 buffered writeback. It prevents
stale data exposure when mapping or io_end_vec allocation fails, reports
unwritten conversion errors to fsync(), and preserves concurrent io_end
flag updates.

The patches are arranged as follows:

1. Move extent mapping error handling out of the loop, without changing
   behavior, so the following fixes can share the partial-folio path.
2. Submit mapped buffers when allocation of the next io_end_vec fails.
   Otherwise, their ranges remain eligible for unwritten conversion even
   though their data was never submitted.
3. Submit mapped buffers when mapping a later extent in the same folio
   fails with a fatal error, and discard buffers still needing mapping.
4. Drop the folio lookup reference if partial-writeback validation fails.
5. Prevent silent data loss by reporting unwritten extent conversion
   failures through fsync(), instead of returning success while direct
   reads still return zeros.
6. Use atomic bitops for io_end flags so failed-bio completion and
   writeback cannot overwrite each other's updates.

Sashiko helped identify these issues.

Changes since v1:
- Rebase onto the ext4 dev branch.
- Call mapping_set_error() on fatal mapping errors in patch 3.

Julian Sun (6):
  ext4: move extent mapping error handling out of the loop
  ext4: submit mapped buffers when io_end_vec allocation fails
  ext4: prevent stale data exposure after fatal mapping errors
  ext4: put folio on partial writeback validation failure
  ext4: report unwritten extent conversion errors to fsync
  ext4: use atomic bitops for io_end flags

 fs/ext4/ext4.h    |  16 ++--
 fs/ext4/inode.c   | 189 +++++++++++++++++++++++++++++++---------------
 fs/ext4/page-io.c |  24 +++---
 3 files changed, 149 insertions(+), 80 deletions(-)

base-commit: 8c4f6e3376348fc3162eed86a05b933921c8f9ed
-- 
2.39.5

