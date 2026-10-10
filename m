Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14F237DAAD
	for <linux-ext4@vger.kernel.org>; Sat, 10 Oct 2026 22:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791670370; cv=pass; b=JohyHbCApu5UhAtPNQj0+mIGBp7rK/mhip1olafstlAWEHLH5zYPVgSP4On81ilM0Ydqblo7YRAZtG89AGobzMjbHkvBel4hUdbyokuFyh7UAiOo3G8s+7T8DIbs7kAjOCKYpvfdw7kQeLcmDebshpDhReFQD9Sluu53ylT4XdA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791670370; c=relaxed/simple;
	bh=Xo2ytTYRV+4VyZ/TTMQIOOJseVL7WvyAFkzn/p1Vm/o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aCBEhj646eLOy6f2Y8cGW4TelMPORFGNMrpybNzRHWu2M0I0dIGO6gMqryL4HiatesZqLrxEgBs3Re7TBa3Vi1DKryDWsY0X67ndK1rJsUxqxmJIwR665huaUmhkI/soK/9de8etMR1msDZn6DMbB1c6moji/PkHyEk7F3F6wMo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=BTcreY6s; arc=pass smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="BTcreY6s"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a018dc1f98so6073465e9.3
        for <linux-ext4@vger.kernel.org>; Sat, 10 Oct 2026 15:12:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791670367; cv=none;
        d=google.com; s=arc-20260327;
        b=cTAY9h7eR/zM+XG22Q7woxdqyJZnG3BOWO5eT3IuOTtljFJ/aB5WT1cmmrziKpj01r
         S039fAhYABFtNtvkZ4OcFzGzr9qgfJtRErM3KyNGghY5x2T1Es4s1e1Y1Oszqyn327vf
         RSPzFi09WfCNfA9UrJ7OXOh5/YeX/qmx3GpaRR6RImArG5ycw6zDh9OF9GwenmVQZ503
         7GmBKQjp7M24uOa8kpfM7tbKoIa2K1UOhvYETFHa1zZmwf4TI0zZjaJGN/Y5fHXJnSgE
         M+3tBYNdWgE2CNw/A1hgKUEGykf6yG8nmNeALmysr9kovVgGY2/KXUxrIBCZlCFbErev
         AlzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=H+VN5tKtCiqk2vj42K2JLyib5t34/kw/B6UEZE9FdAo=;
        fh=GaxwEen1G61kxQhT4g+pikokcL0UpPSMJOp/kM1nMOQ=;
        b=ljIMwUofeOzDpBn/UOUDOUf3jISWsoa46Jd0MxnTixj112LqSVlHr0liiOM/GBkd/2
         TDHIulpx+pxmZ3dT4WgV9hOmWtuUauhHO/H5pM3Q4ob0FubP4JrXwDwAqspCYvBCQBoN
         kZwl3e7f43SZ79qqjc93T5xFEYbGr7+3+zKOL039yqhdhuaSt4Fp3Zjm6/b3QCBbqRuT
         ZFwwVdsI5UuNOq3bdgc7Ku4i5sLb7k1SZ3eT7peEOIaxxvUB8kH2Kj8uj6JBigN0WdN9
         ObD0/dfXqX9GwhB+c5//CiJ4MLVYuEMqfC6LnAkfxMnm4F0rgMQ676bhJ92PegaqmXMt
         LKmg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1791670367; x=1792275167; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=H+VN5tKtCiqk2vj42K2JLyib5t34/kw/B6UEZE9FdAo=;
        b=BTcreY6sPFbxcNaec3sXkjbSp18pbasJi1imwwGGMJnqc5JVuGsom0mjdNksv/9iiL
         nw7xvwGXrFAlJwu1IxscaHLZYMR0ODZiWcB1dHHwcCs2RN+kjTAkXUhzu3LWRIlLffLQ
         pmeqpdeS7vIHSTTXVIL3MR3+Sbtn52YnR27x9CSWqvKVYXEdlE+xECO4SovesjJvSwN6
         tfAu6y7KGw8yI38IefpH483TvH0WSzYZtTI4bzOLHR5abnqBQ4PwW72mxkmHxIzLsw95
         3r75Ag6Bey7lWXniP01V2dEepRfVtE/O0tojOJB15t8POOMHUvw6hAqW9srIWdBxnykP
         pSTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791670367; x=1792275167;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=H+VN5tKtCiqk2vj42K2JLyib5t34/kw/B6UEZE9FdAo=;
        b=o4hfNpL4pjdOgfcRuQkmYNgQZ5/I2epCnD5hAb5iyB0D/nVXxguUP4Ehz/nBvkyAIA
         IVJmqbqJiSIxPhFOc+h9DEckrDgJwr+c7aAj/N6B8PDpbCDVzIohHpiL3rRDtLOOAKWX
         Jn0UGCkEq9mSWfHI23+qnyfiwaeqV4kwDwDaszzUD6DZTXSK1+EMiDboPMwDEUT9vYv3
         Bt2BJoFwdevXe/dcLTxu29rzImG8cSL7FjZG3bjMa0Kr8LRRxsjGSKOWvHTTEhgPyFB4
         B4HYwZr8o7PB+62ZBQjSJQQNluh0Ko9jq2eF4FDVpjti1otQ/oAFl3dq+KLBZb4dl9OO
         UmOQ==
