Return-Path: <SRS0=cA8i=2D=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC69FC43603
	for <linux-ext4@archiver.kernel.org>; Fri, 13 Dec 2019 23:02:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6E3C2253D
	for <linux-ext4@archiver.kernel.org>; Fri, 13 Dec 2019 23:02:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfLMXC3 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 13 Dec 2019 18:02:29 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:46212 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbfLMXC3 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Dec 2019 18:02:29 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 3813C1C25DE; Sat, 14 Dec 2019 00:02:27 +0100 (CET)
Date:   Sat, 14 Dec 2019 00:02:26 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     kernel list <linux-kernel@vger.kernel.org>, jack@suse.com,
        linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca
Subject: ext4 warnings: extent tree (at level 2) could be narrower.
Message-ID: <20191213230226.GA11066@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

Periodic fsck kicked in on x86-32 machine. I did partial update in the
meantime, and was running various kernels including -next... Now I'm
getting:

data: Inode 1840310 extent tree (at level 2) could be narrower. IGNORED.

on 5 inodes.  Is it harmless, or does it mean I was running buggy
kernel in the past, or...?

Best regards,
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXfQYggAKCRAw5/Bqldv6
8nB9AJ9juSmVPpO+cOq+VkavYKT8dnE4yQCgwgmOctfMPzwGErUGccdJiEI/If0=
=w1Qo
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
