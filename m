Received: from mail-dy2-f41.google.com (mail-dy2-f41.google.com [74.125.229.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B134B448B9B
	for <linux-ext4@vger.kernel.org>; Wed, 30 Sep 2026 07:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790752311; cv=none; b=uYGHjWxauDCkd9DokhVAMhku0AEpbaQ7vHLpcQQ6qVX5fjRYctec1JMyYkIZhIpYnIAz/nWLZbUJgq6MO4EzlevLr7avWT7ENAnSmvG/XOqYVd3wCwzpS7gbkuXp2pZ+jaT8NzdqeLjfA47p4mpXkZpFh8Jb75t6UAMGPzF/Mjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790752311; c=relaxed/simple;
	bh=OTLf57bRLMObeZY65qGuyn5U2mnysVcG5k1v3huPGzk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=THqWWbm6JSqpb6jJDcycgSqoDWNCwcIzSMOsgopJMsQbL4gMMcd4r7Td077bosGeNlD5mpeS77FsSGhkXvfh4jMy1HTgLPufJKBeoQImiX4Tx0ulNV4SEiqnKFQO7L6qk8t4JuEAnDAEtyhiqJFS/kk6vDwzP3P4sM8eZqE/YA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iQil8nG3; arc=none smtp.client-ip=74.125.229.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iQil8nG3"
Received: by mail-dy2-f41.google.com with SMTP id 5a478bee46e88-34bb8b31660so805149eec.3
        for <linux-ext4@vger.kernel.org>; Wed, 30 Sep 2026 00:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790752308; x=1791357108; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zcnJ184JoYb53zg3yz9uspX1LHzg9LyZlu2u82RZHnY=;
        b=iQil8nG3POkSdrPnc3CC6TIxkSJFIFzBXy2IfYjPl93lS8Pz4OC8L9KLBqNtfk+DQJ
         uGKR2/tRkVleQob2T0FsbKEtaaUEMc7s1dorzj0yyZ4z9N9xqtFI0q4Vp5nHHhbOCc+m
         pX6lLQO6yETOl4vw9Rvb2SDmk03a7ZJMY7jz03vOT3wiAHqIuJIS50l9cN24sABWOui4
         /4f+OuPDgfZ5e8EzksI4gSE2wBSsUh9xpZi2X5pz2wn7oyAy4ovj4HJPJdSApVz90izA
         uu4UpyJTYUHNen6cdHt943rP/499FY8OIfqBCcDLgmIOwvqCcfGC6qtRwKlkvInzDMf2
         ehXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790752308; x=1791357108;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zcnJ184JoYb53zg3yz9uspX1LHzg9LyZlu2u82RZHnY=;
        b=gshcCvJi9wDmL7asBMI+vGEFqgQK5jazVItkEVjqsizOo4KmCGOXDPG/Mdf32da2fo
         hxmxHm+1URxIEgeDy72g0Qd4zALcG9J36GvcjqMhV5cGe/Ewo21w1fvGsJ4GSZcUEWx3
         m0hhIouloTU0TSYjLHdZu/MB1z6stN/WQCz+CsKEKWEH8meUsqdl3/BUfVIn5rKPJWi0
         JXTV+tu+u56Uhh3qVXF2QZgXtLYzUwUUWZxxOyyqKrqpaBL13jg5xeeTX2hCtzFtSWQY
         TnI7HfR2bFpC/xC0p7rmem/DMQR/9pSEAgR9y7s/MKiwsN7V1FVa97A0URhXxJfAWo2M
         ltgA==
X-Gm-Message-State: AFq9FYKwlFvg49V5XCy/duApEohvjTll7mhwbXjwvNr3WXgWpbSEusjV
	gX2TVfWnLC97JJOX9uzlAezLZMo6ZPioWU5+cYhNs4z9LHHC62vl15Ps
X-Gm-Gg: AYBFou1h1GifEWzJLVKTCupNpKhUwzU0QlRI1ONaqbWhqV82fYHq3UEZDzcrlw8l3So
	7+loA5LvLhMfTw32pJWbe6AULUCfrSwLjMzK7a1o0Vs9A+idBaKFelGktawl0N3SCw23/iuKW2+
	sh07+ui5rA0j3tuuWO1IQswbh9qnRgT9gFmUDlkhEh04HIHAm4oMuDPUkWgJ0sv4R2+Yi1YhKPG
	YRn16HpRxPtPevhJqBx5RrWdXc8GpgQtVzt5vjaaHRX7h12e6oTNxOac2qSjLV1To4xzgEMBWWv
	KpzebN3M7yT6qJ15L4aOTC9Y9EflI4PXrcNk36xpsqyKyh1fgY93UuDlwdqyYH5rdLkH3wl9IzB
	LX1VaYeuBxShmnJkfVPbc/+RcBJiFzFilnF62Bj2deoBeUx6sCEZPve6tYTe7tbK7zeHmKEoTiC
	kD/MNAAuwlJcHIekCjLPZloN+R5et5B+hyEjKuz87MjIsX7MJlfvuYSse+DIFrnILrOA==
X-Received: by 2002:a05:7300:b282:b0:34d:756:9b2a with SMTP id 5a478bee46e88-34d0765e6b7mr406978eec.23.1790752307547;
        Wed, 30 Sep 2026 00:11:47 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34cf5b4349bsm1621837eec.25.2026.09.30.00.11.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 00:11:47 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Wed, 30 Sep 2026 15:11:37 +0800
Subject: [PATCH v3 1/2] ext4: fix shrinker scan budget accounting in
 ext4_es_scan()
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260930-fix-ext4-es-scan-nr-scanned-v3-1-9aef0be87d21@gmail.com>
References: <20260930-fix-ext4-es-scan-nr-scanned-v3-0-9aef0be87d21@gmail.com>
In-Reply-To: <20260930-fix-ext4-es-scan-nr-scanned-v3-0-9aef0be87d21@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>, 
 Andreas Dilger <adilger.kernel@dilger.ca>, 
 Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
 Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Zhang Yi <yi.zhang@huawei.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Qiliang Yuan <odys.yuan@gmail.com>, stable@vger.kernel.org
X-Mailer: b4 0.13.0

The extents_status shrinker's count_objects() callback,
ext4_es_count(), reports the number of shrinkable extent_status
objects via a percpu counter. do_shrink_slab() reads this count
exactly once per invocation and derives a one-shot scan budget
(total_scan) from it, then repeatedly calls scan_objects() in
fixed-size batches until that budget is exhausted.

ext4_es_scan() never signals SHRINK_STOP, so do_shrink_slab() has no
way to tell "there was nothing to reclaim this pass" from "a full
batch was scanned and none of it was freeable". It keeps calling
scan_objects() until the original, one-shot total_scan budget is
drained, even when sbi->s_es_list has had nothing left to give for a
while.

Return SHRINK_STOP whenever __es_shrink() frees nothing, so
do_shrink_slab() stops calling us for the rest of this reclaim pass
instead of burning through its scan budget against the same stale
freeable count.

Tested by fallocate(2)-ing 10000 4K files (to populate the shrinker
with reclaimable unwritten extents without also exercising the
extent_status "referenced" second-chance path, which needs a
separate two-pass accounting of its own) and triggering
"echo 2 > /proc/sys/vm/drop_caches", while tracing the
ext4_es_shrink* tracepoints:

                      total scan_objects()   calls with
                      calls                  nr_shrunk == 0
  before this patch   429                    189 (44%)
  after this patch    238                      1 (0.4%)

Fixes: 1ab6c4997e04 ("fs: convert fs shrinkers to new scan/count API")
Cc: stable@vger.kernel.org
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
 fs/ext4/extents_status.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 6e4a191e82191..d88af807d36e7 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -1783,6 +1783,16 @@ static unsigned long ext4_es_scan(struct shrinker *shrink,
 
 	ret = percpu_counter_read_positive(&sbi->s_es_stats.es_stats_shk_cnt);
 	trace_ext4_es_shrink_scan_exit(sbi->s_sb, nr_shrunk, ret);
+
+	/*
+	 * es_stats_shk_cnt is a percpu counter, so it can stay positive
+	 * after sbi->s_es_list has nothing left to give. Stop this reclaim
+	 * pass once a call frees nothing, instead of burning through
+	 * do_shrink_slab()'s scan budget against a stale count.
+	 */
+	if (nr_shrunk == 0)
+		return SHRINK_STOP;
+
 	return nr_shrunk;
 }
 

-- 
2.43.0

