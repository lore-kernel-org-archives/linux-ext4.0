Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC5237AA7D
	for <linux-ext4@vger.kernel.org>; Sat, 30 May 2026 07:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780127234; cv=none; b=edMEp42WBIki/tp539nUNK1/MgBdT3H4CYX4fkvHLpvf48bQxpagjJe8kb2OljSv3XfJ6Tb4N3Uka+rUQqsieDhG3h6VZNpfAjevfBLk8/jq84/BynO9/6vsS5rLvWqLkKn0RC9ndXm0szryDjhuwxqcQNY00Qju6c3SAjbVtmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780127234; c=relaxed/simple;
	bh=F5IMlNggYjLXo83+1w9ktR79eh3CKKiLOGOVC5ryB2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bSgUEQRspGVLfQJjjrZZ3igCKzOmw/ye2bfGymEGUcbgx5t70H7z8/6qVnLx/zMDUlm8cZdHkEhrPzbFDvZXuOTiYncRq64qbu/POEMF8p+Of1PRF6W7Vxd1twO2FESydRhJ3Cry+suiIWuwNZmiJKv0rGkxJi/rNkHglVSxpq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jbHyl/6m; arc=none smtp.client-ip=74.125.82.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jbHyl/6m"
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-304d8e3bb72so2325240eec.1
        for <linux-ext4@vger.kernel.org>; Sat, 30 May 2026 00:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780127232; x=1780732032; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pH/af+W6r5ntn/mqPL5Kog4gRXS+gR9CcdvVgEuZG2g=;
        b=jbHyl/6mEboqCloVErJK1LXyX11CZJH3ecO6iKz9BTjUnrroFvsrxAnTYxAkCsq0wT
         x2wjfhn47F12T9UmKsSpu9dC9dPmJIecuBfew15xH1V7KbnWO/BeyThDYuorSb9J2zNq
         XQz/LUwILTuV4NwgFNL2LuWXEEElRUU9RlfqhD5gnvcGkDaUxz2TIrqXiidNR2IYCeDi
         xj22wGVFWlh9o8ADGWYFT8cmweOH5xYWd/xizIIQL+Evz8Leg2TVap/baIidpfSGkpo9
         CKjNL8MvFWzEGsrpyix8lZdZgCza2hDEiSkZ/IuwmxnPW56G28NCT2uFeKSDbqdSiqbC
         eqHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780127232; x=1780732032;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pH/af+W6r5ntn/mqPL5Kog4gRXS+gR9CcdvVgEuZG2g=;
        b=AKexf/UabuLeD5779Ov0a7b7zsnp/FRlgLLx4j/28Xy9WyBf4zH8dlthHJTs1D8n2t
         +zKO4hpNoCtOEmtiv3JoIvsoNk4WTWDrwTguC5mq6RSNC4Tk2qNOigCdDgduRrO6tTn5
         ePNPQuZgxfrbpceq1XX8C7dYIhdSXnA+TEU4NxnP8eCrX067apmoK/K80YxixnHK2w9N
         IAVAiGQmtAV3pSEp/D68+rClhNUr2kw8kL+PXxwYbqd9ZLXK09J6SnIrBdQKoudVw+I6
         jZLpfb5ga9MPI1qxYSsTF2HHjD7bmr7P5Dlr06xI45xjj9jyStBawTuP5lLDoMtAY228
         xMQg==
X-Forwarded-Encrypted: i=1; AFNElJ+pJn/+il9BmrTR/pT8psYfgPebEvObcptyTqaFXu/q3IKafCuaSsvhNQRLn76ApzcauTLXnqq5olgz@vger.kernel.org
X-Gm-Message-State: AOJu0Yxy4/L+C+pYCzUhiT75cAN0NP0qc3Jf2TcI9T3VKYN98i/cRgDW
	ERMiXMF8bXx8fqO9c08fSXUegjFfcSXIcymq2PGSc1K3ZY5SExJTi0/S
