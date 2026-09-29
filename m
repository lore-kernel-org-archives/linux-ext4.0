Received: from mail-ed2-f33.google.com (mail-ed2-f33.google.com [74.125.228.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B191433F5B3
	for <linux-ext4@vger.kernel.org>; Tue, 29 Sep 2026 14:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.97
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790691319; cv=pass; b=rA+US4Ms99ot16snbTEcq8fWq0ePyDXAt62oZjqhDuvANlhGjYnzslrc8Bery7EAAwkJm6ZQEW7eZ1NLgFXFRQe8NeZ7xmNJJPo5kLsD1WB2ElmhYgVJFcFWpVfjP7TeMdzNdLjrjDXBo9SP2yOXAr2ibyfb6cQJwZme5hMs7o0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790691319; c=relaxed/simple;
	bh=WNPiWlZ8WpoGHZK99aHcbTTI4gKFUrGP6Bht4p9ETqw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YJ8cCC+07IBK7XEdYUNHNzXDntTxBKnfHtsl5uHcAs35K98J09qe3Ls2+9tKzLOHspRppaK2S8FkQuzremKOp1a2tYLtBcAopsEL7rPJXPD/Z5TAzYbtFanOIBOk0lLS/IuBkYUVKaEX7tSCSes9pxFDxZOb15uSSJ+l5etdW1E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m5y2zrvd; arc=pass smtp.client-ip=74.125.228.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m5y2zrvd"
Received: by mail-ed2-f33.google.com with SMTP id 4fb4d7f45d1cf-6abc27842b6so4558345a12.3
        for <linux-ext4@vger.kernel.org>; Tue, 29 Sep 2026 07:15:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790691316; cv=none;
        d=google.com; s=arc-20260327;
        b=onu6fIU8GXKeexHj7DGCM1M9VoBVmaUVD2P+3jx6IrLfTwDBaPjywZgR34XanDQgzG
         xDU+bsRbjuqgttDCJPo7PRoR9JoOB2Xde+eXVN2on8Br1ZugpqL+5Y6RMmY+rYAQQNb7
         lKrlA7FJd8ae+8xVoH79UGVxD0zA6e/hDZ3S1hTW4TEtEbd7V1eScKyme7pCs796A0cY
         vP9qaSCmyYrS3yjt7ho2D7wype97FwyA5suBq23Dut5nacPVgnWBb5mFCnWwhDMUgJAm
         7cxDwAF4bTGaO3PdusxzH+DjPTbHuVxt5A1xDffSMyP8kopu6R9MXlhvvG3mpHtmAi/W
         8iSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=trsZq/IgHnE0dFOaiSMsY9WGT+wIu9sqLXFKuCxoh54=;
        fh=qBLYb0ZYAbdbHuttK1R+b+n6ZPXrJl6NVxifElruGUs=;
        b=pYeQJM/WjEg9Yn5xon/ebkVJdp3Jom4wfra0f/JfoOvXmqzXXrbkaeO6N/JjBga44n
         PEtmZbQ5cMqz8PsYqmnPNb5TydpbEypMDaecjszn12c2+c5cdBMlWMDsBLAQ30UDSY5z
         BU3T4vuTOVRc1T5Zr8A2pSNfrl+6S8O4S2HsLgJsbDQUEKAWcbWAwdXTUxkP/lCOknvv
         BtWKXiz5BIbv+zWLC/t3wh2BVYjrP+Cpr5t6IpOzttOwmjbZSbTc/S0qFbRAmEZJxOXB
         ZpwA5RzuRt95N0eb2iSUPfxQTwgQ25SMV3zcR9PvVtvkpKJEoJW2/2e6CC4fq1pwgRj5
         dC8Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790691316; x=1791296116; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=trsZq/IgHnE0dFOaiSMsY9WGT+wIu9sqLXFKuCxoh54=;
        b=m5y2zrvdfKrrDlWmbGVWkbKGlBSJlMpl4+t0+q1faSnSoOJXN6vDuwrx7Q5hAD3Jpa
         TY1linw7bcIDan8EjtIzhGgc+cyoOOwyRE9RzgVeKFdxqJx0w4V70OU8Hj01JopcA6Hn
         WUcTqIB2KUfNBRFKNWoiCbphBarMs/ugh+VFmI9cyBvZd/KaML1Tx0RbvsQGKM0Zw7BW
         7Pw7XjOq/uRJAEVaeBmKNlOq4oCWmiCOwzzEWoGrPOkTbvUPc+hZQDS6ZR8C1hSEvJ9h
         mJ2XaYaEL0wMf1AGO+tJPkEy03kCRy0RMlpqaxhBeISH8gpSJDejJ/lXf8WFf3CQ9Ewc
         K6Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790691316; x=1791296116;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=trsZq/IgHnE0dFOaiSMsY9WGT+wIu9sqLXFKuCxoh54=;
        b=tPBiAnsCeLWhXDz2XSWZHHcHeeadQo3HMiAaoPLClK1CUMqTysnHNEe8blo3nIIMpi
         4Dps2OX6bZi4bMp5bkFEKKkisakjOpo/cW1Swjx8BtSuK2PEiVARhxql4rt+XTZaMRT0
         dN8e4u/0WQLyxoIZYFoIQyoi185J64ZElzCcb3sSSOp5p4YoEzQYk5I2KmSeH4O/mOQ8
         yUhRZLW2iyEaUfswulFmhxhwsKzpDAeykWnJVVtAr2g2tG7I0LGbucaf6Ot5uwfMw7u9
         StBWQMEcZWMpQy/L1s1n7YnsMClYh0q9sGD8ftFqF9NcLVbAP/zg7GDwLf6ZaBFjWkRs
         WVog==
X-Forwarded-Encrypted: i=1; AKwUvBxVu3i86xlxKLinM3fsOyczw5JFNbTTPdY24xoNR0awU7MU1ILvk6Evg2ywr1vP1fkSndG1ymAufQMc@vger.kernel.org
X-Gm-Message-State: AFq9FYIb0AUlR5qIgtPQs3K6aITLe24E49utWH9GLydd9QZw9hrinhWD
	mIrBqLZ9yXqHE+mQMc4TQz6RPiV4/ZuYr/gcQ3+yhRNeJdtrcfAgU91JP+Jpvc1yqahvncsRaEP
	HZ+Mwaqs7WlBvkieseLtJOF1Vtm2QYoM=
X-Gm-Gg: AYBFou3KsPHEe6uslQydCGsDCbL9R11IMwBShvztRAIGkvs3Fon/hvDeGWXusZ5lkbS
	i6DX571/ZrlTWiq8zb1yxNbq4SyAbKda513daeciRxYWhUNi4155lxkz6EVqCUZaJFVCbC8ELTj
	Afa4euF9qwKvnhip8kdVoRLFiBobqsjR9goA9KsncZmami8cNQe76CQC0yWU1ol4LPUCrXmScZj
	PbO+fE2a9+OTFhTkO19VbHN5WSRGoxbzZy/3edRA4mEGaYD8gajKYr2QuVCv/S7w6Sum6eeqDHZ
	tz3icCuQtvXe2F5QrjeULAgEamL3tMtkmAYnC1v1/WRdHkf2K565eqdr
X-Received: by 2002:a05:6402:380a:b0:6ac:bd84:2b84 with SMTP id
 4fb4d7f45d1cf-6acbd843b1fmr1090820a12.34.1790691315590; Tue, 29 Sep 2026
 07:15:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260928213155.2612039-1-krisman@suse.de> <20260928213155.2612039-5-krisman@suse.de>
In-Reply-To: <20260928213155.2612039-5-krisman@suse.de>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 29 Sep 2026 16:15:04 +0200
X-Gm-Features: AclHuK8ytKjl4O38jVPReRqXBMm8kcLwbRELyjNeXdrdxLC7F0LMOcN0dvJ9ryk
Message-ID: <CAOQ4uxj7Vx-UGvgGGr9hPC0qUgJZ_WRAv1ZLi=gJ6r=ZJW0QAQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] ovl: Expose the filesystem encoding through sysfs
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
	Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>, Hugh Dickins <hughd@google.com>, 
	Daniel Tang <danielzgtg.opensource@gmail.com>, linux-ext4@vger.kernel.org, 
	Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-mm@kvack.org, 
	Chuck Lever <cel@kernel.org>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 28, 2026 at 11:32=E2=80=AFPM Gabriel Krisman Bertazi
<krisman@suse.de> wrote:
>
> This patch reproduces the same interface from ext4/f2fs to have feature
> parity, so users don't need to rely on parsing dmesg or trying +F on a
> temporary directory just to check for support.  Note there is no
> encoding_flags file, as none are supported by ovl.
>

Gabriel,

I am not ok with this API.
It is wrong in several ways.
It is not generic, we have already file_getattr() to get casefold status.
There was a suggestion by Pali [1] to get the supported xflags - statx styl=
e,
which can be a way to say if a fs could return FS_XFLAG_CASEFOLD.
In Chuck's v2 [2] FILEATTR_CASEFOLD_TYPE was already suggested
as an extension to file_getattr(). I think we can still do that if we inclu=
de
proper versioning in the casefold type.

TBH, I don't think anyone requested this - you only mentioned
the need to know if tmpfs was mounted with casefold on and that
doesn't mean that etx4/ovl patches are justified, but ext4 can decide
for themselves.

The point is that this sysfs is not going to be the standard for all the
fs that can return the FS_XFLAG_CASEFOLD, so I see no reason
to add this sysfs interface to ovl.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-fsdevel/20250216164029.20673-4-pali@kerne=
l.org/
[2] https://lore.kernel.org/linux-fsdevel/20251211152116.480799-2-cel@kerne=
l.org/
