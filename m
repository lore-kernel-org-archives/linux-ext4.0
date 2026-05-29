Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D863A9625
	for <linux-ext4@vger.kernel.org>; Fri, 29 May 2026 08:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780043694; cv=none; b=VLoQ7AMeAolj73dfaNhbSFPFwL1bTsevvnJhGU/ez/mf5/NJIvGcpwpTZd1t/l+eHZCsxKQtl7V4BGTa1P13G6+TEfHMBNK5S5DJro3MJWsOzSrOhBUDltCVDsIf1kP8A7Iz7gQ0sxEd9f/gCO9qhHb+lZMOuJMPDsqa7zkb5l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780043694; c=relaxed/simple;
	bh=VoTk959RKC7KR6OdCa80Copb59WxI2zh0IrP/MSHewg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=quMPH/O+E4tlAX77H/uBlg8eQIDOUyM2FL3dcYIUu8lpu5Xe+mU/oDyACGvSjONalLpknUzwy3JMNlXFUrQ5ynwQXT/jh8TMqiYt756lPRn5JyMPzsUlcyb/3NnvsTbXT0X3N3UJKTxVPrD9hGop6I6yz1upxsH4grCSTCQOZEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mdSok+dc; arc=none smtp.client-ip=74.125.82.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mdSok+dc"
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-304df7ff4c2so763972eec.0
        for <linux-ext4@vger.kernel.org>; Fri, 29 May 2026 01:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780043692; x=1780648492; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=assWDAQinq786qitYHFd4ZWsA7lCv/W1SFzL/FQ0AdU=;
        b=mdSok+dc4+HiDUAdiMGjjO34RUzPdA5N6X2GvtqaP5tUDMB3kw/vHRsLdlZKmtvGNU
         lt+1eOpWIsU8el3zqzbVP0cWwcHTjo8xuDHoexsI906mK0takdcAS7kFR+561h5+kHyS
         d9D/IFLrXxYkUmLKz7iyNQYUwb5AIJ9b1r/EVRXLv28Tp1Z/Yf5NymmzGhqbRY3FgL+H
         Wnpzw95bvJMYmSbD21H+RQp8OAuMv7DzAKipjo1OrtBKGoQbIsIy3CUao75ReIqf3q6u
         4RNja6fWSWhtbq3lfhaxhSxobN3M7lazMae4y4t5RKBzduMx8F+a3YWOhQ7BQXOXLPzC
         U2Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780043692; x=1780648492;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=assWDAQinq786qitYHFd4ZWsA7lCv/W1SFzL/FQ0AdU=;
        b=mQE8tfneb/omF6mys6fwyThbLT1Y4CjSyJkJUNHoL/hpfQ18nj8o9/DI1UGFStEWOg
         FL4VNeEjMGjv0Ax/9gYZ6N1yPkYNWc9Ze8mam1KbtS478BTxweQIsl9hHvQUYg2PKkC6
         wV7dXW9yiB+/HdicSFwK0VyjfvNH3GohHGXCL/Vy+1j2WbGRCB33Buoc5RwMFL9KS1WK
         f3OLfqyMDAben37aZSBzWCfrr6UD9PH60DrMnvpCSoDt9UvZp7KWWDOVgLum5s6Ap41X
         ZIUV0KQg7fx6V3WZad+YD86T9uLcYWRJYAw39w69h740juUtP7AiMxkW8mjBuyW9ZCYm
         RbIg==
X-Forwarded-Encrypted: i=1; AFNElJ8o1JgmyzYBiUEywsLDvk7nWFvvwpEzE8Axf+pMpv31fWZPUs2JZINXjJsd0cqabONVwoPgSUGojX2l@vger.kernel.org
X-Gm-Message-State: AOJu0YxJY1ypDxPI/Vevznd7baj2fmuao8oTPwdOoSQ372kbfMWtYTmb
	Xo33w53S8f/Gm97wsDKDGlObUFdrnEG41D9nhlUnd3cGKlHNc3CW78tK
X-Gm-Gg: Acq92OFYxLnseRAn49i5JK7BTBc+Q1WBomnyVbSHNc+3eEy5ZGNY9FHr7fLFZcOmEi6
	uM9yekaF6tyU8262/deecmM33/Vb2wtDZlW57lFqyDKu79XMyEsv47piyK6zGS/NTd5etMi+xJM
	K3sjVUyqLiHoeEslb2P6A7XPi8pFPIqgqh7T9qlafYf64ruXzpYx0WMgf7Kl9JqIg4f0NwjFrXj
	OtIni1TI410uPfgMl0n2wNVraTRSQtSvtByyetj4U2NQe3kNB2XDKElT1adTwIcQmcxGyIBLmic
	w0vT6cuT8cZt6ctB0imTKOTHunkH50RAB4WUTkAhyFNLf8te/9ciO5vnE3nFPdRFoOU2tcKVMH8
	t0YjlYrWrsNl083mH51082AjxKTp6CrhD1HopzNtK01viFS3OZYeK+M9tAvXgl5irGbLpOtdai9
	wh8Z095Kv2dUvqs+poiBdKr6nCta3xEkOJVZGLAtCf
