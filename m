Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F4A34DCFC
	for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2026 12:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773490736; cv=none; b=aRpFfELeOFY8CMgmnjjn2d32nYzPuziKXB9JVRwKIZfe6fGkkRLvxIJkScCU61GSNnqKT5KOPllP1tn4bzWdzKludYo92ozEo/Lo/rCHy8BvyITgPUHbDBBTrUA6R7x1MK0dDUnyOraXWl36Ul6v8FTgKN0iPFY82jHZv6tU/Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773490736; c=relaxed/simple;
	bh=RDYvSZNdyhUJN7CzAZF0cH5j45MA2Olo808XyfEpkrs=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=YkJDdN4yywMR52UEKeZ9CbfMFLBvOB3GPVIN2yEApvq9IufFBE7l6eGhUNFRbUrH5a12YkHftRCHOWPbWSjSKXuasceikFalGeP6QQhf03ODjB6/tLJUwbyM43lWU+FObQN+UzgCzNbCWisexBSMvwWNCTmBiCojJ/XEbhglGP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BNm68MNj; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BNm68MNj"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-35a1dd9c842so1335545a91.1
        for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2026 05:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773490733; x=1774095533; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DnnrgrDndGstE0RJoYedutPL7k/iDXUtrXWuwbvkIo8=;
        b=BNm68MNjRyDA81e2H3+/eIXszOW1i4mVz0VGqZ48SkIs0UbF+YQBl3F3ffjegRfykN
         6MSOW3p28j6dFNNjw4xGU4B9nwETL8jeNmlOT9E/z4sIHiv3HE632fesS/ReitJrSvTC
         jmRHOzJqBHKx+2ZUpDASq2WozIu36gNCsFuacY0dv8qbdqg63HEa0lSeZHBoyO2rZm50
         gv/FIDDk8jCRp6JLwR/l6ogttfHdnnD8/cILdSOcw2R9oGHhRcwNSG646KrMN3jL0Ucd
         uJjsnlKDWaYYSbWcY+SM+/VuroVQzeQjv4LIoN6kdPn7c528WqwzDEP2vP2pqtCDbXkH
         9C4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773490733; x=1774095533;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DnnrgrDndGstE0RJoYedutPL7k/iDXUtrXWuwbvkIo8=;
        b=qvaj9FfO6Qd2D+/sc4pGdO4jIKtSL7JYfoY0Tn29n3JK/h5JI1mWQqoCQXhxPhnSMH
         G0aYMLCrB9U0UhCDfRWk/9yzQtH3ClFGau+dF88sCw122w1oWPfyiv8mfsJDRNzMrCPC
         m6ORVnrmMA0FtbW8T2UfZuSL8Uy0FoOMQ/EjlE89HusQVs1I8yb85g67kElgd1WREQOC
         qfequdvcKA24LnII8BkTdIFq/5/WbzCIppRG7ZaH0t/OK53nai+cSUngVuAntZaD4P8b
         Qnp/bW7TER/oE636E3bMrN1SjplaDOWB4QT5e3rllWiDmMRCJXWPBa7Hqy3Fff1f2rVU
         gbYw==
X-Forwarded-Encrypted: i=1; AJvYcCV/rHnTSr+k/Sy3EN3jWoFMrD/PMxHdsUaRX+loFWdPmSOi32GUCPq+bzSWm7FL9kMG9lTpqLvd3Ybz@vger.kernel.org
X-Gm-Message-State: AOJu0Yx95DoiSGvr6sWTDz2Hy+NFbCSWtC1wPkUnbAPeGMh4A87tzM2n
	vXxOTwieV51FGq7GYJDrnF0WYqc52SMF6bEWnSI6xDbR/2UkvRpbSxbu5Hb1TB4Q
