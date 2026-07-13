Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A613D9533
	for <linux-ext4@vger.kernel.org>; Mon, 13 Jul 2026 10:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783938159; cv=none; b=NlgEAfs4y/Nh/c4AtjtboTyvLeJ/IJH9riLrz1xgy/503e9oT7zA5QdGm6cewgcJ8xRLTncAcFg+LIsOxFC8dwPmj3+H8IK5j9QzrRTOkH3IiaxbXSfJtRojkR3HYwd6ZYegrobYkLDSLihxrqcgK8VBc/v9b9kUDoVL7MMDSBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783938159; c=relaxed/simple;
	bh=S0apE44jg4thzwLs2H4ktkq49NTNQCRu8dBmqyqkmPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ec5eGCVLFprmtWSkRalnT/0Zhd0zalSnXmuVcp/lDV47yTceLKbgCld65Jlsu19ouz1TJo1WOp+FzuqwRQXgF1Cg86cdw4KJcf2VFJlNA6ASY72oTqQGgWpWB7nqT0ccY7iVIKW1YVB5KM12VOEz8rGwBk6kdkwwrS3vahprHnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=JPH7XAer; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="JPH7XAer"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-47de0093c42so2319040f8f.3
        for <linux-ext4@vger.kernel.org>; Mon, 13 Jul 2026 03:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1783938156; x=1784542956; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d9qPFT2w9NJfNkCDFx/9oMKsPCaLSc0nA2j4Q4SrUdM=;
        b=JPH7XAerNSnuSOAfQUJJqz1Q1b3tAESXIXh+94UkDqA0kZ+spQdux8lkZHJhjQRFRH
         e8DVf5i9AWFFbrCGy5BYKvqS+FNXbGL4mSY3AgWX2NWx5ZoxXgPdVzLCuuFJJR2bDtPi
         mU1jnnXbCv3++vY/UkBJ2Y/JwI5gcdAzOvsIxleSBk4G5wJpunQWFIdekWgwYwjShAOe
         Twf4rmdWRBx1lETml+MAFp9cghIYaZb2flgeGcb1LFqorPcCy1BdkhUl3E4bEvDfWuJ3
         F5bWYNdejlq679WHyv4Tk7tFbOwEiQUZ862kTDXmz/9hPFSTifibnsrSiBSdc2Hh5Sgz
         VgRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783938156; x=1784542956;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=d9qPFT2w9NJfNkCDFx/9oMKsPCaLSc0nA2j4Q4SrUdM=;
        b=NaWQboMH1+jJZRdUs7Vir3qDnGGrbYkB6ZjJuumSFerjyH9KZjERugZKjMw0u0PtpK
         bSzSoFYIRACnOAxSxiMUAn1HUhDcdLhpzZVs2tfnGAUC4xFXbCGY2NzWam5g2oEj9pNW
         QNSmmaGgFHX7EettHiYtGCBz3Si2PB+LXEORHs+T0v7E1PtLpo4v9ld4gXWUDqYjJ4Ey
         zNC5rAQ6IzHxOqF/nIKy9diVv+PM8QdXgjFe9dp9iXPCW/h66oH2xYxdTeCC9cUe9TRb
         8RN3hEaNHT9mtY/rN9FWcTsfvFNvnth+pGfTvgbK7NjY8EDNP7YUS6PsDDYz9uYiKCFm
         4WwA==
X-Forwarded-Encrypted: i=1; AHgh+RpLbl39GbhiNIpHU7XPTBPliMdl476d6U4ulUaIom95XLLeoSZvv7YxuCJEUcnzNY7+r0g9wihU3IT+@vger.kernel.org
X-Gm-Message-State: AOJu0YwGualemq39vPeRfyIyL3JrtReW1cCUNtC+3XAbQ+aPjE9+AroX
	KYPWmD0lnxr6NQyGzsy7Hn+DklGKKSYRilLV/Fi2vSYEyLWbAxBNeZTY4wtmJLPmSxc=
X-Gm-Gg: AfdE7ckeytqWxg58zSEkOHsAIn+aTTIks42B6P+H5LxJk+9piiAXcyJ46iETpZrtI3f
	3aQZ3yGIYGSl5BWplWbmnclhBYDXQNn6Pod6tPbJXfVHVt4H4KpEYJAoev4X7TpOpc5K/qipoIx
	3la6PSVmgCzjD/pz0nCznMJ8IARWFmOCEiUOkwBimxs3VYhy53lkKcS/9UWWhgHYHKRrR1OcfjL
	3YMn1/xMO7juvVQp8k2HgAYRjtPgRHQ5cxvRR0uLonshQ8F/xao6/1/+Va9JTdYjKMX4ubYmQpm
	3RCGAOZjfZPwK7osPiT/KCnbwBIpGanMGhG/57y3ZXAqcxh3Uu6morsN97wXqohY6zYAw2/zhBn
	z60jFZogA+KhVjZavdvYBz5PEBESxRuQw7QCCf54S1JGXQp6ZjotZwLCrl0HS0W0qv8C17kRShF
	TNFYRYza3OJwOK5k7BWtt+21BbLY+kIlY8hSe9PoaCmwtmH42gXnDxnMHc1YCe5kxHyDgnBT9lc
	9LuiDHnTR/hPNSijntjxFcFxcY=
X-Received: by 2002:a5d:6f0a:0:b0:47f:250f:71fc with SMTP id ffacd0b85a97d-47f2dd139c2mr10176696f8f.54.1783938156185;
        Mon, 13 Jul 2026 03:22:36 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f484700023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f48:4700:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa09608d4sm84858344f8f.25.2026.07.13.03.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 03:22:35 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: tytso@mit.edu,
	jack@suse.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Max Kellermann <max.kellermann@ionos.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] jbd2: check need_resched() when skipping busy checkpoint buffers
Date: Mon, 13 Jul 2026 12:22:28 +0200
Message-ID: <20260713102229.1598812-2-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260713102229.1598812-1-max.kellermann@ionos.com>
References: <20260713102229.1598812-1-max.kellermann@ionos.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

Fixes: b98dba273a0e ("jbd2: remove journal_clean_one_cp_list()")
Cc: stable@vger.kernel.org
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 fs/jbd2/checkpoint.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index 1508e2f54462..5266017565ac 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -389,7 +389,7 @@ static unsigned long journal_shrink_one_cp_list(struct journal_head *jh,
 			ret = jbd2_journal_try_remove_checkpoint(jh);
 			if (ret < 0) {
 				if (type == JBD2_SHRINK_BUSY_SKIP)
-					continue;
+					goto next;
 				break;
 			}
 		}
@@ -400,6 +400,7 @@ static unsigned long journal_shrink_one_cp_list(struct journal_head *jh,
 			break;
 		}
 
+next:
 		if (need_resched())
 			break;
 	} while (jh != last_jh);
-- 
2.47.3

