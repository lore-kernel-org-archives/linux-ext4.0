Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792679363;
	b=gxCUVlE731BeOSG98Fu5hBb5+NkONoTsyiV/W4/cH/o27dmXvfB/SYgr2unZbcWdRKn8
	 3nbI40ZjK/mihmS+EZmu/9ihzScgqAkVa02BWfpBTMMgMRoAHcTCc5mjkx/RdkUSXiCOj
	 2LNZY9qzbgn4wlyF0H6QTJ7RzTiuRgc6rr/VBGt8vy8j4aS9jzgKuCAi6iOd4GP+aHMlJ
	 4hh1w2jq0m0hBPTpb2Fz9dzlCQeJT4bUdtbxdwTatzvDgR8ZfiFqhVmCuANjg+m7t34cB
	 0kSd2m2iqOcA0YEEC43PT+d7cRj4bRLdtMsHs3outkgph28Y5Fv7WUhBOcZRI8XjXFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792679363;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ip3LDVkz43JVMLeEy65y5DnSL95eKEKIg6rsimQU6Ow=;
	b=U8JiE1m+I8Yg2aPczcD4Zohgu9vs7QpKRXuee5rMiZiIS1ix5iL278ZzsF9fv6ajvBRN
	 NsF3KSx5aP0DgHmDKsY/kGBYyy4rhsvuUN+iGSOzvDZ2wlr1Jpl5WywVngrQ4bfJzK+O8
	 rjbKRPL+vM8wewTnJ7tUof7D6SBBfy7vP9gT2G8PyuskeYGwBvgUqhrKGL8vy3blDYh0K
	 f8TgfRAcmGJTX41Ubg+uh09FVT26RNf3Wf+U5aryzPqb+xWG5apsQMuN+pJLxyfJageM5
	 JFgjtOnbMIKMSexVIc0DF2FLlzKL4uulI5fOM2TC6yMmmH9UwkTvKMy+CpFOP13XSkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cs.unc.edu;
	spf=pass smtp.mailfrom=cs.unc.edu;
	dkim=pass header.d=cs.unc.edu header.i=@cs.unc.edu header.a=rsa-sha256 header.s=google header.b=Sh3VG5SY;
	arc=none smtp.remote-ip=209.85.128.172
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68BC606A32C
	for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2026 14:29:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D68BC606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cs.unc.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.unc.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cs.unc.edu header.i=@cs.unc.edu header.a=rsa-sha256 header.s=google header.b=Sh3VG5SY
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-8b0e21048f8so18566277b3.0
        for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2026 07:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.unc.edu; s=google; t=1792679362; x=1793284162; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ip3LDVkz43JVMLeEy65y5DnSL95eKEKIg6rsimQU6Ow=;
        b=Sh3VG5SYS86Y/cUu48NcOpZrlstcwtzOP6oDtt0f1lj8SLeLI5pZWs7o+SIp4ix3oT
         5SggpjHjZ7iWCohx4alswx4ieJz3fvs2sb977apngl3IBzprzk4ulKjhiMFuN6ydLzPY
         u+OpLY/nMxUyMt/PFrFzJImPdTz/mxUyUWVNKGrEISFLs6U1C1IZZV7uuawmXExSMTo/
         fLl4ztuQw5RQXnLf6jlBAC9GycJ38e4qI3pKMz8GHe7RDB8g6Qib28eKU+J32wqwYyK5
         90VRC7sN7POAsHt2h6PjNVLCGTBMGFJ/5KOAClc+KKEbaLuUeqK6opKhBmbEwfSp6jMU
         PbbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792679362; x=1793284162;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ip3LDVkz43JVMLeEy65y5DnSL95eKEKIg6rsimQU6Ow=;
        b=Y5t3t02z0/Uxooi31RdJ0gJNQZVJ5rf3kesTm/9oU75tdIACjMV3Z0VUB672bqP450
         pZvLt3usAUqvaRSf6EI2nGCUBZgTNJU5qWcgpUAr75yrWTYeLmSsz4hDiCHN5c17nDQh
         RSgtRrykEasY7dlhmzobRIKQcP1Csur+TOcFice9MWys37x957Ajn7vLzBqQyLeP9SZb
         9egWQ3qjQ5ZEuJ0infoYQ8xAMvTZGyWh/UcBkwN/awV/UObG/yWMJkLSc5ieeh6C6H6A
         Ap3hCZ9cKsqySkyBXvFzkUIPZ75IX0QHEObK5rDlODyyjVqlm5nzA2bcHaKQCMpLZMkS
         TKoQ==
X-Forwarded-Encrypted: i=1; AKwUvBzvntGohumdBhm9WZFi6P9OnfkgDNMzTAiDu26ZvDif/zk5EWpKh7Nv92tZhcUFUdVqn8l0eC1E0oyj@vger.kernel.org
X-Gm-Message-State: AFq9FYJcRslg6YCiJo3qCXeWmesO0jeBse3sQNyVphX4PbFsGZIgK0Sp
	zJxDiE8koMgJZEdHdCW9/sUUa/Gat7Ax/i3XYeQGAkzMSprRKPreveZEZ2K23Dvl6w==
