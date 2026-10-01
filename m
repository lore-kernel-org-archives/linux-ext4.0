Received: from mail-dy2-f42.google.com (mail-dy2-f42.google.com [74.125.229.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7657363C6C
	for <linux-ext4@vger.kernel.org>; Thu,  1 Oct 2026 07:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790840630; cv=none; b=hrCsoNbZmIFFoNPNLpfVm3JP3QcrqlNvZiZRHc0Chr8Uu2jGjMlu0OdGTLyTRQ1lsPLIZ7toTruxcMHX0ku/7oHMv2ImcZ0dD79clJtLDOn/Wd3mBmpJ1MU2AdgjR5hYSnc8RDBma3//teC51Hh8jVPrXXQ4G6YmvZtlJRjGUsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790840630; c=relaxed/simple;
	bh=SSwCzyX87gRH7hW4GI560tjujgur5XBXYAVfLJ2Z25E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=AKkKIx57kdYTb3dscTZCEifKH6UBybr8abYMr5s0dtDJDqNsrGelU7YuLUthEgYNumcJXVUs8wL4gwlvhO9VeKEeEzsuJSru7LgP+xCIzFO+MPNTt5orS8SZV8KRJUYC0n7gTOK+mn+1qinhV2CnX7iapj9d8mHcUXQLYWsyIOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OSz0R5CQ; arc=none smtp.client-ip=74.125.229.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OSz0R5CQ"
Received: by mail-dy2-f42.google.com with SMTP id 5a478bee46e88-341d0522b4dso9656256eec.1
        for <linux-ext4@vger.kernel.org>; Thu, 01 Oct 2026 00:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790840628; x=1791445428; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ILJGyWA9cCx1Ar1Qgl+/EPmfWI2kJKAy/oM+W8KfewE=;
        b=OSz0R5CQUVFxw5kL7jht1KYZ2LsCg07zhBzA2M5p/2jdd1OI652P4Jpr3ljJE9UOL5
         R5qFLWs5MibuXvtuyySTM6dvK5hpB3GkbRvjDY5p9bMKaIUMMrKDHtzpplkn4oFA4FF3
         0MldKxmvzyBQ69u9H/E9Y5y44v9RbSZm8XJOoGXdK1L6SbpclVfzfdBJpK1Ms4DNdftx
         I95538SBuWMUpS3YCNBopCDQlUCM40pRR2aF7UpFAK7+7A7t1zkIYeiNBwv7X4FCzC9d
         NHUn19z35s3Z6lenyLGECpehDZdYQ0SoRf2ip38PrE5D/25TlIPTsqyasbOUPqX8mOiS
         Zasg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790840628; x=1791445428;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=ILJGyWA9cCx1Ar1Qgl+/EPmfWI2kJKAy/oM+W8KfewE=;
        b=rYxgt5qZ2eYoQ6gaCiVqTZLVz+khczYhq5pQODjt3Tdsa9k21KL8ZJ7ZQThdoBjPSd
         52Hq050RGjXiLACf2qcX6PEp4eIMhusekflLLh84PDN0M6kswow80ekJ7KTrp1EcDOp1
         kSHzLtbGPDAosVzvHED5DNFKYuvhAIdXiT0iDhnbCHGxocNME13ulfJoQaoRR3JRVi7l
         9VAF9qoaOEv1gNkb8YtbvnaTGROBYU7ROyq0kjpTQ42Lze4chHseDB4LZmnDoDAYL9yz
         G0BJd7gOY6AjnzGmnqXzmiXqwW9Vwz8UUM1gh6qd4wfC8x/zUOw3g6I6aF+w6y4Krzyk
         2wWw==
X-Gm-Message-State: AFq9FYJDbO6Wds62BGFWfQh49RCybSKTaVfIEmSit3mClArpicJdxo3o
	PGLjjD1kYEtXY+bjKuDpuxXwAK1L5EsEecpIMNENtzZv2QcqDeCYNIj+
X-Gm-Gg: AYBFou1TawKTzkAxQhZX4BLZDAtoTsUQKr2/gerSi+b9bPL4orF5PXJIFyIUAGYxHjE
	6bdRT+aBCAwVDIC8IBVZ6hsegelZBhGzM114VWLyUuupo11HVk7jwQRFt0XY4QUMxlbtzuLxpgf
	J2+cisTVJgsBaMhbF8JkRVSiNImrWJ6GUczDdurYIjQNBNSdb+9NxUcNd7BZWG8sNzdxYrreD0C
	w/iyY8qYChiRc8AwaIdbc9oeSCcGOu8UTfxbZHrtKpChv8ucTLKxxMp6dyarg1sEI9ciNN+OgoX
	Pv0mnONVobRGtfY8P0M3wvKDsnAeXtd5535YWjucGLnIFfIJGfjx9qRGiIL9VebO6KubECpu4Lg
	Tj/FiDlzpeAZuaRID+iU3Vyd7NAiJxa9k7qWqu2IKB/5AR/Svz3VYneO1RUUL1TpUZu/04zI9Z4
	46SyTFAohZlOhjIzOe+acSAjjFOOLmptjyG4q75hzChHUQ4iNO1DXTl4kjMBwcWSA7sQ==
X-Received: by 2002:a05:7300:b507:b0:34c:8c69:5294 with SMTP id 5a478bee46e88-34cdd68f6fcmr6014635eec.35.1790840627612;
        Thu, 01 Oct 2026 00:43:47 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34db5016cd1sm4587555eec.31.2026.10.01.00.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 00:43:47 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Thu, 01 Oct 2026 15:43:43 +0800
Subject: [PATCH v5] jbd2: fix shrinker scan budget accounting in
 jbd2_journal_shrink_scan()
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261001-fix-jbd2-shrink-scan-nr-scanned-v5-1-5348b51efce2@gmail.com>
X-B4-Tracking: v=1; b=H4sIAC4PvmoC/5XPwW7CMAwG4FdBOeMpcdJAOO09EIfgODQbpFOCK
 ibUd1/aE+IyOFm/JX+/fBeVS+Iqdqu7KDymmobcQrdeCep9PjGk0LJAiVY63EJMN/g6BoTal5S
 /oZLPkMsyMwcgLd2WgpOKUTTlp3A7WRr2h5b7VK9D+V0KRzVvX7dHBQrYRiOVZbLOfZ4uPp0/a
 LiI2R7xTQ+bt2HFkUn7GOKzp9/0dPOcsuS977RB+eyZB0/L/z0z/3t0XhMRdmgevWma/gC42b5
 AvgEAAA==
To: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Qiliang Yuan <odys.yuan@gmail.com>, 
 Jan Kara <jack@suse.cz>
X-Mailer: b4 0.13.0

do_shrink_slab() reads count_objects() once per invocation to derive
a one-shot scan budget, then calls scan_objects() repeatedly until
that budget is exhausted or scan_objects() returns SHRINK_STOP.
include/linux/shrinker.h documents that scan_objects() "should track
its actual progress" in sc->nr_scanned, so do_shrink_slab() can tell
when there is nothing left to examine and stop early.

jbd2_journal_shrink_scan() never updates sc->nr_scanned, so it
defaults to the full sc->nr_to_scan on every call. do_shrink_slab()
therefore always believes a full batch was examined, regardless of
what jbd2_journal_shrink_checkpoint_list() actually did, and keeps
calling scan_objects() until the budget derived from the (possibly
stale) percpu checkpoint count is drained, even after the checkpoint
list has already been fully drained.

jbd2_journal_shrink_checkpoint_list() already tracks examined
buffers accurately: it decrements its nr_to_scan in/out parameter
for every journal_head walked, whether or not it gets freed. Derive
sc->nr_scanned from the difference, and return SHRINK_STOP once it
comes back zero, since that only happens when the checkpoint list
had nothing left to walk. Key this off sc->nr_scanned rather than
nr_shrunk: a batch can find every buffer in its transactions busy
and free none, while later transactions may still hold buffers
whose writeback has completed; sc->nr_scanned reflects that real
work either way.

Tested by creating 20000 small files, running sync, and letting
checkpointing settle for a few seconds (with systemd-journald and
cron stopped, since their own writes to the same filesystem keep
re-populating the checkpoint list and mask the effect being
measured), then triggering "echo 2 > /proc/sys/vm/drop_caches" while
tracing jbd2_shrink_scan_enter/exit:

                      total scan_objects()   calls with
                      calls                  nr_scanned == 0
  before this patch   22                     10 (45%)
  after this patch     8                      1 (12%)

Fixes: 4ba3fcdde7e3 ("jbd2,ext4: add a shrinker to release checkpointed buffers")
Cc: stable@vger.kernel.org
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
V4 -> V5:
- Revert to keying SHRINK_STOP off sc->nr_scanned (buffers actually
  examined) rather than nr_shrunk (buffers actually freed), as v1
  originally did. Jan Kara rejected the nr_shrunk-based v4, pointing
  out that failing to reclaim the buffers in one batch doesn't mean
  later transactions won't have freeable ones; Sashiko AI review
  independently flagged the same issue. Restore Jan Kara's v1
  Reviewed-by: the diff in jbd2_journal_shrink_scan() is unchanged
  from what he reviewed there (only the explanatory comment reads
  differently).
- Redesign the test: the old methodology (no sync, buffers kept busy
  by design) exercises exactly the busy-but-productive case Jan Kara
  describes, so it isn't a useful before/after comparison for this
  change. Replace it with one that lets the checkpoint list actually
  drain via sync, then measures scan_objects() calls wasted after
  draining due to percpu-counter staleness.

V3 -> V4:
- Shorten the SHRINK_STOP comment; no functional change (the trigger
  has been nr_shrunk == 0 since v2, not sc->nr_scanned).
- Carry forward Jan Kara's v3 Reviewed-by.

V2 -> V3:
- Rebase onto v7.3-rc5. It already includes Max Kellermann's
  "jbd2: bound shrinker scans by examined checkpoint buffers"
  (15cb16496446), which independently fixes the busy-buffer
  accounting in journal_shrink_one_cp_list()/
  jbd2_journal_shrink_checkpoint_list() that v2 also touched. Drop
  the now-redundant checkpoint.c changes; this revision only touches
  journal.c, reusing the accurate nr_to_scan tracking Kellermann's
  fix already provides.
- Add a Fixes: tag for the commit that introduced
  jbd2_journal_shrink_scan() without ever setting sc->nr_scanned.
- Re-measure test data against the new baseline (176 -> 8 calls,
  vs the old baseline's 168 -> 7).

V1 -> V2:
- Count examined buffers, not just freed ones, in
  journal_shrink_one_cp_list() (Sashiko AI review finding).
- Trigger SHRINK_STOP on nr_shrunk == 0 instead of
  sc->nr_scanned == 0.

v4: https://lore.kernel.org/r/20260930-fix-jbd2-shrink-scan-nr-scanned-v4-1-eb9a3ccc2524@gmail.com
v3: https://lore.kernel.org/r/20260928-fix-jbd2-shrink-scan-nr-scanned-v3-1-916caaa53420@gmail.com
v2: https://lore.kernel.org/r/20260928-fix-jbd2-shrink-scan-nr-scanned-v2-1-7e1efec3afdf@gmail.com
v1: https://lore.kernel.org/r/20260928-fix-jbd2-shrink-scan-nr-scanned-v1-1-e6f4016ec699@gmail.com
---
 fs/jbd2/journal.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 00f5a98f3d4fe..eac5f84a1afc5 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1263,10 +1263,22 @@ static unsigned long jbd2_journal_shrink_scan(struct shrinker *shrink,
 	trace_jbd2_shrink_scan_enter(journal, sc->nr_to_scan, count);
 
 	nr_shrunk = jbd2_journal_shrink_checkpoint_list(journal, &nr_to_scan);
+	sc->nr_scanned = sc->nr_to_scan - nr_to_scan;
 
 	count = percpu_counter_read_positive(&journal->j_checkpoint_jh_count);
 	trace_jbd2_shrink_scan_exit(journal, nr_to_scan, nr_shrunk, count);
 
+	/*
+	 * Key SHRINK_STOP off sc->nr_scanned (buffers actually examined),
+	 * not nr_shrunk (buffers actually freed): a batch can find every
+	 * buffer in its transactions busy and free none, while later
+	 * transactions may still hold buffers whose writeback has
+	 * completed. sc->nr_scanned only comes back 0 when the checkpoint
+	 * list had nothing left to walk.
+	 */
+	if (sc->nr_scanned == 0)
+		return SHRINK_STOP;
+
 	return nr_shrunk;
 }
 

---
base-commit: 72d3fcf802c45d00b300f25b848a93c3a2bd7c7e
change-id: 20260928-fix-jbd2-shrink-scan-nr-scanned-c3098cd901e2

Best regards,
-- 
Qiliang Yuan <odys.yuan@gmail.com>

