Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF4935E1DF
	for <linux-ext4@vger.kernel.org>; Mon,  8 Jun 2026 18:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780943270; cv=none; b=ii7zfQwaOCbh7mSpQzWaNef4yQjKcan9RDAuEwux6ugvdkeYI0nqs010kK5x21ZGFCroelpWGuE6R75NfjlZT8A3JSRfLtxDmC/x/4Gs1z/fvjR9fK3EkNIBQBYPiEcPKd7jvWAHfVCT5vLr94Tbq13D3S8y+onN9yrzPqK5c30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780943270; c=relaxed/simple;
	bh=LSul0qYcPP6Z5v5Mj3Z4t3szhI0J2hqOzbi13a/3kek=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=ZOl0cjAtBwFNHm99E2YevPTb/CxWecVNoE8OM+ueaTAgpCDVSr2CHZ8tZSzJryfAzXI18vMy1t9Vdh0O5nbdwdU/+BLrmKdonb4+zPsGBfXmP9R4xZKJSwMek6YfpSZce3VPqIM3/AKr4gBjf2dyCwCK7lqTqZOQBITGS/ZpaCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b=Crdl1/Gt; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b="Crdl1/Gt"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2c27fc587ebso5345125ad.0
        for <linux-ext4@vger.kernel.org>; Mon, 08 Jun 2026 11:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1780943269; x=1781548069; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1RePW8uhx1YLC2vs47fCv2wFKfuayn9ekepgHhwlp+U=;
        b=Crdl1/Gt8WRonsJNod7/J7YQOD4RJjKTBUZPjP73af2hF7G++F7ltRf0wCJEbYFnmZ
         5L0jhV9fOAD/KCjuo6s0d4szQbqdxRKQRTZXNpD/VzdWOzGgE5Bj3zuYfNyMIhfaFJPF
         1y+Ydm1/sEIIxLQI09LS5XIOlWf8gjBQM4gN+SjA+CPhZErLoiZ9S5oEJ1VpDBO1uL9D
         ekbGqsLPuySKWGyDes8UjRr+YenDzdDmb6IIxqFAqBKIWt59juDI65W9ySjcEhJTCImj
         gO6L3R+4TewE22InJzMwVDIm/NpQzQk2xgY8tZ3gQk0Jx9asHkRSn91qyiz1SoQiR5ME
         osig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780943269; x=1781548069;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1RePW8uhx1YLC2vs47fCv2wFKfuayn9ekepgHhwlp+U=;
        b=W2+bFxtpCViOeVUhhisVniUfNiUKUc6V4G79QzkFCmszu3OEcfCsQr3sKo9GUIgfCt
         C3z93sV10N0qvxpwPjI6nzI8H2AO+xJe+32tRP3dcZjyTGJotJyikfdz9quMV4l1ULFk
         k/r4KrlhM/QPRm/CasfTWo2w2FVVN7sf+Xi8frEQemZJ91vtfc8t0tG6Fwdy6dLZZncH
         h0sFv8S3X44pBYw38UxYojEHpGzcvHwncyq5YqJRqT/NW8sR7uggj1j+RMtKIRIajoP2
         P8uiiKzG0WuGFYu/EdB1wcmRLN0xSJQWxrTyktaBCQ4AgVf+xHZ1tX+vnchUzQPl9qu3
         GpQw==
X-Gm-Message-State: AOJu0YzPky94TOddwBWaJQsYBg/+PagvjITGPSSlkbn2MO1M3gSiOFp/
	97B4xMnuWyvaoHLzTB3zlXUaTT6h8RFJrHOQkX6xEKo9bvWUBQoaGEFPqKQLV2+kwQw=
