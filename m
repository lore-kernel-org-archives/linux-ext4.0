Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D93325704
	for <linux-ext4@vger.kernel.org>; Mon, 30 Mar 2026 19:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774897712; cv=none; b=QXg1AoUL2tGWsFCVfQ12Vnbr365j3Pc4rJiiFf2pwGlxOiDWRBZxGCdDkP+w88C5aBu3EcyU6es4wl1K/5GM5bpFn8v64Lfcqb+zqnQ4FPG+9krG+zDSkCxrT4CWmnsuk2CxTULtKm8wMswLMs3d7cMnBhuNGh+f+QF42Vi/TfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774897712; c=relaxed/simple;
	bh=GapWNzZORgILo9/YkO8TEyUNq0VI4uzSmW0dTXVI+ew=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=I+53qjXhtfP4rxGAVN/LMee89/ypjkKx54IP9I//ruSQrkmpQm0VQ3FOOBmxlssYUnDntF6mcLBGDXSCajodQfCjneMUN7T78Ax0ZdFKwZ3wdzs4uEMmaQOeKLXGGcgC3yIpDv7naZp8kipt49GJozAT7DjEQ90ewbTBJ+FkASQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20230601.gappssmtp.com header.i=@dilger-ca.20230601.gappssmtp.com header.b=mIO6O+rU; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20230601.gappssmtp.com header.i=@dilger-ca.20230601.gappssmtp.com header.b="mIO6O+rU"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-c76864f4e58so1421442a12.1
        for <linux-ext4@vger.kernel.org>; Mon, 30 Mar 2026 12:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20230601.gappssmtp.com; s=20230601; t=1774897710; x=1775502510; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J0xs4EkeRNL+sV7WTCB1UIuRfg7I87e8qZPxRushHdw=;
        b=mIO6O+rUd9OVI7H1dm9ACgRDbPNkE8K74hgint0GjOywAk+218pCoEENQ2EGzory4H
         pAJVVehHTZjil7P0Ik4PngjpOEVroW1HFLLZxW3xCjMo5J2OQJn43rgSSdKlxirN87Fl
         YdZybgN1lHqTQbhvVkhkW1JvLqmW+CBcPN7wpmXZjyjjpN9xX/c8YWx0ugroxKisngG6
         YjyRVJTFAirIdSV8zVcXl7E0co5+0JoeSmF6veGF7WoVYlzwiVKQ/jePFHpSXvfpVmi1
         b3cNxzj8oRVav6CKLT6/89KwIvKSrmc7qQJDfk1CY7uQTYvfrnOZ8VF/Ih0ou923nOSW
         U/2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774897710; x=1775502510;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J0xs4EkeRNL+sV7WTCB1UIuRfg7I87e8qZPxRushHdw=;
        b=rPTsQA05sbvD7zIiq2zOvaSgrC43KiMsk2cL4IVgxzBDTllAnYMYkQ/GCPYBWpOsOX
         TRFcyCarlG4PjpRtYywbs7Nm3xLO9lvwfkzRkWuJGA94lC55iqAmPPKivctdlYG4pfBN
         t3Qt4X3tWBQh/dDLdoWOvjkS2bPYxnFbNziNSNg6RB0P+Y54w4JbFs11Pd4s8gKgLsPh
         g6xuY/UJuy7rnxIur6hlHy+Kgdl7dMwHza9aEC7ndvZ7727jNpa36KmksSHhSWvfrx4P
         dF0REnPCA4A/lqk27cGX5NBPr92f9A9LzYuuPFfoNRHkuj1p+xIHEPFerakK9t+gwGMD
         OB/A==
X-Gm-Message-State: AOJu0YwLHWGM7TksCSe96eLB46FAx+Mo2K9ZMQrnzXCcBazUFFyma0oU
	RSjEP6DCk5LIkbCptV361aF3KSnN4JdaBIEE7d/VearVXtg3cG96BzpUv83lUPhRaQo=
X-Gm-Gg: ATEYQzwUkxcW0N4KBsvTb2eGDjDy7R6k1XMobodFPjXKClwe3UWx/ix1ShJiOhkOZK5
	30IR1U0Kqy9j9Th24AA5fyKEL6Rl7TiqkOy8wlr2Luzj1oMDG4VPyWklqjV1yH6JpwTHQ7PG9PO
	ifwoF4HydgQP/39P0R0qf+J7Z8wcUWQcVI47d6e5RFclSvRdkGQ7xwlmT9ueXJ4YSxaMW7nNCaQ
	78gRR50QjDQ7x2Cn0bMTPgDu31xgvrhwzEcbsgcVhF7IfsfPBKO6coqJ4NhUw6/GbVNVQ/JLYGy
	wgGHCrKhCtRi0WPg/JD6VzjUAMKIRwjkfV6r3CCifkndKc8Tr6G/rLIm9QCdBUIykNjiU2mOZ2I
	9/HjXr2m67RWH58c5m0L9/DnZnPG3F6cTlk9hCFYqM8cSewoE2bekDWECEB9dKzJFNir6C1dyMK
	a2oD5uSOwPnm8NAxjye75LPloZDKmHda2WBkjpRIAqdQbTxo7p79qav3ZERL+bf/OD6eDxjEKIT
	fld2A==
X-Received: by 2002:a05:6a21:e082:b0:39b:8dcb:f36e with SMTP id adf61e73a8af0-39c87ba1d31mr15051788637.64.1774897709983;
        Mon, 30 Mar 2026 12:08:29 -0700 (PDT)
Received: from smtpclient.apple (S01068c763f81ca4b.cg.shawcable.net. [70.77.200.158])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c76917d843esm7875286a12.29.2026.03.30.12.08.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Mar 2026 12:08:29 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH] ext4: fix missing brelse() in
 ext4_xattr_inode_dec_ref_all()
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20260330174248.71268-1-skoyama@ddn.com>
Date: Mon, 30 Mar 2026 13:08:18 -0600
Cc: linux-ext4@vger.kernel.org,
 Sohei Koyama <skoyama@ddn.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <0E011FF9-2A0A-48D7-9609-86B12AAFB9DC@dilger.ca>
References: <20260330174248.71268-1-skoyama@ddn.com>
To: skoyama.kernel@gmail.com
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On Mar 30, 2026, at 11:42, skoyama.kernel@gmail.com wrote:
>=20
> From: Sohei Koyama <skoyama@ddn.com>
>=20
> The commit c8e008b60492 ("ext4: ignore xattrs past end")
> introduced a refcount leak in when block_csum is false.
>=20
> ext4_xattr_inode_dec_ref_all() calls ext4_get_inode_loc() to
> get iloc.bh, but never releases it with brelse().
>=20
> Fixes: c8e008b60492 ("ext4: ignore xattrs past end")
> Signed-off-by: Sohei Koyama <skoyama@ddn.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca =
<mailto:adilger@dilger.ca>>

> ---
> fs/ext4/xattr.c | 4 +++-
> 1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 7bf9ba19a89d..19c72e38fb82 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -1165,7 +1165,7 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, =
struct inode *parent,
> {
> struct inode *ea_inode;
> struct ext4_xattr_entry *entry;
> - struct ext4_iloc iloc;
> + struct ext4_iloc iloc =3D { .bh =3D NULL };
> bool dirty =3D false;
> unsigned int ea_ino;
> int err;
> @@ -1260,6 +1260,8 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, =
struct inode *parent,
> ext4_warning_inode(parent,
>   "handle dirty metadata err=3D%d", err);
> }
> +
> + brelse(iloc.bh);
> }
>=20
> /*
> --=20
> 2.39.3 (Apple Git-146)
>=20
>=20

