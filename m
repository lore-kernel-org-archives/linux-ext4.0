Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247E21FBE90
	for <linux-ext4@vger.kernel.org>; Mon,  3 Aug 2026 00:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785716916; cv=none; b=fw99aERVI+M8SMckyvwoXIMWzrZ0lDUyBK439RvY08ZJrqIp5Jq6sE8Y2rHQIyHhPGxRZFe+PwGZp/olr/FlsZiO8ae9LQI4SzTX4Wu9Tt0YYY7s+OhsAijgh0yVRG1Vj1EAveZMwqYsE7DAw4UPdLFdOQR8Az4Clgz65u/lvSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785716916; c=relaxed/simple;
	bh=Av2TN/PKqrCcMjMKRJuH0SXBFRr4ucK9hZn/kRVcsdg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eGKt1Hre4a3SHibFk4ZN4Oi8nCXdRVADE44DoAl9Jaze5oGp0DEt19FCOFR9nq8GcPcFf11lleiFiypzwF48pFpKBF2bk3dFEhzAYvjVkAzp9wSVo5E7xy/KnYuMLD1MQ5dv7TZH/j9aXao7TloH5pvOu8F5LfhtRYKD4gEoS/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OgQMXsxH; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OgQMXsxH"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-cb5b8572b70so2144937a12.2
        for <linux-ext4@vger.kernel.org>; Sun, 02 Aug 2026 17:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785716914; x=1786321714; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Av2TN/PKqrCcMjMKRJuH0SXBFRr4ucK9hZn/kRVcsdg=;
        b=OgQMXsxHlQbxBFozSm+GoO5vAJ3tXQvU0F5S6BgQ2JriOcnInY6GHjns/nOWj3oyhJ
         R9SXW0yOEa/LVXB5SvRDaT7SKekQXFP6mbXXaKR476nJk+oWQ9MunxImpYYO3ylZiaLn
         QMm2WvSh5gBXnsAAGs4rO9qJbmkUBtnNP1eU6lJFP3uSv7MkMRc7Vyc4H8DQ5Kaj6LH/
         8/baTiHuuqGadS4N1OjMM6+P5nrydwH3Lq3M0ue8cfPPlDJAVRhycdxerp5AGPmimCaA
         3mpTvOQ+gu6iTAlwDjTbFL3Qf33pIL2ciHkUEQRNvH4wOaQCfWikcdTTRKp2TJI0yxB3
         DVFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785716914; x=1786321714;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Av2TN/PKqrCcMjMKRJuH0SXBFRr4ucK9hZn/kRVcsdg=;
        b=iw1Yf3WC24x2tmHDfDbwzxB/lqjqBHheEGSXU40YIAfoHLHXnn+MzOFM8SBd1vKpUZ
         rK+qG5Gob/JR4k0o1tlsEjS1HVKYvqli32LDz46m5LVL4FjZLkgAR3tqMAmEZkOwuGDX
         ew+/pkoMLMW9Vd9EjuQ/GFTamgiiwAIiutIIK2/9wnoNtWhMQs2HzMkBIZkegA0Ktpx2
         U26HFp6ITc7JXXhtFXFM+v623nqRtNufiy+cKj5vnuND5gYX/hnnhnAU3tlDijDFlfAf
         eYk2CVCZsvO2bnhXk3WKRJGXb9kZc8sZTkCixsI4eTkAS/0ctmxkwPcofKLWbfpgCv49
         R/0g==
X-Forwarded-Encrypted: i=1; AHgh+Rqv9Qi2gNY2p5q8uvOn3hXF6OBV05H/8NQytquSlKE/xF+A9ckkIzJxdHJ99xCIpmPfcoQNK3cjxbb9@vger.kernel.org
X-Gm-Message-State: AOJu0YyGtJIOvYi24YpLi9HelrpKwAmtfU3FHo2Ky20x+aQICrz82lm9
	p3gCCoL9Lk/N0ruhP/iFiNdtzUtr28V2CNu4tPI+oVE7xUyWq0D/xsZa
X-Gm-Gg: AR+sD10G/25bQaX23pLdfZYBNKaFqxmilUkOXSSXcOjWpWRD2nBhY4G1o0oq98NNamm
	mxtCqgmZKg40JIb+3mWFhDWv/vGseCEENlePIQI17qogHugwDeIZAI8I9X2yGnjyXNjBZjxNMCM
	JZJi11Z40zkgCVKBBAF1tEvwSNvIUTJT6mROzoY/75LkSWCBS16CVClRASNG05SfhFhYX6hwKm6
	9gr7EEiUQ4fo5mCwukFpTM9dKvthMcCsSaX2QL+Ckrs3wOieVUAPnzs0H7Q+e1epraUnrgB7FcJ
	2jVIAulAG15gPw8AW3Qtq0d/CbDL5qQSDasLs2FzuAmhysEV+74i1pHWhWdIheKbgRm6qd5ySMR
	E/nEKPJmYYZxiGnGe0SEzjLb5HKkr5Y8aYyOMNwgnxHafecOQ1OfhrkggzgxAXG2tOHxfIY3Mos
	bimEXc761Kq+PU0FSDqwMDch786ZBw6Hq9joh+IZREaVmoxaowBQ5+wsUzf++Ujt+BIZE=