X-Received: by 2002:a05:693c:6087:b0:2da:13c6:f27b with SMTP id 5a478bee46e88-304eb0cba12mr668899eec.5.1780043692441;
        Fri, 29 May 2026 01:34:52 -0700 (PDT)
Received: from wujing.localdomain ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-304ed130dafsm896744eec.0.2026.05.29.01.34.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 01:34:51 -0700 (PDT)
From: Qiliang Yuan <realwujing@gmail.com>
To: yi.zhang@huaweicloud.com
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	ritesh.list@gmail.com,
	ojaswin@linux.ibm.com,
	libaokun@linux.alibaba.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yzjaurora@gmail.com
Subject: Re: [PATCH] ext4: fix quota accounting WARN in bigalloc punch hole
Date: Fri, 29 May 2026 16:34:44 +0800
Message-ID: <20260529083445.101050-1-realwujing@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <73e91ebd-27de-4834-af2f-9b4ac19a4100@huaweicloud.com>
References: <73e91ebd-27de-4834-af2f-9b4ac19a4100@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Zhang Yi,

On 5/29/2026 3:32 PM, Zhang Yi wrote:
> On 5/28/2026 6:21 PM, Qiliang Yuan wrote:
>> __es_remove_extent() -> get_rsvd() already correctly excludes
>> boundary clusters that still contain delayed blocks from resv_used.
>> Adding pending to resv_used double-counts those boundary clusters,
>> erroneously releasing reservations that are still needed.
>
> Hmm, the analysis doesn't seem correct to me. Do you mean the
> following case?
>
> # Assume the cluster size is 16KB.
> xfs_io -f -c "pwrite 12k 4k" /mnt/foo
> xfs_io -d -c "pwrite 0 4k" /mnt/foo
> xfs_io -c "fpunch 0 4k" /mnt/foo
>
> During the direct I/O write, quota space will be added in
> ext4_mb_new_blocks() because the EXT4_MB_DELALLOC_RESERVED flag is
> not set. Therefore, in ext4_es_insert_extent(), we should release the
> quota reservations, since this cluster has already been allocated.
>
> Then, in the third operation (punch hole), it will reclaim the added
> dqb_curspace. This should not cause an insufficiency.
>
> Am I missing something?

Thanks for the review!  Let me explain the issue with your specific
example.

After step 1 (delalloc write 4KB@12KB in a 16KB cluster), we have:

  ES tree: [0,1) hole, [1,3) delayed, [3,4) hole   (blocks 0..3)
  Quota:   dqb_rsvspace += 16KB (one cluster reserved)

Step 2 (DIO write 4KB@0KB, RWF_DSYNC):

  The DIO allocates one cluster, but the mapped extent from
  ext4_ext_map_blocks() only covers the written range, e.g. [0,0].

  In ext4_es_insert_extent():

    a) __es_remove_extent([0,0]) removes the [0,1) hole entry, but
       there are no delayed extents within [0,0], so resv_used = 0.

       This is correct: the DIO extent [0,0] does not overlap the
       delayed region [1,3).

    b) __revise_pending() scans outside the newly inserted extent [0,0]:

       - Left boundary (block 0): the range starts at cluster
         boundary, no blocks to scan on the left → no pending insert.

       - Right boundary (block 3): blocks [1,3] are outside [0,0]
         and are delayed → __revise_pending() inserts a pending
         reservation and returns pending = 1.

       This pending reservation means: "cluster containing block 3
       still has delayed blocks, keep this cluster reserved."

    c) Then comes the bug:

         resv_used += pending;   // resv_used = 0 + 1 = 1

       This causes ext4_da_update_reserve_space() to release 16KB
       of quota reservation (dquot_release_reservation_block()).  But
       block 3 is still delayed!  Its quota reservation should NOT
       be released — no blocks within [0,0] actually used the delalloc
       reservation.

    So after DIO:
      dqb_rsvspace: originally 16KB, now 0 (incorrectly released)
      dqb_curspace: 16KB (from ext4_mb_new_blocks)

Step 3 (punch 4KB@0KB):

  ext4_remove_blocks() sees that block 0's cluster has a pending
  reservation → calls ext4_rereserve_cluster() → dquot_reclaim_block()
  tries to move 16KB from dqb_curspace to dqb_rsvspace.  But
  dqb_curspace may already be insufficient (depending on whether
  other allocs/frees have happened), triggering:

    WARNING at dquot_reclaim_space_nodirty

Step 4 (delalloc writeback of block 3):

  ext4_da_update_reserve_space() → dquot_claim_block() tries to
  move 16KB from dqb_rsvspace to dqb_curspace.  Since rsvspace was
  incorrectly released and not fully restored by the punch hole's
  rereseve, this triggers:

    WARNING at dquot_claim_space_nodirty

The key point is: pending from __revise_pending() indicates clusters
that *still contain delayed blocks outside the newly inserted extent*.
These clusters' quota reservations must be preserved — get_rsvd()
inside __es_remove_extent() already correctly excludes them from
resv_used.  Adding pending to resv_used double-counts them.

I also found a pre-existing retry loop issue: if __es_insert_extent()
fails with -ENOMEM on the first pass, resv_used carries a stale value
back to retry and could be double-released.  I'll include a fix for
that in v2.

-- 
Qiliang Yuan
