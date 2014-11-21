From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 3/4] vfs: don't let the dirty time inodes get more than a day stale
Date: Fri, 21 Nov 2014 17:09:49 -0600
Message-ID: <656297ED-3A8F-4437-8356-950F8C77D9DE@dilger.ca>
References: <1416599964-21892-1-git-send-email-tytso@mit.edu> <1416599964-21892-4-git-send-email-tytso@mit.edu> <B1759DB3-7D86-499B-BE09-34D9927C75C8@dilger.ca> <20141121213651.GF7112@thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_75E0AF1A-FFD9-42D3-AD1E-9032144F7D7A"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:44838 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbaKUXJZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Nov 2014 18:09:25 -0500
Received: by mail-pd0-f179.google.com with SMTP id w10so6209545pde.38
        for <linux-ext4@vger.kernel.org>; Fri, 21 Nov 2014 15:09:25 -0800 (PST)
In-Reply-To: <20141121213651.GF7112@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_75E0AF1A-FFD9-42D3-AD1E-9032144F7D7A
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


On Nov 21, 2014, at 3:36 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>> and "days_since_boot" should be declared unsigned short so it wraps
>> in the same way as i_ts_dirty_day
>=20
> Good point, thanks.  This will only be an issue after the system has
> been up for almost 90 years, but we might as well get it right,

Speaking of stuff in the future, it looks like the patch to fix the
ext4 dates-beyond-epoch handling hasn't landed yet?

The last email I found related to that is in "[PATCH] fs: ext4: =
Sign-extend tv_sec after ORing in epoch bits", but the patch that I =
actually thought was ready to land was "[PATCH v8 1/2] ext4: Fix =
handling of extended tv_sec (bug 23732)" and the matching e2fsprogs =
patch:

http://lkml.org/lkml/2014/2/13/667
http://lkml.org/lkml/2014/2/13/670

Would be nice to get them landed, since we have less than 20 years
left, and at some point there will be embedded systems or VMs using
ext4 that may live long enough to hit the bug...

Cheers, Andreas






--Apple-Mail=_75E0AF1A-FFD9-42D3-AD1E-9032144F7D7A
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVG/GPXKl2rkXzB/gAQLOew//eEz3nEXSTHxnqszD00WonE1zy0nQzJpz
HWKM8PwSUp3Cr5tN4RC1AIFFE05cbGoNvAPXFDcvuU0G8YYoOZzyibTwl3i0eKez
0VTxdM7T/XXMX5Oln+yaWOSoN0p+2rltp1iUl/szVxUGOLDMvI6bTTrQk4zBR77y
wyH43gAtAwzMr4v2tL8N6iyk5oUvgAiDFE5sDr0isQh1c4EueX8/Zu4FZ9inCbdd
YD2mYn/kvf+ZJou3/+QI5GoUvNRp37JKS0BxioiximGNPY8TtO5whNuoGlbKwudc
lPNtpoPxGS3ic3n6VPMGCMuE37GCfax0K2tmo7J0OhGuciqSuvIe3eksHXZ4/hq0
ewxeBjLANDZLU8rdA6M3QYN/p/Cx2LVq56Ei643eyYuBYoqvPwgR8zAGHuktbCY5
LKKbtYfJiX/LEcWsWkrrLWMzc0Ji4bELMDa7KNIrhq7fpCLf/m0gbctnOUGqHeJx
LKtMjbck7K4W6iO6b0Y52rLjFbrKWMmJB9oPUQq86AAdZladPKatkVWzVStd08N5
ytMbBhPUqfZJHCVP5EvspFvnnD7X10FvN2fVrNJ59C3qqMa7bLR9U4V2+vsy1ot0
ROE339aS4fKSQgas4vSNmcAqFxyJb9nq5hBQrTYpzo7k3LDgLBwjyyvU8IQ07quj
2X/oNixDX88=
=xQi3
-----END PGP SIGNATURE-----

--Apple-Mail=_75E0AF1A-FFD9-42D3-AD1E-9032144F7D7A--
