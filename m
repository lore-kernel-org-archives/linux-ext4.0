Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7BDC2DAFCC
	for <linux-ext4@vger.kernel.org>; Fri,  8 May 2026 08:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778227643; cv=none; b=TpLsvfute+4yfEZoaKBWEUpDkwplF7JRWNCH7tnsvfjrHoRXpiBsxphUUXFI5TrZhQdbzTGx5M+ehuzQe+2DxaxrW2fJmulLX/P5PsKWK4obS8bCdHGAJkahh8Xz4imEToUc8onWvHUFOulsc1z6odSmLLyDYoSDj8ReXtAVVK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778227643; c=relaxed/simple;
	bh=c3xHH694o+zphEIQVN9RVAb0WxSsn7choMJU73Az8Kg=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=PipTRc/PebP8NY8qyHQcHIvWY99DDMSfU5Mp+ZvaapGENiv8KcK5+t5IXuyZCUkqhsP6Fx5zFaw/yuL7RXvHp1RvPImzFgizLVQAf/iSaaYsQ/IicGZjbNqzH8EJe7LLMme2GgKQ7y3tzq9tTHcpeJZY4KNLNvQHrPFgFoJJF+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b=PFIgrnXf; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b="PFIgrnXf"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2baef9f5ecdso3253915ad.1
        for <linux-ext4@vger.kernel.org>; Fri, 08 May 2026 01:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1778227641; x=1778832441; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NE9SvXJ/p2OOR2/6OIE6c5VL6XNI0jB0FPluXe8xKDk=;
        b=PFIgrnXf5Ycfg2oS+WJ9m4E3KWJGPsAiOvDSP+O/kwJ66X0mdkmCVeuL9iNtnZfpvv
         BUJTndeZ2tNLqeNlTjEmtfT4VTbqEfVirQ2PIFZ2KNv+jPgWPalBzESCELrJkzdl4eIL
         cctjwnlcenMM8ZUM/hSi6eopsr59Vs5Kw/U9LRajr4aSHt7ALEtNSjB0RmMajYiGV000
         00j0gMRRPCgugoSh2GP5RMW+CYqF4u2w1EduJmb08nB6ebeUgo5MMTb3P2jOGReHTCeC
         Dy+27BWOp3E5i+Z4yIGn6AoiTkS1R7a7xZwCpF99zoTxGNs6nUtjwbIPTTmHYMZt42Jq
         37HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778227641; x=1778832441;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NE9SvXJ/p2OOR2/6OIE6c5VL6XNI0jB0FPluXe8xKDk=;
        b=n7SyIfT3bt9DM5HLQTIZRgoW+9D7f8vp2GtEZN8n9e1zm+kA6WsOh3MSumRdzQVFIY
         zFz9f1kvbOMs333HD8f8UbRnV63ByNpVxnfns5RxQPrvggdFRjAM6mhkOP87t92znLOv
         yLC8F3wwEMLw5G1sLaUx0lOS4FJqH8H7wqbxY8r/g0KD4jrbk76kDQMpx07LxzYUzsoU
         Bd2RPwMXUFa9wqrRmQJZYDqMsHRf3dhytiFXcJXELyDbxSrPc9uvTLSR97IKICoRqlfX
         wFWH/XnVjTOpegKQkmUauwDtQLWL7f1L1x13ZF15cCnYvsth0CfMzgyFNHcSNjP6Xh1A
         CxKQ==
X-Forwarded-Encrypted: i=1; AFNElJ8V7qXMBY6UG1IdKtXgKEfvbZQ4QJzmjtiJKANojCdFA7Q6qZSB2Zurg/gUQCcQUqg9o4uZMEYucndg@vger.kernel.org
X-Gm-Message-State: AOJu0Yw56sWOPBOS8BJhRD5i117YBUiwoH1yLZ47x4CWu0lHyPzmvUAx
	DOPhngji8RjcQXrejqmbg3r/WCkJcdAMJe8Or0vn+3X1793S7J0crwAxVtsWzQtNZqQ=
X-Gm-Gg: Acq92OH/r6gS6yGqz60mKRFvUiEBb6CvwUQ1Z3yY9I9MXjd3orkaFGKhRWLNWxlGlx9
	PtmjY5W5jgjOyEqVQyKyMkvJMi01lDItrqW+38e4yI358yfeCwq97jXgcniXMXNVJHCSQSW2HnM
	aTPx2HnxAAr10WX1G0gl8k5Cz6JuXtkqi3FCuqiTmVZcDdldICDZmUSsaS4j9+rhnnKPTHSZ90v
	jns5/JFxkTU+lk6IIA5KgsVnxv3dyc7X5pZep9XcENRbnSu8EcS76J33WKmW0GN/uHRoD7M/HMR
	j2V2Oq8juQvQ4J5sq5kJs04PefAm/W3vbTHf4yX7uO4Y57K2Rlr/ajm2YqzgqijAw+fJlPL5U05
	0PncI26lurok3uYAcQ+fCTsF7aLY48vnWCVWwz/Q22QiBXoCBPuo5TG/6T07NRNexqPQhFKfTya
	RDLifrdXGQrXbuzCPIvum6A77NTvBNmd6QTUMvLhzyrIhWWEWUYZwhbSn3kQG9Rl8ELiA+N2suR
	0X3dQ==
