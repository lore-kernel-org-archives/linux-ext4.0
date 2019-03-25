Return-Path: <SRS0=eNh3=R4=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58B9FC4360F
	for <linux-ext4@archiver.kernel.org>; Mon, 25 Mar 2019 20:00:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2493E20850
	for <linux-ext4@archiver.kernel.org>; Mon, 25 Mar 2019 20:00:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20150623.gappssmtp.com header.i=@dilger-ca.20150623.gappssmtp.com header.b="DcP7yrUI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730261AbfCYUAH (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 25 Mar 2019 16:00:07 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46557 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729548AbfCYUAG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Mar 2019 16:00:06 -0400
Received: by mail-pg1-f195.google.com with SMTP id a22so7060958pgg.13
        for <linux-ext4@vger.kernel.org>; Mon, 25 Mar 2019 13:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=1zXhpRZO0WAdOqWP7x2ebolGGLk+YEfDkHo8iks+akk=;
        b=DcP7yrUImHYE0ppg3I7gbMEVbKEqKEtqdx2yKINGm7hZbPC6vrJJmiUuBcct7zn1w/
         1KxBW8Ec5Hn1eWG24P+RNGU/VdyCAVF/ef2moRdrYnNtbgK7G6uohnNLrr6FoUKMGEG2
         JxIt1UJbZJQU9o9Bh1Rxw99c/zwR3oRdSUXWAnVO5JEyQOX42QWd4IaVh2FVYAdYRwr8
         D0D7dZ/Fx0/iOmN0X2XlOYQEjBl6Rm3Lv99/1pHZPLOI0lrgRsdlsnvdFIDDUYCFxfZ6
         CXx1sNvxaYOPoHp5Ujr610RqtyQrobzMcTjr2kRQ1mp4+VsLXhVIBIMC820Zf0FdOU7T
         gEDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=1zXhpRZO0WAdOqWP7x2ebolGGLk+YEfDkHo8iks+akk=;
        b=Jd8zcuwFbahlQqanJoCo8stYbChaCkMeqjNqlf9tipnZn2lei0FKhWHwYwgP03syKi
         OH9TZCdptGyRyl8IOQoS/iBBHQd+ufTX3PSGjgHn2sTzECLBm0ivgRNv3qrA4n6zpphy
         h26x5e/k2g33nawsoVbp/wdLoz+eyA90R2Yi295PHVGbi+RVRRD9O+V53ba3LLyeNIC6
         in0o4RIRTTUa0wUDtJKcGdL6qjsaF6WJLIG9hMX4kh+NI/x5RGI797fOB+2AXY1C8FA5
         2Y9EzVAFgCEMrY0lrLG+MLDh8F76+HxJGewqgKt1a826tklJMqPD8pUT1VWDyenvUT4i
         IqmA==
X-Gm-Message-State: APjAAAWB0TvQ1zTNX+Nim1uSniAvm3whkJzYyIBTY5eh89Ef9yqQ23cg
        DxBHlHZn07dqUac/gkXk9gbZpA==
X-Google-Smtp-Source: APXvYqycHrRTeR58160gy46GMcWU9UDYo3aBHMoqKWs/6YkXHeuUFWmC/woYJiDY61Jz0aSxOhZV+A==
X-Received: by 2002:a62:4746:: with SMTP id u67mr25748583pfa.243.1553544004607;
        Mon, 25 Mar 2019 13:00:04 -0700 (PDT)
Received: from cabot.adilger.ext (S0106a84e3fe4b223.cg.shawcable.net. [70.77.216.213])
        by smtp.gmail.com with ESMTPSA id i1sm1022990pgc.63.2019.03.25.13.00.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Mar 2019 13:00:03 -0700 (PDT)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <9F56F958-2DEF-4350-8BBC-9A40598D0365@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_73BE7F53-B23C-4F73-89F8-8310F4842D0D";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH] ext4: use BUG() instead of BUG_ON(1)
Date:   Mon, 25 Mar 2019 13:59:58 -0600
In-Reply-To: <20190325181422.GH1173@magnolia>
Cc:     Arnd Bergmann <arnd@arndb.de>, Theodore Ts'o <tytso@mit.edu>,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Eric Whitney <enwlinux@gmail.com>,
        Sean Fu <fxinrong@gmail.com>, Jan Kara <jack@suse.cz>,
        Eric Biggers <ebiggers@google.com>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
References: <20190325130040.1437445-1-arnd@arndb.de>
 <20190325181422.GH1173@magnolia>
X-Mailer: Apple Mail (2.3273)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


