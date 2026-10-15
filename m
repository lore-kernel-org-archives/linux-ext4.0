Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8E1379C22
	for <linux-ext4@vger.kernel.org>; Thu, 15 Oct 2026 20:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792094541; cv=pass; b=ZCUSIhJTTLGJ9p79yJtrti/38zoib8Va4GRKzzbY2MORMQqwCovg4MPlJKyGsP7qe5xWUb84dyZRjgGxmdOMmx7Pd96PjXh6oXVfU/k4PZeZoYHlbHO7DAcviiBt92Xr+LE7GH370cEwZYyqIlxKh8hYzAqyDCSNSwzlmOPTdsY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792094541; c=relaxed/simple;
	bh=mTPvvAdIxgOtHuBEpEFyNQt8LStAshIksTq74xqzhRE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kd6ZC9sW7Dek6MaGOxrsWwxjBQhOtFx7roHCiSkYzuPX0bBIv3/2Po+4p5F648pmjR1ROTiHn4Du5+dA0OfAoEP6O+IQJ8v5Q81WHshZK3G0ZY0xnkpVxQySAensohBgfJgJ2Dr8u1neS1F12yfdeUYPdlPwF7poAALytYGujCI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=J6tqORvj; arc=pass smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="J6tqORvj"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48b042c0759so4221405f8f.2
        for <linux-ext4@vger.kernel.org>; Thu, 15 Oct 2026 13:02:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792094538; cv=none;
        d=google.com; s=arc-20260327;
        b=kiCGxjx6vj+UTmeY4Xt1TpYCDPBMwq8uN2cCIzP66pcFiX8yXxHkWmNGnQGDfNEGiB
         XhGF5yHziNndYyjdOEqQhNKSwZGEltjSbyMVlrjttNv/xs83blD3GXzo9YHD5fZPG/FS
         IPx/vBfCnCQuXtRJbirU8x4PjIB0CdFTfQ3Ap/iwynSXmPhl7Qe4lMPZMMgjhuZygAMh
         rGvWQw/af1XFmkyvfP0Xz78k3j3wrrM/2TjOP9VmLLN+6gME3gQ7N3vIjqgNzX7VszdB
         EcwNMQ4bz64oXPtw7k2hUtixigRuhw7fMXeG5c0PQ/poQ8orKR8H4uwqY0xnic6HOFq7
         t3vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=adFghwGxsnRj3hxYZf8a4TwNZCzfV6GnTk1GcsiUceg=;
        fh=D0KSR4VaoHyXlksr/teqsIW2fkwSsFCSSTq/oJE62l8=;
        b=Ls90aTs7KtJgKxOBdCOIDa5wrX4HOl+PMFbSGMo983c2mu5yk0uUKxSFHmdO4QIXAM
         nziewgjH8/8EKt9vYrAusBYH+F+r/j0KtyqgmDSilhU5bGP3wheanUbZKSbjOuCBhuNu
         41Fx8LQpcew/1cNmE4JfdRslmzx15erof6vVm2l7cb/0V2CJFYdT/PfIAqJgE7iNFmfM
         JUAMnKZ2ofx/+a/WzK4mmhQOfCUkhvbJcmR0ksMcfTgYs0B1wTjG97iHM3x5yrOKeUQM
         zB0lvk9u5B3jdL2x7W+WpvKS3VlvjmOIy5tUHFTT1FeWE85RFzdf+OJlKFtoHrhdW41v
         zVBg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1792094538; x=1792699338; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=adFghwGxsnRj3hxYZf8a4TwNZCzfV6GnTk1GcsiUceg=;
        b=J6tqORvjRuFkEkkGRW/2LhUoSr3JqMvg9Fg+4R6PXROwZ/ey/9K3hnFRKuH6BlyuaO
         6ndrOb40SHg0/bR7Hhl8I4CB9UHTvSh6t1GZT7oTU7j6bJkmb4nsg2m6Ydgghckt350w
         EGiyldwcAVUCimvFv7FHdpzwBV8EafymP4TSA+8Y9NHPPxdPk9dpujAsgDRWgJcR79zQ
         I6/xF9PK0B54QpcY2W7ZMuFuk8o04TQjeZ8rNfgdI5w60T/5gujFXfpfY0txIejuAhpU
         OM73573QKnsIxRbYpE5hzvvEFpIpqODEIuHQgoAC3LpBEEekPcdkrdWsCAz8QzasjRdV
         FkBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792094538; x=1792699338;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=adFghwGxsnRj3hxYZf8a4TwNZCzfV6GnTk1GcsiUceg=;
        b=0koWYEukUee5eecdTHFF0UeFj7JhWXiqB3dI2gg9yII5vA+jXGhXhIAdgtnyF5sNs2
         g5D0XglFMD7xKT1sP3aOcrkUxnFE2GVrnEboOoXTyDF0eSAO/JBxMnkGkEWn3SO+JD17
         d/+APNHOfdoIWD+G4fCQGuv2imBiFiN0q2hYxY5DLESEY7BQXsyoO0TrwBcneSrICFbt
         /gPBiIknNenBIMxwmNEzqiwwK3ZjOal+VlLPzX15yOONE/9FBP0BtmWRtLvCy/2zNxnq
         NAv79zQ4DQE20SAQfS487l5/38+FDZ0pSOb+6nhHszNUrqjWtEjLVWPkRZ/qfcgX0/gl
         0YYw==
