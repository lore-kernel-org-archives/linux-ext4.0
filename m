From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Large directories and poor order correlation
Date: Mon, 14 Mar 2011 19:43:57 -0400
Message-ID: <4D7EA83D.20400@cfl.rr.com>
References: <4D7E7990.90209@cfl.rr.com> <4D7E7C7F.1040509@redhat.com> <4D7E8005.4030201@cfl.rr.com> <20110314215249.GE8120@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.122]:63598 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732Ab1CNXn6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Mar 2011 19:43:58 -0400
In-Reply-To: <20110314215249.GE8120@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/14/2011 05:52 PM, Ted Ts'o wrote:
> Unfortunately the kernel can't do it, because a directory could be
> arbitrarily big, and kernel memory is non-swappable.  In addition,

Buffers/cache is discardable though.  Or does the entire htree have to
be kept in slab or something?

> what if a process opens a directory, starts calling readdir, pauses in
> the middle, and then holds onto it for days, weeks, or months?

The same thing that happened before htree?

> It's not hard to provide library routines that do the right thing, and
> I have written an LD_PRELOAD which intercepts opendir() and readdir()
> calls and does the sorting in userspace.  Perhaps the right answer is
> getting this into libc, but I have exactly two words for you: "Uhlrich
> Drepper".

Wouldn't it be better to just have readdir() use the main directory,
which presumably is in a more sane ordering, instead of the htree?  That
way you don't have to burn cpu and ram sorting on every opendir().

Also, I have checked some smaller directories and lsattr reports they
are NOT using indexing, yet still display poor correlation.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk1+qDkACgkQJ4UciIs+XuIktwCgi1u4T2x+igOw4feO0hNjzB9W
liIAmwRBdPiZMSfWpzu4+40xJsNXzouQ
=d4VX
-----END PGP SIGNATURE-----
