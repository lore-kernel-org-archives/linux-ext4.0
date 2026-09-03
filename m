Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E9F3812EC;
	Thu,  3 Sep 2026 07:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788420485; cv=none; b=RM17xlGKenZvs3l79Q6sVqlXh9ZKlrnuQc62Zbe6ceu1Ewp9eDFs9mrg5eTv+aL1gIIFfoTrxhLdxwWUWPi50I2YAqSVRZ6TQEat+V/ArIxm9VemPG81WjdDmCEIqIyE6ElwIADnyLMpnyp4ieKovecjyWlPM/C27MPzaqb/X0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788420485; c=relaxed/simple;
	bh=qCPUlHBAagKK70IAA/b5RgaQ+CmDhbIKFHglQpAc/YA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HKUez6153Ni3VmcZqpux5d/aCjbBKLzv5a3Rb4jWrAORNnLDXPZuT+dtutHp6OuYd20EiretNgH0SZEvBTEsNZJb+zTgtIE2IH2B69Piupvidr2ZGJR+frtc1mUmGWAnqOi2gMTToyXolDzJE+SZI4iW+xjTd+mm01YDXm3Vik4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IsQF/Nqs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IsQF/Nqs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C7A1F000E9;
	Thu,  3 Sep 2026 07:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788420484;
	bh=RQgEmkMwAsWbb4PYDcW5x///C28juV7yABj45P5jroY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IsQF/NqsW5wbCRyqvF31duH9gwbyzLdXK6iV/QOTvWJmlaqfz8z/Ng4jPulxFr30C
	 ufUtXSfQtmS26Ytyb/E9zAR9teZ/tqUAaMUtKQisjmMwJ7gmk7HiM+9SvLlImUzijU
	 wsYUohCBjrUOJZRRhbvIOqyZlY2WlxCw4+IPYTGBFdF9qD2V7Nf3Fb3ZipT1UfFGTn
	 j4o5ukeBAiIuf36oYKceBWR9/Rb14suK9cXZhEjHwZpVg1G86dFXsWNc8mR60DfiuY
	 o/QqO1/VAOPjYkKbi4gexZU5jgVX/5vnebZzoNvVVdx6kcSxjLMB9qMYo32JTEkfGI
	 ZiI/IznaOXZwQ==
Date: Thu, 3 Sep 2026 00:27:59 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Timothy Day <timday@thelustrecollective.com>,
	linux-ext4@vger.kernel.org, Jan Kara <jack@suse.com>,
	Marco Elver <elver@google.com>, Theodore Tso <tytso@mit.edu>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/8] Support Clang context analysis for ext2
Message-ID: <20260903072759.GA1750084@ax162>
References: <20260811160336.782342-1-timday@thelustrecollective.com>
 <xiymqvu5la6h63umrp6upnzbl3xjjcacuyxg76xp4labnrioyj@xowfpjlhfrzh>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xiymqvu5la6h63umrp6upnzbl3xjjcacuyxg76xp4labnrioyj@xowfpjlhfrzh>

On Tue, Aug 18, 2026 at 11:58:20AM +0200, Jan Kara wrote:
> On Tue 11-08-26 12:03:28, Timothy Day wrote:
> > This description is mostly copied from v1:
> > 
> > This series adds annotations for Clang's context analysis to ext2.
> > Clang context analysis was recently added in a series by Marco
> > Elver [1]. This allows the compiler to validate different
> > locking patterns at compile time.
> > 
> > This series enables context analysis, fixes pre-existing warnings,
> > and adds new annotations. It is inspired by similar series in the
> > block layer (NVMe host driver, for example [2]).
> > 
> > I'm starting with ext2 since it's smaller and simpler compared to
> > ext4/btrfs/etc. After ext2, I'd be interested in converting the
> > other filesystems and infrastructure code in fs/. I think the ultimate
> > goal would be to enable this by default across all of fs/.
> > 
> > The series was built and tested with Clang 23 with
> > CONFIG_WARN_CONTEXT_ANALYSIS enabled. I based on 7.2-rc7.
> 
> Thanks for the patches! They look good to me. Once the merge window is over
> I'll queue them to my tree. The only thing I'm not fully sure is how much I
> like the spinlock_init scoped guards - they looked quite confusing to me at
> the first sight (as much as I understand the convenience, conceptually how
> can initialization of a global lock be scoped?). I'll sleep over it, maybe
> I'll change them to just spinlock_init() + scoped_guard for the lock itself
> or maybe I'll get used to them. Anyway, no action on your side needed :).

This series is now in -next, where I see the following warnings (or errors with
CONFIG_WERROR=y / W=e) with various configurations, such as ARCH=arm
allmodconfig, when building with LLVM 23.1.0

  fs/ext2/xattr.c:825:6: error: rw_semaphore 'EXT2_I().xattr_sem' is not held on every path through here [-Werror,-Wthread-safety-analysis]
    825 |         if (WARN_ON_ONCE(!down_write_trylock(&EXT2_I(inode)->xattr_sem)))
        |             ^
  include/asm-generic/bug.h:180:2: note: expanded from macro 'WARN_ON_ONCE'
    180 |         DO_ONCE_LITE_IF(condition, WARN_ON, 1)
        |         ^
  include/linux/once_lite.h:30:7: note: expanded from macro 'DO_ONCE_LITE_IF'
     30 |                 if (__ONCE_LITE_IF(__ret_do_once))                      \
        |                     ^
  include/linux/once_lite.h:23:3: note: expanded from macro '__ONCE_LITE_IF'
     23 |                 unlikely(__ret_once);                                   \
        |                 ^
  include/linux/compiler.h:77:22: note: expanded from macro 'unlikely'
     77 | # define unlikely(x)    __builtin_expect(!!(x), 0)
        |                         ^
  fs/ext2/xattr.c:825:20: note: rw_semaphore acquired here
    825 |         if (WARN_ON_ONCE(!down_write_trylock(&EXT2_I(inode)->xattr_sem)))
        |                           ^

  fs/ext2/super.c:1149:3: error: calling function 'ext2_rsv_window_add' requires holding spinlock 'EXT2_SB(sb).s_rsv_window_lock' exclusively [-Werror,-Wthread-safety-precise]
   1149 |                 ext2_rsv_window_add(sb, &sbi->s_rsv_window_head);
        |                 ^
  fs/ext2/super.c:1149:3: note: found near match '_res->s_rsv_window_lock'

-- 
Cheers,
Nathan
