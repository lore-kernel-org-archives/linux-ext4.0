Received: from mail-dy2-f43.google.com (mail-dy2-f43.google.com [74.125.229.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53FAD49B458
	for <linux-ext4@vger.kernel.org>; Thu,  1 Oct 2026 07:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790840651; cv=none; b=d5zDCrCjZCn3Eo7CfBKqoxJ8iSon577GICyVxIXVns/BrEhrVJpFvZ9iTfIHsSbU9d58qxbq0FGp1BtbcfzN3xkH3JGiGhz3CX+5dti2i6VZ6TItzy0gctMfqPtNIA6CMqgS1MLaUk7vuahls0h43qrGh4EUJOAv9CFzFKNG9/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790840651; c=relaxed/simple;
	bh=wqRaIOXeDPT3+XISe3ngOCJkiwjeRsctUaQA26plR8I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Hm4HSF0wBjQf4GPF2m4N0G5BGhkI3PKzW+2PR1i1wCvaSFZsygL8kJhShvmq9WWGscrH1sZNbVs7MYd4WV0p1EEjk98pPx2yM42RjthOU9+DIrUKQYfeEkBXsHz1WMY/SXtO5NI9/C1YYx9ioKrcfRsyMtzNPto+VL49GWPSwsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hT3qmn7Z; arc=none smtp.client-ip=74.125.229.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hT3qmn7Z"
Received: by mail-dy2-f43.google.com with SMTP id 5a478bee46e88-33e62211987so6226487eec.2
        for <linux-ext4@vger.kernel.org>; Thu, 01 Oct 2026 00:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790840649; x=1791445449; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+wjicLxXLe0gzUFdN1SPp+yYA5R4cKA9OIuHvIpazYc=;
        b=hT3qmn7ZZQ9v83lRA69AMi7xttyIlOFrqAcX2p7syQRgEzM65snlcQmTCjJUdd3Hqx
         jREfSwiJUSQC8E4gy5imozVYIqz05xXNwbRhtIk80V6NJLMMNm6bEhA6ven4Yz85iJJP
         0WrDKRC5QQIqX1GP69q4tUNY9qhsAz1LoBrJ3KfizB9o8m6+TdEbVC/8Bmu+mT7DVr4E
         lxJbfie/Y7ytrBjo+90xsnlvAlC0cuC5rMiCoLkWAJGm3jYFVcHKEUWydpBJcDjWLmhJ
         uQ67oojixGC6889EbqhOpNenVA5HxyNjg9tbg8Ttd8YGOrm741PvvjuXZugGc572VyYF
         nZwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790840649; x=1791445449;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+wjicLxXLe0gzUFdN1SPp+yYA5R4cKA9OIuHvIpazYc=;
        b=s81ReL+xoC70b73BzMn3qLvVuYcy0iaBuGbV3gR7EYNW6QNOsAOrnMRLebLtDfE3tX
         vvPiWpZ1SI814KOnYgf9d99R3cQnFvp7boNDf4PRymuUMPakqgDx+4+N+MgfLc2SUeGr
         D065a/gW8sHVzs+L5jF9fD9LXjGYwa8+5Z4UIfKQqpPT+DwyAD5JNnXrey6NN1IXu2FT
         T010gOn1f3xwIbi+k9eioawedgAberF5PYjz/pbhGZ8oXGnfN1Ed3QYoRlFApAxgT+Si
         PiQmk3eRdX5N/2Qr+VJGKdP65gMZ3yi+0W3AavQVE+vcAZ+O5kLDQUm8W+CCeNVzVJYe
         HueA==
X-Gm-Message-State: AFq9FYIL2vJgNhsM/0NDohr/OCMioEjvlvFqBijHD4Jwpfn5oxxg0wSl
	6FDSZqOCdQ1ZYXq5jo2UCx9mcl/ix1WiNfM0n9yI+5uV3p9LrsNjJUag
X-Gm-Gg: AYBFou2ezdurAjmlVFO741ZvEOHD94GxLdBuQYziuh2fS9VOpHyTtyCWU8LLr4yrx/J
	3wWjdoE/uy8X9MbA/T4N62HcAuhxTZa1h3ZDCYFTAIPgUmVSP6F5Jjc2kTJ9cWaWrfXer9UEWbP
	MRGwNxduyCp/TE1Wb6yllysYcj9MPaEJ869FHz4tP+3QQxWqk4ylo55Kk1sUIAnzCzht15xE1Eb
	CK+3ltdjmYluA5mPdwH0+rCjkXLcw+oBrw7PVRwju0q+pUJIQZR1xdplJY03idNZTK0r50A2xbZ
	UZLQSSXAWKG0I7mjFlOqrXh3HJq3SUlvIe0YR0+DDIitKkTrUctkqAosn+3goPgGckECws72yQT
	02lteThIb3aEvVpoTYlyIcwWfWsiuhNH9Cso+X9AXx/FC1Q3pXydgOfyDt2l0PphRIWcMlUhWak
	WHSYtcp880eqqoNbAuRokBttYvwnHN50T2+IZViLmngQsJlow7arE3Ey5jWJfvggPh523U0N/GJ
	zew
X-Received: by 2002:a05:693c:83d2:10b0:34c:bc38:e2ee with SMTP id 5a478bee46e88-34cdb1ff925mr4496818eec.8.1790840649381;
        Thu, 01 Oct 2026 00:44:09 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34db3e33b73sm4876955eec.18.2026.10.01.00.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 00:44:09 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Thu, 01 Oct 2026 15:43:57 +0800
Subject: [PATCH v4 2/2] ext4: remove unused locked_ei parameter from
 __es_shrink()
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261001-fix-ext4-es-scan-nr-scanned-v4-2-b13703714ce2@gmail.com>
References: <20261001-fix-ext4-es-scan-nr-scanned-v4-0-b13703714ce2@gmail.com>
In-Reply-To: <20261001-fix-ext4-es-scan-nr-scanned-v4-0-b13703714ce2@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>, 
 Andreas Dilger <adilger.kernel@dilger.ca>, 
 Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
 Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Zhang Yi <yi.zhang@huawei.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0

__es_shrink()'s locked_ei parameter exists to let a caller pass in an
inode it already holds i_es_lock on, so the shrinker walk can skip
that inode instead of deadlocking on write_trylock(), and fall back
to reclaiming from it directly if nothing else could be freed. Its
only caller, ext4_es_scan(), always passes NULL.

Drop the parameter along with the two code paths that exist solely to
support it: the ei == locked_ei skip check, and the trailing
es_reclaim_extents(locked_ei, ...) fallback, neither of which can ever
run while locked_ei is always NULL.

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/extents_status.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index b8821b93693a9..77786111ce59c 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -184,7 +184,7 @@ static int __es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 			      struct extent_status *prealloc);
 static int es_reclaim_extents(struct ext4_inode_info *ei, int *nr_to_scan);
 static int __es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
-		       struct ext4_inode_info *locked_ei, int *nr_scanned);
+		       int *nr_scanned);
 static int __revise_pending(struct inode *inode, ext4_lblk_t lblk,
 			    ext4_lblk_t len,
 			    struct pending_reservation **prealloc);
@@ -1670,7 +1670,7 @@ void ext4_es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 }
 
 static int __es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
-		       struct ext4_inode_info *locked_ei, int *nr_scanned)
+		       int *nr_scanned)
 {
 	struct ext4_inode_info *ei;
 	struct ext4_es_stats *es_stats;
@@ -1707,7 +1707,7 @@ static int __es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
 			continue;
 		}
 
-		if (ei == locked_ei || !write_trylock(&ei->i_es_lock)) {
+		if (!write_trylock(&ei->i_es_lock)) {
 			nr_skipped++;
 			continue;
 		}
@@ -1735,9 +1735,6 @@ static int __es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
 		goto retry;
 	}
 
-	if (locked_ei && nr_shrunk == 0)
-		nr_shrunk = es_reclaim_extents(locked_ei, &nr_to_scan);
-
 out:
 	*nr_scanned = orig_nr_to_scan - nr_to_scan;
 
@@ -1782,7 +1779,7 @@ static unsigned long ext4_es_scan(struct shrinker *shrink,
 	ret = percpu_counter_read_positive(&sbi->s_es_stats.es_stats_shk_cnt);
 	trace_ext4_es_shrink_scan_enter(sbi->s_sb, nr_to_scan, ret);
 
-	nr_shrunk = __es_shrink(sbi, nr_to_scan, NULL, &nr_scanned);
+	nr_shrunk = __es_shrink(sbi, nr_to_scan, &nr_scanned);
 	sc->nr_scanned = nr_scanned;
 
 	ret = percpu_counter_read_positive(&sbi->s_es_stats.es_stats_shk_cnt);

-- 
2.43.0