X-Received: by 2002:a05:6a21:a97:b0:3bf:6f30:1ccd with SMTP id adf61e73a8af0-3c92a7bda5bmr8059858637.42.1785716914233;
        Sun, 02 Aug 2026 17:28:34 -0700 (PDT)
Received: from archie.me ([210.87.74.117])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153dd9c1casm31037640eec.10.2026.08.02.17.28.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 17:28:32 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 63E53420A9B1; Mon, 03 Aug 2026 07:28:30 +0700 (WIB)
Date: Mon, 3 Aug 2026 07:28:30 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Tigran Aivazian <aivazian.tigran@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>
Cc: Linux Filesystems Development <linux-fsdevel@vger.kernel.org>,
	Linux ext4 <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>
Subject: Re: ext4: spurious "orphan cleanup on readonly fs" due to remount,ro
 failing to reset orphan_file structures
Message-ID: <am_gplyBEyvbuHM_@archie.me>
References: <CAK+_RLmWU-GjYu9Z+AWnoKd__AiaWZUt=zOkx3jr2-a4Hv3KHg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="3QVTYZfKyLSL06hz"
Content-Disposition: inline
In-Reply-To: <CAK+_RLmWU-GjYu9Z+AWnoKd__AiaWZUt=zOkx3jr2-a4Hv3KHg@mail.gmail.com>

--3QVTYZfKyLSL06hz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[Cc'ing ext4 folks with full reply context]

On Sun, Aug 02, 2026 at 11:18:39PM +0100, Tigran Aivazian wrote:
> Hello,
>=20
> I have been experimenting with optimising rootfs for custom builds of
> Ubuntu 26 with various options like fast_commit, sparse_super2,
> orphan_file, inline_data, metadata_csum_seed, etc. And I noticed
> something strange: if my root filesystem is made with "orphan_file"
> feature then on every reboot I get this message:
>=20
> EXT4-fs (sda): orphan cleanup on readonly fs
>=20
> (tested with SSD, NVMe and even old HDD -- because initially I thought
> that maybe it was NVMe controller failing to flush its volatile DRAM
> cache to the NAND flash, but no, it wasn't the reason)
>=20
> I think what happens here is that when a filesystem with the
> "orphan_file" feature is fully unmounted, ext4_put_super()
> successfully clears the "orphan_present" superblock flag AND properly
> collapses/resets the physical orphan file headers. However, during a
> read-only remount (which systemd must do for / in order to halt the
> system) ext4_reconfigure() clears the "orphan_present" superblock flag
> but skips resetting the physical orphan file structures. Consequently,
> on the next boot (which starts with a read-only mount of /),
> ext4_fill_super() observes that while the superblock flag is clear,
> the orphan file itself appears non-empty. This unconditionally
> triggers ext4_orphan_cleanup(), which prints the spurious warning,
> scans the file, finds 0 orphans, and completes silently.
>=20
> Let's test this theory on the kernel 7.0.0-28-generic of Ubuntu 26:

Can you also confirm this on latest mainline (7.2-rc6)?

>=20
> # 1. Create a filesystem with the orphan_file feature
> mkfs.ext4 -O orphan_file /dev/sda
>=20
> # 2. Mount read-write
> mount -o rw /dev/sda /mnt
>=20
> # 3. Remount read-only (Simulating systemd shutdown)
> # This clears the orphan_present flag in the superblock, but leaves
> the orphan file structures intact.
> mount -o remount,ro /mnt
>=20
> # 4. Unmount and mount read-only (Simulating the next boot)
> umount /mnt
> mount -o ro /dev/sda /mnt
>=20
> Expected result in dmesg: nothing (well, except the usual
> mount/remount messages about ordered data mode, etc).
>=20
> Actual result in dmesg:
>=20
> EXT4-fs (sda): orphan cleanup on readonly fs
>=20
> Since this affects the default shutdown path for any modern Linux
> distribution using systemd and ext4 with the "orphan_file" feature, it
> would be great to get the remount,ro teardown path aligned with the
> full unmount teardown path in this aspect.
>=20

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--3QVTYZfKyLSL06hz
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRwG4Bv3KXTpY/7j318J2xkpeRKHQUCam/gpgAKCRB8J2xkpeRK
HSjJAQCrTKPJqmqDsTmmKuuhPdXQqQvie8vEnTlFEPH0aYG+6QEAsM46SzZSFQS7
KZ+FYthoqCrwK657LOkMj/2Ive8VtgI=
=X71E
-----END PGP SIGNATURE-----

--3QVTYZfKyLSL06hz--
