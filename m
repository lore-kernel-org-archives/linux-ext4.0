Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8E03F4100
	for <linux-ext4@vger.kernel.org>; Sat, 13 Jun 2026 15:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781365293; cv=none; b=ldD9Ij9W22muU/ErAlTj1tUbIk58avbseuuhqpUpgCSHbcCCFw/H7Y5MvCGXmIylL5wD29Y8/1bIeg48LQAEidI+eZaruZYmMocE2dQJTZ7tw24MPvRAeTxn5EvDqIGMfKslM7aAhaNnqWonSYrixun7q5mbRZTBKDEf5wj6WHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781365293; c=relaxed/simple;
	bh=P4u5TPTTnBMGYmYvxn3VlN/OjVZl6LI1DHXrKq4wKsM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZP5aGRoHjvQ7fZS2azluYvKC4eh1lrs+rks1v7foW1FUT2qByOM61GAzfzIfq5Cb/6zIz34g0l0tC54i08bGTqZy+of91BOSHtTGaeY0TUglEcPAt8mf6poDqOB2VQMwpGWVQEl98JqLE67Ya+In8PBmX5KtAhqqWFYo6JsgB78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=BpNAiegZ; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="BpNAiegZ"
Received: from macsyma.thunk.org (pool-173-48-113-103.bstnma.fios.verizon.net [173.48.113.103])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 65DFf35W031098
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 13 Jun 2026 11:41:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1781365266; bh=hrE0AyrtUY+tf+F0WtIa3PolaWpjFHur4mMRwHAqj3Y=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=BpNAiegZVCwaISAjaygNJoy7Y7rw7gHakfm1CZy5QbZG706kXNq0UvQQqaOMCjUHL
	 k3W1dDxkLaMcKelq1iKskiqmg2Pi1GayIWKNuCjwCLcshzN/MGuqEJWIyk7Wt6OgyB
	 JtMWiA3/Q7GDYotgI9pWbAw5Z36x6ZWKyTers9Cmh6n9Zz49gPBXTn1/JKGD3BNH6N
	 Ju8ZRdf68bbFs0rTGmvX+p4NaPSLxVXPmxgG0mI8aMv5gvmBtUGfirSLL6IZ13jJIm
	 v+H3WlRv7/ZoBtL6Jy3uxqWGypp3NOHozcnpZFNTw+Ym8IwxlfWAkm5aXZ+m5jHdtL
	 hvZb16MsDhl7g==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 9D09049F232; Sat, 13 Jun 2026 11:41:03 -0400 (EDT)
Date: Sat, 13 Jun 2026 11:41:03 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Hanno =?utf-8?B?QsO2Y2s=?= <hanno@hboeck.de>
Cc: linux-ext4@vger.kernel.org, theodore.tso@gmail.com
Subject: Re: [PATCH] e2fsprogs/resize2fs: allow online resizing with
 CONFIG_BLK_DEV_WRITE_MOUNTED disabled
Message-ID: <3mfthuwidu4kzkeoe2mkpildsbkx7dhkb235jtqi53wmh6gkbe@s3mz4n3i63js>
References: <20260613110507.67289f68@hboeck.de>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260613110507.67289f68@hboeck.de>

On Sat, Jun 13, 2026 at 11:05:07AM +0200, Hanno Böck wrote:
> Kernels since version 6.8 have an option CONFIG_BLK_DEV_WRITE_MOUNTED
> that, if disabled, prevents accidental writes to and data corruption of
> mounted devices.
> 
> This breaks online resizing with resize2fs, as it opens the device with
> O_RDWR. However, it appears that this is not necessary and by changing
> it to O_RDONLY, online resizing works again.
> 
> See also: https://unix.stackexchange.com/a/796881
> 
> Signed-off-by: Hanno Böck <hanno@hboeck.de>

If you try run e2fssprogs's regression test (using "make check"), with
your patch applied, you'll find:

% make -j24 ; make -j24 check