X-Forwarded-Encrypted: i=1; AKwUvBxTRndI/KBDk7llBAeHmGHWi3t6NRfoqp8jQM/3rp5KvU6NjJeRSDCqHECcDp7ey6JGQJEMKUJBinqs@vger.kernel.org
X-Gm-Message-State: AFq9FYIPlg8Rm0ipTpkliR2V7A6tGDhSbhHr01ZJ39iftvq+vEIklnr7
	4mHzywxXxAspcexvbALtdkXfewqoZmXwWT93QDFXU+4R9Aj1GdWQ/XJrcfOv9vPCBkcKdxljdHa
	TKmGKrE9TZbO06vY3Pm/G9+zIT+hMfclpJCK3pcM3D3C2syhfCuK1d8/WaZyp
X-Gm-Gg: AYBFou3qY28yKTwKBjpdhaJxJbDd29pjknmlACYqSmJ/eVihA+4kik3LzjySPZqnJGZ
	vf1ctgsF7zTKvZrv5puDPKwDl0QJZ9gKomuyWvEx9ffuMc2vorZauIMt7AtNa5vq//9S9W/uaVn
	nhGVyS0Mb3lJan4K0dgVdOtKWmpgn9Y7rKREfMd3m44Kpw1BYCW5SNrJCK7jn6sVLjLmczBrBS2
	LOYd5KW8fnzCdp3pClLerclyZ6i29e3Hr9OQZPftp3OBBcuCvAKwpZ1TwTCEYobjhA0luJJwk4i
	p/pwNKL1IE8zFT/3O/GNmOcxsuUtwxdWyIih8JIwccwfQow44awNMhqaaF7LWmFetfONLnGSwez
	3tOxwq/hDfF1b4IcMzVEHILGfMPQZu3g7HAMdIuMSlchNUg==
X-Received: by 2002:a05:600c:3b1a:b0:49c:fa20:cbfd with SMTP id
 5b1f17b1804b1-4a18e4b91f8mr99455835e9.20.1791670366714; Sat, 10 Oct 2026
 15:12:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261008192048.98833-1-artem@trailofbits.com> <askqkXhBORyXr-v9@mit.edu>
In-Reply-To: <askqkXhBORyXr-v9@mit.edu>
From: Artem Dinaburg <artem@trailofbits.com>
Date: Sat, 10 Oct 2026 18:12:10 -0400
X-Gm-Features: AclHuK9w-SV7bZxUS95KqilGQ0lekR2ZEntvX6s-OMlV71Zq2btNf8sGNIbe5Hw
Message-ID: <CAP3zxaC92rwQNCpuK_tXR9THQOecVoZwxg8ZUgYt=0iKiMsuxg@mail.gmail.com>
Subject: Re: [PATCH 6.6.y 0/2] jbd2: backport CVE-2026-89566, CVE-2026-89567
To: Theodore Tso <tytso@mit.edu>
Cc: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Sasha Levin <sashal@kernel.org>, Max Kellermann <max.kellermann@ionos.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Ted,

Thanks for pointing us to xfstests and gce-xfstests. We had not
included this regression coverage in our validation, and we appreciate
you explaining both the testing approach and the stable-rc review
process.

We are going to start including filesystem regression testing to our
backport checks, and started your recommended ext4/all, XFS/4k and
Btrfs/4k auto matrix locally under QEMU/KVM.

Our initial unpatched/patched runs showed some differences in both
directions. We cannot yet attribute those to the series, so we have
paused the patched comparison and are running three complete
iterations on the same unpatched baseline to assess repeatability.

