Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9B948A8C7
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 10:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788431727; cv=pass; b=FH9fcrF0XG5iBMmCrCwiDFhKSty0Gzmq7wcS3BkUamnUmOZc0Begt7zAzJeE+3bBn/jGAY+8hehaEuCBhOTJCraaF4lkseIicmPZhuXutej/CZ9VJL2QuaCEjPpgMnDFHqT4N0ThDk6Ia0I7JBYs4Cc56rCZQ+z47+Fw7o9fVo0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788431727; c=relaxed/simple;
	bh=/zyYtEZmFhhQgOsgXNLJ+e0A/ltm9fi9IENg+VYRnRo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Tu3zkP4jvgzR7PAjjt+Vk7e3ggeRxJsaRph2WdBA/rNQpNN6wGVQbKLGANjmAna/HBmGf1OdiqounaGu17qYNgAdQQAAN3huVPXSuZWikL32BzRQ3iCzAUjyPxopFaY9D0wYewFia3x/j1SMLYDEGF3bDYH6c6rkiOdbjqGPISg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lE/ZWT5v; arc=pass smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lE/ZWT5v"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cbee846deecso2850225a12.1
        for <linux-ext4@vger.kernel.org>; Thu, 03 Sep 2026 03:35:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788431712; cv=none;
        d=google.com; s=arc-20260327;
        b=Ho+b73fthRmYoRYJjc8InvOlGDHnVlGAt6PZONL6oP2B434f66DK4UFgaYHzhrtCvG
         5G8bImWHsnL1Ok51eFvOsDUjyWQ2s8Z0FD7RobglxqOwA/mDF2WDGAgUCuXw/eGVCS+P
         S+K4TPrR5JHXRRXVsB4sl6ai6FeCwf5XrWuVEHjuGJtjEz+8Jg7HFDm2PQy6sLA14d5g
         08x+CYdUQ2LXCyHqhVycs83aUk6Lrelc+gUPhsfeOkNJUNPMBZe021gnsA1b0P/NQ5xi
         /OCIuqz5gDvyMcbCbGpZ4xcGtHYY+DUOkyENUNMGyUTQE6APae/d+72plElYVnFOc3hB
         I4nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=A1wiUzfIxqJZYxMHbVMwIllXO/kuz3RAjcv5fqZ/QkY=;
        fh=6oTJpSDq5Ao2SnYom5Mlyr1eidMIFbg/Ot5BuiyA28Y=;
        b=N3Xzfaeya3UcTKxB+FbOosZYdaT0lUE0M1E+B/OfeIeGjKb4ImsBCaLcPazCKFK3/l
         BpMk/MJT2ROnDProqE6hNeUyexsXG3FGDxntlKRBM0WgCMEVUDRS4dI3ATaqvRFYS8TL
         QEepKgJHEHpCjIXEmQjeQiMG3WjFuyjBXTtEbBygJsrDOH2K8caxh528G1TkAzEfG6Kl
         d/aBkooqvfesh6LJVeJWGQGSc7r5r9WQbYj2PaCXasFTrmnCotheCsF77FDxEGmPFMvG
         +sy30Y1AQv03L6YyjwSeaBkZovbRQcDEwFpSs+VaD3i0k+FFJac5JfiPvmheqqpZXJcU
         Xn7g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788431712; x=1789036512; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A1wiUzfIxqJZYxMHbVMwIllXO/kuz3RAjcv5fqZ/QkY=;
        b=lE/ZWT5vVhGhIftgyHocZbvleVWCk6i8HMIpDwRkqRHYL2WYH4ywyqPSkj8CCVZrEo
         qM6ZAjznBnVQsfHyIKm9r4maGVGzZLcXsKUX7Fhmoh2HSXJIc24PLWQRsJxXcknuPrT+
         krvl/QQQuFF+mA+BnnRgMA9OR/HbpkR6WIWHOPcFs4Mq9PPOQLNsbWL1snwKuuiNLDpw
         PO4W/Phcd/vuevy3m7l/mRhQwBGXrZeHrK+P9fcOr2eRMjFHm7rODhcBoeTaiKG6D2g1
         o/CBPQuJcaxhNMCi+JSyj/2RTqTam9akqVkwRUBUxu3dh7QHimyL4fSpwo1Xl6fBfc15
         Noyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788431712; x=1789036512;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=A1wiUzfIxqJZYxMHbVMwIllXO/kuz3RAjcv5fqZ/QkY=;
        b=XwGZqbRlS1+20VVcqXxHCrNFZ3lofYLA+TGxh5E9hKQFtmhZesxbcKF9z7vfQm6JGT
         DFJ4YrjvWuaOK+mvWr4YBT8qY7s/wML06dcJBR3+BSdak7ecC3rZpOvOSy6DdZ4kR1nT
         KBpkYLXPIlEgx0TajaNc5nq1zpwAx9qkCds4iqs3bLUQ7QQZItH9KT2mavcD34NzyHpe
         6gOQ5zN6O5xkdTcCM4mp1uHtPO8yq9kSEDcSE7GE3AasAi/3O8A73TIBa0RLsuN1c+Eu
         qtKLRuSzPEEdN+RBnKSKrcWdrnOVDhzcpPOd0Mzdw9MxW+PXfN86P/qHKK8D1ltQ4TyY
         avdA==