X-Gm-Gg: AYBFou12TIzw5VHNi7peyYSA1jU2UtCx7tw1inrBvvyADWrpeDCEQczUiQVeZL2Rdoi
	vQBprDfNtWBRPm3eBY33/auMhjCuL1YH4xQ1vDv6wxSBeXxHg5rGeGV/07jmbbq6d806tPdpVPV
	6jIKf5ancuLECWHMB8gPXhZQsTWwNXAqbRE334srnmjiWMYr4fOxKtJpxSyGpvrS3X6podo4smB
	TCjZQwA+B8FmQgOoQe7PKthimfxuAQY9V8i3CzxyvFVCQ7nPCkav5hXxVOLmWI3jSWuVBufQXYd
	mFWPWWkhQ96MqRNJ2TexD7zNruBggSICE9z3NnArAbS6b6bVe7dTpr1OZ1j6hSZ+WuV0Im8SOj6
	yWhihRMLxdKWG5YDwbwz0HkX1C57fDEdCudZkZR0OTCKpFWlUHaAH5C+98Xdvnj1iqCVZlVVeW8
	pOOUhfXFpWYeEWvDnz7B/MrrcdUAk5lazfGVWT6VLtKWXNso1Sw2I5fwbizG9QkwfNzN2smr7X2
	nze+MJ02k/yuja/aqWCQuINVIIiUpX7ua73sevK/b9EYzNl6m9SJsKEiJD8UaBIhmdHfRxAIktF
	J26yh2eQU97xiG7cq1teF90p
X-Received: by 2002:a05:690c:6603:b0:8b0:a171:65e4 with SMTP id 00721157ae682-8b133f979ebmr36772897b3.15.1792679361535;
        Thu, 22 Oct 2026 07:29:21 -0700 (PDT)
Received: from cobra01.cs.unc.edu (cobra01.cs.unc.edu. [152.2.130.143])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b1300f3cfesm27329767b3.27.2026.10.22.07.29.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 07:29:21 -0700 (PDT)
From: Hengyu Liang <hengyul@cs.unc.edu>
To: jack@suse.cz
Cc: tytso@mit.edu,
	linux-ext4@vger.kernel.org,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	dave.hansen@linux.intel.com,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] ext4: do not advance i_size on a buffered write that copied nothing
Date: Thu, 22 Oct 2026 10:29:11 -0400
Message-ID: <20261022142911.1490979-1-hengyul@cs.unc.edu>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <34dtkdstf5yxg2ulinnh4hocc53gz35ij6k62egi2ykgpyc3a5@zuxt6doiajwq>
References: <20261009044656.1993196-1-hengyul@cs.unc.edu> <34dtkdstf5yxg2ulinnh4hocc53gz35ij6k62egi2ykgpyc3a5@zuxt6doiajwq>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Jan,

On Thu 22-10-26 11:48:35, Jan Kara wrote:
> I agree with the problem but first, Ted has merged rewrite of ext4
> buffered IO path to iomap your fix would very likely need rebasing, and
> second:

Thanks for the review.

In the ext4 dev branch, the iomap buffered path is only used with the
new buffered_iomap mount option, and it faults the source in before
->write_begin(), so it does not have this problem. The default
buffer_head path still does: on 8c4f6e337634, a 100-byte file still
has a size of 1048586 after a failed pwrite() at 1 MiB + 10, sync and
remount. The patch applies to the dev branch without changes, and I
will base v2 on it.

> this is wrong and would leak delayed allocation reservations AFAICT. You
> should just use ext4_truncate_failed_write() like e.g.
> ext4_da_write_begin() does on failure.

I don't think it leaks. ext4_es_remove_extent() gives back the
reservation of the delayed blocks it removes through
ext4_da_release_space(), which ext4_iomap_punch_delalloc() also relies
on in the iomap path.

To check this, I ran my earlier tests on the dev branch with the patch
as sent and with the helper replaced by ext4_truncate_failed_write(),
plus a test on an image with the quota feature that reads the user's
quota usage (which includes reserved space) and the free block count.
After a failed write past EOF, both versions bring both numbers back
to their values before the write, and nothing is logged at umount.
Without the patch, the same case keeps 64 KiB reserved until the inode
is evicted.

I did not use ext4_truncate_failed_write() because since 665575cff098
this path is also taken by ordinary writes. When the source page is
not faulted in yet, the first copy fails, ->write_end() sees
copied == 0, and generic_perform_write() faults the page in and tries
again. ext4_truncate_failed_write() would then run ext4_truncate() for
each such write that starts past EOF, and that frees blocks
preallocated past EOF with FALLOC_FL_KEEP_SIZE, even though the write
succeeds right after. In my test, a 64 KiB write from untouched
anonymous memory into a file with 1 MiB preallocated past EOF leaves
st_blocks at 2056 with the helper, but drops it to 136 with
ext4_truncate_failed_write().

So I would prefer to keep the helper. Is that OK with you, or would
you still rather use ext4_truncate_failed_write()?

Thanks,
Hengyu
