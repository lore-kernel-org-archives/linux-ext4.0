Return-Path: <SRS0=V5lK=QY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83E55C4360F
	for <linux-ext4@archiver.kernel.org>; Sun, 17 Feb 2019 01:57:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52D98222E0
	for <linux-ext4@archiver.kernel.org>; Sun, 17 Feb 2019 01:57:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20150623.gappssmtp.com header.i=@dilger-ca.20150623.gappssmtp.com header.b="0oiNyj5y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbfBQB5p (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 16 Feb 2019 20:57:45 -0500
Received: from mail-it1-f193.google.com ([209.85.166.193]:39180 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727459AbfBQB5p (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Feb 2019 20:57:45 -0500
Received: by mail-it1-f193.google.com with SMTP id l15so20336297iti.4
        for <linux-ext4@vger.kernel.org>; Sat, 16 Feb 2019 17:57:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=0oi8tg3xmPdJ3QxEJLuquxqNvfILu8oMWgTcsH30WKs=;
        b=0oiNyj5ytuc10PzdJA2j4Do5IRrw7cgCxqYHPsgnPxD3YDVuFWUdWapbRJe4TyH7Jd
         q6Rp1ILG3844W7okmKbUtfeVX1l4FC0P0g/aWsyhyUio/FuxoQxjOkzjQfitzVnNJO5f
         q77HVyepSqt5eVow7PPWTNGdobVkDl8aHF2+gILgSZivJdFztnKOUi5DWMGd2G+Dj5JO
         X5abruzbrs0HFuvXTgRtGMIWPlILfT0dA87/KCrDJ9wcFdfULE/IacVmIWdMWZYsMQ5v
         E5qxn766jKlPOtmPkpAhsr+bQVC5JFVgep3JiDcq8ZlIhPZQtezS6nU8vk4/VfushMKL
         4caw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=0oi8tg3xmPdJ3QxEJLuquxqNvfILu8oMWgTcsH30WKs=;
        b=YIcGWroofhCRTzer/OT/S7XhNqL734L7qd6ejiiROWkdbMBPKIZ4CvnYJq0lNc5Pw6
         QELCl9Y5YgoBOtYfjL7SyptHOgtwjVrhVhF4YeDgD29bGdTx1y6+XPDnL0M2UXiZQ2CM
         ei1YXuXXo4xTicJs6PUtKsLWn6glVcK+hqxJ/BwE4NjMlKnBUrpuPo+82yvU2X8g/bQ1
         Wh82mczZ7JvbcEIMurpwaSqwx8bxFW5Ed4xcDKBilCo7tCElru7mNBmr8DsJCOSAY600
         yXbGuN1/wfwspB0PyzjrfjMp97bBZCRuU7ngJjn6p+l3LiL6mzJX2uL92lZBSNFMqTd4
         Qr9A==
X-Gm-Message-State: AHQUAuZhupbtbmwwB2YKmgKba+mBnHCyvMwqpng2q95w5cVlG7IxvIK6
        toV/BVZLH5sF1YwbeofLRSqJfg==
X-Google-Smtp-Source: AHgI3IZcpuX9sZT4gaFfaSvRlvbR9MC4ugElCHWiDMmxah9+7AHCPU7XC6h+uWySu4aJI1PT3LVRBQ==
X-Received: by 2002:a24:1cce:: with SMTP id c197mr8317185itc.81.1550368663801;
        Sat, 16 Feb 2019 17:57:43 -0800 (PST)
Received: from cabot.frontierlocal.net ([47.158.158.91])
        by smtp.gmail.com with ESMTPSA id r11sm4043381iog.46.2019.02.16.17.57.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 16 Feb 2019 17:57:42 -0800 (PST)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <72A04438-5991-4A60-8AAB-021A41DE6711@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_2BFC7822-8AA0-4845-B9EA-99BE13F0AA9D";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [RFC PATCH 0/6] Allow setting file birth time with utimensat()
Date:   Sat, 16 Feb 2019 18:57:45 -0700
In-Reply-To: <20190215065947.GG9819@vader>
Cc:     Dave Chinner <david@fromorbit.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, kernel-team@fb.com,
        Linux API <linux-api@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-xfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Steve French <sfrench@samba.org>
To:     Omar Sandoval <osandov@osandov.com>
References: <cover.1550136164.git.osandov@fb.com>
 <20190214220626.GV14116@dastard> <20190214231429.GE9819@vader>
 <20190215001657.GY14116@dastard> <20190215065947.GG9819@vader>
X-Mailer: Apple Mail (2.3273)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


--Apple-Mail=_2BFC7822-8AA0-4845-B9EA-99BE13F0AA9D
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Feb 14, 2019, at 11:59 PM, Omar Sandoval <osandov@osandov.com> wrote:
>=20
> On Fri, Feb 15, 2019 at 11:16:57AM +1100, Dave Chinner wrote:
>> On Thu, Feb 14, 2019 at 03:14:29PM -0800, Omar Sandoval wrote:
>>> I see a few options, none of which are particularly nice:
>>>=20
>>> 1. Filesystems like XFS could choose not to support setting btime =
even
>>>   if they support reading it.
>>> 2. XFS could add a second, writeable btime which is used for
>>>   statx/utimes when available (it would fit in di_pad2...).
>>> 3. We could add a btime_writable sysctl/mount option/mkfs option.
>>=20
>> 4. create time remains a read-only field, and btrfs grows its own
>> special interface to twiddle it in btrfs-recv if it really is
>> necessary.
>=20
> I'm curious to hear what the ext4/f2fs/CIFS developers think. If no =
one
> else wants btime to be mutable, then I might as well make it
> Btrfs-specific. That is, assuming we reach consensus on the Btrfs side
> that btrfs receive should set btime.
>=20
>> I'm still not convinced that even backup/restore should be doing =
this,
>> because there's so much other metadata that is unique even on
>> restored files that it doesn't really make any sense to me to lie
>> about it being created in the past....
>=20
> I suppose it depends on how you interpret btime: if it's strictly
> filesystem metadata, then it makes sense that it should be immutable; =
if
> it's metadata for the user's own purposes, then we should allow =
setting
> it.

My personal preference is that crtime/btime be read-only information =
that
tells when the file itself was created in this filesystem, not some =
added
metadata that is managed by userspace.  There have been many times when
I've needed to know when a file was _actually_ created in the =
filesystem,
not what mtime/ctime report.

While it may be a bit of a stretch to call this "forensic evidence", =
making
it hard to change from except via total root compromise by a skilled =
hacker
is very useful.

If this were to go in (which I'm not in favour of), then there would =
need to
be a CONFIG and/or runtime knob to turn it off (or better to only turn =
it on),
similar to how FIPS and other security options can only go in one =
direction.

Cheers, Andreas






--Apple-Mail=_2BFC7822-8AA0-4845-B9EA-99BE13F0AA9D
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlxov5oACgkQcqXauRfM
H+AyPhAAlbb/G73XdA0bWoKFVbnhMxf3ry5kn2FiSnjF8tUNsvWQWLgGwtKDS7LA
NjAzkZUaYLVVVkxP0Re9XyYNinbPdoyIsgQdjb+6x/Gc14lkP94bXzqQ8xBBC8rA
uBB/n7GsNj0FsU/osl/TBsQ4pPiQvTZk6Yq5hoJ51eTMk7SnCUQfgtMICtCaRkGX
edOfzbky+1RpJgu4NfwUlodFqJiNZ05st+gSjCoxcTXrejdhb+itIm7Pi0YIg3Rv
DuTcg5V1jkmeBwK7ZrocfGjBVG/+zxHvHhNucae2TWQ7EHxA1Qo+zdUu9Vw6U2sk
vKFYYK1Lb12St25MpTpP3UkO1yHypEjGSniMBWgKH8dZSXIPS3dWL5rsvKWdSP3/
jjcSXLYQaOQUrCaHkKX/ZyBw/tRM44ZpyTSE1N1YJcrsKvEPb4tSVa6+sydZHWJH
aWTie3vLN7se0GoYJKtngRzlFxpLHZelMZEGWBeFk4+cMK4kw+7HcoqCa4RnGn9T
gGJr0YTZfskzYwXYyJDeLIOxSi530C+6rgXooLXKcMWsq5qUy/wFWK22WG75Rqa5
CuJmPHVy3avbipdjRyGbX1nVPIce9Lr77O9dmEF3qAXZyyEKsNq4LKvt2usKfToU
1aJq6evQLDDIORopZSxYd/lGAgQLBM6RDMB16jwwa/8se1J1dak=
=Nx1H
-----END PGP SIGNATURE-----

--Apple-Mail=_2BFC7822-8AA0-4845-B9EA-99BE13F0AA9D--
