Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8177426738C
	for <linux-ext4@vger.kernel.org>; Wed, 15 Jul 2026 21:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784149563; cv=pass; b=aY6wSQtT2U2tov1PCTIIqEJLhMmuX9ZGI2fdX27txkdGHboLh1hfSUCGodXMGOJ21zWrvs5MJebgf/lBglHzJK1uQEjcicHYyvT6KdQJZExPraDz/iRf+F4Z+QJkh5wQ4hjMEy8jgAuiPQU+crWfF1lZ4E3pMhoe6q9lkesbOlc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784149563; c=relaxed/simple;
	bh=ohcHmnwMMSDmJjfmYivpS1QS5sro1hDQqWxGQZCr6A8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dlk3uPxUFaAjGRVdltkOIWU0SzraJvHNkWQJFJmcXEzZomfuMFCpwflMMVDyuRZTYA5/TGnlvSUHtnBqATOcIzv0WZi3iDU1xjFPcZ/SbP/NjKocmZh5A+J5p4hGnccU1AszM8Yab9DbReUM42SsvYmda+GRdwxvHV694QQQBTk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wOU4GZJt; arc=pass smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wOU4GZJt"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2cc73e322dbso72133175ad.1
        for <linux-ext4@vger.kernel.org>; Wed, 15 Jul 2026 14:06:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784149562; cv=none;
        d=google.com; s=arc-20260327;
        b=otqGArETKr4PSEKdiRM+COF2+K1fOc/qVAPgm++1yon4bZR8FMcTq7ZqWHngbEQBpX
         571IzF54OtGvnLB9yoyn1IrDOlJfMElQOTftCckweyj3fMCWumWvvlgRXXkgDqoL0gwI
         mpiN2njh+3Ltcs8xFt1azwarcIIeBF/BHGOmJSRDs4E9CegvzaAyhKQIk1V+yTISkXPm
         ZyKU5sZA8TfXk+M6am30tsgTCQj9vW/O0b8EJSRRoFJkj2Bji7Qsfhg+fPLdsfwGq1Gw
         qzKiRIx4fiVh6rYHFr9wxOI46D3xIZdYM+4ve5vAbRUu4+Gqgz2PyXiAjEsKdGm8LH5u
         O+7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ohcHmnwMMSDmJjfmYivpS1QS5sro1hDQqWxGQZCr6A8=;
        fh=Gn+IGE4crpZVVE3wgazTlE2LlKJK2voYfR9vZnv84Qk=;
        b=A0Gyn5zVqO690CH6s6W2fbwTs59EwgVjLaGc/xWa71nZ6QnlZkwbkFApeqfqbhexvD
         UKWT7sI6LwzyBu22bFbu663DpdWcvVz1IpGyKU4eKp7EHzxiHi/jByp8RA32GjUlacTV
         q9fWlmmN3+5mxpe0j8weSc/p8RVTi0ZPcMNo7rkrrh5CyEXGuX+oVF4eWydEMDUmHh8T
         aIojOxOAl34Vn/Ay8oWSalhzd/Vg81lEvCX4Apxh4pjlJy21MhjSJ82tyboeZEqWc2lu
         cPUYIePCU7BHQOLX6CHhrCR458OgIF0v52U+ZnDYGEObI49fIj6zLY9adNcQyyqj5TwZ
         4uyA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784149562; x=1784754362; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ohcHmnwMMSDmJjfmYivpS1QS5sro1hDQqWxGQZCr6A8=;
        b=wOU4GZJtSU7Lwga0jExKpSsyOS5owiRux3+9bhSuC5A3nsnBPX69zxGDrIgFa+wLEw
         xmkJSpoXnsKplAF51qLQ4QIQasfo/qLp3mRAIxTKS0waoIoq0ORGX+RsM2RLqA2TGuLV
         rfgaEbVK6Qh7yE8yr5oI5ar2kKU4ruwxkmsEq2SkHvqzCEFlMoYY7Wxd7E+tcQLEktMT
         kWDiRTL6185fjIE9tuuVElTHyHfp7slgZ6sfQ9hsEyjVfYfxnccDKTXfBumVP92YbKub
         q+OrF4Kq/9BzK+pVaw/vKAawjQTJtBO9U4U8yhl0JuVzzYA7wJzCaa1iT9CCo6mpYr7H
         B+9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784149562; x=1784754362;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ohcHmnwMMSDmJjfmYivpS1QS5sro1hDQqWxGQZCr6A8=;
        b=Ynmd7wHxd25jtSKOmwyHViiWC9LZY09qBEsf0EpBP9ARqQmLhJYn3I6Iq4kZpOSykS
         Fe6p8r7ItbFd7bDZOYfDCOXIT8VBG4vkfD9vmnHBoXUIFz9d+/YPFOC4ZGixapa816hU
         cf0EENsEypJLb9xenAzWPeTkS+3ogqV4rYrVOERBNL6Ah5ASQr4AH5/6B1+lEhnxVrdu
         sc/s97k/lrMttMlIVUhKS6CL8XylZ5TRs8YMmc3xC8AnUWf1UUZsTTcWE+2QM2NU0+6P
         zJpKPLjk6OFGmbC+7Ppv/eusUAk/LC/iLrf2FMRlMvqRo+XTi3Gecwrkb3HOB4+kMPhN
         1PQA==
