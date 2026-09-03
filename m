Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7BE488227
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 12:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788437223; cv=pass; b=GlH22S7Ou687eF4WV9uiuWv55uWa9GQcci6XNAG2P+TzjRXq0/4H3qAV1bgu5d6z55k3DxYFTO+g40nw1hUZ9VrlI4NZe/gRVyBt9faofiILXUNEbMKo8o8ESAfCexnG8f3mtdRB1Ck65CUCAxJTy/YDjd8aiVrOCsCTojA6CUE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788437223; c=relaxed/simple;
	bh=N9hcHMJS/8lnE6uQtyDcuSOjyISuIsi+YVlWMBbwn9U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uKsdd2LKUWzTOebbZnzTXI4Bv6fwXctcvTiTTn+5j9HxF+BZgWf+9guzGRA66cEB24aFaj66rmohfoiYuLhmC+luQUGcNYd2OX+5i+Uja6ZrRPAPH7AGr6NkxvlI1CdBPlUqV/49ZqLnbv6z+z6odifHQZTxJcY9iaRt/bV70PE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l5nR44zl; arc=pass smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l5nR44zl"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8568e3ed034so1911580b3a.0
        for <linux-ext4@vger.kernel.org>; Thu, 03 Sep 2026 05:07:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788437221; cv=none;
        d=google.com; s=arc-20260327;
        b=VL+RtwYLPhcYKhGLx54+56c0VZEebbNHvfMBrHgdCoF/u712SiXejeYZQK5fAcD8qD
         8PCNG0FiV0X+YVpPMZuet8oJzgEWF9TNBxQ0QYyW7kjnoBMtyDYW6hADm58MdsQL72dD
         1TIUPBTyNo21abWJA3k/ABvpO+FPaXcH0BrN1ccxZ8ns+pA0j5w/XeK2hHSU5IzltY3S
         eVG1CPTkM4oCx1V0XgboLe+OWj1j/Ygaz/NgvWLFU4cUhx7hYxpBGxdO6PgqpoBaumZE
         YOe4n/VRmkJtUW1ZrcuIobjdKdNJg2H8Coq2XfVy6JxDVSzduuuaMFuZtB3mHI/2MBsU
         935A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=T7mRs8f62kLAbWPgFDhouIuEptLLIIkw44oKaw49xlg=;
        fh=nCXZNUEJvhC5/myFn8dQkanVsv+A48s5BonG1oly1Og=;
        b=EDa1qZ0ImuSjr6k/W2JcWBwFBwrSy+WsljJFB1jTOKiWpG4BIsib0oCpr6LGsFigLD
         v+EBnv1q9OiuoYjSN0l9mFM3Zx4dixCabTK+M5ry/CgHSYZzgXVUccMTgOPVuXM/qZ3j
         XtrZdnWWR+x1Nnsw/gc+Ct0YfWJ+KkzvCk+ryLIz0oupdhPz8IcQCEp/3UOpPWazevnH
         E0ROSUPEH2jxylyQWvCcVuRYMR4EqqeJpcrZ4kHjQ4MjjPFHjxNZyGYupo+0U9do0Npe
         74Xd5VFgWN7sBg/l8dqa5C84gn5WtRoS43+6gZ7wiyci8SSpSkLlsWktU64rRUJR9BCj
         DoBA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788437221; x=1789042021; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=T7mRs8f62kLAbWPgFDhouIuEptLLIIkw44oKaw49xlg=;
        b=l5nR44zl3xNW0KOvLvjUE8EY1mXbPtRD/yYqBlmVsGcr6n25HyQADIdD3tdCORtHgY
         P75Lwdzg3MI4MQyWBHggbiynQ6VxDBuFfft6N6tAEGlLePLoq++xZHFcTVs5HdgNg2jc
         tfAHIao66uK+n73EyyUw6jy3J9bL/G6uAmFaUXO7nmXm9O3eNKhlB4LJo2Ko3zOYu9FT
         UPGyexTbuUFP1hyGYYnZjMbz09jTwsm61Ry5HZkCLKK5egzpO8FNq5Vv/npodJ8P3Rc9
         /S8MuvabAa6g9UfS7Hy4/KAl4iku4NQkjRDEp+Ojb4LqeXoedJq07S7PSeb1VkV6IrDw
         06/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788437221; x=1789042021;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=T7mRs8f62kLAbWPgFDhouIuEptLLIIkw44oKaw49xlg=;
        b=pLRt1BDlzhgKDbQq0/VRMuKddfxXe8ccmxe1vND9wqlZzDkJyeTY0SJkeygtKKktLX
         swPKEJ4wkh5laRH2yhY8f8qa9o5dg2CSfI8V0Uir0IftDLEWk5FEZJBAQgZ2p4QdCk3E
         pXg0oswW1XQO0LZ/jAyGWG3+OygiD7Ezc7vmdh2wN+27VpepzB3CeF8hVvcK2H+IbMbf
         2GEMC121mVAuzNDNk2ugmX2qIG3+Yn0eGE4SW95iQSUCmqF7QMQN16qp7msSLoeZAwVk
         jueXzeyaB8ooscxveIqJzIlWQxT74AlxnS3yDqkpVp0hPZrhwzUm9LVL3RGwWrcsABSw
         XRfQ==
