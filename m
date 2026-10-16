Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E4134D3B0
	for <linux-ext4@vger.kernel.org>; Fri, 16 Oct 2026 02:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792116438; cv=pass; b=c8zINggYJv1kSCRd/LJ4WTm89fb4dW2vt2qszp7aH5mnPFTJ0ngBuiFZQrNqP6egnRCq3Rt8x3IU7Qpx6yn+QeSgh6QgaDahEWxUmIvC8bpqgf/+wPPy/JxOasMHWmc/iljbFVg4wlpTMjiER7q9bMSFW73hJQQwNi9cZPmnEtw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792116438; c=relaxed/simple;
	bh=EX53AveEWvr1sInCjm4+XROj7u7dde7DD4tvWbj9anw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Xv8WUdtxrFqjUA0YdR+vhltRizRy6FAjOFuFAfnRIXpC27ExA3HoSCrFayNSv6Kj8+aX+iPb8VbZDW8l6y92WTWJ/eZwyBmefLBuXhaVyGaT4aevjTT3EL+Byp9ChsLm/9dcz19RLvlxIVMmNNREIX29Y32jF/qeNOZoCG243N8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=XJDCHo0Q; arc=pass smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="XJDCHo0Q"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48df0fa43c5so363205f8f.0
        for <linux-ext4@vger.kernel.org>; Thu, 15 Oct 2026 19:07:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792116435; cv=none;
        d=google.com; s=arc-20260327;
        b=exsh2EjTiiFI9bukQgYS7daTR6WXZk7PVoOfaOY8NYuFeVYdiAg91fxyug+KCOGStj
         L6mGVOWElu3P+EU9zCjTXw6oGgHey0QjzKBPYQM/0AL3qGSxF/3TZM4288+QDzI/3MPX
         PSAHiECh70u3NQ4WP7dWDIdbcq7WlgQAtNlSnMHkKEFcqw3gvGz/RnoCDMzLBx3OCCpo
         9sMVh0AbqsRku4hA31svUIakRAm+3seHEvPsmyKrESAuiJE5asbxpdYRZLmjYMMibMZv
         NCnrbA9wVFXmp20bO52s2ZkMrrNS/hX2GI2SXOjuu3VhVR0ADZdBRvZoRv9Q+Hh14Jtv
         yFWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dmpL0BrIKQ9K1FnmJJsWfuTcm+ZME8/RBnTvxlPXWB4=;
        fh=KNxlpfrZqTOG9KvxXHqfQ3hDkdZEUilgPpZnpcDkZzs=;
        b=FuDFpXCqKTN0ABAKpW4EXAT65Hp4mJeWv8qSHtX46cZJn+UnLxSpFad/b/DF9QXAKc
         UgAaY7LepBVvIWconhHYosDh48kFYupe5Icn0FP/3+d+OPX4ztmFB9SkLmQo3Usl/9N8
         5tTPuKVWOHcUv8QjSDErhg8J2Kb1NGfiTdBRBPUmlV+RyU65f7cnmClDFDBx0PBm3zZB
         Psw4mFQ+jmVWPXNWX0Hu4IbnPyu2tfhVKHH5CBWcaPjgqmnZiGHvBvazuXIOo9akB/jg
         PTafJlAINvEVfjxh2YD6VyjTfFOjC76CkDwEF5zdq5XmZSgHp1RHTV4VxnIE8HUTi6iS
         k66w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1792116435; x=1792721235; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dmpL0BrIKQ9K1FnmJJsWfuTcm+ZME8/RBnTvxlPXWB4=;
        b=XJDCHo0QM8yY1cuwMCGmz9kkBz8pHl24vMTwW+cGkRSEDrfTstYxpL85PtDZputANO
         8mCNlxhOqqWzRbwQRDlOx+fZfPeW5cPo2ReJX5FO9oacMCcPVdRyUnxBk+jhXvw53TUy
         u2uHuuSOH3hG3LNt5gzD1frxphSIRqWJBO/wiMZxRGj4iBxDOd8L7o6tLK1Rv6Jbnv7e
         NZMeOclG1BGNY3d8S7fTI0ZqmXP15G7QFy2OGSP2d58NCw7lYBnuZQHzbORqZeEHvqBS
         /0rspwkue+0iSa5jgKJOf5Kpb8DokNO2gHojfxhOcYohPUuAa+Q5SCPLZyqrfW+gZgct
         iELQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792116435; x=1792721235;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dmpL0BrIKQ9K1FnmJJsWfuTcm+ZME8/RBnTvxlPXWB4=;
        b=j7PtnzXeCQ+xEUE5sDU600GBX5YHZBaxKVeCPBNjVj2L5TGsphYgk+ffA7ih5v966X
         vs4sIfH9+2NuB6LZdvcYDC9m45Fj1yT4PCWSc5nxtPdmxGASDlgaFHyjXAyVetks1uJf
         jH1BnvqK6hWLe5ykwac9Yos4xNH0eOrlfrLDJ1FQr5OU5+5frCKRvWiEljztpDSgv3ap
         kcqS4oveCGKXif05Mf6n096FsMZq0FOFgC9eTlwhWf5j8fIRJxSc4ROo7nxooJHZuVdb
         xE3eUA89j2HziFHTi+GGzEOl9TlPhvyj/19MkQDnT+WzerXeot5BiaX0z5ce8WIF68Tl
         IyrQ==
