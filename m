Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A04384CDD
	for <linux-ext4@vger.kernel.org>; Mon,  8 Jun 2026 18:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780943084; cv=none; b=OXNhCJU/Icrst25Eis0GtB53xxyJKW1HHarrsJcGbQlW9qXwV6raFCoHKGSX1Ysf7KDqhPUgRWoGFDvL0mFsgWAt4MaOXsPjKp+04DMVxxiATJPwez/K0h7S4ABFkJciaNPnZmVEz7FtBonYetw2GojNMbzsU6j8lvG5Hp8A3U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780943084; c=relaxed/simple;
	bh=qdn6SYrlYdxvXI35GCM2qngsiqcm+C+VN3D/+Sg3SeQ=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=ZraTS6bcX/rFTj8KOl0a0cLmabhLnl9dBuN2oBASE68Ej/4s3A7NP8Sm+9CFqTFJL5B8jUJuRnEZEVCuNnjP061ybsdafleRkaxI42JwO/7eM4XIdiPbn0hj/FqU8l3L4Koplm9IejXV24k591BZSxRVWAn/En0l8NtxDLFIr4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b=ZtUMphVz; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b="ZtUMphVz"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2c0c2a68d01so31822735ad.1
        for <linux-ext4@vger.kernel.org>; Mon, 08 Jun 2026 11:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1780943083; x=1781547883; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NDqUBPRNaEnedZQkJ7XUg1ez4PSKRhf0rKvNYoQ5yZc=;
        b=ZtUMphVzZJM7PzNy4SXAElZ53C9OIJzsIR/RP0gWWcvTpfKTw2sOROwpo81O1bcS+2
         X15r/TclAmu62e4nchtbWHis+Ad2dpnSgLhUBtGMrddqkkSm4aj4w29r51X0EkkJF+Ts
         ntgKoRizBLaeMjb9iemPQ8OF7d3UnIzm4tO8/HYXMLmiW4jfclnBmBvsz6SgP3ZK6/4n
         AZXczAOe/IyAJCba78MV7gXAXFZeY2gkxqQPDQUiCvuvy8wx2sicdZI7oLRG3xRUrzv4
         G07nJDRWVwMwUMpf6JYR9MLF58eugMmU+6ZOl6tiYVpRtOSQl0wrZ59VpVQC7vMcglVE
         bXmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780943083; x=1781547883;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NDqUBPRNaEnedZQkJ7XUg1ez4PSKRhf0rKvNYoQ5yZc=;
        b=nmsvAppTVpg0GAkSXf7rqQuRxHtJQ+ZYx5jGbTMSoqNSQoUHI4c2SOGyzmDwCZjHD4
         Sz0ilNBj23YUa+GzUreMaoekxGxj/1RMiwswIzYxzV4RlvHVV4whw96RQhxo9EzXm6Rv
         HsiVBBBcz3phnh0DlGxN4sB1cwbS2QmnbbKBn4cmJqxaOZShG/YbOzZCyNzlX0zO4+Sa
         NjpuEQhbWobcpd7YA36cc23bW9v3uTfXEOJkFycifUFJ2s3lzwco+nFJIYr4539FTQtu
         jYMge3x/YNynMJIAx4CRc4wxD01aicC9WD6SjTvmHk3vtIn2RN+SzXZR4eiKtp4KjsTQ
         9/EA==
X-Gm-Message-State: AOJu0Yw5i3sR+xRcybsGDKHSuJ5ZzO98rBm9cGqn2eUkrqJ9w/3942p5
	JMP7c9SMeyeeSe+m9ciVvF3mSM8kjWpRpd04tI+VU+zQZKVjt8Gmkkm5TN1kaUpRDRA=
X-Gm-Gg: Acq92OH3OS4riIATolEuUGFrwDZhST/jsbOO8G8bPJ7IQ2BPtvyK96v93ri7YKfwXFg
	NSnoaC+cCLtmdPBYe3Ld6i9VAPRdbdEKqmYy489LMo/HVNQZMPBjUGHptfvOkBKwpkd0Gf3M9mv
	LNlAvwIswbAVuLgDEwKEDv9mL6rTN3sPSObL/qn/TEqrvsNC7iBfA4RKduVTqUgAibxwZcPXuwi
	FlumZiPQ9fYVhct0dzfMFKPESmMikrMNCSfwKdYOBfJiiaPnyv0enCcrKdU/MISnJK+F7ei0vsR
	/IZmu2+iGPu5zVAbTLFQ9g+kEOiaSEgQ/QvpVOrUW5VlzreU56Gj7xudTwINRC9cd85U4TzwIy/
	qHRy/1f8ZX0dDsBDhA5bcTJpX8+fj8xewdHC9i/He2mqXB723rGe7OdZ9fBv+tSDmLlzeXt5kte
	ey5We0e90ig/lQ2Z04EDKerLuCsJpfKN+DwhsuxO5WypS5j54KN/1KudmhdI2Ay08h+2rDO6Zje
	LQDGL5P2xLKHsAkcu/3GCvSPP0=