X-Gm-Gg: Acq92OGnFgyfthGq8QJknF3v5DY8IEsQT1uh3nuNw+KmIBGwVcWayBg71zaJyseuT+D
	GxouYO3b4C4S5xCwIgn6hJUCGxB6pGyBrk9qluwRpckP+ODwKfiJqlhqgGoC8DpITuyf5HqsN0R
	kDtogjE6kyU7Ua60P8OiJsB9xmdnZOzXZiTJB6tt9AMZim4DGerULvcpQhDHqUW0XYJfdT7d+MM
	KXTRFPQAUDJrOnkS2NpANmKTh8+j8kjaC6isKuc+SHiDMNl6wYmC5hDFlCoG5xbbSQt+jVNmVoK
	pdo0pSpe6KdWjj95aaG6tvxll5yxwesH4wYQpm28DDwToEwxf6/yt973jvzrwPdenVlwNy1NcrC
	yV6f//F+K65rW9OLZwydQ/zkQC5s7xaKAn2xVIk0ofIPUOr8NTa/Kf/rZLt2cTFqz9NEZhXhx26
	mE9SmVBvmkyehoVmup0B1ItuewhYdRK0MFoZGaBdDh
X-Received: by 2002:a05:7301:2926:b0:304:d456:fca4 with SMTP id 5a478bee46e88-304fa67e7acmr1510250eec.21.1780127232384;
        Sat, 30 May 2026 00:47:12 -0700 (PDT)
Received: from wujing.localdomain ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-304ed2c312csm3651601eec.6.2026.05.30.00.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2026 00:47:12 -0700 (PDT)
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
Date: Sat, 30 May 2026 15:47:03 +0800
Message-ID: <20260530074703.74091-1-realwujing@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <9cf8569a-4f79-400b-ad80-197decec4b15@huaweicloud.com>
References: <20260528-fix-ext4-bigalloc-punch-hole-quota-v2-v1-1-32871356273b@gmail.com> <73e91ebd-27de-4834-af2f-9b4ac19a4100@huaweicloud.com> <20260529083445.101050-1-realwujing@gmail.com> <9cf8569a-4f79-400b-ad80-197decec4b15@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 5/29/2026 6:37 PM, Zhang Yi wrote:
> On 5/29/2026 4:34 PM, Qiliang Yuan wrote:
>> Thanks for the review!  Let me explain the issue with your specific
>> example.
> 
> Thanks for the explanation, some comments below.
>
>>   ext4_remove_blocks() sees that block 0's cluster has a pending
>>   reservation → calls ext4_rereserve_cluster() → dquot_reclaim_block()
>>   tries to move 16KB from dqb_curspace to dqb_rsvspace.  But
>>   dqb_curspace may already be insufficient (depending on whether
>>   other allocs/frees have happened), triggering:
>     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> How exactly did it happen? All data cluster allocations are precisely
> calculated. In addition, the current example cannot reproduce the issue
> you encountered.
>
>> The key point is: pending from __revise_pending() indicates clusters
>> that *still contain delayed blocks outside the newly inserted extent*.
>> These clusters' quota reservations must be preserved — get_rsvd()
> 
> Whether to reserve a quota is determined not by whether there are
> delalloc extents left, but by whether there are only pure delalloc
> extents in this cluster range.

You are right about the simple case — I missed the ext4_clu_alloc_state()
logic in ext4_insert_delayed_blocks().  When a cluster already has
allocated blocks, subsequent delalloc within that cluster does not
increase rsvspace, so releasing rsvspace after DIO allocation is
correct there.

However, the syzkaller reproducer's scenario is more complex.  It uses
three operations:

  1. DIO write at sub-block-aligned offset 0x6400 with RWF_DSYNC
     (pwritev2, 0x140000 bytes at offset 0x6400)
  2. Delalloc single-byte write at offset 0x8080c61 (far away cluster)
  3. PUNCH_HOLE from offset 0x7f covering 0x8000c61 bytes

The DIO and delalloc are in different, distant clusters.  The
sub-block-aligned DIO may cause it to fall through a different
code path — possibly zeroing or partial writeback within the cluster
boundary.

I'll instrument a kernel to trace the exact rsvspace/curspace
transitions and get back with concrete numbers showing where the
mismatch occurs.  This should settle whether the root cause is
in resv_used += pending or something else.

Thanks for the detailed review!
-- 
Qiliang Yuan
