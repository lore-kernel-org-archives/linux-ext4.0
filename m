Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C64A149C6F
	for <linux-ext4@vger.kernel.org>; Wed, 18 Mar 2026 00:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773793221; cv=none; b=pdDwwuLbimayr4rm7tfTuEFZ42TfR8OwnPs5rCtL2g8sdnQECvrBpHnBi89ZrtjdzB2XKuLG83DUbRdGP1tTqNfqeAc2nE8NV8Kq720K97zFtkmZSxM1zQBjYYmYORxHTUGdYu5tHic6xfmhgBSInMQLvaqNlmiKB0PMkl+cQU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773793221; c=relaxed/simple;
	bh=rqlzh8om3MppYlVzPQAKWahRKUryk2ZD1eiUMoHr0NY=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=M3EatuZrsWemsqTTFKvInwKKZzPAf4yrdY0T2o9KLoT07Gawm8y7u/QI7JLrRSlNiovk6iGJ0Bj3k6GThAzgW9z4ywq2BsE0kgICaPXAYiKXfrHYb3gFy3QWQulaF46jDCJfvi7wlOQrn63ixYA7x5xL5Vfbf1qaR+dGwgJn2n8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20230601.gappssmtp.com header.i=@dilger-ca.20230601.gappssmtp.com header.b=AGq2LMd+; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20230601.gappssmtp.com header.i=@dilger-ca.20230601.gappssmtp.com header.b="AGq2LMd+"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-82995242934so195479b3a.0
        for <linux-ext4@vger.kernel.org>; Tue, 17 Mar 2026 17:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20230601.gappssmtp.com; s=20230601; t=1773793217; x=1774398017; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=leWzlXRjKUHn6Crlsk5+VQIAi7Gp+SzgyV5eBtNfjVU=;
        b=AGq2LMd+c+bnRwZ7VL3eTaVNH7hBrB26BABaBmvp4PqyO/pWX/moLOVSn0FrItXjPe
         w4Fox+WZ535pnFITAf+76mFlRkvnmPpLHF0heOnByeb6vh3kzH1oTbkVdRoCGKG1s05p
         MwZCJ8ZNrFxMSLIgJl6mZE7SG+CzcstbBV+zCn1HBDcJGo5YV/mWyXXrm85naqiSIrlA
         cJx1jpc+Y1+uChJn1K6t1g3kc0Za1vZ52Vcf/KVlKTaIP9CXUrZkjuxyQlPcfoonAXCP
         4ZnEzM0ySr62JzZSAcDbuPFSTYx8XVqSS0Gtrzkusq0BfXw+3ROuuiYwlNYOHARcQInB
         rKpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773793217; x=1774398017;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=leWzlXRjKUHn6Crlsk5+VQIAi7Gp+SzgyV5eBtNfjVU=;
        b=fmBQOvSIcjP1eEUNCX2LgEmy5tdhWg74L+hOuDcsH+/eFAyYy9ORzqLU3mxhAjlITj
         MqpakBJVJjQL26khTw/WeRbbRyZJOUcdGJ8YTCS9dytfgh3aWoha8sDOnamVHPr88yUI
         7NEHgecj/6H67HKHd/dVp7IpS4yPNZwOHMYDRP+fU3YOqaNdkPAapMCeF7yv44053ixy
         p3hsoMruXbYI0OlHC5oYP3/7y3jXQYxjZfmS/TO/m++DSRIwIP0YgoRg97Q+KWw7Impc
         QlepgCt8amSO2CCD1duAypBLSNVr0rRmmt/B51DCXjVoyJyYM4F4BdC2A+ilrXv8WgLu
         d1oQ==
X-Forwarded-Encrypted: i=1; AJvYcCUKcfxoWy5enZIjpUYkMKeKTr2X0mQoI3q4+Re8dwVptv/yboRrbiWhY2ItoCDcA0/60qzcuut/lczv@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7dN9kPL1dJ13F99LjmJ9ic7dDpLh0IGXrL08p9Xi1IrlHphuD
	2T1S5evF0jaOrn/dFMxJOVkqmHkjWYMBYVN7WvSMSWJK6vWzXedIKzfoF6mQEUxcXW0=
