Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99CBB3ECBD4
	for <linux-ext4@vger.kernel.org>; Fri, 27 Mar 2026 11:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774609789; cv=pass; b=TySfp24vfUTv/a9I7lePi4EREjbsrYBiVQrYvezhkAGZuXxowqHFH1Q1OqwpaR1PynEl19jDbKb6cvd1HEzvBVUHhGVPuwejCAn9vvN+e6iI/dn/ttemz0ZxgpWDykOx+azj3DVMJ0omWcpWj0Aqqy3TXmDLwAtlU1VbHfh8kG8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774609789; c=relaxed/simple;
	bh=ZVUSVN22rirdB2W+suD1qjIDwFy/2R7FDSsezZv8VSQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E9DW1VV8NVyAmv739f4Uyvz2V6rj4D14Qgpv5sReQZyf1MCYFp2KW1H4ljO2M4wopZAOtRL6uOYYrNPDhoIyxkHr997qyUp62XU9/d4TbfLzsuVpQqArm13YTfHlh8sEx5T2mmih45ZppDZRRUuK/FLfDcUBnxBGgHbLTkGnz3Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oJTa2gs1; arc=pass smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oJTa2gs1"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b980b35534eso463904166b.1
        for <linux-ext4@vger.kernel.org>; Fri, 27 Mar 2026 04:09:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774609779; cv=none;
        d=google.com; s=arc-20240605;
        b=DiRg1EWcB2ZUhrQtjYmHXENaWxMwqHxK4x8nEQoqClgj4473JujPrLEjPoqQDjvB9p
         4T3DrCDYC4T1ja5NUgz1yntFwxI4AQfKL77YfL2jsX5X6Ic1l6btcTLAnpd4KHtl5dnw
         LEbTyoWdYS/ef+dyM809tfKMXjLMdOu4YTxhac7YqnykT9VekBHZyHHQyflrG5GZ0bpY
         26MQf/51tQf2JxU0NGXXunC0QNutNeDJUQq/dQCxZoP/RIck4mniRx+IYwqY9+pQ5SkI
         PNQRGdHmpNwM1ye6jlg4qkSGom3j+rlGnkKWEqQs0OeKZm0ka/6wvKOA/j4ZNPGUuqoS
         DDSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qByozSkeAIvuXKwVx4Y1ULXB+DloAKTWtZ7pVWLDr2A=;
        fh=Q97IFsbDoudUBWN1OlYlooglfetTZII+3ioZvYbnQ5M=;
        b=PoS7rWz1+G7Kbw79fXtyCKjjRqXga9Tz+JwohuNvRlo1MrTEFcX1JabBR/mZsX/9k/
         oN+077I7a/niHlaNzqMbwVeQ6sTsUoQxETthL+6C6gaPPxoM7M/V5o/xVQZTnMxvZ61z
         X6RU/RN/dBPz2oZACyS03CJoMFPZ3wVKs4CEdvXG/b6SKTYvKmsDf9DdwSQRqJarXXQe
         IZHLGH74ZnmNyxkVB74yTwTfJol4avKQch04/6cXSQSdKkOCEPp8j/eOunJZYYFvnxmW
         TopQbmPmGWylCrToVgv1qGkbtxl2aTQjjh98H0WpVSYXp3jzO4E3VvSrXrk6LtFY6yIO
         kttA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774609779; x=1775214579; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qByozSkeAIvuXKwVx4Y1ULXB+DloAKTWtZ7pVWLDr2A=;
        b=oJTa2gs1N55wIpENqrRMTHB8A7/O6skSt1ymi7jTOAUyPSutz67dcIcceYSbKaMfDV
         o+d/gxuJ7aWksPMw7iRLwjwjIWBK/eSTDqandNFVpyDWNxlgYBTtd2cE89IIlad+tqWB
         35YzmFIUWhPkBG2PFi9jcEP3aOhovYvHvYhAl2YQClbggCdX8BaCZnDtbm004bgruPHk
         E0Ib0Qf4Nb4jx6NX9qDBuEcns5fAWN8xrNNp1LsaIJg4c3zChMEMpq1sQIeGmXw0B5am
         M5Lpx9apWme9gt6u5qG1tsXPeKdo4nN2aNFs9wgnPi5LFJL+bGrW8fkp2JBHGJEvCgEO
         yK0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774609779; x=1775214579;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qByozSkeAIvuXKwVx4Y1ULXB+DloAKTWtZ7pVWLDr2A=;
        b=CF3lj9MfAGsvkRtkditIjd9rOYEeR7B+ayF6KeL+OTNnbqzbGo7NWGueBhEngiPcuR
         H006Xx97mZgtljZSjc4NsnurcitiiPtHWfK/LnUm1GK5f5OdP6Yl/xbYmTrH/zfRO9+f
         KxOs46PFVs7N+hpc6hAKiyAARzlzhUGdeiaDxjCEDtp5cMijsXVbtjjcZQ/Xq2oGMcuz
         yv6+Qe8jlcOwZYjI4c4ESS8WYq5+4YfOHotWhODUB6AY4nforaHyof6mmxImds2qvITS
         j3MNiE4FIi2G2fTQA/RrfO5alt3rdBnnNRbGMfW1JoZFtYHNJ5mlrGb/bHr4ghmq4qZA
         F5zA==