X-Forwarded-Encrypted: i=1; AKwUvBxqgcSHOYrXCxWUOR34TdVyC5UQjsR3wgUaG1ulaYwRpoiwCKtt7W0ZG+HzfhLH/8GLYgeAbJTmCsXc@vger.kernel.org
X-Gm-Message-State: AFuF++k21t8wL3RKBj0toDnHVqu/TwNSGduqtmjZmou2N0aSoYrlCZ6e
	xQAhmQHhZWajlQ7b6SwD/IVOUHjsHIQMNmt15HQn4qj/lLbn4Ynzhs1BIa2FmkWzawlG1C43YZA
	2DFgdAotmFR/70zXjvoHdOTbBrQfTN44p6OoYSVW/
X-Gm-Gg: AYBFou39YTwVgnfWIUKgook935JtjSiXlAtXzDJKjU/pj/09dijDJzfyaIPk8b5iYz4
	U0TNPgzYYm+B3RCx0IbbyGtx7sE1+QNyv+S3rvfMbY0zAZYN+c7Kts5ir/+1kPitoJyVET5Tao3
	JRDlBkX9t4/X/vNG3kus6D+0AiW23E0xjrZ+qgP8rSphrARIh/EP0LyWLE4tJO+ItdGPGV8Zsik
	FdoJiQFOarfthe8NU/vLIQ/jBHth3nxiSqqvC7H8PfAq+Ah3ezX6SrwICRCjSg5ygxSX73p217l
	5kl26+3CfjrghSiUlRUuBUBY/MmVbJpDwDiBpDB3dOgOVwfR2BTM32HBZlNEtnN7yiroMaRZcOY
	q
X-Received: by 2002:a17:90b:2b8b:b0:398:ba9e:75ff with SMTP id
 98e67ed59e1d1-39aee12c707mr18887440a91.21.1788437220106; Thu, 03 Sep 2026
 05:07:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260811160336.782342-1-timday@thelustrecollective.com>
 <xiymqvu5la6h63umrp6upnzbl3xjjcacuyxg76xp4labnrioyj@xowfpjlhfrzh>
 <20260903072759.GA1750084@ax162> <CANpmjNNWiX51UU064+P823sDX42=O6ChSHrUux1aNqLj60mfUg@mail.gmail.com>
 <hnmqtyjazturtmhrw5xh445q4vrwv2mldhhspl6sf4hj6yzvqn@vzje2tuhtzdq>
In-Reply-To: <hnmqtyjazturtmhrw5xh445q4vrwv2mldhhspl6sf4hj6yzvqn@vzje2tuhtzdq>
From: Marco Elver <elver@google.com>
Date: Thu, 3 Sep 2026 14:06:22 +0200
X-Gm-Features: AcwNN1Xhd1oZ_SfzBigtwT3XXDzSDHD70cYPowTnNLJ8nboEDZfHt_OFrhqa3Vs
Message-ID: <CANpmjNPBxfgbuyK1VWsCukurEzhR5nFg1ydwEP9Gt0sGm9p5GQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/8] Support Clang context analysis for ext2
To: Jan Kara <jack@suse.cz>
Cc: Nathan Chancellor <nathan@kernel.org>, Timothy Day <timday@thelustrecollective.com>, 
	linux-ext4@vger.kernel.org, Jan Kara <jack@suse.com>, Theodore Tso <tytso@mit.edu>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 3 Sept 2026 at 13:06, Jan Kara <jack@suse.cz> wrote:
>
> On Thu 03-09-26 12:34:34, Marco Elver wrote:
> > On Thu, 3 Sept 2026 at 09:28, Nathan Chancellor <nathan@kernel.org> wrote:
> > >   fs/ext2/super.c:1149:3: error: calling function 'ext2_rsv_window_add' requires holding spinlock 'EXT2_SB(sb).s_rsv_window_lock' exclusively [-Werror,-Wthread-safety-precise]
> > >    1149 |                 ext2_rsv_window_add(sb, &sbi->s_rsv_window_head);
> > >         |                 ^
> > >   fs/ext2/super.c:1149:3: note: found near match '_res->s_rsv_window_lock'
> >
> > sbi was just allocated, and EXT2_SB(sb) and sbi are pointing to the
> > same object (unless I misread the code), but the compiler can't tell
> > since aliases can't be tracked through non-local objects. So that
> > scoped_guard could just become:
> >
> >   scoped_guard(spinlock, &EXT2_SB(sb)->s_rsv_window_lock) {
> >   ...
> >
> > But I'll leave that to Jan and Tim.
>
> Yes, at the beginning of ext4_fill_super() we do:
>
>         sbi = kzalloc_obj(*sbi);
>         ...
>         sb->s_fs_info = sbi;
>
> and EXT2_SB(sb) is just sb->s_fs_info. Are you saying that clang is not
> able to infer that sb->s_fs_info and sbi are still pointing to the same
> memory later in the function where we do scoped_guard()?

Yes - alias tracking is only done through local aliases. sb is
non-local, along with additional member indirection; unfortunately,
the C language doesn't give us the guarantees that it wasn't modified
somewhere in between, say after a function call (this rule is applied
also for local aliases if clang sees that they "escape" their local
scope via non-const pointer to pointer).