X-Forwarded-Encrypted: i=1; AKwUvBwe8LuhlJbm2vIZhBGgCi22/NRfC4GRQmV60s+NW+/lNKTm3+DE+OK74+xJKOYaHo8XEakkWyl3e6Kk@vger.kernel.org
X-Gm-Message-State: AFuF++mtwUa6+pYcz0ZkjzLWrBoM67kFzX5g0cOAoN/4ThzaWKUczcLW
	gtUqddU6/2zM7nGnNZf1Oa/PivQX01EezZ2BhweBoEnpDjYWOP2AM4cxhjirHU+coxSP/SOq604
	YO4yo98Ux4FENTBMNxaL2pvWzfMz+D5xOh2+CzFjP
X-Gm-Gg: AYBFou3Iq/pfHxIEUd+X9igTtN729S6J0mg2GDDraxEtM603w7PixuJP+YZJfgpOlVn
	tVkAqOnMCehJl6zDoKCjd5nqBftLYMYSbOLFsVAYFqDXR8XVcTl/3SnaDZuXjRVXC55IsL+a6iv
	T0bIMUzMbZajj7niAXmzHmCeSZF6k09+E/kpvTC31ahpSrp6TLzZdQxe/jJyhwARnHOxrrtxQjn
	LheJMx/HHGld4+KgtDHrRVOgK9MUyV0PAyG/3gAVUnelzBbygtIfIyFCe/Ye9hJWM6421afCSpV
	gTyrVC983o+G7EgKoSm9sljOxXohyvksg4EW3NgSMqm+8QUMB0UJKys+YFk/otkcrEj+gPF4Imy
	/
X-Received: by 2002:a17:90b:2785:b0:398:9be5:b41e with SMTP id
 98e67ed59e1d1-39aee285570mr19268361a91.25.1788431711616; Thu, 03 Sep 2026
 03:35:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260811160336.782342-1-timday@thelustrecollective.com>
 <xiymqvu5la6h63umrp6upnzbl3xjjcacuyxg76xp4labnrioyj@xowfpjlhfrzh> <20260903072759.GA1750084@ax162>
In-Reply-To: <20260903072759.GA1750084@ax162>
From: Marco Elver <elver@google.com>
Date: Thu, 3 Sep 2026 12:34:34 +0200
X-Gm-Features: AcwNN1UBcaXn6RBIaclwnjVOGuTZ1dRp4jV_o2Hi5QwVrPsWTxTE-agnX7TT9dM
Message-ID: <CANpmjNNWiX51UU064+P823sDX42=O6ChSHrUux1aNqLj60mfUg@mail.gmail.com>
Subject: Re: [PATCH v2 0/8] Support Clang context analysis for ext2
To: Nathan Chancellor <nathan@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Timothy Day <timday@thelustrecollective.com>, 
	linux-ext4@vger.kernel.org, Jan Kara <jack@suse.com>, Theodore Tso <tytso@mit.edu>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 3 Sept 2026 at 09:28, Nathan Chancellor <nathan@kernel.org> wrote:
