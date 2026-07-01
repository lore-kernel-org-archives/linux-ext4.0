Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FAEB3EF0DC
	for <linux-ext4@vger.kernel.org>; Wed,  1 Jul 2026 09:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782898195; cv=pass; b=cJjuT8bmgJJt1byQ+236HdRyn8mJdvZOBIGqo4+TAp9ZAvKQ8vuI5B19Q22v/5KLfl51H8gWA3Rv0GjvXoMO65G3vWSN84WRbSeX57WR3C5LqnH+69luoJlyOb3GqQ1HhxSJewlni16bqH7Zklp9bY+zkeNeLmgMUvF1Zf1/bHk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782898195; c=relaxed/simple;
	bh=wuRM+tcB1KjSDDLm3LT5C+DXByrfbxxf6GC+nkn5Wmc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rpfPo4f7mLHnv/vWvb4TjuvwmLCwhZWrDdkgn3BQLSF/3Vo5wDDp7lL37Z9HBTJLy3OX2lLLwb/AD7B4dpB2IzHcEH9oUcr+G+yIBES4T+ClD11+xg1qts4jBVyUhdKllYJGbyMUDPGxRa9x2usdkBesphfrjTr+tDOt/pENSAM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hIdz0uWa; arc=pass smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hIdz0uWa"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c126553552dso59173966b.1
        for <linux-ext4@vger.kernel.org>; Wed, 01 Jul 2026 02:29:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782898193; cv=none;
        d=google.com; s=arc-20260327;
        b=paMsIL/7+DADW1L4si5mkZpDt3TQ/9TUEIiA16TcOqrJLV/Wf85ly35TZIM0wLmGS3
         Ou6eitqsIAU9YVA7TFHHybK+KGHSlwX69CH2cIecLZ1C1V++bRQBnRqGjTHqUhpyi82O
         0imDjjdWN8pNxlFXUEDPNEi59cf35yWzeBLE9gz7tSYsg2shzBSpt5HzDaq56G7D3saS
         7pfYs0xsFvP3xPL/+O7Yo9yzwDQuW41295rUDrvdbFOHcEcuJcHZMZHnk6iFnipS8QhE
         d9si+9ohZCQhuBkZGElx9HDlz6Nl5iLrpQa8qnamEpdqTZs7S1v2VjQb7lcRL/KwLNtb
         B3oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nyFZblf28m4uZe4PtMDIudn9j1XK/d1XjqzIVFyhRsc=;
        fh=xz31kc+BkarR3lDQKrkRn5gxqz4xyHKSaAtIQ+hVt+k=;
        b=HezddSwJMxRSZ2Mo495Tml8tU0lf7YxZtSsDma8a2WLW+b2LZxjhuQo6sHXzt3tAAB
         cIeFKzPNYjtogh8m5PaqKxxxB0eu6UE4YGwEKAi6/tujvzjebWoXdkBN7NEO3K9cHETe
         nqU7eoPVY/LGALzRGbjg48xLZSzgrUKFjfy1bkblQriDyKJWlUsvev1PXZKmLr72mLyX
         7eXwLZkgISzaC0NdZNIAWSJi9sr7XXGRvr+T18hHvzsKJyAxwxI/abEZUIzazP63dNQI
         AhKFiKYtBZzUBVrnsjZoNNq1AbvOkaqg5e3NHgjkkJK7i6rjr84H6I0jBCHGIM94zR8p
         RRHg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782898193; x=1783502993; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nyFZblf28m4uZe4PtMDIudn9j1XK/d1XjqzIVFyhRsc=;
        b=hIdz0uWaAjd5/8UgeuJPSnXD20zLNnm2LPb2P3k8WVYrgKoP8n06FF/2Exo8zsokqv
         ehBaP/pPiCvsibg1b57K8i5e+WfoMPU5KxbUlvCoXEh472iQa/NfhjB5/bcOqm/AjCB+
         e9zU5S/WcQsiLGPRBaRPtWnHxgRZhUY7xu1ytLmCMOxd2d2IVrCUPsTFKZHmuTB4RKhR
         I0zYriCRbEQPbgX/S3btIVr0EGxvbb2WB1r5VxQ8bGKPfvPAOd+yNSmKVTYV84hwLnGe
         UBFVxNWrAShJqsbFwCCVcJ5o3mpZkEkvpm+F7+yPYgHMZgHjAUc3ffb9QSJK6FcO9NXH
         I7iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782898193; x=1783502993;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nyFZblf28m4uZe4PtMDIudn9j1XK/d1XjqzIVFyhRsc=;
        b=Ydxilg4AZU5i/hSqJej7MxXHB68rR3b5DWP4J2e+cl0AbMJSYS3gXRZJoKLCF6Ucg+
         fWQxtpdDAzmDXCzDahJ5xTEFajKPopv9NE2KOdtLK6ZjcpPksv9XRHpRZujPNxg0Lsi+
         3R9QTBszVgJ7ZpqConac0NZjtTKO5d/Yorc8FFXsvCDINcZK5PMgAkEiaNlp530qy/TB
         u4pJFze9evVbkAxvLknWLLm3QhziRRnjCTK9QE5wjQpygbO33J4iXXwq6IFjT1wg4ImV
         Z34CiPcMPyQ8gW6E97XAhEQgSMuq59QdyFtpa66XsQitTo3r81Nu/R3WoUkyU7PNWKvv
         ADxQ==
