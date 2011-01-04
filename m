From: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH resend] Update atime from future.
Date: Tue, 04 Jan 2011 13:21:47 -0500
Message-ID: <13585.1294165307@localhost>
References: <1294131418-3835-1-git-send-email-sickamd@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1294165307_4985P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, adilger@dilger.ca,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	swhiteho@redhat.com, sickadm@gmail.com
To: yangsheng <sickamd@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lennier.cc.vt.edu ([198.82.162.213]:39788 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab1ADSWF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Jan 2011 13:22:05 -0500
In-Reply-To: Your message of "Tue, 04 Jan 2011 16:56:58 +0800."
             <1294131418-3835-1-git-send-email-sickamd@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--==_Exmh_1294165307_4985P
Content-Type: text/plain; charset=us-ascii

On Tue, 04 Jan 2011 16:56:58 +0800, yangsheng said:
> If atime has been wrong set to future, then it cannot
> be updated back to current time.

> +#define RELATIME_MARGIN (24 * 60 * 60)

Nice patch overall.  Should this be a #define, or a CONFIG_ variable,
or a tweakable /proc/sys/fs variable?  Or am I senile and we thrashed
all this out once before when the relatime code landed?

--==_Exmh_1294165307_4985P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNI2U7cC3lWbTT17ARAgywAKD5Q+Q1kKqpD2mF0s1qbTE+kJDevQCgleQK
nHQxjWnb1lqjWD6K7A8nLco=
=EK1/
-----END PGP SIGNATURE-----

--==_Exmh_1294165307_4985P--

