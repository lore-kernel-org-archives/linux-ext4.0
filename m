Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3336311946;
	Thu, 24 Sep 2026 08:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790239944; cv=none; b=ckop8blfEUROcXd2ymnFsAtnz2BgQMugercb9zHEA7gvq5QIEDJV/6v450PyDvRq2mEpjVLL57p+01JV0ymbW1lKDJHrRREkQBSQvWu4EkredC0GNUMgU4D4OY+FRBHfgKqNeO2i+G56AF3EJWCD4hfscqYaBDsMrq4surotQBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790239944; c=relaxed/simple;
	bh=Qe82rKIHScuhe2PuK2KMbNDhBK7sjwiMWTxBycrZztA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c+9cYO+2yx1I8JFZNa0iyMoWGfzFfPrOYH2y6c4kRHIqKVGZEmmmpQgxLQ7xRfBC8Eh7lVApy6x65YGpnLTa+l0q7T4u/wlXgI8/zeRzSYU0dL5iuGz82tbl06ROlsyTA43MKqLZQUHO3C9NYrIp1baEo2E2GvYWH1f70EO/f4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R5mi1tiQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R5mi1tiQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2116F1F000FF;
	Thu, 24 Sep 2026 08:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790239942;
	bh=uWMhh+Vr2gIxwHKH0IoyS9nRGOMWCcgjZiTj2nIYyiM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=R5mi1tiQKGkktN6ni0msY6lIOn680upbYYmWPhP0bEoC4/sOKoPWa18jz04oK42AK
	 4w2hU0VgsSYfUsx5l9nYsMwwSy6fIspuaTRzFulowUKw+zqqVpvT0UqaQa3bzsCbNM
	 PNqbv+tv0GUXiIXwyMp4bviiWcHjWMSWxB/YgmB5kqv5snWfRICyLJrV4diYCPWM3o
	 YG+SL6YXwMA8YifrP1fuTsM1yVI6QnYPqVZ/ucWWEDbM+FPIKanV18ZDY0vvIhgp9f
	 eAUaTX/9ow46HrwcXL3emBRJ2UjO67+66oik/ixS14ceRCu0Qm0ffw2w1hHw+ZcnXh
	 UXKCgAMHr4Ovw==
Date: Thu, 24 Sep 2026 09:52:16 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org, 
	harry@kernel.org, jannh@google.com, liam@infradead.org, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, riel@surriel.com, 
	syzkaller-bugs@googlegroups.com, vbabka@kernel.org, 
	syzbot+c181d3198e98f8aef8b9@syzkaller.appspotmail.com
Subject: Re: [syzbot] [mm?] [ext4?] WARNING in __folio_set_anon
Message-ID: <arTiHRj-i_17L3qo@gremlin>
References: <6ab4ae75.80e1c6cc.1e8e5f.000d.GAE@google.com>
 <20260924065458.49698-1-lance.yang@linux.dev>
 <0a0a07f8-8ac9-4d75-b4c6-c403865f0be9@kernel.org>
 <08bbb615-a054-472c-9873-787cc0f7a4d7@kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08bbb615-a054-472c-9873-787cc0f7a4d7@kernel.org>

On Thu, Sep 24, 2026 at 09:50:02AM +0200, David Hildenbrand (Arm) wrote:
> On 9/24/26 09:43, David Hildenbrand (Arm) wrote:
> > On 9/24/26 08:54, Lance Yang wrote:
> >>
> >> On Wed, Sep 23, 2026 at 10:00:37PM -0700, syzbot wrote:
> >>> Hello,
> >>>
> >>> syzbot found the following issue on:
> >>>
> >>> HEAD commit:    38872197cae2 Merge branch 'for-next/fixes' into for-kernelci
> >>> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
> >>> console output: https://syzkaller.appspot.com/x/log.txt?x=17a44d25580000
> >>> kernel config:  https://syzkaller.appspot.com/x/.config?x=56ed23170c168d4c
> >>> dashboard link: https://syzkaller.appspot.com/bug?extid=c181d3198e98f8aef8b9
> >>> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
> >>> userspace arch: arm64
> >>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16a36515580000
> >>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16dcf4c9580000
> >>
> >> Looking at the repro, emm ... the repro maps an O_RDONLY /dev/zero fd with
> >
> > Does this trigger upstream or only after Lorenzo's rework (not upstream yet IIRC)

It'd trigger with my make MAP_PRIVATE-/dev/zero true anon stuff too yes.

> >
> > 46827ac1ab221 mm/vma: make MAP_PRIVATE-mapped /dev/zero mappings truly anonymous
> > db7438ea23180 mm/vma: only permit MAP_PRIVATE /dev/zero to be mapped anonymous
> > 54e8e096ea86b mm: implement file_is_dev_zero() to uniquely identify /dev/zero
> > fb24843cfd9eb mm: move drivers/char/mem.c to mm/char-mem.c
> >
> > I assume it triggers upstream. Does it also trigger with lorenzo's changes?
> >
> >> MAP_SHARED | PROT_READ. do_mmap() clears VM_SHARED and VM_MAYWRITE, so
> >
> > Clearing VM_MAYWRITE for a private mapping is odd. Can you point me at the code
> > that clears both things?
> >
> > I assume we still have the file pointer, and as the file is read-only we remove
> > VM_MAYWRITE. But why are we removing MAP_SHARED? (where?)
>
> Looking at the code, it's the
>
> 	if (!(file->f_mode & FMODE_WRITE))
> 		vma_flags_clear(&vma_flags, VMA_MAYWRITE_BIT, VMA_SHARED_BIT);
>
> So we end up with VMA_MAYSHARE_BIT but without VMA_MAYWRITE_BIT and without
> VMA_SHARED_BIT.
>
> So it's by definition not a COW mapping. But it's marked anonymous and confuses
> the system :)

This is definitely a bug. And I added these asserts specifically to find
bugs like this with anon mappings:

	VM_WARN_ON_ONCE(!vma_is_cow_mapping(vma)); <-- fires
	if (vma_is_anonymous(vma))
		VM_WARN_ON_ONCE(pgoff != linear_page_index(vma, address)); <-- would have fired

It's because mmap_zero_prepare() keys off VMA_SHARED_BIT when it should be
keying off the terribly-named VMA_MAYSHARE_BIT.

(VMA_MAYSHARE_BIT actually tells you if the mapping was mapped shared _in
the first place_ specifically because of this clearing of VMA_SHARED_BIT,
VMA_MAYWRITE_BIT.)

So it turns out forever a readonly /dev/zero shared mapping has quietly been
converted to yet another variant of a 'special' anonymous mapping that we
weren't even aware of.

And it's got an incorrect pgoff (but not anon pgoff now) as a result,
similar to the usual MAP_PRIVATE-/dev/zero case.

So the solution is simple, check for VMA_MAYSHARE_BIT in
mmap_zero_prepare(). The Fixes: will be in the sands of time.

I'll send a fix out.

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo
