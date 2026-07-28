Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF452D8378
	for <linux-ext4@vger.kernel.org>; Tue, 28 Jul 2026 07:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785223016; cv=pass; b=hrVi5FOx5bXZQVrTSkiOeDXAh2eCaYHO6drjBf4qVzWBWvG65dDDWNNgoxKaLZ35//5Cv40rgaubMlxlFTrXUfYWJGp57q53lSYqtqIAez4qpCsUL1ezFI4BxO70cCOjRUUfEO+SUodPqALLL4C1suTB4m3AZrdZJsQ/xOchIVQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785223016; c=relaxed/simple;
	bh=CIzeAHTKjYSjdth23Y6KsuYapPuualACZPUlNo2PKpA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sS8Dh77ctCmbLw+Mt3w4GInrEJbfyTVYbMCG0k4Yi679UnI2LFeI8uC39lNzgKPUHmcNdHYiw9ShcfsoBLzsenqcyfXD1eB21L8jS5BRkbo9EWN677qFTBAkMURkUie93X233mfFm5kC7YTUxxuU4OHYQBD49vZk7adxszT05Zw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ngK/g9WD; arc=pass smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ngK/g9WD"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-38e3617ba36so3653731a91.3
        for <linux-ext4@vger.kernel.org>; Tue, 28 Jul 2026 00:16:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785223014; cv=none;
        d=google.com; s=arc-20260327;
        b=m7SYby24JK2pM0vBZheYMA1ocno4guRhSg8C606bQh+sY5/nsuyqn8GtwuYwmb+pdZ
         LfXBW3qF32CaYjva2ZeY4SkaNtUNgYQzt1OxSIM9eLkWdyD6FW3bXqTxPp4ihL1FWOvS
         Oio10KhyDziMVumsgilII8Rcecr73F+D1dGJFoQB0Hef85J//94eQ2t3PyUM2/24E73O
         67YjsVAl9G0kmp8NvnMOa6YnMGLXOnO+PvAZkGsO0noaWsfJRmFeZZcoLPGcy7bwBMfs
         ZcPkvNyMQFHuyL2NEeJprrLvhiOkRPpvzFQ0hSIG0DwniOsHcDhU6m3CxwV8q7FrvQta
         IjIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pzZLHeBaEx6oA7oTfCIBucMK1T2IZ6zRhZSKR/t/pQY=;
        fh=v6t/WFc2+EYNUKeVV3xBwIjc+DuscSAH3YSHrMDrTp8=;
        b=W9e2ocX37abIc8f4JMmXpjg/QNBKY2n9TCe3NXmV5NUXS5OA4wYhs4XwkZpDC7ulY6
         sBSYOp8yr3UX78wvSUtwIbDkoNQ5j/Fx+ic//2w949xbswn7RoPRZLYvsfZOvi+cb6+a
         c1j8umDeid5b3Ytp/qlv3Z6VFU6AH/jGB3fsiOIoLms9dSXy6GSGLpKSwZzAba1mdCD2
         NWSzbh1DWM3svk8q5npENglZ1VM4C9qawCuXmE+MufiuJa+i2v5IO+gT3dLDi+lrQ90J
         d5A3gZ3RNsz4gGFHsmBWPtrH5Tl8vamqSnaKUcRsGYr6mXJcoXjWN8sKaT21oSBkB643
         1Hhw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785223014; x=1785827814; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pzZLHeBaEx6oA7oTfCIBucMK1T2IZ6zRhZSKR/t/pQY=;
        b=ngK/g9WDajCqb+EEUKnWpqUgW5HliGbJvxTdGc1EmSxX0IMo0zb/8dVsEcqBa4fXdP
         UzqKYIeZblaXddfDn14UPTadGIroCGaWj49P0j8dOdfQeZ23oyqc6l1ivF6DNnA3ZqJP
         qgAttNms05uKOLnGqtCShhJjGTvGkFUpsPC6pX2BPnyyVR4GiXlv2S4SrfomKmCVv7W8
         +wlJjIm79ZJghwVT71cPlldEECVIw3Lb8TtGNJGwx2M8/wFGiFrMHJtBIAk0bxDJhrcS
         6oEwgruPcX9M1bZjelxUR8sYGL/FnSFIU6R9jOyNOFwwmGNAXLETcLxtc6HN8OUixLiP
         SOoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785223014; x=1785827814;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pzZLHeBaEx6oA7oTfCIBucMK1T2IZ6zRhZSKR/t/pQY=;
        b=aL90ohh37FzntPVod0lr29Vk7oj18gQUr0ZQjqNHFPfRgA63QlGabKwDvU3BZ/y6s/
         nb08NzFmlPNiFRkE7yErJhsvVWGHudSG0H3oIVCBKaPJgnBoXPtd9m/Nn2ZFSYDlzj0s
         TLrzpl7tkyjJDVlorxoqfHdEHG0Irm2ZLJ35RWm/TZVQ3ilLi2jWLYUIgz6eV4T1Kd/v
         oVwa/66lboJFhbOckPCMLxfyz7xj6bJZ6jTfThWU84J1RVLrEVo+oUdVIajz4q7oF7s6
         HIj13KTkHM4nzZa+8mRzsgKY8t7yy+HQahcwJaelDhn9Ls9QMYlye7wU2rqG5YjETBtO
         svYQ==
X-Forwarded-Encrypted: i=1; AHgh+RqJHYJ6wIFfzjTbdgvFzHgnlDF2s6D6Yep8dXv/IGis2sxKfcML6hebKGNd/X2DEIPJrSMC+N75la1X@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2AzLvWnXuk2Kd/dUg4Op8LlnI5YRW6aIVYzU9722/1ZD3iVVs
	nmzvZOEHHptQdILU5PbhfTh1duX/2Cy6+xTGEMpFF8ydRcqVc0dOsIYhKQx4hd8tE1u2qw8cW62
	lNIz7HFQ08HDWuXbSp4GG8qUHUcyjg2GxNec3T0+buw==
X-Gm-Gg: AR+sD13gmw9r6sElH9ewcSU6FlkaOjuFEhMQV3s6y1aONDv2qL/vKEBT1dPxiBW+XDN
	fvmdq/bDN0bui/0KGJ1XALNyb0A6U2Ad+ZYnx1UYK9FthiW75MQveF63e3Y8urPRZP/ro241LFo
	LgdPicmlFpnOLRcHAbYzISd47OAjapgnNmizRMhbf80SZ65ser9mlCs5ERQktq8rnZqp81KVowB
	jHAJW3BTj9TjUBNCqrAUQWAJr0hQpz0/LuBLx8/4jk/t9BnyJk/IG1+JlXgjx9ytKOS6phyiLRk
	FbMzHi+qCqRz8GJ1EF0=
X-Received: by 2002:a17:90a:e70c:b0:37d:f206:a2ac with SMTP id
 98e67ed59e1d1-38f6a33dcd2mr1158623a91.7.1785223013842; Tue, 28 Jul 2026
 00:16:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260720034441.3900050-1-rafad900@gmail.com> <2joyziupzemt5vjdvmnic3kcdckt6z5dht6vgusxsxrfbtthhn@uuiexxvvcclv>
 <amePTzFUaAEZ0cgl@mit.edu>
In-Reply-To: <amePTzFUaAEZ0cgl@mit.edu>
From: =?UTF-8?Q?Rafael_Alejandro_D=C3=ADaz_Cruz?= <rafad900@gmail.com>
Date: Tue, 28 Jul 2026 00:16:42 -0700
X-Gm-Features: AUfX_mz_ZOBSFNfm6kgPmduich1pdozSjv8QJzt_0vasyCU44WmISkfO0596Hqs
Message-ID: <CALp66yFWvPuj+y10FZowt_3ai1uzwT1F1tLQKeatNVuPX6Up0A@mail.gmail.com>
Subject: Re: [PATCH] ext4: convert pa_count from atomic_t to refcount_t
To: Theodore Tso <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello everyone,

