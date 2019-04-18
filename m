Return-Path: <SRS0=ZWG9=SU=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 553FCC10F14
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 18:58:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CB262183F
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 18:58:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20150623.gappssmtp.com header.i=@dilger-ca.20150623.gappssmtp.com header.b="MfU9AJa0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389945AbfDRS6T (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 18 Apr 2019 14:58:19 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41167 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389841AbfDRS6T (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Apr 2019 14:58:19 -0400
Received: by mail-pl1-f194.google.com with SMTP id d1so1570872plj.8
        for <linux-ext4@vger.kernel.org>; Thu, 18 Apr 2019 11:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=Rls8ZXKxpitLdToJVhs5aQI6eogfraGi8L51K73vZHA=;
        b=MfU9AJa0duArcFo2+QYl8UPFXdYay3Rc1DAlk633euOpRQos/H2Qsq8hI9EHE0VglA
         l3lJzLNDZseM4FhVy+SjIJow8umIWXKZfKWSe+B/13SayWTmuivmwKEHIOFQd1yLkPCh
         d0axKanB3162FWykYa48SdDp9Oo982oGwQz//7yRu/0ny1j+dY1oUTW8Tsmyj9NGB4Kr
         +MXj6AUB8Qts7YFGyvOe0AU5DPwcFh/5C3QZMDFqarBOoMDaL72tVjlnHRT172BKo6I/
         lpXDf4aU4cbrZZ5HW/IsBD0Gu1lkBL9BxDPv+K4tWSOC8F6+GFyTiNHRznNuWH0EHqz/
         +e6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=Rls8ZXKxpitLdToJVhs5aQI6eogfraGi8L51K73vZHA=;
        b=k/ItcEOYy4E8OrN8ZLxJKTZJ2HTPhdPRkwkokgkDUjM+R4hlLp7Ojwc1r7PPCFxeDA
         Wy7JAfGgeIYdFXreV8D1RqTasuOWR+GooDXxJl8rXa95Fgc22NsXYVzmqLlnIxzAgmbQ
         2UynGkob+fBUJJQpgcxoIolKW+IEKXf6yelM3jmBLo5Iy/Ye7HpEkUYhJOWRR4f1fnHg
         ocqz3IRaZBCdW1tu7+Fp+/98wrZUg3ON7j7eBbV0KuVO9bS7j36Mi68Z/Ew0k8fWJXcG
         9nV4zyXSaEENs2rDrxuVZJmiVd4Ss3I2v6LNHP75ChogO/fspajBhHaZzFoLC3g/3mno
         QKqw==
X-Gm-Message-State: APjAAAUTZImwmCtuyifUxNCdUM5RHePYuQH1w6OI4sMNj2zL4CSXh+lT
        ATP6YYQyGWgOEWZOSIskOa5UP7HdSZg=
X-Google-Smtp-Source: APXvYqzX8/1l6sox8PUa5IqTovbL1mZTLZLDYQpGPrG8X1cAjahdf+PnEQIsTOk7eecHLzVgnAafIw==
X-Received: by 2002:a17:902:581:: with SMTP id f1mr55594044plf.304.1555613897955;
        Thu, 18 Apr 2019 11:58:17 -0700 (PDT)
Received: from cabot-wlan.adilger.int (S0106a84e3fe4b223.cg.shawcable.net. [70.77.216.213])
        by smtp.gmail.com with ESMTPSA id u5sm4225156pfm.121.2019.04.18.11.58.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Apr 2019 11:58:17 -0700 (PDT)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <9BD0C782-5967-4DCB-9D01-E5BCC73E653C@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_E3FEA83A-9256-40CD-B4F8-E3FF6FED0F48";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v4 4/7] block: introduce write-hint to stream-id
 conversion
Date:   Thu, 18 Apr 2019 12:58:14 -0600
In-Reply-To: <20190418140603.GL28541@quack2.suse.cz>
Cc:     Kanchan Joshi <joshi.k@samsung.com>,
        open list <linux-kernel@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        linux-nvme@lists.infradead.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, prakash.v@samsung.com
To:     Jan Kara <jack@suse.cz>
References: <1555523406-2380-1-git-send-email-joshi.k@samsung.com>
 <CGME20190417175358epcas1p41a0a4e349dfe0a70bdcc244161c71604@epcas1p4.samsung.com>
 <1555523406-2380-5-git-send-email-joshi.k@samsung.com>
 <20190418140603.GL28541@quack2.suse.cz>
X-Mailer: Apple Mail (2.3273)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


