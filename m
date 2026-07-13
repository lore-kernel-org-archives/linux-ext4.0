Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B78B36A361
	for <linux-ext4@vger.kernel.org>; Mon, 13 Jul 2026 10:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783938160; cv=none; b=KfxOLV4XVvxbywafeC2kA++y79bluKdKkU0epzmiV3Hya6xEvXAlfOl7dUOwBx9g83FOeuL4JmZNBco6sIIZkBSPHasI9IopGTF5l0LqO8JWBwdKQwFhD8w/vgFgobITUuuCvwcQ8cWI3wC0p0j9bZDyj3k0B6iaF/AwF8+63Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783938160; c=relaxed/simple;
	bh=l8axt9Tk9geBEkN8bylkeCe0FVdnGDnLH1I3RigAbJU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hVCmerW4n5t36IozUUI5KGvcvCTsSzdCYwkRyxkBlsq6p+c2/2/UXttrZf5pUifwT44e8kB7yaY0VIkdPSwQw+X6MKT+f6bsEnAFpa8KsLsEEDssLsoCuh5kWdo/uKK7GXxIXUQ+xjOEpbPKX7XozxXAbrOVQhAOVc9hZzVQ1QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=QeyyZXiI; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="QeyyZXiI"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-474560436c3so2264181f8f.0
        for <linux-ext4@vger.kernel.org>; Mon, 13 Jul 2026 03:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1783938155; x=1784542955; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=uuK9JeqClTwXWplH5M0lC/009LSJw3bFvJurNVCcSgk=;
        b=QeyyZXiI2sEENdtWCA1M47I2OgG3d4R+FWr78FcvSnsEthd/VsZvwuY5S3k9V8Uh/Z
         eVuax1pheEmYQwZy5AhD+9tooQG9YpauilvJ9cg3yE4LVqmC18VqxP3v8/bwHGMkBPTw
         ZE3C03dACJbERXWvJsHRTP6srzdSmPNgZi4xKlTWf61tE84MijLT6p07QEgqm52lczmh
         /V1jGkXN5ceP7UHUeQ6XJnIuoP8Irh5DRhfeVgEq6vcb01DdQgsWcOxved1pOgFO+/ZY
         QVABYjs1GaYVQ9420gId0zHCec6sd/h+/H8jkUtiZHkLGHn3C1ysjfbxpqjLmn4bZxae
         ejWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783938155; x=1784542955;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uuK9JeqClTwXWplH5M0lC/009LSJw3bFvJurNVCcSgk=;
        b=lmGqHzZE7+jsYw/lxs42j9WZrSsJpPEjgTnuPxEYVs797xgFYQun4viTuk8cPAGRQV
         4oG8laHlTZBvqfC3wYoJg7Y/ZV1cFCIMGzPh/DA7PLgCRwQFR9B4m/ifndOw9vKrPgjm
         vW50j8xa/S7Jm/8LksLGwAInsKUOn8PGeBaTJfkdBmR0DChP+sG4u+xTv7Zp+pPl1/Ji
         YR5sKp+FxSx3fgyZPQk/jim1bTUG7uhe8kTj5Y1HLHcsHGoqU5VIMEstZKewJVQt6axu
         nttb4Wv+0VUZnlwFA6Xb7RsFStzAqoU5ynsOqvC74MAERA2BonczpVSmK6/ol/STDnvN
         7gdw==
X-Forwarded-Encrypted: i=1; AHgh+RrHFtg8Hq64EYjbu9aF3uc+yg5CgkPi4geBQwCWHLPK1/e1MOsNhxufousIEt21DOlq2e+jhaKpVjyz@vger.kernel.org
X-Gm-Message-State: AOJu0Yz29erTl3ixr3N2ygSN9U3REQ/WOowy6Q6/gY1KGpHMe9puXwdB
	w2f4d6KvNL2gzdmyD7GRmVq9UceSf8t5etyNLpeXWm+J5wC4sdbYKocV6Vi8fD25o4k=