X-Forwarded-Encrypted: i=1; AHgh+RrcDlXE34crFx7KukeIyJk7e0yPHUjHqPAM+nROhIAZoY34FRHw63/AYvi9Wsl5A+gmfi+ukqm4viXZ@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7YCH4MkZkD4lAHjvZfoW9kLhs+/gqiWmLTKYY3ppT10WCEaxR
	TeeJNooK5u7N25cLqBcIiQzFbN+OLCqZm2QcBt1oEjGWOUlCRA0DvpLXVlHbcLz7+/3uWT6aJvt
	atffvIPxvpMpTCxpn0dYMJUNhGczaNVw=
X-Gm-Gg: AfdE7cku4bzzGLJ9PmmZWK96EWpEbUy3+x1CLyNje79MMzAMCVmM184rMtI6nZ0n6he
	TRMJyZnh6NnDEaLgPTJs/RkLyeP6aHgVIgdgU+5dD1jewwt4BZ5P1oK9cfY6fxbzdgHWx1gGd7C
	8V12rWGXT+ret6/lUtXNGYMFlQPZoVH0z7NCX01UUmfT/cCBE40mnBO++sbM+SLYdYqf2OtbrM6
	1mSxt++0iLyUNQrlTlWDPKUg0DXALcKt5eVC0nYtWRiOpftSegu/97U587JLn/p3aD5oTcLPkUZ
	E0xmpVDxWcYaShisFAH6MhFyqk04sA==
X-Received: by 2002:a17:907:96a1:b0:c12:9b93:61fd with SMTP id
 a640c23a62f3a-c12a9d37e0fmr34834266b.6.1782898192577; Wed, 01 Jul 2026
 02:29:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260630152812.1706-1-aditya.ansh182@gmail.com> <du3mel4k4hwnbbogufghauulvqrijx3bhgem2lfuss2nfgcoxv@6awcqkjsrsh6>
In-Reply-To: <du3mel4k4hwnbbogufghauulvqrijx3bhgem2lfuss2nfgcoxv@6awcqkjsrsh6>
From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Date: Wed, 1 Jul 2026 14:59:41 +0530
X-Gm-Features: AVVi8CdycI1IH4Ct-nF61eZi5sGJCVN1QhBWc0GVo6oA3dOSvQlNHkrxUK7wB30
Message-ID: <CAK5ssPOrN+=uqqF3=6_0CukAigOMY=GrLLZQEUSz5jrn30aBYg@mail.gmail.com>
Subject: Re: [PATCH 0/2] ext4: fix race conditions and clean up locking of
 inline data writes
To: Jan Kara <jack@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, Tao Ma <boyu.mt@taobao.com>, 
	syzbot+0c89d865531d053abb2d@syzkaller.appspotmail.com, 
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Jan,

While the cover letter mentions only a clean compile, I can categorically
confirm that I have run fstests, LTP, and a layered filesystem I/O
testing matrix before submitting. Sorry about the confusion in the write-up=
.

Thanks,
Aditya

On Wed, Jul 1, 2026 at 2:33=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
>
> On Tue 30-06-26 15:28:10, Aditya Srivastava wrote:
> > From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
> >
> > This patch series addresses the remaining race conditions and locking
> > issues involved with inline data writes, implementing the clean
> > state-communication design suggested by Jan Kara.
> >
> > Previously, `ext4_write_end()`, `ext4_journalled_write_end()`, and
> > `ext4_da_write_end()` checked the inode state and the inline data flag
> > directly to decide whether to finish writing inline data or to fall
> > back to block writes. This is highly susceptible to TOCTOU race
> > conditions where concurrent memory-mapped page faults
> > (`ext4_page_mkwrite()`) can convert the inline data to an extent
> > between `write_begin` and `write_end`. Since block buffers were not
> > allocated in the inline path during `write_begin`, such fallbacks
> > resulted in kernel crashes and NULL pointer dereferences because
> > `folio_buffers(folio)` was NULL.
> >
> > The series cleans up and resolves these issues in two distinct steps:
> >
> > 1) Patch 1 introduces state tracking via the standard `fsdata`
> >    parameter. By marking whether a write was prepared as inline
> >    (`EXT4_WRITE_DATA_INLINE`) directly in the private per-write
> >    `fsdata` during `write_begin`, the corresponding `write_end`
> >    handlers can reliably decide whether to call
> >    `ext4_write_inline_data_end()` or complete a normal extent write.
> >    This eliminates the race-prone checks on the live inode state and
> >    gets rid of crude fallback/retry hacks.
> >
> > 2) Patch 2 replaces a potential kernel panic
> >    (`BUG_ON(!ext4_has_inline_data(inode))`) inside
> >    `ext4_write_inline_data_end()` with a graceful retry error path.
> >    If a concurrent conversion clears the inline flag right after the
> >    `write_end` checks pass but before the xattr semaphore is acquired,
> >    we gracefully release all held resources and return 0 (VFS retry) to
> >    let the VFS safely retry the write from scratch.
> >
> > The series compiles clean against the latest linux-next/ext4 tree.
>
> This caught my eye: Do you actually do real testing of your patches? Like
> using fstests / kvm-xfstests? Every patch author for ext4 is supposed to =
do
> that before submitting his changes...
>
>                                                                 Honza
>
> > Aditya Prakash Srivastava (2):
> >   ext4: use fsdata to track inline data write state
> >   ext4: replace BUG_ON with graceful retry in ext4_write_inline_data_en=
d
> >
> >  fs/ext4/ext4.h   |  1 +
> >  fs/ext4/inline.c | 14 +++++++++++++-
> >  fs/ext4/inode.c  | 22 +++++++++++++---------
> >  3 files changed, 27 insertions(+), 10 deletions(-)
> >
> > --
> > 2.47.3
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
