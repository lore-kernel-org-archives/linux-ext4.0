Received: from server02.seltendoof.de (server02.seltendoof.de [168.119.48.163])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232B034B40F
	for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2026 20:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.48.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790626952; cv=none; b=J/k/a4Prp0UjJ40+MXEAxbROMLMz3iZXhtlKlkuKPB4xLGPINc1ugC99NHDgH4LifoFhleE+rIoF0jQq/blDzWLcpB2cjDGmVZ3RCr+PmRMI6I4HqJ3gA9x3voSd1Aj3ihI2MK4xuh8GZi/Bn2NV11du+9KM2bNJswbIh0eumDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790626952; c=relaxed/simple;
	bh=0F1W1IX7QWMli4f0o7/O5vBFXX34uwyRKDBfUQPF+pE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MAGB1/Pm1kcEJ1AKfQM4E6qD5eb7ujELRnXK4FkTDLz7dEHk4uFoK7PbaPiFfON5wO9K08SS82arAtwFAUcL/Rq49NcyvPlxEyj5DwOMmuDpg3VDCeLbMYJjURNiy/VrSwPGU6qNYLIEBhe5MGzA5KBmh+A0OHj1H5Winf41LXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=seltendoof.de; spf=pass smtp.mailfrom=seltendoof.de; dkim=pass (2048-bit key) header.d=seltendoof.de header.i=@seltendoof.de header.b=F2TwqQ2M; arc=none smtp.client-ip=168.119.48.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=seltendoof.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seltendoof.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=seltendoof.de header.i=@seltendoof.de header.b="F2TwqQ2M"
From: =?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgoettsche@seltendoof.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seltendoof.de;
	s=2023072701; t=1790626947;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
	bh=YTvkukAuga9o9xsThrzpGJi5V+hiBD0JKNpHLT6mKNg=;
	b=F2TwqQ2M2Xn7wGJvzOqQY+QqVRS/7h61eoIPLUbQ+YKLrQfDOp7alkYGJWzmFq77OvIrp2
	jy0vKxz2ECNJE34uV/0lPJ9+hZWfRA50yEbbt7xkiNy9J2LrkHbZGzwOa/lajIqSnoGXA3
	pgo3ufM+pC1Bstlb7JR3ZaOXTgdYXb7NZMcU7Z7eJpQ2E50cOZ5XlLOJ+gPgfhjhOinntC
	W5afpTLIP+ti7E2o6zjVxojGWETmzqeiy1F9VtUjuakzhLq00iwFViIKEYx28LPZEAuAQz
	xC7Qy4/yRLd+oCCA1qcN1C04v+QKUg7JtV2lqCWg+kZQbWwIC22vJOvWUfnKPg==
To: linux-ext4@vger.kernel.org
Cc: Jan Kara <jack@suse.com>,
	Theodore Ts'o <tytso@mit.edu>,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>
Subject: [PATCH] jbd2: set JBD2_LOADED under j_state_lock
Date: Mon, 28 Sep 2026 22:21:59 +0200
Message-ID: <20260928202159.2463182-1-cgoettsche@seltendoof.de>
Reply-To: =?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christian Göttsche <cgzones@googlemail.com>

j_flags is protected by j_state_lock, with only quick racy checks done
without it.  jbd2_journal_load() however sets JBD2_LOADED with a plain
read-modify-write after journal_reset() has already started kjournald2,
which tests and may update j_flags under the lock.  KCSAN reports this
while mounting the root file system:

  BUG: KCSAN: data-race in jbd2_journal_load / kjournald2

  write to 0xffff9c6b012c6000 of 8 bytes by task 1 on cpu 3:
   jbd2_journal_load+0x279/0x3c0
   ext4_fill_super+0x34dc/0x5740
   get_tree_bdev_flags+0x21d/0x340
   ...
  read to 0xffff9c6b012c6000 of 8 bytes by task 77 on cpu 0:
   kjournald2+0xc8/0x3e0
   kthread+0x1bd/0x200
   ...

  value changed: 0x00000000000000a8 -> 0x00000000000000b8

A concurrent update of another flag, e.g. JBD2_ABORT, could be lost.
Take j_state_lock when setting JBD2_LOADED, like the other writers of
j_flags do.

Fixes: 470decc613ab ("[PATCH] jbd2: initial copy of files from jbd")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
---
 fs/jbd2/journal.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 00f5a98f3d4f..fa91093a2284 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2091,7 +2091,10 @@ int jbd2_journal_load(journal_t *journal)
 		return err;
 	}
 
+	/* kjournald2 is already running, see journal_reset(). */
+	write_lock(&journal->j_state_lock);
 	journal->j_flags |= JBD2_LOADED;
+	write_unlock(&journal->j_state_lock);
 	return 0;
 }
 
-- 
2.55.0

