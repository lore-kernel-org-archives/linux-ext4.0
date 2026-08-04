Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ACAA23EAB0
	for <linux-ext4@vger.kernel.org>; Tue,  4 Aug 2026 07:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785827230; cv=pass; b=hHdjB0+t2sSQLCMcdrd3ngyXCXSP7IeqkOByqRA9TBnDRrN5cQdR2grvA/WQ6H8meeqKD63T0+bQGs5SfJf7QoBGBhj9GZGl+mkmELO6iNcn/X+hzCOhG83KsHpLqxk+E9CzE9KVe5k2P/1DT6bs7QQMwVPYGux9dB+7fjbWbPA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785827230; c=relaxed/simple;
	bh=K7fp4RIDjGpoeFh745LyFbaeONTzPRj8J/2g0MPGJOQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mnSul76d3jsadGDHsz/Hp5CjK9lyQAntXigE6cWOUYniMHaNQ6yIa5Q3h5nFUp4quPhneAD2lALCwBlOqHwLJJ0xA9OPEgz/fFsKZZBHxkKu6B6TUo1+LX5xmrH0sZr8QOpDEAB3D+dlT24CBnkHrktC9LTaN+RzZNTdsqR9mD4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EfqPhWDa; arc=pass smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EfqPhWDa"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-81f64e8dfbcso58700127b3.2
        for <linux-ext4@vger.kernel.org>; Tue, 04 Aug 2026 00:07:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785827228; cv=none;
        d=google.com; s=arc-20260327;
        b=heBrxeD9WFr+XXWxAjxIQVY4+r0iWwyR4r5qG/sSqVecKw/uNObd3TZ36ObloiRqZ2
         ENeErXWFO2brEG0FBIKPDnNqdkukdAPmoAOKgRvgGPhjgyxjJzCTebIasJ6rA6GD0rhZ
         cnq526BEgB7UC1qTNKBdpk7u+aoonBi+F0xCSiqVYpNtqMCiZSVHiYe2pYeXkif7v74g
         n+1/2yiPc3V3kK9qJt+RKpKoAiXawYAzxIiiH5+sGyEGjOMGhUGir4hj2zl0xMAS8YtK
         sBk5nb7VO7+lWsoNkhLfne6PP0Kd01Jf0JE0HBhzGRHUGgGpxu0a16V2SCwX5czUO53z
         0etg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=SVdx2hNQFC7tZLuV+Q983vTFnBvIFpFaJOmwifl7Kf0=;
        fh=/JYt4pnvqzt2m1e89TpU65CrmFoMK0SFEHz9LxzDXaU=;
        b=s/CMwMQhYgFonABelQivfXrsY/aad0q5mnDQiOFFjh7c9HX45tSIPl1jCJIjWbnc+f
         wit+2Vxn0j36LMv2vYNxIAcFpC6hdPLdzkp5XsrpVYroIHicEW4n1DocwNZLTZT8+2X/
         ZGlin9vobSeHGFhpqGJ2v29g8RRFpzOztOfiTHpFrF6C4pU8jxAz6mmDs10u/uzCvFqo
         bN9vob3gQFHfqsc/6axPumMvg0KKDikNQ9TnwzNvkP+GBIrui4uz802e1CsRsbCWGrXI
         LCNmP7LvWIOC3QO7a1E7ahhxXVWgf3jLXj0JRcP38jX/YRxxFYWfs2gQpqVGzo2uwlIz
         p0Tg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785827228; x=1786432028; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SVdx2hNQFC7tZLuV+Q983vTFnBvIFpFaJOmwifl7Kf0=;
        b=EfqPhWDa+90i8TLbX09oYlic0BvV+yoRoUJ6rpsKFw35E1IRj2cKMePqVSpDBFHw3Y
         Jdst4YghZkTAeYfTIFljneQb5cpOxo56r/KzAeVxF11/ZtO4PYF2NZFcM9ZvSaWP9mQH
         PT6M5e3jjJWCfaLlD7Op9e29qcSxsegGjl1+yjmdHFt1+8pZSgL7fsNVyeRI2y7fNEwU
         hQBL8NFEGs5qBktv2jvyGKhIMCnGIpXCLovY1o3nfxzAeyGHeMpWZ8oRc28UnG5sv1Hp
         tPO+u8JAovEze3R3UrAheGHjd97Vuhl3sKFw3Ol92BulGc7wiN2RS7E1OUrMhpibz9Mm
         AWEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785827228; x=1786432028;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=SVdx2hNQFC7tZLuV+Q983vTFnBvIFpFaJOmwifl7Kf0=;
        b=VkfMnt4RiqxXTZq/07r6YG1VXsbymUJ+Ah5TDK4DAbq0H5JYPIPOW1tMwoeVfmLflL
         QFuNDHp9+Kbf/SFGS9CPsFya3pTvShp7bsZVV9HJwU6Rc+omrPJHgP8njsjKzyquxTjh
         2Xa3bAHPgiWJnsHZqeNDmM+E10BjOKFtoqWJNhunA/SJ4SIWG4NxNdbdiVewo+RJ4034
         y9RZx/xM46v48Q1zobf9qUP9uCs2t2pPMzTbIv1TkEUAMUIueseG/i6GzLB5u2ICb74w
         2nf+lbTOKkzT8b3pvP8CCpr46L1P2GBTG7BJcYDszfxAyijiflriv3GC2PEjnGEoTa/M
         bhoQ==