> On Tue, Aug 18, 2026 at 11:58:20AM +0200, Jan Kara wrote:
> > On Tue 11-08-26 12:03:28, Timothy Day wrote:
> > > This description is mostly copied from v1:
> > >
> > > This series adds annotations for Clang's context analysis to ext2.
> > > Clang context analysis was recently added in a series by Marco
> > > Elver [1]. This allows the compiler to validate different
> > > locking patterns at compile time.
> > >
> > > This series enables context analysis, fixes pre-existing warnings,
> > > and adds new annotations. It is inspired by similar series in the
> > > block layer (NVMe host driver, for example [2]).
> > >
> > > I'm starting with ext2 since it's smaller and simpler compared to
> > > ext4/btrfs/etc. After ext2, I'd be interested in converting the
> > > other filesystems and infrastructure code in fs/. I think the ultimate
> > > goal would be to enable this by default across all of fs/.
> > >
> > > The series was built and tested with Clang 23 with
> > > CONFIG_WARN_CONTEXT_ANALYSIS enabled. I based on 7.2-rc7.
> >
> > Thanks for the patches! They look good to me. Once the merge window is over
> > I'll queue them to my tree. The only thing I'm not fully sure is how much I
> > like the spinlock_init scoped guards - they looked quite confusing to me at
> > the first sight (as much as I understand the convenience, conceptually how
> > can initialization of a global lock be scoped?). I'll sleep over it, maybe
> > I'll change them to just spinlock_init() + scoped_guard for the lock itself
> > or maybe I'll get used to them. Anyway, no action on your side needed :).
>
> This series is now in -next, where I see the following warnings (or errors with
> CONFIG_WERROR=y / W=e) with various configurations, such as ARCH=arm
> allmodconfig, when building with LLVM 23.1.0
>
>   fs/ext2/xattr.c:825:6: error: rw_semaphore 'EXT2_I().xattr_sem' is not held on every path through here [-Werror,-Wthread-safety-analysis]
>     825 |         if (WARN_ON_ONCE(!down_write_trylock(&EXT2_I(inode)->xattr_sem)))
>         |             ^
>   include/asm-generic/bug.h:180:2: note: expanded from macro 'WARN_ON_ONCE'
>     180 |         DO_ONCE_LITE_IF(condition, WARN_ON, 1)
>         |         ^
>   include/linux/once_lite.h:30:7: note: expanded from macro 'DO_ONCE_LITE_IF'
>      30 |                 if (__ONCE_LITE_IF(__ret_do_once))                      \
>         |                     ^
>   include/linux/once_lite.h:23:3: note: expanded from macro '__ONCE_LITE_IF'
>      23 |                 unlikely(__ret_once);                                   \
>         |                 ^
>   include/linux/compiler.h:77:22: note: expanded from macro 'unlikely'
>      77 | # define unlikely(x)    __builtin_expect(!!(x), 0)
>         |                         ^
>   fs/ext2/xattr.c:825:20: note: rw_semaphore acquired here
>     825 |         if (WARN_ON_ONCE(!down_write_trylock(&EXT2_I(inode)->xattr_sem)))
>         |                           ^

This one can be fixed with (should also be a bit more efficient):
https://lore.kernel.org/all/20260903101843.3462767-1-elver@google.com/

>   fs/ext2/super.c:1149:3: error: calling function 'ext2_rsv_window_add' requires holding spinlock 'EXT2_SB(sb).s_rsv_window_lock' exclusively [-Werror,-Wthread-safety-precise]
>    1149 |                 ext2_rsv_window_add(sb, &sbi->s_rsv_window_head);
>         |                 ^
>   fs/ext2/super.c:1149:3: note: found near match '_res->s_rsv_window_lock'

sbi was just allocated, and EXT2_SB(sb) and sbi are pointing to the
same object (unless I misread the code), but the compiler can't tell
since aliases can't be tracked through non-local objects. So that
scoped_guard could just become:

  scoped_guard(spinlock, &EXT2_SB(sb)->s_rsv_window_lock) {
  ...

But I'll leave that to Jan and Tim.

Thanks,
-- Marco