We will follow up once we have firmer results.

Thanks,
Artem Dinaburg

On Fri, Oct 9, 2026 at 2:30=E2=80=AFPM Theodore Tso <tytso@mit.edu> wrote:
>
> On Thu, Oct 08, 2026 at 03:20:44PM -0500, Artem Dinaburg wrote:
> > Hi Greg, Sasha, and maintainers,
> >
> > I'm working through the smaller CVE backports still missing from 6.6.y.
> > These 2 upstream changes belong together for CVE-2026-89566,
> > CVE-2026-89567. They must be applied in this order because the later ch=
ange
> > depends on or completes the earlier one.
>
> Note that some of the 6.1 and 6.6 LTS backports in the past have
> caused ext4 test regressions.  Since I don't have the time to track
> down said ext4 regressiions (the last one took a week of my time,
> because bisects are painful, and even after I bisected it down to the
> guilty commit, figuring out out to safely revert it also took a lot of
> time), I've largely given up on those LTS releases.
>
> In addition, many corporate security folks are advising that it's
> Simply Not Safe to use an LTS as old as 6.6, because even if you are
> trying to address the 6.6 ext4 CVE's, there are plenty of other CVE's
> that don't necessarily get backported, leaving those older LTS kernels
> vulnerable.  But if you do have a real business need to use 6.6 LTS,
> would you be interested in taking over managing the 6.6 ext4 stable
> backports?
>
> It's a lot easier to revert ext4 patches if the regressions are noted
> promptly, and so the easist way to do this would be to use
> gce-xfstests[1].   I can send you the results of running:
>
>     gce-xfstests ltm -c ext4/all,xfs/4k,btrfs/4k -g auto --repo stable-rc=
.git --watch linux-6.6.y
>
> ... or you can run it yourself if you like.
>
> [1] https://thunk.org/gce-xfstests
> [2] https://github.com/tytso/xfstests-bld/tree/master/Documentation/gce-x=
fstests.md
>
> If you see failures in the latest stable-rc.git which are not in
> previous test runs, then promply send a note (within 48 hours) to the
> stable maintainers asking them to drop all of the ext4 and jbd2
> patches that were sent to the latest stable-rc.  You can then spend
> time, at your leisure, figuring out which of the ext4/jbd2 patches
> caused the regressions, and then either fix them up or skip them and
> send the rest to the stable maintainers.
>
> If you see test regressions which *also* impact the xfs and btrfs
> trees, then it's likely that the bug is in the vfs and mm backported
> patches, so there won't be a need to request that the ext4 patches get
> dropped from the stable-rc --- but if there is a test regression
> impacting ext4, xfs, and btrfs, and you want to use 6.6 in production,
> this might still be an issue for your company.
>
> > The complete series is already present in 6.12.y, 6.18.y, and 7.2.y.
> > These fixes also affect 6.1.y, which will need a separate backport; thi=
s
> > series is only for 6.6.y.
> >
> > Could you please consider this series for 6.6.y?
>
> If you haven't tried running xfstests to verify that your patches
> don't cause any regressions, I strongly recommend it.  I won't NAK the
> patches if you haven't, but that's because in my personal opinion, I
> strongly recommend **against** using 6.1 and 6.6, and I've given up
> trying to provide any ext4 support for 6.1 and 6.6 --- I just don't
> have the time.  I barely have the time to pay attention to 6.12 and
> 6.18 LTS kernels, and those are only best efforts on my part.
>
> Cheers,
>
>                                                 - Ted
>
> P.S.  And if anyone would like to volunteer to be the ext4 stable
> maintainers for 6.12 and 6.18 (and 7.3 or 7.4 when the next LTS is
> declared) they would have my undying gratitude.  :-) And the newer LTS
> kerenls should be much less work than the older LTS kernels, since the
> chances for regressions (and the work involved in trying to track down
> the regressions) are much less.
>
> P.P.S.  It's because of the risk of regressions than XFS has opted out
> from LTS backports.  A few years back, a few companies (including my
> own) contributed engineering resources to test XFS patches and only
> sending patches that were verified to not cause regressions to the LTS
> kernels.  Unfortunately, all of the companies decided it wasn't worth
> the SWE costs, and so the XFS stable backports project collapsed.  I
> am happy to help provide the VM resources for a future XFS stable
> backports effort, since the VM costs are relatively modest.  It's the
> SWE time which is significant burden, whether it's coming out of
> company funded time, or out of volunteer time late at night or on
> weekends....
