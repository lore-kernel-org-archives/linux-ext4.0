Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A43918DB0D
	for <linux-ext4@vger.kernel.org>; Wed, 18 Mar 2026 00:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773793686; cv=none; b=HGwO7P4miVNl8sW9Ykpjl2InJwFMZYRojlq6sfioH5OId0tqqwA0qMlQl3CyIZgY/zThqjkS+eFfxjEn6/xDtv4upY8queah7wyvireHiPvY33KVdy8oTxvUaLrBoVB9Dzss44Au/ls3PwZhhgpNpct/qdtotgwL7DwHdUhrTHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773793686; c=relaxed/simple;
	bh=u54493lJbkcmd/+84jAe4am8OweBkH4FGMyaX29kuI4=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=RyKUzxiVShEHIDTJrIFg+MPnWnv8MRJPpDTulmz7fKilZFQQu75Tryv6cGBuaJlwMxr/aK5FstxihfG1EU85VvoUtcDLmwZ4JCEiaFK8jmC928wZ05q60Sbv9hNoUMp5je7JwztlgcuDXOP9Tp9P79lGGQyF6Mi0u8XWL6J9PwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20230601.gappssmtp.com header.i=@dilger-ca.20230601.gappssmtp.com header.b=0KaS4hli; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20230601.gappssmtp.com header.i=@dilger-ca.20230601.gappssmtp.com header.b="0KaS4hli"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-8296d553142so2958382b3a.3
        for <linux-ext4@vger.kernel.org>; Tue, 17 Mar 2026 17:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20230601.gappssmtp.com; s=20230601; t=1773793684; x=1774398484; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5NA8Te4axz3jvg5v3TSjl5PFwjfVUdZ73qS17BbRLpo=;
        b=0KaS4hlikCE12bEyY5QSrBlHzp5+byyhYHROBEbTh8f2Zkxs7UFBCbXH4kIZMvWcxP
         70/84CmciHwauO9AvvEISnqsVEHdwvGdpXZ3phnfDn568ZE9NwIktmVdhNtDl7oJN4/C
         P2wdf9VvkjM7dc10hq6Mvw03uolAcmnJiGsylxXvCDrjIu6UKTyxvvc4C9nEPVbuRnzt
         EGdA3AKIa1YSu7ArrYJgi8ZI2tVeRjUMSir2SfhBTeDYURVrcgQAX2DeX1wi48E6SW23
         U8PnWu1YMmf06g9iBQCQs57lw6/Sh0YcwE5ljY9+eVwhjaf0/Zlg/Vq8KVshjCi8ifgI
         u8Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773793684; x=1774398484;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5NA8Te4axz3jvg5v3TSjl5PFwjfVUdZ73qS17BbRLpo=;
        b=CTgGkAo3sB0pJ4SGtUuICDG/14ydH7Q+Z3FxVH6aWDMTfqs8X1hP0YISUcyVqzCGLy
         J6YKVgmjeahCFYfZxfsMtU96XD/JE2CbvaKsN6gmzS26Ps0sNiZOMg+3GON6jysUUqU+
         0tgD2K/Zs7KXnnojAVACU2aqTB6w8GP9cPcR9WLqAlM+bsQ+fpaW+3UPTp3RWepdu8T/
         drLot2Q8ATUUirNmO80Fgd8vNW8WMhT+qzTmj8dwcRgCXRdsGVB76f7NBjyCsDRCYlxC
         PFWCfB8qC0ExjYqMop1X+eTZdJaGdZY1O7RkuKAgDp2Cn4Ct9UuuyotYezOD4wEsNm/C
         N5zg==
X-Forwarded-Encrypted: i=1; AJvYcCVA859hfgJRObgOoe4X1SGaZfTRrKG862vwM75Hg9MSg00yLKeInyjWxFfs9snjMgZePyVA4gBkN/8/@vger.kernel.org
X-Gm-Message-State: AOJu0Yyq6SnFYdlfzcUxVzgg5GXnyEiW8xoawPvUkx+ZZAG0hF2gzo4b
	iCdQPMoxa87S+bZeAFgP1QV4f9K8KNqYfxnH4FxE7M+7zwiUrObIKzCmbX8RgGcVcRI=
