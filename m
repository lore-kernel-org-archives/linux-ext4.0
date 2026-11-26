Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795723989;
	b=4yITt6lvQKEEC2gDHI7Wao3ZCHMKKQkV7u/hd3ct6bvDvbRSdgRk4cdlDM0h+qQqt3fz
	 xpoJR1WQiZBS6DIdjruBvpJdfFOEr2OEZmz807R8BAZF0ZeaRZryrRK5XDH6uC8pob752
	 hY0eY/3EfNLznt/Ls0t6ApRD+oa2GIc5Bi0LAaK6JypfsL93uf1Iu3iW+aoqdYOqhIkfJ
	 gMSGzI+LEPCoK6DoICBrFAzRpw8RM2tKiEopQJIc+IAlbBdnjyiYIW7A+eun4pH+WCAqL
	 7FVw0Xsjj/dXELWrsVWqsMphViEWR6j7mXvcop0CzrEGYT7h2R4nramYhscYV8OqmyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795723989;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=mL+21PyCVLF5ghJvqDSntYj5Kp0/5iC20T9hvOMzCG8=;
	b=mSu/8/1+I43T8Rc9xpzsVeid5+b4Woq5y2Oc0r3IfLmQzHssbkonnt8UUCXuYnF1mmii
	 pDaTI4UDNkP+76kfEi/3awi1f8dFWObJDa/UAD/Kq79JvFqPF4RcT85nnHA0GPihTpWa5
	 FL8r1bjSSYsbUm5boS2rWXsyZR0eX8xvDUY7kRuqwZ26aoPXNtbT/YYnV7yEcbbADOxTs
	 XlD4KkDhRB66H9tiR4PsJ+c3lMPev0ohdkQaQ2eSWKd8NBhIShRP9bKjd6McJyDbll6Ws
	 Q7cCAJLtaObICcUxxHsuJz+Mqumv8qXu6V5u7ggjrs3Gsb6oKqkzHcix70wOdA35W4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=e2b.dev;
	spf=pass smtp.mailfrom=e2b.dev;
	dkim=pass header.d=e2b.dev header.i=@e2b.dev header.a=rsa-sha256 header.s=google header.b=VliH7veT;
	arc=none smtp.remote-ip=209.85.221.42
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD94606A31C
	for <linux-ext4@vger.kernel.org>; Thu, 26 Nov 2026 20:13:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9CD94606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=e2b.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=e2b.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=e2b.dev header.i=@e2b.dev header.a=rsa-sha256 header.s=google header.b=VliH7veT
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-4b52fcb410dso2792970f8f.1
        for <linux-ext4@vger.kernel.org>; Thu, 26 Nov 2026 12:13:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=e2b.dev; s=google; t=1795723987; x=1796328787; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mL+21PyCVLF5ghJvqDSntYj5Kp0/5iC20T9hvOMzCG8=;
        b=VliH7veT028K+7BrmhRstnwd+2pbV9NQm8dNcirQY1FDl52cafWvCr3j7QP+Lud51v
         LGvQwCtyMRlNUJQe2JLpGIy6irr6Dq8ZOvbDoLO6oDZDAK/ZBDb4+AAfDV7u1FnMwVPc
         jwsknRNhgghCxVPighIh7jHxi7tjOxsT8e22Clc+ZHyidnBlEBtgOrFGKJDiQwcJW+Z+
         V8RZ3mATu7f02+X+/7ojOU6PceciQztXxHjrQ/2rYbeeCrGPWrTLRY9JPlb2Yo4UwxdG
         j15fbplOVy/tRa5R+yrsTVd3rgm8vo3AFoKIwWjlrnzYR2rwAoFJhGiMuqxgPxOYIHUw
         W/NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795723987; x=1796328787;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mL+21PyCVLF5ghJvqDSntYj5Kp0/5iC20T9hvOMzCG8=;
        b=GWLa1bx69pVcBUW2THasC61Sbunw6ipt0Xwoe2vAL5gRxJNTpp29AtgBZXL+Bm16Fj
         5pxsdwvlBSN4atNXcgqoYXz24H1Nx1Izn8VHmU/XuD7WhPIoy3ZV68KI5i8+/Twkrxc1
         c4q4iyr2FZGXJvm5aJroqZKeCL8LbeuT14Xaqlhdq61lDmKpy2yUVxr9DiYQiffJOQFY
         ZzPnKgxMEjDqFwew/YlyEmzlVSndUMTjuL2q2FCqCl0isZQDRvNe4WggqwEgmDTScxGo
         VgMUDSjRdkMzn7d7NvlLePMLjX7/dSoy9rryBUpLhVC1N5SKYMOk5aTgHkbsYc8aEcWL
         UJog==
X-Forwarded-Encrypted: i=1; AL+hErE13GSHJXX2+CauGsrtyxn8aqUxX8WqX0JIHwItmZbkNVwMb7maz4XufyF+WHj7cNfbGve8KGI7OM0a@vger.kernel.org
X-Gm-Message-State: APuU4Z9sH+3EoNksVw7g4Ly4zjPB+S+3pkJNQprpettnyRVE5mH+rz3o
	4rh8T8pPoQil7SvqCcWPOr9mtzkMt44P8S+p60PaPqbOUADKSiHxg56g3tnsZcDb5D8=
