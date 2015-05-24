From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: resize2fs minimum size wrong
Date: Sat, 23 May 2015 20:27:50 -0400
Message-ID: <55611B06.3040608@ubuntu.com>
References: <5560EEB1.8070003@ubuntu.com> <20150523233603.GA3270@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:20536 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752092AbbEXA2D (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 23 May 2015 20:28:03 -0400
In-Reply-To: <20150523233603.GA3270@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 05/23/2015 07:36 PM, Theodore Ts'o wrote:
> Figuring out the minimum size in a way where we don't screw up and 
> pick a number too _low_ is tricky, because if resize2fs aborts in
> the middle, we can end up with a corrupted file system.

Why is it hard?  Why isn't it simply the number of used blocks, or the
highest fixed metadata block, whichever is higher?

> I'm going to guess the problem has to do with the reserved space 
> needed so that resize works correctly, and the amount of reserved

Reserved for what?


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJVYRsGAAoJENRVrw2cjl5R8fsIAKPy2Z0IKOpKUcQR/2dpuBp+
i1Td++sM3jPfXkshJrds8xe/B1dqxcVKTK6KOjk3YIQg7cr1XfRZW4hNZ4dU/vDi
NK5UiwHMa15HkVGTcF3ic3mEXmO2x3iYpgMb/9kkVJ9/k+VAXOuku1C59BQ+TAaM
bJ75j4xGatN58wMs4+RqTqDHBo/SiSCSCRvlpBmytcZIjmGguhvY9VtgbS7Wqf3l
GN1IjryP5CQaxq563avoIIl93u6ej4l3gYv2cIBDeBfBUv5iXkMx5rA56Z1PRs7v
WRvOA75aKS6EBq1/7PvRkyvfPOBBMUgRJOoYWziMJQKD044HKVNdy72BGjn3hbQ=
=ngJP
-----END PGP SIGNATURE-----