X-Forwarded-Encrypted: i=1; AJvYcCVuh6cDluqbN1Ex8HFwoz6cYJacvbelNe6F9UHOuTi34SwdnStEFARgUaknA8PB3givzVKKNunsZ8Ne@vger.kernel.org
X-Gm-Message-State: AOJu0YzJxzM/bGTLjOuU+hxdrI+gGjO6oru2+blslwrwNH0We8Uopo91
	/eVuC4c2zgbXVuKPu9Y2sO7qoU+MhmWU16sNb9TDzFVfqAVxTLAff4u8201uKKPoNTl/KSfTWZm
	dVFjgzgQ3omFxgC7vxSKtad84ZVK6Olw=
X-Gm-Gg: ATEYQzwZimfwOAzxOMspbXZRVMff683C5yZ7JxWGR3d88KHnqklRQ50SXXJCr7ss+93
	2bPYrhYsnGY0dy0eeE+qcK/AXV5nZux5fbFw9hdX6AGIx5gizu4o3T4toCr0a1fMVxFspALPwTv
	lDS7L1DRWsyiwDH3kB9JAU9yDaABTTKnyVOhbc6i7cm1ZnDphvQ9b0yiHvqdiGGNYAFV0vSwFX9
	wUhoG9kL/oPQo3yae0lhKL+3DYloBR5gFB5rgwF7MkgcNgqPcrG34NF6mU9mzM24LnNqubnC2cP
	kAHJk+00ab4DFj7wTDq74dsjMG0G6HedXchEou+13A==
X-Received: by 2002:a17:907:3f8d:b0:b97:b88c:386b with SMTP id
 a640c23a62f3a-b9b2eb9bd1bmr316439866b.29.1774609778731; Fri, 27 Mar 2026
 04:09:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260324145750.90719-1-amir73il@gmail.com> <acN457svKhT5TcKI@infradead.org>
 <CAOQ4uxh5NFvXGop6ne-zfRbH5p6BPT2kCt7dUkP__-TtpeJjJQ@mail.gmail.com>
 <CAOQ4uxge9QDMwnLr1+W0xF2GocnFWVrbhRdriaf5Qe+4KkrG4Q@mail.gmail.com> <acYZglh4iyauvDZj@infradead.org>
In-Reply-To: <acYZglh4iyauvDZj@infradead.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 27 Mar 2026 12:09:27 +0100
X-Gm-Features: AQROBzC2dL79PdiPpxlUD5MQNlb4iqMJeIMOPJZddoCKl1fQWRstl-FZvT8sICw
Message-ID: <CAOQ4uxgw55ibvCx2ihXZ_oEfRQsbBacaoRi4onUWu_XDp9w1nQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: make fsync after metadata copy-up opt-in mount option
To: Christoph Hellwig <hch@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, Fei Lv <feilv@asrmicro.com>, 
	Chenglong Tang <chenglongtang@google.com>, stable@vger.kernel.org, 
	Theodore Tso <tytso@mit.edu>, Ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

[CC ext4]

On Fri, Mar 27, 2026 at 6:45=E2=80=AFAM Christoph Hellwig <hch@infradead.or=
g> wrote:
>
> On Wed, Mar 25, 2026 at 02:11:31PM +0100, Amir Goldstein wrote:
> > When an overlayfs file is modified for the first time, copy up will
> > create a copy of the lower file and its parent directories in the upper
> > layer.  Since the Linux filesystem API does not enforce any particular
> > ordering on storing changes without explicit fsync(2) calls, in case
> > of a system crash, the upper file could end up with no data at all
> > (i.e. zeros), which would be an unusual outcome.  To avoid this
> > experience, overlayfs calls fsync(2) on the upper file before completin=
g
> > data copy up with rename(2) to make the copy up "atomic".
>
> Sounds good so far.
>
> > By default, overlayfs does not call fsync(2) on copied up directories,
> > so after a crash, a copied up directory could be observed in the upper
> > layer without some of its attributes.
>
> This does sound a bit scary.  How does a directory copy up work?
> mkdir + adding the copies up entries, probably with some chmod or
> chown thrown in?
>

