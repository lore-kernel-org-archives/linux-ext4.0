Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D50331EBB
	for <linux-ext4@vger.kernel.org>; Mon, 24 Aug 2026 22:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787610031; cv=none; b=hURvO1MQtytiqSHKxO1BVui94quL2w+ZIFzCA8RrNlKgM/QpfEEUFbq1fNm7TqrT6foxLAWKg4gDQSDWnJqpQifb9sB3E/VI0REOVsUXl5xkPkgo8aIlb6rqyjXL7PIIsQhlYxdOAAhzK3R+1mCALIy+TTeNrhx6TD5OFrvivxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787610031; c=relaxed/simple;
	bh=N0jBuRzZl2+emWBlhxXqz2g9yuS01vKSn9d/0jJqTvA=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=ZHbRt4JaTrkWAjqWKw1cx1OvymnpKohcjKpzP50EABstITD0MrHXIv6UOq1gOcwfRzT49nryw4zX2y8piJa1D4cZhvdSsPv0NGk5887X1pfHFL1QQguqgoRAH/Id75TnaUuVrwW3OsRmqsq474Kte0L4xIJCntIPfL7WvfJiDDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b=tx3OuOxO; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b="tx3OuOxO"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3900e39d935so4319624a91.0
        for <linux-ext4@vger.kernel.org>; Mon, 24 Aug 2026 15:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1787610028; x=1788214828; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Cp2QPBkidtttrv3sl9K0M0pxvmtqwSjq5nwYEqJbxsU=;
        b=tx3OuOxOQvFibOWpg1cfTAb6he4PmPRKKRFdXRE/r5Dv6wxOl/AdQMcjcZuM+0KuqJ
         WKHs8cyHDZAMfMH+KoJS8TPTClD/4r0ukywEoiI0I1AlgWIOwBqnHSvo0T4G43BMyDUI
         kbq2Ijd1C0aG9Bhez66VJ8+F/V/HDFHbx+vufNW6rxWjl+AOi0Ts13e4adKsg2q+OpTe
         Km28VMuSylUETGn+Pif/A4MP3Bzkrh3dtoBSBf/9jKD5XAFeVpg+27bOi1sDY4SDLAii
         80Y0sKe/f+QB3EODX9BLJ/U4P89acylH0bxWcgpFKhJ9YsID/gr4Vd7sf6U0oNr/iPBn
         cQuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787610028; x=1788214828;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Cp2QPBkidtttrv3sl9K0M0pxvmtqwSjq5nwYEqJbxsU=;
        b=ZRaJNnIu2+owyL6AMS80ID5ri7fMgXXCkHzRo3mpSptaJOfJH5Jm8qxheZ6sgEALcl
         mzYCErqgluw4GYOA1s6PIs9a3rv7lfTwyKmilsuYWMij2bsMFgTkMVI8v8oHESHLsjxO
         a3qTgyUspcPoLp8ANgkQj5624glvnX7G+aON9lRdU9vCWNY2vrT9Mbzsof+v8p6HAo3f
         8gq3Acxzz+2hMLrbAo4Q+wJkbyriqPDvaVBTzLYWRCNGY9ErwP6RuXxisZMC0uOFJMoQ
         lh192/CHfWq1K95FapcqbTueT6VTE/yZUQyW8ay6nftL9p17VHB8HvVcEymHGe3buBzB
         7dww==
X-Gm-Message-State: AFuF++nbZ03+zcJKZAZ10bdgttImC7rr/+ZHl58F4V1PNyCjWvS8mz9U
	2bDRd/TZd6thfQHl7RpIP3y0ZwgGmy/5Jm6O40xl4WjUOx3QlK3OzYXg4qJSnIYrI48=
X-Gm-Gg: AR+sD128KI7SEwHMXjO625T7FIWH0Vxh3sIrihcCRsTXmh8B6S3XK/dcsBY8sV+DWkE
	MLNzG5yJ6QWxusbSf5svbOnheKy49aNAOcnbJzbpjfHbbtyDcm9u9QL5xR45GCEj7u+c7u5yMBN
	w96PN1x2TaWygV/ubA0I3Pty1UR7nX7KcK/Taqi0rL9AC71NFmWLBpu9wdhkPij24qeefiWDnYh
	ciUOjx02enC6H8nUm67NeO00wCXWLeG/pSf9R6I/4KZx2+Dig7/98CsriF48vjo1SQs8dTnm3TI
	UUccA790/jKjGw/IUFtSGZfhdqm4DBqt12Jj4l1TnDEPUoJ1HzQIVoYdVTpBLJmV8DF/eWBMQRD
	J6sujvT6R+3y8KYJ/RIonPbqMmErSyM3Q4gmCmeybmTVM8WIy7l7m2OgWBlO7/kFwVhNqgqTn0k
	iP6Wwq3PPRLtNqjeyi8cIhzcVUsREQ1YsJDVz6XQiRWTH7jEVCYfAF2jSdGAUYUDop7qFLpiT+i
	H2s+7um601LRW8SxQ==