X-Gm-Gg: Acq92OGJaBiMWM9/2jchUTaWudxNWDZAdQhQZPH6aKnS7Oa7F5xlsDk2PUKN2pJpEt7
	YoTremLXmbtl/XsuI6a7v47NuMSToaaDIVYB2Rmox0POceC88Iwxi/IGCr7w7PRiTKtPOLh15Jm
	jTDGmJpWYuVizZhLNy7wjxpLbAfVdhkASeL0nUIls3zDPzPoOZ8W02qRGh8LmOkl0U12pMGPADk
	ImgAwWAdbj9X8c+WDStHKD5VwcRAwbCJyX3NQApr1BwMQayXeyy0veHRFVTV72ScPcoWDK+7BGY
	EghqOMFN3opLmNj1+7IhzN2ct9zMTlYEx7+hLD4knVSDuTfnFtTb01Qxf2XfJGqGkcy7iK+hBHN
	7BYijU5woUjpgdQvHVlkvcg0JuXlPaafSEbhby5/g6oaTsMxJBIIGzgbKj57nxP5D+pS6CMD8mn
	hfYMcKeuKdEOVNBTAjx3FsWMDMQJjLgcg+8oj0/yhzdgd79RVMRuQ4ELWQivB41A/KY9yCCuk5R
	vBYHEAvVgxgHqIi
X-Received: by 2002:a17:903:a46:b0:2c0:c37d:dfc1 with SMTP id d9443c01a7336-2c1e820e316mr125943925ad.34.1780943268716;
        Mon, 08 Jun 2026 11:27:48 -0700 (PDT)
Received: from smtpclient.apple (S01068c763f81ca4b.cg.shawcable.net. [70.77.200.158])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c16629c08bsm191923255ad.61.2026.06.08.11.27.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jun 2026 11:27:48 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH v2 3/3] ext4: reject mount if inodes per group is not a
 multiple of inodes per block
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20260608111150.827117-4-libaokun@linux.alibaba.com>
Date: Mon, 8 Jun 2026 12:27:36 -0600
Cc: linux-ext4@vger.kernel.org,
 tytso@mit.edu,
 jack@suse.cz,
 yi.zhang@huawei.com,
 ojaswin@linux.ibm.com,
 ritesh.list@gmail.com,
 Sashiko <sashiko-bot@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <097CFB85-3C4A-4BDF-829C-E6B2322386EC@dilger.ca>
References: <20260608111150.827117-1-libaokun@linux.alibaba.com>
 <20260608111150.827117-4-libaokun@linux.alibaba.com>
To: Baokun Li <libaokun@linux.alibaba.com>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On Jun 8, 2026, at 05:11, Baokun Li <libaokun@linux.alibaba.com> wrote:
>=20
> If s_inodes_per_group is not a multiple of s_inodes_per_block, the
> division that computes s_itb_per_group truncates, reserving fewer =
blocks
> for the inode table than needed.
>=20
> On a crafted filesystem image, this allows __ext4_get_inode_loc() to
> compute a block offset beyond the inode table, reading unrelated data =
as
> an inode structure.
>=20
> Add the missing divisibility check alongside the existing validation =
in
> ext4_block_group_meta_init().
>=20
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: =
https://sashiko.dev/#/patchset/20260608061112.392391-1-libaokun%40linux.al=
ibaba.com
> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>

Looks good.  Is this also fixed/checked in e2fsprogs?  There is really =
no reason *not* to use all the space in the last itable block for =
inodes.

Reviewed-by: Andreas Dilger <adilger@dilger.ca =
<mailto:adilger@dilger.ca>>

> ---
> fs/ext4/super.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 3ddcb4a8d4db..5ec9e1ef00c0 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -5306,7 +5306,8 @@ static int ext4_block_group_meta_init(struct =
super_block *sb,
>  	}
>  	if (sbi->s_inodes_per_group < sbi->s_inodes_per_block ||
>  	    sbi->s_inodes_per_group > sb->s_blocksize * 8 ||
> -	    sbi->s_inodes_per_group & 7) {
> +	    sbi->s_inodes_per_group & 7 ||
> +	    sbi->s_inodes_per_group % sbi->s_inodes_per_block) {
>  		ext4_msg(sb, KERN_ERR, "invalid inodes per group: %lu",
>  			 sbi->s_inodes_per_group);
>  		return -EINVAL;
> --=20
> 2.43.7
>=20


Cheers, Andreas