--Apple-Mail=_E3FEA83A-9256-40CD-B4F8-E3FF6FED0F48
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Apr 18, 2019, at 8:06 AM, Jan Kara <jack@suse.cz> wrote:
>=20
> On Wed 17-04-19 23:20:03, Kanchan Joshi wrote:
>> This patch moves write-hint-to-stream-id conversion in block-layer.
>> Earlier this was done by driver (nvme). Current conversion is of the
>> form "streamid =3D write-hint - 1", for both user and kernel streams.
>> Conversion takes stream limit (maintained in request queue) into
>> account. Write-hints beyond the exposed limit turn to 0.
>> A new field 'streamid' has been added in request. While 'write-hint'
>> field continues to exist. It keeps original value passed from upper
>> layer, and used during merging checks.
>>=20
>> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
>> ---
>> block/blk-core.c       | 20 ++++++++++++++++++++
>> include/linux/blkdev.h |  1 +
>> 2 files changed, 21 insertions(+)
>>=20
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index a55389b..712e6b7 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -730,6 +730,25 @@ bool blk_attempt_plug_merge(struct request_queue =
*q, struct bio *bio,
>> 	return false;
>> }
>>=20
>> +enum rw_hint blk_write_hint_to_streamid(struct request *req,
>> +				        struct bio *bio)
>> +{
>> +	enum rw_hint streamid, nr_streams;
>> +	struct request_queue *q =3D req->q;
>> +	nr_streams =3D q->limits.nr_streams;
>> +
>> +	streamid =3D bio->bi_write_hint;
>> +	if (!nr_streams || streamid =3D=3D WRITE_LIFE_NOT_SET ||
>> +	    streamid =3D=3D WRITE_LIFE_NONE)
>> +		streamid =3D 0;
>> +	else {
>> +		--streamid;
>> +		if(streamid > nr_streams)
>> +			streamid =3D 0;
>> +	}
>> +	return streamid;
>> +}
>> +
>=20
> Someone told me that stream ids are potentially persistent on the =
storage
> so it isn't great to change the id for the same thing e.g. if we add
> another user hint. So maybe we should allocate kernel hints from top =
as
> Dave Chinner suggested? I.e., something like the following mapping =
function:
>=20
> 	if (streamid <=3D BLK_MAX_USER_HINTS) {
> 		streamid--;
> 		if (streamid > nr_streams)
> 			streamid =3D 0;
> 	} else {
> 		/* Kernel hints get allocated from top */
> 		streamid -=3D WRITE_LIFE_KERN_MIN;
> 		if (streamid > nr_streams - BLK_MAX_USER_HINTS)
> 			streamid =3D 0;
> 		else
> 			streamid =3D nr_streams - streamid - 1;
> 	}
>=20
> what do you think?

Dave has expressed this sentiment several times, and I agree.  We don't
want the filesystem hint values/mapping to change over time, or it will
conflict with data that was written with the previous hints (e.g. if
data was written with a "short lifetime" hint suddenly changes to be
grouped with a "long lifetime" hint).  This is easily avoided with some
simple changes now, but harder to fix after this patch has landed.

Cheers, Andreas






--Apple-Mail=_E3FEA83A-9256-40CD-B4F8-E3FF6FED0F48
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAly4yMcACgkQcqXauRfM
H+D0PRAAqc1IZBlPSc3z+RpgV6C85m4l3Yd3cAYdG+R0kOOUx23t/z/vT9Sb0Qgr
mohRguY/t1dzZ9Kmu/XPYpuMVX2VNnymVjldxVVea7V0NYuEb7qDzMvPKrGr1tIR
rHh4vrrx+Riq+4K6TqjfgsJI6hdjIhCTU37VcCcAW9/3tHOTHPpYuhcvSpIzAGxc
60Zm+btRFcrx0wKRd/F0x9D1tbv0LKXJlaC3bD6OquZ0QbM8Z4TncHkl4NjwG7IN
iNJOOoYJKm623G3aJMLyPlXnJ5KCTgr9Swy4fiJDQOqtFb1oU0Jd2/1+gIXSmIVD
sZ+72FId74kf5Iu3Upr9tFtRdFs/IkUVVJVKDOmpeTO0FJXVkIgejpKwhJTzhWE8
E50OkTAgEg11+6VfI072rhudkK5FbXZ3ACVnJp+htOdLiT6etlyYEfpE35l+mUhE
XJ2TavOJi9P+SQ3VSsSpEXzNBDfho838ZkwaH43LdmBIWeZCdymf2FHS3DJ9mDOi
ihGr0DQGQAqLwbgD+zjNI9dCXoTiGp4+SDA0CcfwNPc6j8CPtFpguCmrQu/FJTRF
GjXBTeu07u+kw0Nh0B3nDbieS87ObR8XOqGtvQHCC0sOkIfr78KnKahgICXsqAna
Mo9d9G6Iq6nW/oY4fgk2ZVFgL+ubMJX0h2ho4I9MxtdonFabeTk=
=vct3
-----END PGP SIGNATURE-----

--Apple-Mail=_E3FEA83A-9256-40CD-B4F8-E3FF6FED0F48--