X-Gm-Gg: ATEYQzwcFwNjlL0OxgvsrATeFUG/jfc3gifQ9Ei84V3bzDi9b/8k3eGFU7TV3WEJi06
	bIKLeccLtSyxSyUJF8gIfYAscuVZZl5FgKNbgf6CRmXU/Kloeb7pjRm7LP9yP+uLWclvaO7ERH2
	QIzNqUoAv2RgLDymaCe+G4VJsdZ/xvYITJYdZsP/cxbQUyDjL3iLc6tB47ImQNqMPplxDkWhTj6
	w3xJj4H79xnaKp95g6oHpTKz4MQUXvU/WCyPyGdES0EXFkn49F9yCC7/Wsi8Ya2/+4uIv+mEZi2
	N8/8bEqXHNrlWE7g3kXQHOlJJZQTDD1xGdqNKEc5aO2nR1KIuN9ehZ7U6i7f4w6fc/25WAIUPhX
	pQEJKhm3AZn6KYVhnTVTNxSZbmOzD0IHY6nkY6vaGyE9hD2LpxEcFHcZlDS/L8sdq4ahcJManHP
	wxwmfWCnUTWc/nnIFaJvVa5w==
X-Received: by 2002:a17:90b:4a46:b0:34c:35ce:3c5f with SMTP id 98e67ed59e1d1-35a21e38ea7mr5653542a91.5.1773490732817;
        Sat, 14 Mar 2026 05:18:52 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35a02fca40bsm14675769a91.10.2026.03.14.05.18.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Mar 2026 05:18:52 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Ye Bin <yebin@huaweicloud.com>, 
Cc: jack@suse.cz, tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v3 0/5] Fix some issues about ext4-test
In-Reply-To: <20260314074903.1314851-1-yebin@huaweicloud.com>
Date: Sat, 14 Mar 2026 17:34:24 +0530
Message-ID: <ldfuty5z.ritesh.list@gmail.com>
References: <20260314074903.1314851-1-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Ye Bin <yebin@huaweicloud.com> writes:

> From: Ye Bin <yebin10@huawei.com>
>
> Diff v3 vs v2:
> 1. Remove three patches from this patchset:
>   ext4: fix mballoc-test.c is not compiled when EXT4_KUNIT_TESTS=M
>   ext4: introduce EXPORT_SYMBOL_FOR_EXT4_TEST() helper
>   ext4: fix extents-test.c is not compiled when EXT4_KUNIT_TESTS=M
> 2. Fix 'sbi' leak as no "sbi->s_sb->s_op->put_super()" registered.
>

...and that this patch series is based on top of [1]
[1]: https://lore.kernel.org/linux-ext4/5bb9041471dab8ce870c191c19cbe4df57473be8.1772381213.git.ritesh.list@gmail.com/

I think you also missed to take few RBs from previous version. But never
mind, thanks for sending the fixes :)

-ritesh

> Diff v2 vs v1:
> 1. Fix compile warning when disable EXT4_KUNIT_TESTS for patch[1][3];
> 2. Remove reviewed-by tag for patch[1];
>
> Patch [1]-[2]:
> Decoupled mballoc-test and extents-test from ext4. Patch [1] does not
> have any changes compared to the previously released version, so the
> reviewed-by is added.
> Patch [3-7]:
> Bugfix for extents-test.c.
> Patch [8]:
> Bugfix for mballoc-test.c.
>
> Ye Bin (5):
>   ext4: call deactivate_super() in extents_kunit_exit()
>   ext4: fix miss unlock 'sb->s_umount' in extents_kunit_init()
>   ext4: fix the error handling process in extents_kunit_init).
>   ext4: fix possible null-ptr-deref in extents_kunit_exit()
>   ext4: fix possible null-ptr-deref in mbt_kunit_exit()
>
>  fs/ext4/extents-test.c | 54 +++++++++++++++++++++++++++++++-----------
>  fs/ext4/mballoc-test.c |  6 ++++-
>  2 files changed, 45 insertions(+), 15 deletions(-)
>
> -- 
> 2.34.1