X-Received: by 2002:a17:902:c942:b0:2b0:608d:d8a8 with SMTP id d9443c01a7336-2c1e79e2aa7mr195359445ad.1.1780943082878;
        Mon, 08 Jun 2026 11:24:42 -0700 (PDT)
Received: from smtpclient.apple (S01068c763f81ca4b.cg.shawcable.net. [70.77.200.158])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c164f6d45csm255523515ad.14.2026.06.08.11.24.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jun 2026 11:24:42 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH v2 2/3] ext4: reduce max cluster size to match documented
 256MB limit
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20260608111150.827117-3-libaokun@linux.alibaba.com>
Date: Mon, 8 Jun 2026 12:24:28 -0600
Cc: linux-ext4@vger.kernel.org,
 tytso@mit.edu,
 jack@suse.cz,
 yi.zhang@huawei.com,
 ojaswin@linux.ibm.com,
 ritesh.list@gmail.com,
 Sashiko <sashiko-bot@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <AC985F81-7D0F-47CA-A103-A8C6953089F0@dilger.ca>
References: <20260608111150.827117-1-libaokun@linux.alibaba.com>
 <20260608111150.827117-3-libaokun@linux.alibaba.com>
To: Baokun Li <libaokun@linux.alibaba.com>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On Jun 8, 2026, at 05:11, Baokun Li <libaokun@linux.alibaba.com> wrote:
>=20
> The mke2fs man page documents:
>=20
>  Valid cluster-size values are from 2048 to 256M bytes per cluster.
>=20
> but EXT4_MAX_CLUSTER_LOG_SIZE was set to 30 (1GB), allowing crafted
> filesystem images to specify cluster sizes up to 1GB.
>=20
> On 32-bit systems with bigalloc enabled, the consistency check in
> ext4_handle_clustersize():
>=20
>  s_blocks_per_group =3D=3D s_clusters_per_group * (clustersize / =
blocksize)
>=20
> can overflow when the cluster ratio is large enough. Since
> s_blocks_per_group is not range-checked in the bigalloc path, the
> wrapped product can pass the consistency check, leading to =
inconsistent
> group geometry and potential out-of-bounds block allocation.
>=20
> Reduce EXT4_MAX_CLUSTER_LOG_SIZE to 28 to match the documented 256MB
> limit. With this cap, the maximum product is:
>=20
>  (blocksize * 8) * (256M / blocksize) =3D 2^31
>=20
> which fits safely in a 32-bit unsigned long for all block sizes.
>=20
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: =
https://sashiko.dev/#/patchset/20260608061112.392391-1-libaokun%40linux.al=
ibaba.com
> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>

It should be pretty safe.  I doubt anyone could be using > 1GiB clusters =
for real-world
usage at this point, given the nature of the bug and the amount of space =
used for metadata
(e.g. 1GiB per directory, etc).  At that granularity they can use LVM =
for space management.

Reviewed-by: Andreas Dilger <adilger@dilger.ca =
<mailto:adilger@dilger.ca>>

> ---
> fs/ext4/ext4.h | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 94283a991e5c..11e41a864db8 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -334,7 +334,7 @@ struct ext4_io_submit {
>  #define EXT4_MAX_BLOCK_SIZE 65536
>  #define EXT4_MIN_BLOCK_LOG_SIZE 10
>  #define EXT4_MAX_BLOCK_LOG_SIZE 16
> -#define EXT4_MAX_CLUSTER_LOG_SIZE 30
> +#define EXT4_MAX_CLUSTER_LOG_SIZE 28
>  #ifdef __KERNEL__
>  # define EXT4_BLOCK_SIZE(s) ((s)->s_blocksize)
>  #else
> --=20
> 2.43.7
>=20


Cheers, Andreas