Don't worry, there is no attempt to implement "directory content copy up"

There is only "directory inode copy up"
or in a more generic description there is:
1. "inode metadata copy up" - attributes, xattr and some fileattr
2. "inode data copy up"

Copy up of directory a is:
mkdir workdir/tmpdir
set attrs on workdir/tmpdir
fsync workdir/tmpdir (fsync =3D=3D strict)
mv workdir/tmpdir upperdir/a

Copy up of a/b/c/file is
copy up a (if needed)
copy up a/b (if needed)
copy up a/b/c (if needed)
open O_TMPFILE
write data to tmpfile
fsync tmpfile (fsync !=3D volatile)
set attr on tmpfile
fsync tmpfile (fsync =3D=3D strict)
link tmpfile to upperdir/a/b/c/file

But note that the trigger to copy up is file data or metadata modification.
Overlayfs provides no guarantee to persist the modification unless
user does fsync themselves.

Overlayfs only provides the guarantee that if the copy up is observed,
the observed data is not zeros because data is synced before the link(2).

> > - "ordered": (default)
> >     Call fsync(2) on upper file before completion of data copy up.
> >     No fsync(2) is called on directory or metadata-only copy up.
>
> "ordered" sounds like an odd name here.  It's more like lazy or

The inspiration is the journal=3Dorderded mode which provides
similar guarantee to ext4 (after the delalloc mitigation) -
no zeros observed after write+rename even without  explicit fsync.

> "nodirfsync".  And it might help to explain what this implies, which
> is that the fsync on the files in the directory also sync the
> directories out, because they are usually modified in the same
> transaction, and a traditional simple log model implies that.  That
> traditional single log model also implies that you get the metadata
> file fsync for free in that case.  I.e. if you did:

I wish to avoid a naming discussion, so this is going to be fsync=3Dauto
and documentation will elaborate on what it does.
See rephrased doc below.

>
>         for each file:
>                 sync_file_range(file, .., SYNC_FILE_RANGE_WRITE |
>                                     SYNC_FILE_RANGE_WAIT_AFTER);
>
>         fsync(dir)
>         for each file:
>                 fsync(file)

This doesn't happen but I get what you mean.

>
> at least for xfs (and probably the others) you should get the
> performance of your ordered mode with the durability guarantees
> of the strict version.
>

Honestly, we did not think that adding fsync on the parent dirs
would impact performance so much, that is why we did not
do this opt-in to begin with.

My guess is that ext4 fell from a fast commit workload to
non-fast commit workload due to this change.

If ext4 developers want to investigate, then may do so with the fsync=3Dstr=
ict
mount option. The regression report is from Google COS so...

I just want to make this ovl behavior change opt-in because I do not
want any more surprises from any other upper fs.

Thanks,
Amir.

Durability and copy up
----------------------

The fsync(2) system call ensures that the data and metadata of a file
are safely written to the backing storage, which is expected to
guarantee the existence of the information post system crash.

Without an fsync(2) call, there is no guarantee that the observed
data after a system crash will be either the old or the new data, but
in practice, the observed data after crash is often the old or new data
or a mix of both.

When an overlayfs file is modified for the first time, copy up will
create a copy of the lower file and its parent directories in the upper
layer.  Since the Linux filesystem API does not enforce any particular
ordering on storing changes without explicit fsync(2) calls, in case
of a system crash, the upper file could end up with no data at all
(i.e. zeros), which would be an unusual outcome.  To avoid this
experience, overlayfs calls fsync(2) on the upper file before completing
data copy up with rename(2) or link(2) to make the copy up "atomic".

By default, overlayfs does not explicitly call fsync(2) on copied up
directories or on metadata-only copy up, so it provides no guarantee to
persist the user's modification unless the user calls fsync(2).
The fsync during copy up only guarantees that if a copy up is observed
after a crash, the observed data is not zeroes or intermediate values
from the copy up staging area.

On traditional local filesystems with a single journal (e.g. ext4, xfs),
fsync on a file also persists the parent directory changes, because they
are usually modified in the same transaction, so metadata durability during
data copy up effectively comes for free.  Overlayfs further limits risk by
disallowing network filesystems as upper layer.

Overlayfs can be tuned to prefer performance or durability when storing
to the underlying upper layer.  This is controlled by the "fsync" mount
option, which supports these values:

- "auto": (default)
    Call fsync(2) on upper file before completion of data copy up.
    No explicit fsync(2) on directory or metadata-only copy up.
- "strict":
    Call fsync(2) on upper file and directories before completion of any
    copy up.
- "volatile": [*]
    Prefer performance over durability (see `Volatile mount`_)

[*] The mount option "volatile" is an alias to "fsync=3Dvolatile".
