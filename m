Return-Path: <SRS0=8KOi=QA=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2CAAC282C6
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Jan 2019 09:23:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B40A02184C
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Jan 2019 09:23:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=javigon-com.20150623.gappssmtp.com header.i=@javigon-com.20150623.gappssmtp.com header.b="q8aoglYn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbfAXJXx (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 24 Jan 2019 04:23:53 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:34897 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbfAXJXx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jan 2019 04:23:53 -0500
Received: by mail-ed1-f67.google.com with SMTP id x30so4008192edx.2
        for <linux-ext4@vger.kernel.org>; Thu, 24 Jan 2019 01:23:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=javigon-com.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=hazvHEbzHlDqYsmMEu8W14zUjeP0zUZTkCQb1dt0eUQ=;
        b=q8aoglYnAJuQYRQUnSNzn1ctrHw93ML1rLpvdb27JoNLtAIeEK3wEimXsO9NNwjju/
         tvchnR1NGuDBRa9Ot91sQWhKeu3CJ3QgHQ+NRZzOEud+ER2vOwtXO7cASCEu8ccGzF2Z
         torGYOBY3YNghxopWmDzGISu4LFXg7NukGQWkVIRRkSmHj+j19ZVC3lFotxJs6UgP4P9
         ws9jYKjwjoCOEmCh/JT7Sy7bon+n3MYWc2cpuk01Q/0YrDnhxRhVOhjMY0okQ/0Z23Ae
         6XYwVB9lScsaRXnZY6C7O5M5rtw7urcH1/2RvlGLqFdL0TYC6EVKgg9MTwlP391SYzDg
         5g4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=hazvHEbzHlDqYsmMEu8W14zUjeP0zUZTkCQb1dt0eUQ=;
        b=pFXmZx6lB7j9mnqrCnS9Q8Tr9W4DfVm4l2blSPz9jJeNUO1hR+BaljqPeUJImEPElo
         2IZuWRBy2hdgZsgOk9Gtt1df8YsyoA1V3BCVsUzrpp+b+QL4LpJJL2p4DHBNEfFNlD6i
         kOOQdwVnFWnHajMTEmDadAixePGyBbJ0gGwif2OSIJcpZ5N5ASOBnp7pUZoMPNvGSiq4
         yBaK4YjdswK4X74d+C6EANGkze0ldzS5iFpTWg21DY13MjbRbFO+OkeV5MA20OjKXZW1
         zpanlb2nLUVFXxweWv7M34fmfrrBukJLpAq391jH1hkhlqjb64Np0zB67o7q+TYQjnL1
         xeLA==
X-Gm-Message-State: AJcUukfAlW0H1hFm+m8vdabZy6rARCBN9TlF601waVf9ynPds204NXYt
        jhnMGX9HMaUhBbSkInhIGRsX+Q8EQXcBqQ==
X-Google-Smtp-Source: ALg8bN5sxoEjzFgr0jiHUYeJuF6tyRWpjNifCnTAyCYQYadzthO/x8istF+WsPcZnvWFKEjOHlo8vA==
X-Received: by 2002:a50:bc12:: with SMTP id j18mr6036401edh.50.1548321831072;
        Thu, 24 Jan 2019 01:23:51 -0800 (PST)
Received: from [192.168.1.85] (ip-5-186-122-168.cgn.fibianet.dk. [5.186.122.168])
        by smtp.gmail.com with ESMTPSA id gy12-v6sm6096573ejb.44.2019.01.24.01.23.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 01:23:50 -0800 (PST)
From:   =?utf-8?Q?Javier_Gonz=C3=A1lez?= <javier@javigon.com>
Message-Id: <2C518FDB-F9A4-4884-9317-A3AC207E316D@javigon.com>
Content-Type: multipart/signed;
        boundary="Apple-Mail=_B00D8D2F-6C7C-4FE7-9B2E-0877BFFC739A";
        protocol="application/pgp-signature";
        micalg=pgp-sha512
Mime-Version: 1.0 (Mac OS X Mail 12.2 \(3445.102.3\))
Subject: Re: [PATCH 2/4] introduce four macros for in-kernel hints
Date:   Thu, 24 Jan 2019 10:23:49 +0100
In-Reply-To: <20190124083536.GB12184@quack2.suse.cz>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-nvme@lists.infradead.org, jack@suse.com, david@fromorbit.com,
        tytso@mit.edu, prakash.v@samsung.com, Jens Axboe <axboe@kernel.dk>
To:     Jan Kara <jack@suse.cz>
References: <1547047861-7271-1-git-send-email-joshi.k@samsung.com>
 <CGME20190109153336epcas2p29b3275b6c545e483a3f43b92268f08bf@epcas2p2.samsung.com>
 <1547047861-7271-3-git-send-email-joshi.k@samsung.com>
 <B4980620-2CFF-41C1-8EE7-C33F1FE431C0@javigon.com>
 <20190124083536.GB12184@quack2.suse.cz>