X-Forwarded-Encrypted: i=1; AKwUvBy8FgJitVEvtiM4P+n1qt0HgoXZjjqf6rEiTvltQO2ZuZbpW+6qV2NyaoZPEURWMd4eO48ngVy1adVC@vger.kernel.org
X-Gm-Message-State: AFq9FYKwNMMO6VWzgtEwKQujwzsoEa3tNieE+vkiz8veZjBayyQ8Bevl
	SPH8xngMaaNy2vHDzHXRBIGRg0ctmN/qE/gBFj4iBFfC/2V2YCqlWfRcMp5iKcbJ1de13R1BN2j
	9BfxVLNOr9RlUsAte9qNMwQjRZaQHM5/lbYXrA2tBXQ==
X-Gm-Gg: AYBFou0YrSI6XSynbr6g+aMLxOupjECiI8UEOLK2xfPOHlmAQ2ZE3661xJhY2r3UBTJ
	InV2SGEqJ5AY41uBnunzdWhWmGFoGFvajIEg4/jeU985AjZxzZUaJqJKY1EJfb9kzmjVOtUZmg6
	2CpwKkR2HMPNZCLYe3P1MKkozpp8Mm0o/vxMsdNXcQrGA2y9bsXNE+sHKhC/Q4FvVKnVVMVzuyw
	XOVmUHyGlGi0yZERLbjlAOrDK4piQS5KnTQsft4aV6buVc9NmnQMOO7Qd3ughgcFlMJyxdfcLfI
	BY/2X9LLBcd2RbvbTuVKaMhfmi+92u6+E6HjwfmCO44zTUs3EJzel/3Axho08yVOFpMOYemHaCs
	mqqMM1G0j2Os/D3azle1aMC2hMIQBTP9AptHClF4dWqD9N5oP9g/6oVg=
X-Received: by 2002:a05:6000:26cc:b0:48d:fbd8:d598 with SMTP id
 ffacd0b85a97d-48dfbd8d5afmr3401253f8f.17.1792116434934; Thu, 15 Oct 2026
 19:07:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261008192048.98833-1-artem@trailofbits.com> <askqkXhBORyXr-v9@mit.edu>
 <CAP3zxaC92rwQNCpuK_tXR9THQOecVoZwxg8ZUgYt=0iKiMsuxg@mail.gmail.com>
 <asrNX2qBf5qBrFLu@mit.edu> <CAP3zxaD3-QYqe588XGxzTrgAnK4OQC4aRfbea1Ln452mM45KBQ@mail.gmail.com>
In-Reply-To: <CAP3zxaD3-QYqe588XGxzTrgAnK4OQC4aRfbea1Ln452mM45KBQ@mail.gmail.com>
From: Artem Dinaburg <artem@trailofbits.com>
Date: Thu, 15 Oct 2026 22:06:38 -0400
X-Gm-Features: AclHuK8inf3GXwIZ-Bnc-vk5hfu4ep2ADhdtdND_LhDfQfWlLsaqaWOgE0fQ0CA
Message-ID: <CAP3zxaAP-AunA+DTq+x1uoHBZT13TBxtUxm704OKZ3ikWUSTNQ@mail.gmail.com>
Subject: Re: [PATCH 6.6.y 0/2] jbd2: backport CVE-2026-89566, CVE-2026-89567
To: Theodore Tso <tytso@mit.edu>
Cc: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Sasha Levin <sashal@kernel.org>, Max Kellermann <max.kellermann@ionos.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Ted,

