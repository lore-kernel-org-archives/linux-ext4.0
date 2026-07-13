Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CC1313543
	for <linux-ext4@vger.kernel.org>; Mon, 13 Jul 2026 15:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783955009; cv=pass; b=AsfCxIr3b6aRDS3iHDUsi/00R6+5iFCQpsYlbq6KLEegDdUR/mmfctF4nV6uZX/zHvu9LyGHyD8k0jkxwZkYZcmjRw3TmOsJgS/bZ3FrvY1iCq10jhcaFBWIJuD0O0iAhSmHpgr/G6+QZ0OV9AxBZbW0zSFP0Q8HS6R7/AwPJ+k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783955009; c=relaxed/simple;
	bh=5utkWJXQ2msP/ojSA84SxAAqN4bNj1DLNYGCcDQbdHk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SBREcbppCOF9n20WH87bZcUA8D9+Cq8XDvgP9eHmDbC5oAJEjJH+7ZbxGZXJmzZcEDssW/VGO5Qobl6lXu81quHegN/hl+Ipgb0MnbvHOe1i57EI9/HTDG7v6V1Offyv6HcnsRXVxZ9cXtrZQ4rG141h5c/hoA5aBmXR0WV0h0Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=TkjuYspe; arc=pass smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="TkjuYspe"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c15b33f7b23so464203066b.3
        for <linux-ext4@vger.kernel.org>; Mon, 13 Jul 2026 08:03:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783955006; cv=none;
        d=google.com; s=arc-20260327;
        b=lFdDhOZiuIiwLi5iPA23zteEb+Dsm+4oNoEWBQ6ftlDem6tBP6/gzTiqzZccYRL3Gl
         utuKwrgdTkCWitqadPtohp8uwhcbyO/46Aq39vkZ3LGUVk7xU80oEH1mXAybVI+MfHHI
         rrbpvValwjKfzt9nz7ts4I0imk2JussEdRysvBXOQGYFRuOn9Vi7L2DzNpez1ZBNF5X6
         bDOtMrjByCcFtpE83xHrNWCIhfRkmhXX25WgRcuYJkes74wfOFVoXnuj9e/I0EehSib+
         ah/eoU5p9Agai3+Aa8xl9V3IGvGFpHqfhNxmCPRDe/hlN8JbeiI6QdyarL0ZsNN7pwq5
         SVSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5utkWJXQ2msP/ojSA84SxAAqN4bNj1DLNYGCcDQbdHk=;
        fh=L+EUwiuBPAhQtTrOPJQom+ZNi2bIhWMr22ADacasWY0=;
        b=XGyAI/0/c+yMcZA0mfYuv7tjIge67Cdd3yw+o5S//NwO8qzt8mTFTKqSFMpeLyLa42
         1zFhsKpEowbIlx5VxZF6wqzQnpLNSlU+mankJMQn9jqSW4uCJOrBXEKYTSo0KUyjAJUG
         +oshurlPs6xIuZf4UUe3hzNWA60O9iBEDumkTOllVe1Jw88nixKIzBp5IbizJWkIFIua
         X7piRzM3D9s1aGmlQh7GRuaLKcRf01NpjW01T4jOTtSRpA7gx2XDnQ1CGAK99Gxa0N4F
         ic5R13M7rnrS2tAQrARf0SOTyJMYhYxNBGJwYe0dcrKqJzDyUsR61agvFz5lYQwBzbQU
         GWhQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1783955006; x=1784559806; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5utkWJXQ2msP/ojSA84SxAAqN4bNj1DLNYGCcDQbdHk=;
        b=TkjuYspeuq6kPUJx0/oHBCIXKWElJFQ7m6HKTNcG8Lm29VpqtXwG0JTUYfRbD780ml
         +/NifQMXQ2mCEvI/8jiaYq8O6GgWdsguGjeDDpS+FJtoi7o25ziie2crhQksm1f3ze6p
         Enl+DcbzDeCd1fGZB8q+PQNSFmMgDE5/86DQHxOt+ui0/6/h7MlRB1Wg/kNBCRQi7UYX
         v92ajsAc991Nx4jOcEvdUUSZD8klp/dVXr9UNQ//UsEn5d73SH/9OMLV5KTfYWVqaN4z
         d2i8UJMe27wsytv92yccQ7ybINc+WwoCP0PeFKFWh8i3gmibQ7mvmIeA4O+EhCuhMZm/
         iFOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783955006; x=1784559806;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5utkWJXQ2msP/ojSA84SxAAqN4bNj1DLNYGCcDQbdHk=;
        b=Bz5v5YXIDqsCON4HjzZbydaDmN/clVsfFAo6EhU0ZkREQk/BX827unLytEXBPcIk9H
         noxmeQvhl5vYXv/3AEMpj2hkBHU16PztHladldUGtTuY7x1vxEik4zEkA+Ak8F26cCyx
         cinqdmNNk6LSgsKFFlZ/9DDYxbt0dPBMIRFhpTFWkrQuwMW8DQCVpcy5M0Why3moKQKN
         akshbrOsgrzQ3eozQre2CcfEfAdLHek7bFxk95nrFabvs8j7t4m9BJIQQfdLSkaQ6Pls
         HYwr9lFGBFpbwK1bP3QbL2xOsCxJWiC/i7ZK/Ih85q38OgtjQ0mtbtttzbc6XNWHk/tb
         RMRA==