Thanks for the helpful responses! My name is Rafael A. Diaz Cruz and I'm ho=
ping
to join the Linux community. I have a background in CS with a Masters from =
UC
Davis and am currently working as a Software Dev at AMEX.

I read the kernel in my spare time and joined the LFX mentorship starting i=
n
April of this year but due to personal reasons I wasn't able to dedicate
much time until recently. I do hope to contribute more to ext4 and the kern=
el
as a whole, however, given that the kernel is over 40 million lines of
code I think it
might take me some time to catch up :) I do greatly appreciate your
tolerance for
my lack of expertise!

I did continue looking at what the overall ext4_prealloc_space struct
was used for and realized that the pa_count was being set to 0 on purpose. =
I did
not understand it at first given that other subsystems in the kernel
treat 0 references
as the object being completely dead. But I think I see now how it's being u=
sed.

I did try to build my mental model of how ext4 was treating the
preallocation blocks
from the comments alone, yet, it's taking me some time due to the sheer siz=
e of
mballoc.c and its complexity. I was wondering if there are some diagrams th=
at
show the flow of the overall system? I get lost in particular when
thinking of multiple
threads reaching the same function.

Also, I have the unit tests for both the kernel and the ext4 fs but I
would like to know
if there are other methods by which I should check my work besides QEMU.

https://www.linkedin.com/in/rafaelalejandrodiazcruz/


On Mon, Jul 27, 2026 at 1:17=E2=80=AFPM Theodore Tso <tytso@mit.edu> wrote:
>
> On Mon, Jul 27, 2026 at 01:57:11PM -0500, Jan Kara wrote:
> >
> > This is a bit problematic as for pa_count 0->1 transition is fine (as l=
ong
> > as pa_deleted isn't set) so this conversion will trigger false warnings=
 as
> > the 0-day report shows.
>
> For better or for worse, the lifetime rules of the ext4_prealloc_space
> structure don't match those assumed by refcount.h.  Which is to say,
> it's not a reference count the same way that say, struct inode's
> i_links_count.
>
> The whole *point* of the preallocation space is that we are holding
> some blocks for use by an inode or by block group, because it's too
> expensive to figure out that this set of blocks is available for
> allocation.  So even though pa_count is zero, meaning that there isn't
> an *active* allocation in process, under normal circumstances we want
> to keep ext4_prealloc_space around and linked into its relevant linked
> list.  This is why the pa_count 0->1 transition is OK, and it is _not_
> an existing "use after free".
>
> There's actually quite a lot of documentation in fs/ext4/mballoc.c,
> but the comments don't really make this point clearly enough.  I think
> that's because the assumption is that this high-level description of
> what the goals of ext4_prealloc_space is assumed to be known by
> everyone trying to modify that part of the block allocator.
>
> But given that we are having more people trying to submit changes to
> ext4 (in some cases, assisted by LLM's), it might be a good idea to
> improve the documentation, both for the sake of the humans and the
> LLM's that are trying to understand how things work.
>
> Just for yucks, I asked an LLM to explain what a human might want to
> need to know about how the ext4_prealloc_space sutrcture was used, and
> it came up with this.  (See attached.)
>
> I don't propose adding this directly to the beginning of
> fs/ext4/mballoc.c, but we might want to see if there is some parts of
> this that we do want to add.  (And to seeif what we currently have as
> comments at the beginning of mballoc.c is accurate, since I don't
> think anyone has reviewed it in a while.)
>
> Cheers,
>
>                                                 - Ted
>
> P.S.  Hi Rafa/Rafad, it appears that you are a relatively new Kernel
> contributor; I see that the only other patch contribution from your
> gmail account is was to attempt to address a jfs syzkaller issue.  If
> you intend to contribute more ext4 changes, welcome!  It would be
> great if you introduced yourself so we know a bit more about who you
> are, and what name you would prefer to be known by.
>
