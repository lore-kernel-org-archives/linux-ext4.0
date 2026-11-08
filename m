Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=51.159.188.251
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794170665;
	b=1OxOuOSGstDEFoB+RjP+WrsJkCy6qmCQPwDeAU+4ssULuKd1cdZJLsacH99L2ilUjXDb
	 52hjOYrTrpT5Zb2CbgGG26PRaHisienWx+c+0unD+eP4JPMSDz2fdXhschNiu4CuJ6l/t
	 Y0u2lgkWlnYPqQyoCOoJap6cqoHJzk9WwLNG5o+Kd2m6IYmxyBHMMV2mlyjpMXk8fUIRM
	 AP+HY0lA+eeZQuKwqqlFwq2l4Xfu5g0ZVsPq6eJEfeCu/KlZoW8U7v+wkRvANfRDr88xx
	 rWkvJAdE9BxneXR+AZEpyQavVmC5tHHGOtCQ1KwKllj6/LbTuqK6puqqovTg08vH+ZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794170665;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-AntiAbuse:X-AntiAbuse:X-AntiAbuse:
	 X-AntiAbuse:X-AntiAbuse:X-Get-Message-Sender-Via:
	 X-Authenticated-Sender:X-Source:X-Source-Args:X-Source-Dir;
	bh=7Og0qpzuv0jL9nFblkNVAz1so7z7Y134hJP1ntQYMkQ=;
	b=iwPq3eZyieScBrSNiJzpNJvYhCTcclR8ENG298iQkBI6r1mv0/gNEmurwjufCVn2+pSM
	 5HLQjp//m8wi4nr/Bs+S7o91e+oMfH61VaqTfS+zoufBI8spuVMCRi++C6WsRWUg+UYlP
	 qHw/VNq9bDd6d9uUfhmnlMjRRVklwmHhm7YekrYavSpahjTgsg1NacgfQ9/DEGVxpG/aH
	 jk0T+RDQK/x2hI4IPY2uY34s0TgKuYm8AozlbYdfsggK8SEOfz9piBBKsdbjozGGNllCG
	 e//1hUMIF5hUS2cyzKIlXoFhn/5f0zrJrA69/2PzIK+NS4RJ/tAIQojCcuFlhbyAJIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.cyber.gouv.fr;
	spf=pass smtp.mailfrom=oss.cyber.gouv.fr;
	dkim=pass header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.a=rsa-sha256 header.s=default header.b=b+m9tKYS;
	arc=none smtp.remote-ip=51.159.188.251
Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70632606A31C;
	Sun,  8 Nov 2026 20:44:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 70632606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.a=rsa-sha256 header.s=default header.b=b+m9tKYS
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:Sender:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References;
	bh=7Og0qpzuv0jL9nFblkNVAz1so7z7Y134hJP1ntQYMkQ=; b=b+m9tKYSHsNWN7SQ7uZFSE2d8y
	Y+YDvFjijmJi15NMQbFLPqrv9t12eU4YandW2AAcUtUX4W0olFQWqGsbykGhmt5EfWYln4qckpsqj
	wETOn2m93YBNHynge8/lN0S9Gf0xCHH6aFh4tRyjFQqUHDfuq7YOJXyD+qTvEwnQK/OGJSBGp2oWY
	gfui0pOSsQMNjyU5wpBOU3znwcgBLefCUVwuP+PbFTsw8dq20cN8GzQqCkqGurwxJuMAnxrnWuqaa
	t7di5U+O7eQk8jAiEiCeamXlauwHFwD9TaU42qXd/sL/Q5XsSQeCY7JTNfPa8chVXpreMxep92Les
	orA9FCbA==;
Received: from [151.115.150.205] (port=46942 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.100.1)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1xQ9kU-00000001qXt-1HpG;
	Sun, 08 Nov 2026 21:44:22 +0100
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: tytso@mit.edu
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	stable@vger.kernel.org
Subject: [PATCH] ext4: fix OOB write in fast-commit replay
Date: Sun,  8 Nov 2026 20:43:46 +0000
Message-ID: <20261108204345.1423203-2-Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
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

Fast-commit recovery checks record bounds and lengths during scan.
Replay reads the records again without these checks. A corrupt filesystem
can make an earlier replay operation overwrite a later record. Its new
length can make ext4_fc_replay_inode() copy past the end of an inode buffer.
The OOB write can trigger KASAN, which reports it as a UAF:

  BUG: KASAN: slab-use-after-free in ext4_fc_replay+0x1725/0x2de0
  Write of size 200 at addr ffff888008598f64 by task busybox/62
  Call Trace:
   __asan_memcpy+0x3c/0x60
   ext4_fc_replay+0x1725/0x2de0
   do_one_pass+0x113c/0x2370
   jbd2_journal_recover+0x528/0x7e0
   jbd2_journal_load+0x7c/0x810
   ext4_fill_super+0xaa54/0xc270

Check record bounds and lengths again before replaying each record.

Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
Cc: stable@vger.kernel.org
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
---
 fs/ext4/fast_commit.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 0cac890..9edd26a 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -2613,6 +2613,11 @@ static int ext4_fc_replay(journal_t *journal, struct buffer_head *bh,
 			ext4_fc_set_bitmaps_and_counters(sb);
 			break;
 		}
+		if (tl.fc_len > end - val ||
+		    !ext4_fc_value_len_isvalid(sbi, tl.fc_tag, tl.fc_len)) {
+			ret = -EFSCORRUPTED;
+			break;
+		}
 
 		ext4_debug("Replay phase, tag:%s\n", tag2str(tl.fc_tag));
 		state->fc_replay_num_tags--;
-- 
2.47.3

