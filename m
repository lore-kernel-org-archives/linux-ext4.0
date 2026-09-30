Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 260EB33F8B4;
	Wed, 30 Sep 2026 13:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790775983; cv=none; b=RTvX+oVbOQtNLxstVWTueYM52azwQOzu6FgM1ul3wSNAzHnhj0vgb0p9cJI4+EjHfndc2UWAksel7bfpWO60kxA/Tr4K4p+yThXk9MvrBzn8exnVuSLeMUuLabqvxlL61bQdQL5zkLSZGIcCgPLzpOVio1swA+kidiBwwRBf/PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790775983; c=relaxed/simple;
	bh=epNHelTZVSZSvs2fPNH8I4eO5i5YMSV+CgRGIDkbEn8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GQBjkOXzZYB7IXfPf1d9p+gRJMy4XxzLP/tiMOJlfa80R+eXAUOBJmmsV5TsdcxzCBzqgh+HMUJjGq/hHo5kA0Lhj0QV8YyhrkpQrvk/kMgqFZJ5cqGE4b7PMEET04VhSGw/LqZwr8disAI0b3HZY51AUjD2DF1jYzO6+B0nGJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr; spf=pass smtp.mailfrom=oss.cyber.gouv.fr; dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b=Q3X1NAyR; arc=none smtp.client-ip=51.159.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b="Q3X1NAyR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:Sender:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References;
	bh=8FZpJW8azcIqyAgDEfkF38jSbt45RdWYeoaHY3qpYak=; b=Q3X1NAyRPu/xGn3ZzBGxYOiJCS
	JQrFeG3G+CjytKqh3snA120Bu+4Gt8MN3pOMt2Uk4D/Ua2n/UHi7jU6CCJz6CpVU73R/OMgCWJqM3
	kuSxkw+DLO0znS9ay2f2OzIldah2ViLf9NEY3vG/BQ0Jnvp60CeKP3yX0Y7XoJB883NP8MNQ237+7
	p4eO4ium648eP5PfzZCdZ7hzl4J24iece3Z/XcanLJT4g1Ns7jqCBB0eVVed3EgDGSuAQYoML0Yca
	SsNmIR74knvRhNAjKo8ABlGsZsXSyw47llbj1P/+5ER6tQD18rptIGyLYbtGWHo0/X+C0KUhPRbYt
	J6M+o8FQ==;
Received: from [151.115.150.205] (port=43012 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.100.1)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1xBudQ-00000004L9e-2Ic9;
	Wed, 30 Sep 2026 15:46:10 +0200
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: tytso@mit.edu
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	ritesh.list@gmail.com,
	Zhang Yi <yi.zhang@huawei.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	stable@kernel.org
Subject: [PATCH] ext4: save converted extent before merging
Date: Wed, 30 Sep 2026 13:45:17 +0000
Message-ID: <20260930134516.397754-2-Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 

In ext4_split_convert_extents(), merging can release the leaf holding
the extent pointed to by ex. The later extent status cache update can
then dereference freed memory, causing a use-after-free. KASAN reports:

  BUG: KASAN: use-after-free in ext4_split_convert_extents.constprop.0+0xb98/0xc80
  Read of size 2 at addr ff11000002547034 by task fixture/65

Save the converted extent before merging and use the copy for the cache
update. This also avoids using the old extent slot after a merge with
the left neighbour.

Fixes: 716b9c23b862 ("ext4: refactor split and convert extents")
Cc: stable@kernel.org
Assisted-by: LLM
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
---
 fs/ext4/extents.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 76038b6..f5a3880 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3830,6 +3830,7 @@ static struct ext4_ext_path *ext4_split_convert_extents(handle_t *handle,
 	ext4_lblk_t eof_block;
 	ext4_lblk_t ee_block;
 	struct ext4_extent *ex;
+	struct ext4_extent converted_ex;
 	unsigned int ee_len;
 	int split_flag = 0, depth, err = 0;
 	bool did_zeroout = false;
@@ -3887,6 +3888,9 @@ convert:
 		else if (flags & EXT4_GET_BLOCKS_CONVERT_UNWRITTEN)
 			ext4_ext_mark_unwritten(ex);
 
+		/* Merging can move ex or release the leaf containing it. */
+		converted_ex = *ex;
+
 		if (!(flags & EXT4_GET_BLOCKS_SPLIT_NOMERGE))
 		       /*
 			* note: ext4_ext_correct_indexes() isn't needed here because
@@ -3897,6 +3901,7 @@ convert:
 		err = ext4_ext_dirty(handle, inode, path + depth);
 		if (err)
 			goto err;
+		ex = &converted_ex;
 	}
 
 	/* Lets update the extent status tree after conversion */
-- 
2.47.3