...
t_mmp_2off: disable MMP using tune2fs: ok
377 tests succeeded	15 tests failed
Tests failed: m_minrootdir r_1024_small_bg r_32to64bit_expand_full r_bigalloc_big_expand r_ext4_small_bg r_fixup_lastbg_big r_fixup_lastbg r_inline_xattr r_min_itable r_move_inode_int_extent r_move_itable r_move_itable_nostride r_move_itable_realloc r_orphan_file r_resize_inode
make[1]: *** [Makefile:403: test_post] Error 1
make[1]: Leaving directory '/build/e2fsprogs/tests'
make: *** [Makefile:431: check-recursive] Error 1

Specifically, your change breaks off-line resizes, where the file
system is not mounted.  E2fsprogs builds on FreeBSD, GNU/Hurd, MacOS,
and other operating systems which don't support online resizing, which
is a Linux-only feature.

Furthermore, even on Linux, online resizing only supports growing the
file system.  If you want to shrink the file system, this must be done
using off-line resizing, with the file system unmounted.

And as I pointed out on another e-mail thread, fixing resize2fs is not
sufficient to disable CONFIG_BLK_DEV_WRITE_MOUNTED and retain full
functionality.  Specifically, certain file system parameters can be
modified using tune2fs while the file system is mounted.  Disabling
CONFIG_BLK_DEV_WRITE_MOUNTED will break this.

The CONFIG_BLK_DEV_WRITE_MOUNTED option was added specifically to
suppress maintainers from downing in Syzbot-generated noise, which
will gleefully report "security failures" caused by being able to
modify the block device while the file system is mounted.  The syzbot
scanner runs as root, which means it's great for inflating security
reports, at the cost of overloading maintainers who often deal with
syzbot reports late at night or on weekends, or have decided to just
ignore them since the signal is drowned out by the noise.  It was
**not** intended for users to disable that feature on production
systems.

At some point, in the future, the following thing needs to happen to
before blocking writes to the block device can be enabled for real:

*) E2fprogs's tune2fs program needs to be taught to use
 EXT4_IOC_GET_TUNE_SB_PARAM and EXT4_IOC_SET_TUNE_SB_PARAM ioctls so
 that the changes that are allowed to be made while the file system is
 mounted are done via this ioctls.

*) The kernel is enhanced so that write access to block device with a
 mounted file system can be blocked on a per "struct super", so the
 file system can block access either on per file system basis, or on a
 per mount basis based on a mount option.

*) We can only enable blocking block device writes to mounted file
 systems when we are use that users have both a kernel and e2fsprogs
 with support of EXT4_IOC_[SG]ET_TUNE_SB_PARAM.

Also note that at the moment, disabling block device writes of file
systems is at this point security theatre which is only rivaled by the
metal detectors in the airport operating by the United States
Transport Security Agency.  That's because
!CONFIG_BLK_DEV_WRITE_MOUNTED can be trivially bypassed by using the
loop device.

Cheers,

					- Ted


> --- a/resize/main.c	2026-03-06 18:17:36.000000000 +0100
> +++ b/resize/main.c	2026-06-13 10:53:46.165030199 +0200
> @@ -256,7 +256,7 @@ int main (int argc, char ** argv)
>  	int		force_min_size = 0;
>  	int		print_min_size = 0;
>  	int		fd, ret;
> -	int		open_flags = O_RDWR;
> +	int		open_flags = O_RDONLY;
>  	blk64_t		new_size = 0;
>  	blk64_t		max_size = 0;
>  	blk64_t		min_size = 0;
> @@ -364,9 +364,6 @@ int main (int argc, char ** argv)
>  		len = 2 * len;
>  	}
>  
> -	if (print_min_size)
> -		open_flags = O_RDONLY;
> -
>  	fd = ext2fs_open_file(device_name, open_flags, 0);
>  	if (fd < 0) {
>  		com_err("open", errno, _("while opening %s"),
> 
