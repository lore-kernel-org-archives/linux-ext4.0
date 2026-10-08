Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 054BB3CB567
	for <linux-ext4@vger.kernel.org>; Thu,  8 Oct 2026 19:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791487255; cv=none; b=A3QtVeaJj78cK856udONCSiizLqe5jRmDPnM4IgPyHzPDQOpVtevExGY3J/3Qu6X18MpEE865Ap8RdXh1Ept3oOyVQTK/N5LghpQbySwucFifEM53R5cBYLTA+/7h9F97ruMXXZhMIvcUk17GOIfGTCUXXwRCDY81qm4X5ZaFXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791487255; c=relaxed/simple;
	bh=fyyWB8kFM8yS/sTHX0FEktjdZHa2MY6B79uzjhYFx34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sj2NSAhou6vhkskRuLh5IN696MG6/CLaN8Kmh+Bj9nC2MijR4VTKA+Nl0Iq1X+yt3xIYxcseTEiQz9dEz0QScm0U/NJFaajdG7MNj5+nsKkoMKuAhDKYT5I3/fnz0UlZTyW4kgL0cwAvTSWjH9IaTBFSRA+SexZ6QjXzhaPP86k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=TN9me1t1; arc=none smtp.client-ip=74.125.82.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="TN9me1t1"
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-30b6dad2382so7798913eec.0
        for <linux-ext4@vger.kernel.org>; Thu, 08 Oct 2026 12:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1791487253; x=1792092053; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=auJr1ryaFMZM/c/xY8k4emAnc/zPgD5/4eqsxgMghaI=;
        b=TN9me1t1qFKcXRB3KH8/j2XFMzejMhSFQxpt3bbiK79fgxV2idBuvwElOaJ9cw4ivP
         a3N2+15TlIglpdv06cgYtO/ABQUC6QQFd2JHqotYeFFKj+w/ehBGByhvfhfsDxV8jFP/
         gLKPJVNNnA33HFzb1wm5asIRYHE+nLLySUkuOrBcLqSgz4xCu+YfICOSa3q2FG1CZ4kE
         /VR6Sip1Gdx+Sa9eQpaxSDdHzvVVqCHebIaOHHLyPBmwKIUTDipfj9dfSAzDZ6G8wTOP
         wTrxKOt9N5F5XA17MtkxYzpsDSwq+ZFyp7Do7OGcfigQxpi+YdvgDiICU1BO7gNGfJu/
         Sc6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791487253; x=1792092053;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=auJr1ryaFMZM/c/xY8k4emAnc/zPgD5/4eqsxgMghaI=;
        b=OICf/QNjGNdK6ypYEk32/Nd5OAw4hf6F69A47X5TT0I/XJLP9B2p07iN0bjoBkMusF
         9MjGJL5iTeoN6cyEFV3hA0Mc45LDAB0K4py0NylLFpZ/BlfzK94c+pmrzY4wLPPGM4gD
         iO7Yy1wEsL3AN+qMm25yVBKlKXxTbO4fV2jX4YVe2TWpSh74sV6qd+hw35KXuBRtqspx
         2zoPxCl+sJBsm1HFcAM9TYPMEE95xGAuxTZQlSUYVeyWnSjYNOZsAHr+gE/2iT8+YWJ2
         DRHFrER/fnq3aHh0M9EQI3qhy2oSdlA1IwBDk6T8LTfi63WaJB4uGuD62ttK93daAQnm
         hWGg==
X-Forwarded-Encrypted: i=1; AKwUvBwvc5Wfgi3pY/elAb9fzF10vLdS2kH9p+r3yElDEUM5YR8ebtveH+9hJjojk4rjKmlQu81XikwbCfp/@vger.kernel.org
X-Gm-Message-State: AFq9FYKfdt5yz/k6ZZZAY2Y5uO+1SaeIifdTL49EA82AfCzYPrjcj/TP
	q8F7vXP0yjjJZ/LsUeF5UGpx27uqV+Wi+xnZhKYYCJ35UHwnpBT0efQCtqpr3xK7A5E=