X-Received: by 2002:a17:90a:c107:b0:37f:bfa2:1887 with SMTP id 98e67ed59e1d1-395deee4081mr43101945a91.8.1787610028449;
        Mon, 24 Aug 2026 15:20:28 -0700 (PDT)
Received: from smtpclient.apple ([2604:3d09:3a84:1700:d995:f2d8:d5c6:a713])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39645d69f74sm1040711a91.14.2026.08.24.15.20.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Aug 2026 15:20:28 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH v2] e2fsck: take flock(LOCK_EX) on whole-disk device
 during filesystem check
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20260824161512.1332649-1-naraghavan@linux.microsoft.com>
Date: Mon, 24 Aug 2026 16:20:17 -0600
Cc: linux-ext4@vger.kernel.org,
 tytso@mit.edu,
 srivatsa@csail.mit.edu
Content-Transfer-Encoding: quoted-printable
Message-Id: <2AD89F96-3B49-474C-A777-89B7557199B8@dilger.ca>
References: <aoxF8FvVffocUSyI@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <20260824161512.1332649-1-naraghavan@linux.microsoft.com>
To: Nandakumar Raghavan <naraghavan@linux.microsoft.com>
X-Mailer: Apple Mail (2.3864.100.1.1.5)


On Aug 24, 2026, at 10:15, Nandakumar Raghavan =
<naraghavan@linux.microsoft.com> wrote:
>=20
> During journal replay, e2fsck writes the primary superblock back to =
disk
> in multiple I/O operations. The payload lands before the checksum, =
leaving
> a transient window where the on-disk superblock has a bad checksum.
>=20
> If udevd processes a change uevent during this window, libblkid probes =
the
> primary superblock, finds a checksum mismatch, and concludes the =
partition
> has no recognisable filesystem. udev then fires a remove event, wiping =
all
> symlinks in /dev/disk/by-label/ and /dev/disk/by-uuid/. Any mount unit
> that depends on those symlinks will fail.
>=20
> udevd already serialises its own partition probes against whole-disk =
device
> access using flock(LOCK_SH|LOCK_NB); if EAGAIN is returned it requeues =
the
> event. Take advantage of this protocol by acquiring flock(LOCK_EX) on =
the
> whole-disk device before opening the filesystem. This forces udevd to =
defer
> all probes on that disk until e2fsck exits and the lock is released, =
by
> which point the filesystem is fully consistent.
>=20
> The whole-disk device is resolved via sysfs =
(/sys/dev/block/MAJ:MIN/partition)
> so that the lock covers the same device node that udevd locks. If =
sysfs
> resolution fails, a warning is emitted and the lock falls back to the
> partition device itself.
>=20
> This mechanism relies on Linux-specific interfaces (sysfs, flock() =
semantics
> on block devices) and is compiled out entirely on non-Linux platforms.
>=20
> Signed-off-by: Nandakumar Raghavan <naraghavan@linux.microsoft.com>

Looks much better, thanks.
Reviewed-by: Andreas Dilger <adilger@dilger.ca =
<mailto:adilger@dilger.ca>>

Cheers, Andreas
> ---
>=20
> Changes in v2:
> - Guard the whole feature (function, call site, lock_fd, cleanup) with
>  #ifdef __linux__ instead of just the function body, so it's fully
>  absent from non-Linux builds=20
> - Collapse HAVE_SYS_*_H header guards into a single #ifdef __linux__
> - Reuse a single dev_path[] buffer instead of three separate stack
>  buffers
> - Keep translatable warning strings on one line each, even past 80
>  columns=20
> - Drop the blanket "could not lock" warning that fired even when the
>  target wasn't a block device at all (e.g. a regular file), which was
>  causing issues with tests; lock_whole_disk() now only warns/errors
>  at the point of a genuine failure
> - No change needed for the Ctrl-C/EINTR concern =E2=80=94 traced and =
confirmed
>  the existing signal handling already unwinds cleanly