X-Mailer: Apple Mail (2.3445.102.3)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


--Apple-Mail=_B00D8D2F-6C7C-4FE7-9B2E-0877BFFC739A
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8


> On 24 Jan 2019, at 09.35, Jan Kara <jack@suse.cz> wrote:
>=20
> On Wed 23-01-19 19:27:12, Javier Gonz=C3=A1lez wrote:
>>> On 9 Jan 2019, at 16.30, Kanchan Joshi <joshi.k@samsung.com> wrote:
>>>=20
>>> Exiting write-hints are exposed to user-mode. There is a possiblity
>>> of conflict if kernel happens to use those. This patch introduces =
four
>>> write-hints for exclusive kernel-mode use.
>>>=20
>>> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
>>> ---
>>> include/linux/fs.h | 5 +++++
>>> 1 file changed, 5 insertions(+)
>>>=20
>>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>>> index 811c777..e8548eb 100644
>>> --- a/include/linux/fs.h
>>> +++ b/include/linux/fs.h
>>> @@ -291,6 +291,11 @@ enum rw_hint {
>>> 	WRITE_LIFE_MEDIUM	=3D RWH_WRITE_LIFE_MEDIUM,
>>> 	WRITE_LIFE_LONG		=3D RWH_WRITE_LIFE_LONG,
>>> 	WRITE_LIFE_EXTREME	=3D RWH_WRITE_LIFE_EXTREME,
>>> +/* below ones are meant for in-kernel use */
>>> +	KERN_WRITE_LIFE_SHORT,
>>> +	KERN_WRITE_LIFE_MEDIUM,
>>> +	KERN_WRITE_LIFE_LONG,
>>> +	KERN_WRITE_LIFE_EXTREME
>>> };
>>=20
>> I think Jens and Dave meant kernel hints to go top down. This would =
also
>> give space for supporting more hints / streams from both ends for =
user
>> and kernel.
>=20
> Yes, that was the idea however if I understand it right, the write =
hints do
> not really have to be consistent boot-to-boot since they aren't stored
> persistently by the disk, are they? If that's the case, it doesn't =
really
> matter which numbers we pick.
>=20

I guess this is implementation specific. Some times the drive will want
to store this to improve GC. For the current "coldness" hint I does not
matter much, but if the hint were to express other metric it can become
relevant.

Anyway, the comment was more to separate user / kernel hints and allow
them to grow from the ends.


> One thing I don't quite like is the naming of KERN_WRITE_LIFE_SHORT =
etc.. It
> is upto filesystem to assign meanings to the write hints. So I think =
it is
> enough to provide something like KERN_WRITE_HINT_MIN which is the =
first
> hint available to the kernel and then the number of hints available to =
the
> kernel.
>=20

Makes sense to me. Then we can rename the hint for each FS to give it
proper mening.

> 								Honza
>=20
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

Javier

--Apple-Mail=_B00D8D2F-6C7C-4FE7-9B2E-0877BFFC739A
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEU1dMZpvMIkj0jATvPEYBfS0leOAFAlxJhCUACgkQPEYBfS0l
eOCfqw/+OAPsQEb+p6m8d765keQKVs7rRTbuTrj9+7rwHKgCFq34+fO7NbGgcDxE
BE8strFx3oUXGEoF3VX8+PJEXWEebKQ8FvQ6i3YylHhcW15PXBrnY0kUkPvAzshJ
yfkn5WUZM9UTEEFP6SeYaIKUIt9lZwEB3+xOCBbEEceCs55nBcc7grb7GA6BGhWQ
DobjMDCbFDXm7BwvDkyN+rvzj+zLvAWeTBdHrsQUQXZr1owclr9qSdxIO7+mZpJo
2gw1ufg/U60bmb6lfgcL5Dlh9U5by1cmHdo/CJsCbOYEg2mff5MzAlcg7pWssPUv
guJ5atDffHudLpgLi0D+skLtzOYn067otjlfYiZYSEXkwdlJE14octZAQp+B/rMQ
xDqQ1BkrHlgmf/ex3oGHqEG3GrO/4bpW+nctgA/QdKVPHVlMaqcFGJjozhvG0ebg
NMS91G9cNDprPjAu9jPgsVHJKBSd79exCRMmECNxyzVDtmdtl0tCo16ez12gECvq
qkSQyPI1w4jNJYcXjpJqdn9thXinhwbF+loI9sLjtecqb+g1rUnSUYFuLWOktf92
Yn9KRzSCtlpdCRmr9CRbJhkisL8ERr0PywqjMk7LDQfSd/Nc4vyCpewH/FX3s1U5
2+JdCebzvIFIKypx2+ocXx50za6dY/phVmYMZFz9UYIK6iZ9Tf4=
=tt2d
-----END PGP SIGNATURE-----

--Apple-Mail=_B00D8D2F-6C7C-4FE7-9B2E-0877BFFC739A--
