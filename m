Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A244B41D104
	for <linux-ext4@vger.kernel.org>; Wed, 12 Aug 2026 11:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786533310; cv=pass; b=Yd/ZmrtjSRCXZq8i2o1ngG84TWMKGAxb4dMhG3HOUl330B8OxBH8DkkXf7iHliwMzWCBidiQpjMVghdJ9ilc/Eq54V+PxWyo+OtH+wEi3vLxRgacjL/LoeTgFyuLVffP2gBk61eZb8UY+sVtF1bUmnZu4jkAbCh09xmHTsSHd0k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786533310; c=relaxed/simple;
	bh=KwUEegJBmzEyHRWT8RaGNXlv+ltBtx+LzUysKofndao=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Nn6SOZzOZHovhOvdN6Y1+r4Cc+1guYrVzb8lEO3WOUpGlPfWJiiTA5FlU1SnN8c8CYHnrgyKMxp8ogZh+veB7oHA5ey/NCnGG74tB3pcMuIqNZYheu2OoFfskpTbiNaHMT1sHniayd/DRS/OD5MhVucs67huuXiSH0pmTFWflPo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IpnpEZNR; arc=pass smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IpnpEZNR"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2d02b4c3601so5540415ad.3
        for <linux-ext4@vger.kernel.org>; Wed, 12 Aug 2026 04:15:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786533308; cv=none;
        d=google.com; s=arc-20260327;
        b=IWwpfrTt6rI3astMeNTzWVybVyayyAp7HJxQ1Wj5dv57YKotj3hC8dSMvTVzRS1S09
         HYuuBczVoac5RwL8DgZKTFT5LNkwnxOtlyZzZWdZByD/6kMRF3o1QKYw+GLGUDVK76dh
         k6yNwQ9nYqTcHe6hZbCzwtCxjp78L5eA10HzBv00R+Ers3kvQnQSqHgj0eW1aD1qqP8p
         GIlCNGuc9Y37uZalWD1g/5vp2CjDJUUC3xkj/hFHp5TLONuoh5oK9VXZ1WeoJ++VJbhH
         sTJ2BjOkVZVu8UWgvgIkpkeqPZhVeVHWYzeqTLQO1T2AGtgaLT6ZyITYueJy54Limvdg
         bdow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ZdOT1GptfK2kRtjaBvQzbkIIUWBOb5UFCdwV/7cWWjk=;
        fh=whtvW5oaHZhJPk1oWM7fOIRo4BmSuFaVStqwS5uioZU=;
        b=ixbmFRXj3GqlQv4BbU7AJLKiMPuoEJ1f+HGUThH82yzRNmzO/r9fbFuLQKr7iQvQuV
         WD6eqtDnt3/wppO8E05Kp2Ji7kxvUdaozwER7Lhg2H4BvJgkgEzHfjk3fx5LzFGbFDDx
         lhvflZNZ4cRpbwCH5Ql0R1P2sxYfKh5rTWscesjsXIzIecbVGtOoZi/to+svLr99yTj9
         cag01jTOAGfRnVvxNL+rTzcVhDNkCo5gj6rdMFh++fPZlyXYE5JKloyNrTZ2vntK8nnB
         qT1+cglxyUbn7K/6Xbz3Ruw8NFciFNbSK/Exo5T7yWOaDvrQOPlYV+jfGEJV1PzCLXdo
         VOIA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786533308; x=1787138108; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZdOT1GptfK2kRtjaBvQzbkIIUWBOb5UFCdwV/7cWWjk=;
        b=IpnpEZNRLftamW8W6RxTnCvvEDTecGPzIBm01AI4x8PPla9/gV2TclFqjTYKgEZehC
         sy84aZnNOBRZbxt1HaOqvy1k10eGOZVhwmbG47PjgTFI/UQJYz+rlJbnZIjPBIuv8mrY
         4xkh4/PwPzhbJPl/87F5BZlvSpFhwm88tlni2Eqhb+iVPILwXkO6icVTl0MpbJyAwESy
         nQ+ZPhVrDMqq6TMH3M/9DlEU1Lt1NSrzBxK4Vbty7ez+dKxodvhxITkJzMOE0v2WEvOI
         ejGQ5QjbVnbIvGx9se0OVcAMnC5iP1PMw4Jr5XeLeuLC7CvUPmY0VXKiY5YBofV5kS4Y
         76UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786533308; x=1787138108;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ZdOT1GptfK2kRtjaBvQzbkIIUWBOb5UFCdwV/7cWWjk=;
        b=Jy9lCdn2srUFlDL1n1m/zTr/Hw3gP/BKxc2t2DNlqSwFqQhMqaD2puy0qpnQSJeKZN
         mZHj/y/sncJCfX9diBwSwtoXGnIle5q27j2hZC8ht/wxlJgCnIFlvLFmbd/7N8utwpTp
         iu/FdUN2zLLjysmjBhGAV88yO19nDUymVFJZt6Z6E2ZhRY+ihgC+G9ojSlXYGyjeNHM+
         kn4jDROHAjC4cfyHTWtcXpBqMWL7d+aJSbsLhbKGOvpoNQffZveCB8H7vRE5BUxG/404
         gAGmHOSbZGrhr42rG2zRZkNe8AGYLZM10pus1DyvpMSoo3ujA7Op24GDb8twIiV2uYRU
         nJHw==