X-Forwarded-Encrypted: i=1; AHgh+RprFPBU1P6Nwu5Ri7C1XYTjzLQIkVUN28itkA7ay+JQzv57R9CiGkSFNSfUyjtV23qjjbigTUduDy0Z@vger.kernel.org
X-Gm-Message-State: AOJu0YxKq0U0KyopfFtO/nYKK1db7iIy9HNgHX/UwkjVAWKo4KmzekbE
	tLLTslwtZDkK0IHYBSdvCwzx3vBQjJX8FMaqQdY25hvSd68HwPwbhNN04BZZ0GeP+zH7m7FXIIi
	a3X5f9z0rl90p0i+1ayeqOGkoWWAH6INF7J8prascTp6P+LzjdGk6xd0=
X-Gm-Gg: AfdE7ckqESJiNcEOcwcxRUxN0slc26TAaN3+No/rj2siwNDqUsqThplhUAjz86YOeqA
	u8UTn68Hqpx7xDE7m9CUEHCzNMRUFXdee4sWPr0J3Lb6TyQYMdXj0MzOLJtpPuWvEjvlYDxzOdV
	bAgXQj6Fey6e6sIY1rTnc9BH5cINhJPdt0QbhRtJtVYORa1aNg54vap/2ogVsJLK16wpHsHM5li
	lJA4RR9P4F+FxAZEEakhQ1ISmt0qstvJgkwZsFJEisM3D+yVbPNk3E8JUpiakRPm6cw7qzvSEWl
	We2A3+aXSdTepx/ipa6atj/x8w==
X-Received: by 2002:a17:907:cf87:b0:c12:4647:a629 with SMTP id
 a640c23a62f3a-c161e9a515amr466291766b.25.1783955005726; Mon, 13 Jul 2026
 08:03:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260713102229.1598812-1-max.kellermann@ionos.com> <80184b10-f5b5-4b95-9c35-9a5d4208d579@huaweicloud.com>
In-Reply-To: <80184b10-f5b5-4b95-9c35-9a5d4208d579@huaweicloud.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Mon, 13 Jul 2026 17:03:13 +0200
X-Gm-Features: AUfX_mzO8NJeFXI3jvRNHaXWme1x8LGMq1tYx9sxqyZTbrPLdgGrQd7ARUtKbWo
Message-ID: <CAKPOu+_6afuEHv3EcLMe1fiQ9R_nvwOhBfXNCZeyxEe-wfkZuA@mail.gmail.com>
Subject: Re: [PATCH 0/2] jbd2: bound j_list_lock hold time in the checkpoint shrinker
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, jack@suse.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 13, 2026 at 2:53=E2=80=AFPM Zhang Yi <yi.zhang@huaweicloud.com>=
 wrote:
> I'm a bit curious about which kernel version and CONFIG you
> encountered this issue on. IIRC, after commits [1] and [2], the
> spin_needbreak() in jbd2_journal_shrink_checkpoint_list() should
> always be effective (unless the hardware does not support it, i.e.,
> ARCH_NO_PREEMPT).

We run 6.18.38, and preemption is disabled. Therefore,
spin_needbreak() is a no-op.
(We used to always run the latest stable, but got burned by way too
many critical Ceph/netfs regressions and settled on the LTS.)

But even with preemption enabled, this would likely be a problem,
though a much smaller one.

> Moreover, the number of buffer_heads in the
> checkpoint list of a single transaction should not be large enough
> to trigger such soft lockups. So I suspect this issue should be
> unlikely to occur on the latest kernel releases.

Unfortunately, I don't have any numbers for you, because this problem
occurs only every other week, but we have been haunted by this for a
long time.

The setup is a 7 TB ext4 partition dedicated to fscache/Ceph. It's
always full, and culling is running quite often.

For culling, we don't use cachefilesd but our own reimplementation
(https://github.com/CM4all/cash) because cachefilesd scales
quadratically and never makes any progress while burning CPU cycles
and I/O forever; ours is massively parallel thanks to io_uring. That
puts a lot of pressure on the ext4 filesystem, and a cgroup
memory.high setting means it's always under memory pressure (or else
the kernel will accumulate many gigabytes of RAM usage very quickly
during the filesystem scan that is necessary for culling). Which means
the shrinker is running all the time. Plus the usual kernel-initiated
I/O on that partition.
Every time this problem occurred, fscache culling was active.

--=20
Max Kellermann
Principal Architect
Hosting Technology

cm4all | Im Mediapark 6a | 50670 K=C3=B6ln | Germany
General information about the company can be found here:
https://www.cm4all.com/impressum
A member of the IONOS Group
