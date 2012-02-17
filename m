From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH 1/2] e2image: truncate raw image file to correct size
Date: Thu, 16 Feb 2012 19:21:22 -0500
Message-ID: <4F3D9D82.1020301@ubuntu.com>
References: <1329428112-8911-1-git-send-email-psusi@ubuntu.com> <20120216225810.GB26473@thunk.org> <4F3D8D01.5040604@ubuntu.com> <20120216233031.GD26473@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:14876 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab2BQAVX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Feb 2012 19:21:23 -0500
In-Reply-To: <20120216233031.GD26473@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/16/2012 06:30 PM, Ted Ts'o wrote:
> Sorry, I'm still not understanding what you're concerned about.  The
> last write should seek to the end of the file system, and write a
> single byte --- which would be past the last hole.  The goal is to
> make sure the file system is large enough that e2fsck doesn't
> complain about the file system image being apparently too small.

That single byte write doesn't happen when sparse == 0.

> I don't understand why you're saying that it's not writing anything
> beyond the last hole, and why you're saying i_size is not being
> updated.  It's working for me; I can run e2fsck on the generated
> image, and it's not complaining that the file system is too small.

It works for you because sparse != 0, thus triggering that one byte write.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPPZ2CAAoJEJrBOlT6nu75P30H/1KxTJu1NoFk2Wp/JcUwSkj/
gKq+83ykggPvtcDFcGFECRcIBgFdgPyY7pt08RTrvbSjwGLDGbK1zKOFvpYyHHak
yBOC96NTmtLAs1oesCVV+C/zjDehhojeh6xuKCC5EpMoL8KdAdREAWOcsr42fuhj
Qr/XKlQX8xFTrvmFQLORAOV1e7hHFQKOs1R29pCudQcppm7ZnlAWKHD7pGz9478U
tJjxg2B8YUrGriZFe0oAjotxTTTUIK7vErs+tfNgsYmvSFf0XbyC6V0DSpjbK7rf
9RPHaSukNY9ax2dKwGGQp9jQpRZ+RIp5GoZCOSCEOScOviRvHyfdOCgsqEsOYsk=
=9RZA
-----END PGP SIGNATURE-----