X-Forwarded-Encrypted: i=1; AHgh+RrebmnyyqcCTxUGWMrKFEoedR+SsBwYivEagCMYTFlCUMb3CDwUF438x6aRxap+oX91jfakOmIbf4Tw@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1b9QTDGV0syKUklh6Mgu1f6mK2JE1o6SDvGjtiOhd0v8BV6Aa
	RnR7Cs5HPyQ+iANKGGT/oyY6nDQ4k/VSR2olw++mN9/vDDmcNm20b6E+qbentYRyAx0hMAJayXb
	tdeYfz1AjZ7/AThyNHb+qCnSEjhxRfCp6fE9ysHI=
X-Gm-Gg: AR+sD12lOCakYBMRKp8spU1rWdGnIKeyj+xWGP7XpMpbaFZ1KJda/+CC1ouy4cCjxdW
	6+8CP8A28PClNGCQzA+q38cugp/ONgKveOVlP+M7+/mtiIEuR2BHR6rlu4T/0wKjZyTSIaSTGCz
	te2MDB4lTBICJYZ4xVZKLjmZ2mtu9cdy/YUgNbgOdwy06Y03L7TwE7Ebtrh5sXetBLTHIFuFp3a
	JWRTSgt6tgczzGU2UpaSl04L7VFAknRmGQSG768ztjdpDGmYITN5Q3mBx25mfHXoQY0rHeKEuqD
	6Xgcim5uU9mSXCI+LpPxAwumDXOYu00bwhNTPUMOALGt95FoZcmOlhNdLr4Y74LK/Bjf8xTAGZg
	rfyVDQfthJG4=
X-Received: by 2002:a05:690c:61c2:b0:80c:d342:955c with SMTP id
 00721157ae682-81fd49b8358mr169688987b3.3.1785827228478; Tue, 04 Aug 2026
 00:07:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260803160037.64285-2-jack@suse.cz>
In-Reply-To: <20260803160037.64285-2-jack@suse.cz>
From: Tigran Aivazian <aivazian.tigran@gmail.com>
Date: Tue, 4 Aug 2026 08:06:57 +0100
X-Gm-Features: AUfX_myWnE_hSdQWORQ2nBl9ckBdocm1yg0MOaERStJW0QEcVWT5L2S8T9HFoVA
Message-ID: <CAK+_RL=VnbYo9LV+exxP4R2UsCjmmn6G3qK5CXiB7e1at+UxqA@mail.gmail.com>
Subject: Re: [PATCH] ext4: Fix spurious message about orphan cleanup on RO fs
To: Jan Kara <jack@suse.cz>
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 3 Aug 2026 at 17:01, Jan Kara <jack@suse.cz> wrote:
> diff --git a/fs/ext4/orphan.c b/fs/ext4/orphan.c
> index 64ea47624233..2a44998a6c2e 100644
> --- a/fs/ext4/orphan.c
> +++ b/fs/ext4/orphan.c
> @@ -388,7 +388,7 @@ void ext4_orphan_cleanup(struct super_block *sb, struct ext4_super_block *es)
>         struct ext4_orphan_info *oi = &EXT4_SB(sb)->s_orphan_info;
>         int inodes_per_ob = ext4_inodes_per_orphan_block(sb);
>
> -       if (!es->s_last_orphan && !oi->of_blocks) {
> +       if (!es->s_last_orphan && ext4_orphan_file_empty(sb)) {
>                 ext4_debug("no orphan inodes to clean up\n");
>                 return;
>         }

I have just re-tested my original scenario and confirm what you
asserted in the second half of your earlier email: the "remount,ro"
step in my testing was indeed irrelevant. We would get the spurious
"orphan cleanup on readonly fs" message even with just a normal
"umount /mnt" intervening between the rw and ro mounts of the
filesystem in question. Therefore, your patch above appears to be the
most sensible thing to do in this situation, especially as that code
path uses ext4_debug() but the spurious message is using a stronger
ext4_msg(sb, KERN_INFO,...).

Kind regards,
Tigran