X-Received: by 2002:a17:903:3887:b0:2ba:83f8:7b7b with SMTP id d9443c01a7336-2ba83f87cfcmr106624425ad.33.1778227640861;
        Fri, 08 May 2026 01:07:20 -0700 (PDT)
Received: from smtpclient.apple (S01068c763f81ca4b.cg.shawcable.net. [70.77.200.158])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e72668sm13300185ad.58.2026.05.08.01.07.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 May 2026 01:07:20 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH 6.6.y] ext4: validate p_idx bounds in
 ext4_ext_correct_indexes
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20260508065845.3031006-1-jianqkang@sina.cn>
Date: Fri, 8 May 2026 02:07:08 -0600
Cc: gregkh@linuxfoundation.org,
 stable@vger.kernel.org,
 tejas.bharambe@outlook.com,
 patches@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 tytso@mit.edu,
 linux-ext4@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <1C2F44AA-6D22-4AB1-9653-68DDDAFB3E06@dilger.ca>
References: <20260508065845.3031006-1-jianqkang@sina.cn>
To: Jianqiang kang <jianqkang@sina.cn>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On May 8, 2026, at 00:58, Jianqiang kang <jianqkang@sina.cn> wrote:
>=20
> From: Tejas Bharambe <tejas.bharambe@outlook.com>
>=20
> [ Upstream commit 2acb5c12ebd860f30e4faf67e6cc8c44ddfe5fe8 ]
>=20
> ext4_ext_correct_indexes() walks up the extent tree correcting
> index entries when the first extent in a leaf is modified. Before
> accessing path[k].p_idx->ei_block, there is no validation that
> p_idx falls within the valid range of index entries for that
> level.
>=20
> If the on-disk extent header contains a corrupted or crafted
> eh_entries value, p_idx can point past the end of the allocated
> buffer, causing a slab-out-of-bounds read.
>=20
> Fix this by validating path[k].p_idx against EXT_LAST_INDEX() at
> both access sites: before the while loop and inside it. Return
> -EFSCORRUPTED if the index pointer is out of range, consistent
> with how other bounds violations are handled in the ext4 extent
> tree code.

Thank you for your patch.

Do you have an image with this corruption in place?  Does e2fsck fix
the issue? If not, then ext4 will abort the filesystem when this issue
is hit, and if e2fsck can't fix it then it will just be hit again.

Cheers, Andreas

> Reported-by: syzbot+04c4e65cab786a2e5b7e@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D04c4e65cab786a2e5b7e
> Signed-off-by: Tejas Bharambe <tejas.bharambe@outlook.com>
> Link: =
https://patch.msgid.link/JH0PR06MB66326016F9B6AD24097D232B897CA@JH0PR06MB6=
632.apcprd06.prod.outlook.com
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Cc: stable@kernel.org
> [ Minor conflict resolved. ]
> Signed-off-by: Jianqiang kang <jianqkang@sina.cn>
> ---
> fs/ext4/extents.c | 15 +++++++++++++++
> 1 file changed, 15 insertions(+)
>=20
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 7626cf2b07f1..a94798e23c1a 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -1743,6 +1743,13 @@ static int ext4_ext_correct_indexes(handle_t =
*handle,
>  	err =3D ext4_ext_get_access(handle, inode, path + k);
>  	if (err)
>  	return err;
> +	if (unlikely(path[k].p_idx > EXT_LAST_INDEX(path[k].p_hdr))) {
> +		EXT4_ERROR_INODE(inode,
> +				 "path[%d].p_idx %p > EXT_LAST_INDEX =
%p",
> +				 k, path[k].p_idx,
> +				 EXT_LAST_INDEX(path[k].p_hdr));
> +		return -EFSCORRUPTED;
> +	}
>  	path[k].p_idx->ei_block =3D border;
>  	err =3D ext4_ext_dirty(handle, inode, path + k);
>  	if (err)
> @@ -1755,6 +1762,14 @@ static int ext4_ext_correct_indexes(handle_t =
*handle,
>  		err =3D ext4_ext_get_access(handle, inode, path + k);
>  		if (err)
>  			break;
> +		if (unlikely(path[k].p_idx > =
EXT_LAST_INDEX(path[k].p_hdr))) {
> +			EXT4_ERROR_INODE(inode,
> +					 "path[%d].p_idx %p > =
EXT_LAST_INDEX %p",
> +					 k, path[k].p_idx,
> +					 EXT_LAST_INDEX(path[k].p_hdr));
> +			err =3D -EFSCORRUPTED;
> +			break;
> +		}
>  		path[k].p_idx->ei_block =3D border;
>  		err =3D ext4_ext_dirty(handle, inode, path + k);
>  		if (err)
> --=20
> 2.34.1
>=20


Cheers, Andreas