X-Gm-Gg: AYBFou2XKwW07E0CEPGoEteLHu8+/pbvkn2EtVBzI2kKXyJmj/HBAAtIza2cEX7exRM
	/Q1LLNs/55IDxylpe7mCnTJjD33Z89ouhHI9gR6fmSX+LLYurDctAlFD7xmoZO453KJU0g0l/YK
	tIr09lct7WT/jV4f1+l3aBvTSkw6p4Dx9Uf4xcfDr8xMD5KZaMtP0kfbsnRCHWulC3E5klnQ2SB
	+uLPuMDuXEdID1AZ38AomcNSHLZKQoGPLCBpt4b+B1kBzKgnh7xlDAj6uf+FuI1i8xyxPBq/cuh
	Tbeo7pRlpabPPp196/gSvBAzh0jmJCKxPvtzEF5wqpUUQmc5CurZ9vvkwVDlZypu+/AaayLtxoj
	xvoY5VRVBQzfrKO5hzkxiRkM5SbOpwyrYesr4meij9pnFiu8hao4GPP/EX4F2UP47ncH3PfHnGZ
	p91sM6Dd8hXH0fiVI/UC3ELWGVvwA7W9KJ2Hw1vkZT1FncT4mdVVvH9YqIaw+djEfxomuE42EAO
	+/lqvF0Z6gBOOss12/wND3PSyUn2rLNAalfoD9ewDQiCWvv10EF7EMJYCy7xUByT/Ii6sI=
X-Received: by 2002:a05:7300:6007:b0:351:7108:c62 with SMTP id 5a478bee46e88-35171081ee4mr4681951eec.23.1791487252953;
        Thu, 08 Oct 2026 12:20:52 -0700 (PDT)
Received: from localhost.localdomain ([2603:8001:5f01:8bab:bc88:5ec1:4f8a:5b23])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537ca329d9sm104325eec.5.2026.10.08.12.20.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 Oct 2026 12:20:52 -0700 (PDT)
From: Artem Dinaburg <artem@trailofbits.com>
To: stable@vger.kernel.org
Cc: Artem Dinaburg <artem@trailofbits.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Max Kellermann <max.kellermann@ionos.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Ts'o <tytso@mit.edu>,
	Jan Kara <jack@suse.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6.6.y 1/2] jbd2: check need_resched() when skipping busy checkpoint buffers
Date: Thu,  8 Oct 2026 15:20:45 -0400
Message-ID: <20261008192048.98833-2-artem@trailofbits.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261008192048.98833-1-artem@trailofbits.com>
References: <20261008192048.98833-1-artem@trailofbits.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Max Kellermann <max.kellermann@ionos.com>

[ Upstream commit f213e12ff5c9590b1034ae8da0e6d09665c772d0 ]

journal_shrink_one_cp_list() skips busy checkpoint buffers when called
with JBD2_SHRINK_BUSY_SKIP.  The continue statement on this path also
skips the need_resched() check at the end of the loop body.

Consequently, when a checkpoint list contains mostly busy buffers, the
shrinker can walk the entire list while holding journal->j_list_lock,
even when a reschedule has been requested.  Large checkpoint lists under
memory pressure can therefore cause long lock hold times and leave other
CPUs spinning on j_list_lock, resulting in soft lockups or RCU stalls.

Route the busy-buffer path through the need_resched() check so that the
shrinker can release j_list_lock and reschedule promptly, restoring
parity with the clean-buffer path, which already checks need_resched().
This does not change which checkpoint buffers are eligible for removal.

[ Backport to 6.6.y: Use this tree's older shrink_type enumerator names
  while routing busy buffers through the existing reschedule check. ]

Fixes: b98dba273a0e ("jbd2: remove journal_clean_one_cp_list()")
Cc: stable@vger.kernel.org
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260713102229.1598812-2-max.kellermann@ionos.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
---
This is patch 1 of 2 in the ordered 6.6.y backport series.
This change addresses CVE-2026-89566. Both targets skip the common
scheduling check on the busy-buffer continue path, allowing an unbounded
non-preemptible scan.

The fix is already present in 6.12.y, 6.18.y, and 7.2.y, but not in 6.6.y.
This fix also affects 6.1.y, which will need a separate backport; this
submission contains only the 6.6.y patch.

 fs/jbd2/checkpoint.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index 32ed28cfb3a0..e8a7186eb8c3 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -391,7 +391,7 @@ static unsigned long journal_shrink_one_cp_list(struct journal_head *jh,
 			ret = jbd2_journal_try_remove_checkpoint(jh);
 			if (ret < 0) {
 				if (type == SHRINK_BUSY_SKIP)
-					continue;
+					goto next;
 				break;
 			}
 		}
@@ -402,6 +402,7 @@ static unsigned long journal_shrink_one_cp_list(struct journal_head *jh,
 			break;
 		}
 
+next:
 		if (need_resched())
 			break;
 	} while (jh != last_jh);
-- 
2.39.5
