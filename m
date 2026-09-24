Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F67433B6D1
	for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 11:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790248866; cv=none; b=trNxc7znzN5iSX5tjeR+38BKHIBMACDPJf1CptQmzlgTySc4TGEJ//D4uGxGkH3Kes1vHpGKt5pwieJBOH/Fsz5jE/lEUXU98olGdC63m+6GjnfB+Al/CmXRzQlVK/jIAxknlWVkcPz7rRqsEdC0KQdQaoscCQCICqqJGX3cJWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790248866; c=relaxed/simple;
	bh=3VxmDJqwmeExcuYKSuxpIPmngPxffadGxpcdW5oysIM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Y1T/2RahslTYPwEbhKJBaLUpwXgCVPl1Do1Mer6ItTBXnYjKSCooymTyWwXx4hKWWepW60tUBzToEC4MeueBzLuikA84vJ2p1kL9b5SIFUthJUXWcv23UnPrpTuzWmnHDoMdQM9/oQrjI/NCvRakr0YYlYxM0c8ap+iZhSVBqgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HH9g+KgJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HH9g+KgJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FFA41F000FF;
	Thu, 24 Sep 2026 11:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790248864;
	bh=mgYX7S2qe4xX7JfJlSIedkFhHAsqL3lcUnbPDmRy4ME=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HH9g+KgJ2dobQy932Z5mrzpvKA2jr+M/Wsr5RQK0riBbNeBQSq0Q6v7Tf7OTZMHKW
	 SfhnA9hcIRefwLtkVO8GIc5he34I3PGvzjNlYns7MpBh0HvVograJPlqNa04Urf+ZS
	 DkpxtAR8VWcJ5OLsZglZfw6SH0A8W0jusLd9fIWzhHrrmxN0y8aGl8ZkNjniHnr4k7
	 h2FIHlHSOBtdIR1qAEwl3WX3gV8L/4aR48BUPkLSHkC6eWg1I9f+aXUH6h6QDf2A4H
	 68cRWUqbkiapSqWp3Hq4OcRMPHsjvLbtDug7E6DVb0XRD8EgBYbNs1fWXZkRXENm+I
	 EHZhyivWJIGdw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/3] ntfs: drain in-flight DIO before buffered write
 fallback
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiale Yao" <yaojiale02@163.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260924110544.601390-3-yaojiale02@163.com>
References: <20260924110544.601390-1-yaojiale02@163.com>
 <20260924110544.601390-3-yaojiale02@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 11:21:04 +0000
Message-Id: <20260924112104.7FFA41F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] fs: ntfs: sleeping in IOCB_NOWAIT path via inode_dio_wait()
--

commit 8795f10ca6e1ad5705cf4c0e2062d0271399c2d2
Author: Jiale Yao <yaojiale02@163.com>

ntfs: drain in-flight DIO before buffered write fallback

This commit adds a wait for in-flight direct I/O before falling back
to buffered I/O in the NTFS write path. This prevents data corruption
caused by concurrent direct and buffered I/O dirtying the same pages.

Link: https://lore.kernel.org/r/20260629113827.4074335-3-libaokun@linux.ali=
baba.com

> diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
> index 8164326b7812a..329871bb476f4 100644
> --- a/fs/ntfs/file.c
> +++ b/fs/ntfs/file.c
> @@ -526,6 +526,13 @@ static ssize_t ntfs_dio_write_iter(struct kiocb *ioc=
b, struct iov_iter *from)
> =20
>  		offset =3D iocb->ki_pos;
>  		iocb->ki_flags &=3D ~IOCB_DIRECT;
> +
> +		/*
> +		 * Prevent concurrent direct I/O and buffered I/O to the same file
> +		 * range. Wait for in-flight DIO to finish before dirtying pages.
> +		 */
> +		inode_dio_wait(file_inode(iocb->ki_filp));
> +

[Severity: Medium]
Does this unconditional wait violate the non-blocking semantics of IOCB_NOW=
AIT?

If an asynchronous direct write with IOCB_NOWAIT is issued, and iomap_dio_r=
w()
returns -ENOTBLK (for example, if kiocb_invalidate_pages() fails with -EBUSY
due to a concurrently instantiated page), the code enters this buffered I/O
fallback path in ntfs_dio_write_iter().

Calling inode_dio_wait() here will unconditionally sleep if there are other
concurrent direct I/Os in flight on the inode.

Could this stall async I/O worker threads (such as those in io_uring) and
cause unexpected latency spikes when it should instead return -EAGAIN?

>  		written =3D iomap_file_buffered_write(iocb, from,
>  				&ntfs_write_iomap_ops, &ntfs_iomap_folio_ops,
>  				NULL);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924110544.6013=
90-1-yaojiale02@163.com?part=3D2