X-Forwarded-Encrypted: i=1; AHgh+RpUcc7b853qpjRfnqGC2MKEkPEQrDRt6m7/B3mrc6TQ7PThRaL6BknhhiQFo8Dx23LsJ7s0l26PsRoF@vger.kernel.org
X-Gm-Message-State: AOJu0YwUg1fHiLyHrXiLDvnxwOYknEFU2e7+vWI39ZCGKsxYMIH/Q+Ra
	tP7tgfxlNCRg94hWqFM6c0u1R0ZMjUARh/7MXmfL0CMnSnsE6ucuGAXB3mOI/3hjHpY+NmX9jfA
	QDXxgf0a9AbK9rX/nfB2YW/bQV+kiJHZ1hMg2VnDE
X-Gm-Gg: AfdE7cmOPJl8z2YjwbrPEffUFehp5UmHyXdrqn6Ju6oSfijmaBZrZBSEoIVCp8jU10p
	Y4OyZD5CHAPDiTnBUEByf8Am43EeDSvCLHGzkkerkHYS1KI6kBVKiMyAMsByY2FmFCvO++3S8e6
	iQcCV1JkPD1Ep9zKnoiSZDSHo57NAPk2gFr5gJoIpAc94gUPKqBdWrReaHGWC40tsIEmme7IlQU
	ZjFqspgu1mRsga3ZK8K05f4wAZ/QDqT71S63Oaai01O0IR6rhxD3+GV12qnPw==
X-Received: by 2002:a05:6a21:68f:b0:3c3:5c54:b841 with SMTP id
 adf61e73a8af0-3c36c1cfa7cmr4647228637.34.1784149561545; Wed, 15 Jul 2026
 14:06:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260712165610.366474-1-timday@thelustrecollective.com>
 <20260712165610.366474-2-timday@thelustrecollective.com> <alT2yHlfzhTZ9n4T@mit.edu>
 <20260713164417.350710-1-timday@thelustrecollective.com> <CANpmjNMfQT6Z9ke4x49sp6z8+pt_5ZLUoSh0da-99bwos5-8Lw@mail.gmail.com>
 <CANpmjNM5CmQc_YG_5=zhdLCr7gGL3QYPcd4R4=m2NzwNY03d3Q@mail.gmail.com>
 <20260714211246.1046948-1-timday@thelustrecollective.com> <CANpmjNNU_GiRW6y24hvbUsXze+jf+9ptx8_Acq1Y=mvPSr=wFg@mail.gmail.com>
 <CANpmjNMgH3sX-RoOjo4Vo2Dqx7=3rov1Mz02u+vKt4WkNuSg3g@mail.gmail.com> <20260715162742.280285-1-timday@thelustrecollective.com>
In-Reply-To: <20260715162742.280285-1-timday@thelustrecollective.com>
From: Marco Elver <elver@google.com>
Date: Wed, 15 Jul 2026 23:05:24 +0200
X-Gm-Features: AUfX_myRuHlqL0Vte2HOV7aqxou86jIYi-LrBKmgVTBcKZQHoVH6q4rRg3tFW9w
Message-ID: <CANpmjNPR0kEjBZHkODU-fwjQkue68Xbs890qHnVrZLiDp18Arw@mail.gmail.com>
Subject: Re: [PATCH v1 1/9] ext2: fix ext2_xattr_delete_inode() context
 analysis warning
To: Timothy Day <timday@thelustrecollective.com>
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.com>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Alexander Potapenko <glider@google.com>, Kees Cook <kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 15 Jul 2026 at 18:30, Timothy Day
<timday@thelustrecollective.com> wrote:
> On Wed, 15 Jul 2026 00:52:07 +0200, Marco Elver wrote:
> > My Clang PR was merged. Can you rebase and send your Clang fix and add
> > me as a reviewer? Please add a more elaborate commit description,
> > because it's a little more intrusive and the problem and your solution
> > is less obvious.
>
> I submitted https://github.com/llvm/llvm-project/pull/209796. I tagged
> you in a comment, since I can't add you as a reviewer myself.

Thanks.

> While I work on getting the LLVM change landed, I might try adding some
> annotations to other drivers. I have a series for infiniband/hw/efa/.
> And I've been working on Lustre as well, since I want it to enforce
> context analysis on it once it's accepted upstream.
>
> Is there a roadmap for future Clang static checks?

There are some ideas around Clang's lifetimebound (+cc Alex looking
into it) being used in the kernel.

> Other ideas for
> using context analysis? I'm really interested in using Clang to
> improve the correctness of kernel code and I'd like to help get this
> adopted more widely.

As for context analysis, there is still lots to do - mainly, enabling
more subsystems to use it (which is more incremental vs. the initial
infrastructure chunk). For context analysis infrastructure, one thing
on my list is to enable more context lock types, esp. adding support
for preempt locking (preempt_disable()/preempt_enable()), and IRQ
locking (disable/enable IRQ and all its variants). Preempt locking and
IRQ support is likely a relatively big chunk, and I just haven't had
time to get to it yet (I'm busy with heap partitioning in user space
and kernel right now). If you are interested in this, please email me
separately so we can try to coordinate.

Thanks,
-- Marco