X-Gm-Gg: ATEYQzzddWlSVsKEg7xyuZ/bKlKT0TzmkcPDthMCOrcmL5B1+5Y+y3jWGUkfkK12GgF
	xkf1NjgiBE3HvUKEKXxWGH6W+ou8CKzz/08Mio1nRZtGP6qiHUftQUl9vY/ROZRj2UwonsvuwH2
	1uQyIZsgngLRCHV1EzNAUHR75CtUn2njO5F20TQjJuz+GbQGL3Y5Se5eI1J6YVNLVFaO10Cc1yO
	3FNcva9ap+Dfj8cerF+I6pdRZtWev+D4eS/Kr7QOjwY7H0woYnD9s8SeQVtocfH3T7CK4iG0fVY
	LZ3scgr/f3imxjaXR4bV5a/i86DPi43zi6hnmzYQwxpf0rc3HS4aSzEnMf9IKKu9HwszlrnT27o
	mpYB/b7/EUyaprR0b1fubL4F/W2WDAUMe+va1CyCLDKB+4wHFwQXKmADZxpClbdhOspcnJvHu53
	X4ro3k+qsGYQTL6rsU9pcPDEJwmSE4i+n+9xQCihSXO6sb44b5MreUxz+bsBczj2YNw/5oUhsCx
	Eu/
X-Received: by 2002:a05:6a00:e19:b0:7b8:acdd:23c3 with SMTP id d2e1a72fcca58-82a5603b41emr3849369b3a.11.1773793217338;
        Tue, 17 Mar 2026 17:20:17 -0700 (PDT)
Received: from smtpclient.apple (S0106a0ff70715ac6.ek.shawcable.net. [174.0.84.146])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82a6b598f91sm619872b3a.25.2026.03.17.17.20.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Mar 2026 17:20:16 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH 1/3] ext4: split __ext4_add_entry() out of
 ext4_add_entry()
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20260317224638.3809014-2-neilb@ownmail.net>
Date: Tue, 17 Mar 2026 18:20:05 -0600
Cc: Theodore Ts'o <tytso@mit.edu>,
 Jan Kara <jack@suse.cz>,
 linux-ext4@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <0C7B39C6-CD1D-4A05-8418-68CEEE6C97B2@dilger.ca>
References: <20260317224638.3809014-1-neilb@ownmail.net>
 <20260317224638.3809014-2-neilb@ownmail.net>
To: NeilBrown <neil@brown.name>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On Mar 17, 2026, at 16:39, NeilBrown <neilb@ownmail.net> wrote:
>=20
> From: NeilBrown <neil@brown.name>
>=20
> __ext4_add_entry() is not given a dentry - just inodes and name.
> This will help the next patch which simplifies __ex4_link().
>=20
> Signed-off-by: NeilBrown <neil@brown.name>

Reviewed-by: Andreas Dilger <adilger@dilger.ca =
<mailto:adilger@dilger.ca>>

> ---
> fs/ext4/namei.c | 21 ++++++++++++++-------
> 1 file changed, 14 insertions(+), 7 deletions(-)
>=20
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index c4b5e252af0e..768036a109d7 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -2353,10 +2353,10 @@ static int make_indexed_dir(handle_t *handle, =
struct ext4_filename *fname,
>  * may not sleep between calling this and putting something into
>  * the entry, as someone else might have used it while you slept.
>  */
> -static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
> +static int __ext4_add_entry(handle_t *handle, struct inode *dir,
> +  const struct qstr *d_name,
>  struct inode *inode)
> {
> - struct inode *dir =3D d_inode(dentry->d_parent);
> struct buffer_head *bh =3D NULL;
> struct ext4_dir_entry_2 *de;
> struct super_block *sb;
> @@ -2373,13 +2373,10 @@ static int ext4_add_entry(handle_t *handle, =
struct dentry *dentry,
> sb =3D dir->i_sb;
> blocksize =3D sb->s_blocksize;
>=20
> - if (fscrypt_is_nokey_name(dentry))
> - return -ENOKEY;
> -
> - if (!generic_ci_validate_strict_name(dir, &dentry->d_name))
> + if (!generic_ci_validate_strict_name(dir, d_name))
> return -EINVAL;
>=20
> - retval =3D ext4_fname_setup_filename(dir, &dentry->d_name, 0, =
&fname);
> + retval =3D ext4_fname_setup_filename(dir, d_name, 0, &fname);
> if (retval)
> return retval;
>=20
> @@ -2460,6 +2457,16 @@ static int ext4_add_entry(handle_t *handle, =
struct dentry *dentry,
> return retval;
> }
>=20
> +static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
> +  struct inode *inode)
> +{
> + struct inode *dir =3D d_inode(dentry->d_parent);
> +
> + if (fscrypt_is_nokey_name(dentry))
> + return -ENOKEY;
> + return __ext4_add_entry(handle, dir, &dentry->d_name, inode);
> +}
> +
> /*
>  * Returns 0 for success, or a negative error value
>  */
> --=20
> 2.50.0.107.gf914562f5916.dirty
>=20