--Apple-Mail=_73BE7F53-B23C-4F73-89F8-8310F4842D0D
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Mar 25, 2019, at 12:14 PM, Darrick J. Wong <darrick.wong@oracle.com> =
wrote:
>=20
> On Mon, Mar 25, 2019 at 02:00:25PM +0100, Arnd Bergmann wrote:
>> BUG_ON(1) leads to bogus warnings from clang when
>> CONFIG_PROFILE_ANNOTATED_BRANCHES is set:
>>=20
>> fs/ext4/inode.c:544:4: error: variable 'retval' is used uninitialized =
whenever 'if' condition is false
>>      [-Werror,-Wsometimes-uninitialized]
>>                        BUG_ON(1);
>>                        ^~~~~~~~~
>> include/asm-generic/bug.h:61:36: note: expanded from macro 'BUG_ON'
>>                                   ^~~~~~~~~~~~~~~~~~~
>> include/linux/compiler.h:48:23: note: expanded from macro 'unlikely'
>>                        =
^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> fs/ext4/inode.c:591:6: note: uninitialized use occurs here
>>        if (retval > 0 && map->m_flags & EXT4_MAP_MAPPED) {
>>            ^~~~~~
>> fs/ext4/inode.c:544:4: note: remove the 'if' if its condition is =
always true
>>                        BUG_ON(1);
>>                        ^
>> include/asm-generic/bug.h:61:32: note: expanded from macro 'BUG_ON'
>>                               ^
>> fs/ext4/inode.c:502:12: note: initialize the variable 'retval' to =
silence this warning
>>=20
>> Change it to BUG() so clang can see that this code path can never
>> continue.
>=20
> I grok that most of these look like "should never get here" =
assertions,
> but shouldn't we be converting these BUG*() calls to "shut down fs,
> bounce error back to userspace" instead of killing the whole kernel?
>=20
> (He says knowing that ripping all of those out is its own project... =
:P)

We definitely shouldn't be adding "BUG()" or "BUG_ON()" to active code, =
but
rather call ext4_error() and let the admin to set "errors=3Dpanic" if =
they
want this action, or leave "errors=3Dremount-ro" (which is the default =
these
days) and just return an error to userspace.

Looking at the nearby code, it is using pr_warn("ES insert assertion =
failed..."
instead of using an actual assertion for the failure cases.

I guess a saving grace is that this code is only enabled if =
ES_AGGRESSIVE_TEST
is defined, which it is not by default, so probably it is only when some
developer is testing this code.  So using BUG() is probably OK in this =
case.

Cheers, Andreas

>=20
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> ---
>> fs/ext4/extents_status.c | 4 ++--
>> fs/ext4/inode.c          | 4 ++--
>> 2 files changed, 4 insertions(+), 4 deletions(-)
>>=20
>> diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
>> index 2b439afafe13..023a3eb3afa3 100644
>> --- a/fs/ext4/extents_status.c
>> +++ b/fs/ext4/extents_status.c
>> @@ -711,7 +711,7 @@ static void =
ext4_es_insert_extent_ind_check(struct inode *inode,
>> 			 * We don't need to check unwritten extent =
because
>> 			 * indirect-based file doesn't have it.
>> 			 */
>> -			BUG_ON(1);
>> +			BUG();
>> 		}
>> 	} else if (retval =3D=3D 0) {
>> 		if (ext4_es_is_written(es)) {
>> @@ -780,7 +780,7 @@ static int __es_insert_extent(struct inode =
*inode, struct extent_status *newes)
>> 			}
>> 			p =3D &(*p)->rb_right;
>> 		} else {
>> -			BUG_ON(1);
>> +			BUG();
>> 			return -EINVAL;
>> 		}
>> 	}
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index b32a57bc5d5d..190f0478582a 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -541,7 +541,7 @@ int ext4_map_blocks(handle_t *handle, struct =
inode *inode,
>> 			map->m_len =3D retval;
>> 			retval =3D 0;
>> 		} else {
>> -			BUG_ON(1);
>> +			BUG();
>> 		}
>> #ifdef ES_AGGRESSIVE_TEST
>> 		ext4_map_blocks_es_recheck(handle, inode, map,
>> @@ -1876,7 +1876,7 @@ static int ext4_da_map_blocks(struct inode =
*inode, sector_t iblock,
>> 		else if (ext4_es_is_unwritten(&es))
>> 			map->m_flags |=3D EXT4_MAP_UNWRITTEN;
>> 		else
>> -			BUG_ON(1);
>> +			BUG();
>>=20
>> #ifdef ES_AGGRESSIVE_TEST
>> 		ext4_map_blocks_es_recheck(NULL, inode, map, &orig_map, =
0);
>> --
>> 2.20.0


Cheers, Andreas






--Apple-Mail=_73BE7F53-B23C-4F73-89F8-8310F4842D0D
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlyZMz8ACgkQcqXauRfM
H+Ceyw//Z1p1TGsGEo81YLhmCfuKm6wwixRreNCbZVn1BpHU18I7XdKGq3wwHLeK
key5dIj6CuukFB4IyiesTgYvDSIgVgn6+twub0mPzya/oRm0BJhjwiZSvUOvwYDc
lqLEDUrk9Ow9pYyUR+U14nEvQ10I9+tMx4u3iT6aTWcbdMnQAyzYVwr/6QGlJMCy
yjy1wv9VVBhImj7mjPoCuRXckl6fxFtu2dYgXp2Bhx6g7RSxaOJPpIrBEXY0qH3E
23Qvef3+6sdp30B40yFGmQC4uvoE6HHg6sUjC2YhWLqJIVcMvrS1MBnvHPYk+dZ3
dlDNN/S4Gn5rfRRKRufsLEiHgAHB4RnMsg1o3D9VtqIyXtqYmcmizQrlu6mc/JmX
hcfkUp7qT6wg/EzPrm8BVaOyn1lXKitx4wQUomNwnkzaWHE6xyu01r60fvzqx0ve
RYRxo7xkSRHw4RAHFQQEM46Bm3GEFCSFwDAy6OXb5nf4oZoEcqnU+F5NKEP7Gd+d
GLHu+QsR8Grn/zwMosUxbP5Y7uhgKBbhVa0Phok6GbPe8wuhoxf8jACOTARJEmSG
nkdrLsMz++R+CzTvEPBPZL07fuE/ATAoXyRh2OhSpXveBYwJc6zo/6utCLDv1pOQ
j27f3OyDdaLC158bHsCl4SvtAb39B0dHCrhPJ70cB3B+AQFvchQ=
=kTBH
-----END PGP SIGNATURE-----

--Apple-Mail=_73BE7F53-B23C-4F73-89F8-8310F4842D0D--
