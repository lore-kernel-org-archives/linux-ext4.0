Return-Path: <SRS0=EtEF=SK=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EACA1C10F13
	for <linux-ext4@archiver.kernel.org>; Mon,  8 Apr 2019 11:28:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA30520663
	for <linux-ext4@archiver.kernel.org>; Mon,  8 Apr 2019 11:28:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20150623.gappssmtp.com header.i=@dilger-ca.20150623.gappssmtp.com header.b="LgVaDXti"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbfDHL2F (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 8 Apr 2019 07:28:05 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37831 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbfDHL2F (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Apr 2019 07:28:05 -0400
Received: by mail-wr1-f66.google.com with SMTP id w10so15944621wrm.4
        for <linux-ext4@vger.kernel.org>; Mon, 08 Apr 2019 04:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=oiJ0Wvle+szpTFkmYNO05HUKknsuWLrMw41dLM0s07M=;
        b=LgVaDXtiWTE/mWB/LQOW8aIS77zMP/PK5iXQZxK4XZaTAL+Gf58jX4+v25N3uy2XEP
         W47KAYd4GSVhr4kALmzp96v4/lE4nPPtY8z6apLn01zN1qW9c2m3bxVOtyDwqcW2T/Uf
         nOgGfGtkibxecu3/kzaxJ8EFwqFbv9I6DVKjumo7C7drmUGG/GCyWhnMl2oc2a4S6tGJ
         rimOiUk26vabzAwzWKKGgVj3U7ADGJpahP1EH+/SliymX3WPpTczQ9KEyJkaTs/+6Rv1
         6MHxs8aB3rXOQUXLvMKt4jQBr9IaGT9kU/43sSZbiK9CAgrLOcnNJ4knuH4SdILgom/1
         RLTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=oiJ0Wvle+szpTFkmYNO05HUKknsuWLrMw41dLM0s07M=;
        b=bRBZjopmrOGhpz/DZwAh3QkC2ElQvAagNrqZCTZ7qaUztJlioWPyfzl+yeThFA4EjV
         CNc92lQpjl+5uHbkiY/+QECGBtcuXGnQ7kH179nL5jt8NAF3XHmYozeu7kfehGNsAKrI
         cVkEZFOqPrLgqoCwj1cVVdDW7naVDOhzg/aWV9M5785oDZUjA3xokMZOXxUTbDu6l8pg
         A203XEH23Xhi+xwH/alH1pk+MU7GHSGoTUjF/cq4llMLXwQZRA//Yt/tPPh1SbenX8mw
         rBeJbHqyGX4DS7B/YsoziQes4uxrsl9p3Yv01A+kHI6OlvZB4b5p9ggzCsXNwu0S5yBK
         VqIw==
X-Gm-Message-State: APjAAAWCt7v3cyiVMOjqGn7WILtfHRCCvYWw6Mnf6NEiNmBWepJhjOD6
        MbF5gvmXs+RoBtPBmZsE7EJprQ==
X-Google-Smtp-Source: APXvYqzyJXb717bcJB5NUQG+wlJXrHej+SeWnDwrrRDsvfC3GrmMJ7P44jLPbrVhK8m3SM082qhZlQ==
X-Received: by 2002:adf:ed90:: with SMTP id c16mr19536761wro.74.1554722882748;
        Mon, 08 Apr 2019 04:28:02 -0700 (PDT)
Received: from konferenz-8d46b9eb.on.site.uni-stuttgart.net (konferenz-8d46b9eb.on.site.uni-stuttgart.net. [141.70.185.235])
        by smtp.gmail.com with ESMTPSA id c2sm20773812wrr.13.2019.04.08.04.28.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Apr 2019 04:28:01 -0700 (PDT)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <581BC10D-6743-4E2E-A4C1-C8C3F9BE9DA3@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_074D479C-955D-476D-91A4-AD19BEDCE174";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH] bootfs: simple bootloader filesystem
Date:   Mon, 8 Apr 2019 05:28:23 -0600
In-Reply-To: <20190407201328.GR15524@magnolia>
Cc:     Eric Sandeen <sandeen@sandeen.net>, Theodore Ts'o <tytso@mit.edu>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
References: <20190401070001.GJ1173@magnolia> <20190401214632.GS26298@dastard>
 <20190402045519.GK1173@magnolia> <20190406232717.GH18897@mit.edu>
 <e358c920-d49e-8319-ee19-4b3fa930b0f5@sandeen.net>
 <20190407201328.GR15524@magnolia>
X-Mailer: Apple Mail (2.3273)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


--Apple-Mail=_074D479C-955D-476D-91A4-AD19BEDCE174
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Apr 7, 2019, at 2:13 PM, Darrick J. Wong <darrick.wong@oracle.com> =
wrote:
>=20
> On Sun, Apr 07, 2019 at 01:10:55PM -0500, Eric Sandeen wrote:
>> On 4/6/19 6:27 PM, Theodore Ts'o wrote:
>>> On Mon, Apr 01, 2019 at 09:55:19PM -0700, Darrick J. Wong wrote:
>>>>=20
>>>> When Ted is done laughing, I really would like to consider =
something
>>>> like this to solve the problem of grub-style bootloaders requiring =
a
>>>> lease on the blocks underneath a file with a term exceeding that of =
the
>>>> running kernel.
>>>>=20
>>>> We can probably skip the harsh synchronous writes in favor of fsync =
on
>>>> close, but we would need to keep the critical component of =
checkpointing
>>>> the journal on fsync and syncfs.
>>>=20
>>> At least for ext4, we don't need to add anything new, since FIFREEZE
>>> force a journal checkpoint.  So we could try to get a patch into =
grub
>>> which causes update_grub to open each kernel that it finds, and =
calls
>>> fsync(2) on it, and then for all file systems where it finds a =
kernel,
>>> it can call FIFREEZE and FITHAW on it, and that would be that.
>>=20
>> Certain operating systems have hacked this in.  My concern would be =
when
>> /boot is on / ... calling FIFREEZE on the root fs would most likely =
be
>> a bad thing.  Certain operating systems avoid calling FIFREEZE for
>> /boot-on-root.  ;)
>>=20
>> Doing it for a standalone /boot seems like a reasonable (if hacky)
>> workaround as long as we lack a more targeted quiesce interface...
>=20
> The other problem we noticed is that neither the grub scripts nor the
> rpm package scripts bother to call fsync on the files they write (or
> sync after they're done to mop up after everyone else), so I figured =
as
> long as I'm ("jokingly") working around it all in kernel space, why =
not
> just go all the way? :P
>=20
> Ok, I'll go work on an ioctl or something.

If Grub isn't even bothering to call fsync() on a file, what is the =
chance
that they would call a special ioctl on the file?

What about doing "chattr +S /boot" so that all file IO in this directory =
is
done synchronously, which would work even if /boot is not on a separate
filesystem?  The "+S" flag is inherited by new files created in the =
directory.

Cheers, Andreas






--Apple-Mail=_074D479C-955D-476D-91A4-AD19BEDCE174
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlyrMFcACgkQcqXauRfM
H+AwZg//fiemXK1qKdfgFiIOC+jx4FZgypk/xTfHZOr5wXiGqhLey3vd0VrlBH1E
fowWz1NIv3yEFsdi9gmBIHSabb9/ewE3BirB/kwQz9E7DYLkVB30LdI66/CdjxFK
J6Zo+w06ACsaRwfnS5g9Bvx7bKTttt1Rk+1jhmexvwfttgALGRWuUAdWEyDYRwY9
/4PNbfcjfTCVMb2SlZFKIsB5zG8Xc7O6CEGc/jeucUVu57uaB1Bi5nQoKsp6xOaC
JI5QeWA7rZIiksF1mC6dFlwGB8FDXpfPM7DICDi6FjYtpyfynadGwpAtW4I9TqXp
GS2SpRclX+PqLdYSBEzibluz30S7AXoPKcjU7pSG43a1bU8vXDshkPJdeXuSuuRB
6hLBLbhcnFwjCnlnzO+rPPdC7UtOW2gh5O9TIU+6IJgo0mRMIoB+s+XbY2u8zi5U
A53Ndzl+CniXecZ05/obMW9GGjewyS9q2KWRqHEPJFvb4t91uEQ3Mb0VAC098NuF
69YO+Yx6toWz4nzasqNOlq6mNLkmr96E7qIstx4nNSFtY8Lr2qdWu5FQSaAZt0RR
/DEeP6EnvU5kKl1sk2CdThEc/l04Y4UlbCb0L6mTLvbFIMKCofz+GwcxAsEEJmPY
kIkjDU5SVxLHBJcUtlPGVSsHRD/p1UF7FrNyX0jlPBadA4XQGw4=
=sWaQ
-----END PGP SIGNATURE-----

--Apple-Mail=_074D479C-955D-476D-91A4-AD19BEDCE174--