X-Gm-Gg: ATEYQzxkylQbkAQnHy+3cRB+16Drb5ZGitwOrjbFf/QiRyhZhgabIZDUL1I4O6Y/WA3
	RIC14iWhOEle4vNcHpJ3c63QhttOEerQzOnrlT/0z/Ce69eGOAeK33VCcXTeJzlMuuuljkWlhuJ
	ZgJ3fCN8CqXZJcKpb8Fo5ado5IflrthKXYps88PI3l8BVRFOZl9j0gGHdebevx71hwGHxrHSlCi
	UYp+gPvavaDHFaO6X8RmBlcxfgVr7TIR6cYLnI4EOy1N20tIDLA2S84GIr2+AIzRb8XZYgGibYk
	oi0WIn9PBk6rUyhc3MprZZa+/qKiAxPgTwSFUzCi9NQv/nnaSdFYS3ukfeMRwHdUw1ybeTOZhV6
	BY+YEBiK5yuClgUgY6fXZ4qgGciAKjR/Ve3du6AfqnfKI1WKiYbyBHkZ9DmhueUVU8o1RHCeMVf
	GYctxhixNLuIncCMiXLz5is6KCjvi8Czi1hfPNLJk9Dt6b5nV211zEwd03sUaIg1he2CU+8m6+j
	Bni
X-Received: by 2002:a05:6a00:4208:b0:82a:88a:1363 with SMTP id d2e1a72fcca58-82a6adc7e22mr1132599b3a.2.1773793684253;
        Tue, 17 Mar 2026 17:28:04 -0700 (PDT)
Received: from smtpclient.apple (S0106a0ff70715ac6.ek.shawcable.net. [174.0.84.146])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82a6bbe1869sm656174b3a.40.2026.03.17.17.28.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Mar 2026 17:28:03 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH 2/3] ext4: add ext4_fc_eligible()
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20260317224638.3809014-3-neilb@ownmail.net>
Date: Tue, 17 Mar 2026 18:27:52 -0600
Cc: Theodore Ts'o <tytso@mit.edu>,
 Jan Kara <jack@suse.cz>,
 linux-ext4@vger.kernel.org,
 linux-fsdevel@vger.kernel.org,
 Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <59A20B05-459F-4FF1-81F4-11C79BF85155@dilger.ca>
References: <20260317224638.3809014-1-neilb@ownmail.net>
 <20260317224638.3809014-3-neilb@ownmail.net>
To: NeilBrown <neil@brown.name>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On Mar 17, 2026, at 16:39, NeilBrown <neilb@ownmail.net> wrote:
>=20
> From: NeilBrown <neil@brown.name>

(add Harshad to CC list)

> Testing EXT4_MF_FC_INELIGIBLE is almost always combined with testing
> ext4_fc_disabled().  The code can be simplified by combining these two
> in a new ext4_fc_eligible().
>=20
> In ext4_fc_track_inode() this moves the ext4_fc_disabled() test after
> ext4_fc_mark_ineligible(), but as that is a non-op when
> ext4_fc_disabled() is true, this is no no consequence.
>=20
> Signed-off-by: NeilBrown <neil@brown.name>

Nice cleanup.  One minor semantic change in ext4_fc_track_inode() that
deserves a bit of scrutiny is that ext4_fc_mark_ineligible() is now
always called before ext4_fc_disabled() is checked.  That looks OK,
since ext4_fc_mark_ineligible() checks ext4_fc_disabled() internally.

It looks slightly more efficient to check ext4_fc_eligible(inode->i_sb)
first?

Reviewed-by: Andreas Dilger <adilger@dilger.ca =
<mailto:adilger@dilger.ca>>

> @@ -557,16 +548,13 @@ void ext4_fc_track_inode(handle_t *handle, =
struct inode *inode)
>  	if (S_ISDIR(inode->i_mode))
>  		return;
> =20
> -	if (ext4_fc_disabled(inode->i_sb))
> -		return;
> -
>  	if (ext4_should_journal_data(inode)) {
>  		ext4_fc_mark_ineligible(inode->i_sb,
>  					=
EXT4_FC_REASON_INODE_JOURNAL_DATA, handle);
>  		return;
>  	}
>=20
> -	if (ext4_test_mount_flag(inode->i_sb, EXT4_MF_FC_INELIGIBLE))
> +	if (!ext4_fc_eligible(inode->i_sb))
>  		return;
> =20
>  /*