X-Gm-Gg: AfdE7ckX8zCaQUfj4SF26JQS42fwNAas5YTeZUjz8+lWuhlUINNc3TJBDEAy7asVyjX
	RUMChN04/PBzwRcqsPj2y9Luk2rU5Oka+SaOQL3YDRuI+nZe08JTLw1G1dfIch4wv88fVakXylb
	fW64Ki8h8xQxLELUUkl8HRT4pb/iubTlkkMhJzokSF7NeC+XxeCpd/OILuZRzmsvrjLC9lg+42D
	iuLTHKVfgKa3OUXRiEZHFlnhwHfL/YI/lAx+frvSspQ9CpLDj3xv4/TZckQw4s8iYHbWjzDRjmz
	pv8FRUAG7CaJCoVF8f+uY607bUWMUNas8Tx54X0tACIiBGb7pLdkVS68lwrxOxL5IsiQ64WSHvr
	rJ19qwGV2LHW2IGndlVsYZCXPk5F3YLOwBkekMvog041K71m+lxUW4+gfaY/wh+2+SF09nvvtYv
	TqPa9jD+QWXUtTQhzsjYH4QHZbcN81u4JPjSvnFtL82PoFvXfeJ9mlqZd3JPqTS6qNjEwvLDCya
	i1vQALg4F5GB4fT
X-Received: by 2002:a05:6000:1a86:b0:45e:f439:9def with SMTP id ffacd0b85a97d-47f2dcbffdemr9467962f8f.15.1783938154686;
        Mon, 13 Jul 2026 03:22:34 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f484700023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f48:4700:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa09608d4sm84858344f8f.25.2026.07.13.03.22.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 03:22:33 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: tytso@mit.edu,
	jack@suse.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH 0/2] jbd2: bound j_list_lock hold time in the checkpoint shrinker
Date: Mon, 13 Jul 2026 12:22:27 +0200
Message-ID: <20260713102229.1598812-1-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We hit recurring RCU stalls / soft lockups on a busy ext4 filesystem
that serves as the CacheFiles backing store for a Ceph (fscache)
client.  The stall is always the journal commit thread spinning on
journal->j_list_lock:

  rcu: INFO: rcu_sched self-detected stall on CPU
  rcu:   106-....: (2099 ticks this GP) ... (t=2100 jiffies)
  CPU: 106 Comm: jbd2/nvme1n1p1-
  RIP: 0010:queued_spin_lock_slowpath+0x20a/0x240
  Call Trace:
   jbd2_journal_write_metadata_buffer+0x1c0/0x310
   jbd2_journal_commit_transaction+0x5e2/0x16e0
   kjournald2+0xa1/0x220
   kthread+0xe4/0x1d0

kjournald2 has already passed the "wait for outstanding handles"
barrier and is in the metadata write-out loop; it is simply unable to
acquire j_list_lock for >21s.  The lock holder is the jbd2 checkpoint
shrinker.

Under memory pressure, the shrinker (jbd2_journal_shrink_scan ->
jbd2_journal_shrink_checkpoint_list -> journal_shrink_one_cp_list)
walks a transaction's checkpoint list under j_list_lock.  On this
workload, the lists are large and dominated by busy buffers (dirty /
under writeback / attached to the running transaction), and
journal_shrink_one_cp_list() can therefore hold j_list_lock for a time
proportional to the whole list length, for two reasons:

1. The JBD2_SHRINK_BUSY_SKIP path uses "continue", which also skips
   the need_resched() check, so the scan does not yield even when a
   reschedule is pending.

2. The scan budget (nr_to_scan) is decremented only for buffers that
   are actually freed, so busy buffers do not consume it and the loop
   is not bounded by the shrinker's batch at all.

Both were introduced by commit b98dba273a0e ("jbd2: remove
journal_clean_one_cp_list()"), which folded
journal_clean_one_cp_list() into journal_shrink_one_cp_list() and
dropped the per-examined-buffer budget that the shrinker previously
had.

The result is a self-reinforcing collapse: shrinker instances across
many CPUs hold/contend j_list_lock, kjournald2 cannot commit, the
journal fills, CacheFiles lookups block in ext4, fscache cookies get
stuck in LOOKING_UP, and netfs I/O times out.

Max Kellermann (2):
  jbd2: check need_resched() when skipping busy checkpoint buffers
  jbd2: bound shrinker scans by examined checkpoint buffers

 fs/jbd2/checkpoint.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

-- 
2.47.3