A quick update on generic/045:
we ran it another 200 times on each kernel in each of ext4/4k and ext4/1k.
All 800 runs passed:

                  Unpatched       With the jbd2 series
  ext4/4k         200/200 passed   200/200 passed
  ext4/1k         200/200 passed   200/200 passed

We kept the same kernel configuration and QEMU setup, with a fresh
guest and test disks for every run.

We also reviewed the kernel logs from both earlier generic/045
failures, passing runs, and all 800 new runs. During the test they
show only the shutdown and journal-abort messages that it deliberately
triggers, with no additional warning or stack trace at the failures.

Both failed tests reported files with nonzero size but no extents.
The logs do not explain why, and neither failure recurred in the
200 additional runs on each kernel. The earlier ext4/1k failure
occurred during the full suite, so running the test alone may miss
an interaction with earlier tests.

Thanks,
Artem Dinaburg

On Thu, Oct 15, 2026 at 4:01=E2=80=AFPM Artem Dinaburg <artem@trailofbits.c=
om> wrote:
>
> Hi Ted,
>
> > Note that some tests can be flaky. So when you see a test failure, it
> > can be useful to run a test multiple times
>
> Thanks for the advice. We are still working through the testing and
> wanted to send you a progress update.
>
> We have completed three full iterations of
> ext4/all,xfs/4k,btrfs/4k -g auto on the same unpatched 6.6.159-rc1
> baseline (72bada21be7b), followed by one full iteration with the
> submitted two-patch jbd2 series.
>
> We used QEMU/KVM with fresh guest and test disks for each
> configuration.
>
> Following your suggestion, we also completed ten focused trials on
> each kernel for 21 suspect configuration/test pairs: 420 trials in
> total. Each trial used a separately booted guest and fresh disks.
>
> In those ten runs on each kernel, we observed the following flaky
> tests. Counts below are failures out of ten, unpatched / patched:
>
> Flaky on both kernels:
>
>   btrfs/4k btrfs/028: 3 / 3
>   btrfs/4k btrfs/192: 7 / 6
>   btrfs/4k generic/449: 4 / 7
>   ext4/1k generic/051: 3 / 5
>   ext4/1k generic/388: 2 / 3
>   ext4/1k generic/475: 5 / 3
>   ext4/adv generic/455: 5 / 5
>   ext4/adv generic/482: 4 / 2
>   ext4/ext3 generic/388: 8 / 9
>
> Flaky on the unpatched kernel only:
>
>   ext4/bigalloc_4k generic/320: 2 / 0
>
> Flaky on the patched kernel only:
>
>   ext4/4k generic/045: 0 / 1
>
> We are now running 200 additional iterations of generic/045 on each
> kernel in each of ext4/4k and ext4/1k. Ten runs leave wide confidence
> intervals: a rare failure could easily have been missed on the
> unpatched kernel. The additional runs will let us estimate failure
> rates and their 95% confidence intervals to assess whether the test
> fails more often on the patched kernel. We will finish all planned
> runs before comparing the results.
>
>
> Thanks,
> Artem Dinaburg
>
> On Sat, Oct 10, 2026 at 7:54=E2=80=AFPM Theodore Tso <tytso@mit.edu> wrot=
e:
> >
> > On Sat, Oct 10, 2026 at 06:12:10PM -0500, Artem Dinaburg wrote:
> > >
> > > Our initial unpatched/patched runs showed some differences in both
> > > directions. We cannot yet attribute those to the series, so we have
> > > paused the patched comparison and are running three complete
> > > iterations on the same unpatched baseline to assess repeatability.
> >
> > Note that some tests can be flaky.  So when you see a test failure, it
> > can be useful to run a test multiple times, so you can see if the test
> > is a reliable hard failure, or one that only fails, say, 30% of the
> > time.  So to run generic/363 10 times in the ext4/1k configuration,
> > you might do soemthing like this:
> >
> >    kvm-xfstests -c ext4/1k generic/363 -C 10
> >
> >                                                 - Ted
> >