X-Forwarded-Encrypted: i=1; AKwUvBwZhmAJqXXM455lNbMeOkHX9aao46/bLEaVDcYoxLDDJzX+bbeE1Ms9LfbPi3eZ4NVOj1+7qId1DX3u@vger.kernel.org
X-Gm-Message-State: AFq9FYIFDeberWIQIzPeZY6D79ZGQfoq0pE9QDBQydINdT//W+WCJA7e
	fSkCxdgB3cPy17N3UJm1jxtpwQVfiBkSPKHmGDTmtMgli0lCpizY9xDWKXzzEMBaeRLuCYCHtSS
	9U6u3tIuoWimmSUF38JC7v9i4sYg4SiPQLIohKOglvw==
X-Gm-Gg: AYBFou1BWWRUOhf7XZbc4qxmQjLBr6PBverTvoOMdHGsZycbhcu4eA84wFNdj/d3XI3
	CV21oeZ08IjBFuVuaO0ift2cwcHAS6bV9zsUk9+ZsYmqA5LVuzcZTDm2wv6iM0laB2B8nG/ja07
	NQeQVeFORUwN2x3G+3VAF/HJ0v4swGgePWT57flJHAhpAOXWaK4YqmTRo04HXUnxsC5BMIG3wYd
	2wmzoXXd/tgE1s5Bmiv4cvPsONv1vfcb/VUVk9pIjQKXPG0ja3MGQyitJ+sY0SsBj+g4fbyVt1j
	lP9Ce29kQQyxktcTjFqVA30Zcyn75+C4g0hCt45SUy5/e7Ft9naRzL+BrrJxNMxNWnTiPEUK0Kv
	KdoLo4Da8BfHHa929enh2rrGqv7JI4cM0n5+p+0+vMX4obg==
X-Received: by 2002:a05:6000:987:b0:488:7787:469d with SMTP id
 ffacd0b85a97d-48df14ed887mr9923470f8f.25.1792094538039; Thu, 15 Oct 2026
 13:02:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261008192048.98833-1-artem@trailofbits.com> <askqkXhBORyXr-v9@mit.edu>
 <CAP3zxaC92rwQNCpuK_tXR9THQOecVoZwxg8ZUgYt=0iKiMsuxg@mail.gmail.com> <asrNX2qBf5qBrFLu@mit.edu>
In-Reply-To: <asrNX2qBf5qBrFLu@mit.edu>
From: Artem Dinaburg <artem@trailofbits.com>
Date: Thu, 15 Oct 2026 16:01:42 -0400
X-Gm-Features: AclHuK9tJDFa3d3xJEx_0hqszb3wpW9Z8si-SJpf2vKpIgukHzjFNUgs2VdIVxA
Message-ID: <CAP3zxaD3-QYqe588XGxzTrgAnK4OQC4aRfbea1Ln452mM45KBQ@mail.gmail.com>
Subject: Re: [PATCH 6.6.y 0/2] jbd2: backport CVE-2026-89566, CVE-2026-89567
To: Theodore Tso <tytso@mit.edu>
Cc: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Sasha Levin <sashal@kernel.org>, Max Kellermann <max.kellermann@ionos.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Ted,

> Note that some tests can be flaky. So when you see a test failure, it
> can be useful to run a test multiple times

Thanks for the advice. We are still working through the testing and
wanted to send you a progress update.

We have completed three full iterations of
ext4/all,xfs/4k,btrfs/4k -g auto on the same unpatched 6.6.159-rc1
baseline (72bada21be7b), followed by one full iteration with the
submitted two-patch jbd2 series.

We used QEMU/KVM with fresh guest and test disks for each
configuration.

Following your suggestion, we also completed ten focused trials on
each kernel for 21 suspect configuration/test pairs: 420 trials in
total. Each trial used a separately booted guest and fresh disks.

In those ten runs on each kernel, we observed the following flaky
tests. Counts below are failures out of ten, unpatched / patched:

Flaky on both kernels:

  btrfs/4k btrfs/028: 3 / 3
  btrfs/4k btrfs/192: 7 / 6
  btrfs/4k generic/449: 4 / 7
  ext4/1k generic/051: 3 / 5
  ext4/1k generic/388: 2 / 3
  ext4/1k generic/475: 5 / 3
  ext4/adv generic/455: 5 / 5
  ext4/adv generic/482: 4 / 2
  ext4/ext3 generic/388: 8 / 9

Flaky on the unpatched kernel only:

  ext4/bigalloc_4k generic/320: 2 / 0

Flaky on the patched kernel only:

  ext4/4k generic/045: 0 / 1

We are now running 200 additional iterations of generic/045 on each
kernel in each of ext4/4k and ext4/1k. Ten runs leave wide confidence
intervals: a rare failure could easily have been missed on the
unpatched kernel. The additional runs will let us estimate failure
rates and their 95% confidence intervals to assess whether the test
fails more often on the patched kernel. We will finish all planned
runs before comparing the results.


Thanks,
Artem Dinaburg

On Sat, Oct 10, 2026 at 7:54=E2=80=AFPM Theodore Tso <tytso@mit.edu> wrote:
>
> On Sat, Oct 10, 2026 at 06:12:10PM -0500, Artem Dinaburg wrote:
> >
> > Our initial unpatched/patched runs showed some differences in both
> > directions. We cannot yet attribute those to the series, so we have
> > paused the patched comparison and are running three complete
> > iterations on the same unpatched baseline to assess repeatability.
>
> Note that some tests can be flaky.  So when you see a test failure, it
> can be useful to run a test multiple times, so you can see if the test
> is a reliable hard failure, or one that only fails, say, 30% of the
> time.  So to run generic/363 10 times in the ext4/1k configuration,
> you might do soemthing like this:
>
>    kvm-xfstests -c ext4/1k generic/363 -C 10
>
>                                                 - Ted
>