X-Gm-Gg: AZFdTZcmV9ShM3/dzvcKS2d3pgLcmv6q5TJlRPhrW6B9ZIlXtVC0hQPpQZh+zNpLqsT
	1wZXCdrTTnMCWVWQmz/SBtR8g6bJUU2dBTPvtfywW4t8KaZ7BbD6Bhy5AexOzJBa9ZFMFnks6Mj
	VXYQPovNk9wQTAu25amc3RzlBhRS7yxl6no74kR63v8h9rqnN9ZIZBAlrZFdanYgc+s8762jYSr
	iwhZyuoTsS2nzyER6IBjfVh78e+SOWrJHRRpbYtkfFkH5P2oXi4L3LG72K7153Tp03bnVn1SvLK
	WY5CS2zcwIXA6YP4b9LiFR78T8i0BKf/XSuh27lUbpw5k6pg7a1a9pnFE1/ql4uaMtN7N6vsUrf
	WUFdwVA65lk8vxMJgc+cd9bqJ432JrzrPo9jcj9qRuEUVSiLSo2MpOPARYLNJKatHp/5/tIhISv
	3DvFDK9V3FvWSGVFzEwVF31WnqGHAP09av6aikUrwfOVMyfMXxX1BvGWg2ntwJ/ySNlwg+M2QIn
	eAEobwAoKxrHFi7goHb4g586dPaQnoMfTaa9n07F0yY46BF12G2QWRE7BTxdjbFNx7KzlfE4dPQ
	XmO8UzkCCt25j3MDXgYxwzC73wpA3+KAB0cPm14rjyyKjrOt
X-Received: by 2002:a05:600c:e553:b0:4bb:9457:3c93 with SMTP id 5b1f17b1804b1-4bb94573c9amr254801615e9.2.1795723986799;
        Thu, 26 Nov 2026 12:13:06 -0800 (PST)
Received: from fedora.sphynx-tuna.ts.net ([2a02:8308:397:e200:f9e9:8bad:f8cc:87a3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8538b09bsm1154281665e9.4.2026.11.26.12.13.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 12:13:06 -0800 (PST)
From: =?UTF-8?q?Petr=20Van=C4=9Bk?= <petr.vanek@e2b.dev>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>,
	=?UTF-8?q?Petr=20Van=C4=9Bk?= <petr.vanek@e2b.dev>,
	linux-ext4@vger.kernel.org
Subject: [PATCH 0/3] ext4: fix data loss in inline data conversion of regular files
Date: Thu, 26 Nov 2026 21:12:52 +0100
Message-ID: <20261126201258.1553196-1-petr.vanek@e2b.dev>
X-Mailer: git-send-email 2.56.1
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

Since commit ed9356a30e59 ("ext4: convert inline data to extents when
truncate exceeds inline size"), growing an inline file beyond its
inline capacity converts its data to a block.  The conversion copies
the data into the block device's buffer and journals
it as metadata, while subsequent file writes reach the same block through
the page cache.  A journal checkpoint can then overwrite those writes
with the stale copy, causing data loss.  Patch 2 describes the failure
and includes a reproducer.

Patch 2 fixes this by converting regular files through the page cache,
as buffered writes already do.  It changes only fs/ext4/inline.c, keeping
the fix separate from the KUnit changes for stable backports.

Patches 1 and 3 update the KUnit test for ext4_convert_inline_data().
Patch 1 removes checks of the metadata buffer that the fix no longer
uses, allowing the test to pass both before and after the fix.  Patch 3
adds checks for conversion through the page cache.

Testing:

  - The reproducer in patch 2 loses data on 7.4-rc4 and passes with the
    fix, in QEMU on x86_64 with KASAN and lockdep enabled.
  - A QEMU test program covers truncate, fallocate, mmap and
    full-filesystem cases on inline_data filesystems with several mount
    options.  All cases pass with the series, and e2fsck reports no
    errors.  The truncate cases pass on the parent of ed9356a30e59 and
    fail on that commit.
  - The ext4 KUnit suite passes after each patch on top of the ext4 dev
    branch.

I have not run xfstests or tested other architectures.

For stable, patch 2 applies to 6.18 and later.  Kernels with
fs/ext4/inline-test.c need patch 1.  Older stable kernels carrying
ed9356a30e59 (6.12, 6.6, 6.1, 5.15, 5.10) need adapted backports.

AI assistance: Claude Opus via OpenCode analysed the bug and wrote the
fix, KUnit test changes, changelogs and QEMU tests.  I reviewed the code
and tests, ran the tests myself and checked the results by hand.

Petr Vaněk (3):
  ext4: drop KUnit checks tied to the inline conversion's metadata
    buffer
  ext4: convert regular file inline data through the page cache
  ext4: test inline data conversion through the page cache

 fs/ext4/inline-test.c |  92 ++++++++++++++++++++++++--------
 fs/ext4/inline.c      | 118 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 187 insertions(+), 23 deletions(-)

-- 
2.56.1