X-Gm-Message-State: AOJu0YzI3CjLCopwNQb+kTdQpjpY4HlaDXyG3KE8qYK4eFyGPUaoF7nZ
	JXI9eU9Pw6NxRi73AjMJCkmJAio+mYR9j6iGNJemTJdh/JY1JMEIULfOK1h/SPPJf1ySfa0tOWp
	NCyBlixaJkxb9GR1KmG5zx2TJpiZhGCZ4ZmTnGyJA
X-Gm-Gg: AR+sD13y27/bzrAT0pwrPMgpNA98o2UsudtfekJuN5OWNS1O8zGsAPq19yC7PrmfgYv
	XZ3wKBc9jP7wJotYBnKst8/wz8H9VhdfrS62f6yaGRy85F4RNiYyVQme7Fd4sUj2gzHjPxYXW4y
	/Uc4olb2C2UsV5Q3al1qrsil6q7wQRQuxP4LrakU2AUOG9WG6ots4Hg5LW1BbBKUVzIr3qdk/DZ
	3hb5UpXyg+JHmXKw+ies4zKkA9NvGudl8lrhMmpii6Mb6ZtrWE5cpUwtnFGujrdSq5sp+2xB0RS
	4HacMS4YjhPwaKxk5z52s3rNmglfIzc8bAFdAM11TWca7JwsgnbR+c+4WLMY+ruS+i7OF2XIIWM
	=
X-Received: by 2002:a17:90a:d647:b0:37f:e326:6557 with SMTP id
 98e67ed59e1d1-393013d66dcmr5008436a91.4.1786533307285; Wed, 12 Aug 2026
 04:15:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260811160336.782342-1-timday@thelustrecollective.com>
In-Reply-To: <20260811160336.782342-1-timday@thelustrecollective.com>
From: Marco Elver <elver@google.com>
Date: Wed, 12 Aug 2026 13:14:30 +0200
X-Gm-Features: AUfX_myPZ42mV2g_1d6jQzHOsWPbwlDbw_iNRf_zK9PQxPqWoyuCWI6anHmlcgQ
Message-ID: <CANpmjNPOY5D9rdGVCwPhS5XqQuJvnP+0zG6=XNL2QLqOE6iJag@mail.gmail.com>
Subject: Re: [PATCH v2 0/8] Support Clang context analysis for ext2
To: Timothy Day <timday@thelustrecollective.com>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.com>, Theodore Tso <tytso@mit.edu>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 11 Aug 2026 at 18:04, Timothy Day
<timday@thelustrecollective.com> wrote:
>
> This description is mostly copied from v1:
>
> This series adds annotations for Clang's context analysis to ext2.
> Clang context analysis was recently added in a series by Marco
> Elver [1]. This allows the compiler to validate different
> locking patterns at compile time.
>
> This series enables context analysis, fixes pre-existing warnings,
> and adds new annotations. It is inspired by similar series in the
> block layer (NVMe host driver, for example [2]).
>
> I'm starting with ext2 since it's smaller and simpler compared to
> ext4/btrfs/etc. After ext2, I'd be interested in converting the
> other filesystems and infrastructure code in fs/. I think the ultimate
> goal would be to enable this by default across all of fs/.
>
> The series was built and tested with Clang 23 with
> CONFIG_WARN_CONTEXT_ANALYSIS enabled. I based on 7.2-rc7.
>
> Thanks!
>
> Changes from v1:
>
> * A false positive has been fixed in Clang [3] and ported to Clang 23.
>   Hence, the first patch (silencing that false positive) has been dropped.
> * Use guard() and scoped_guard() instead of context_unsafe(), when
>   possible, to express that certain fields are being protected by a newly
>   initialized lock during init.

Acked-by: Marco Elver <elver@google.com>

But ultimately up to maintainers. Also, thanks for helping improve the
Clang side (FWIW, Clang 23 will release August 23)!

> Link to v1: https://lore.kernel.org/linux-fsdevel/20260712165610.366474-1-timday@thelustrecollective.com/
>
> [1] https://lore.kernel.org/lkml/20251219154418.3592607-1-elver@google.com/
> [2] https://lore.kernel.org/all/20260706141452.3008233-1-nilay@linux.ibm.com/
> [3] https://github.com/llvm/llvm-project/pull/209796
>
> Timothy Day (8):
>   ext2: mark s_next_generation as guarded by s_next_gen_lock
>   ext2: annotate ext2_update_dynamic_rev() as requiring s_lock
>   ext2: mark statfs overhead cache as guarded by s_lock
>   ext2: mark s_mount_state as guarded by s_lock
>   ext2: annotate ext2_init_block_alloc_info() as requiring
>     truncate_mutex
>   ext2: annotate block-mapping helpers as requiring truncate_mutex
>   ext2: annotate s_rsv_window_root as requiring s_rsv_window_lock
>   ext2: enable context analysis support for ext2 filesystem
>
>  fs/ext2/Makefile |  2 ++
>  fs/ext2/balloc.c |  4 ++++
>  fs/ext2/ext2.h   | 19 +++++++++++--------
>  fs/ext2/inode.c  |  7 +++++++
>  fs/ext2/super.c  | 35 +++++++++++++++++++----------------
>  5 files changed, 43 insertions(+), 24 deletions(-)
>
> --
> 2.43.0
>
