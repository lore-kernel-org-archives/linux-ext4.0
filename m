From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH 1/2] e2image: truncate raw image file to correct size
Date: Thu, 16 Feb 2012 18:10:57 -0500
Message-ID: <4F3D8D01.5040604@ubuntu.com>
References: <1329428112-8911-1-git-send-email-psusi@ubuntu.com> <20120216225810.GB26473@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:21065 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab2BPXK6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Feb 2012 18:10:58 -0500
In-Reply-To: <20120216225810.GB26473@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/16/2012 05:58 PM, Ted Ts'o wrote:
> I don't see the bug here.  If there are no leftover sparse bytes,
> there's no need to write the last zero byte.  The whole point was to
> make sure i_size was set correctly, and if sparse==0, then i_size is
> correct.

- From what I can see, when sparse == 0, the last write does a seek to move
the file pointer, but doesn't write anything beyond the last hole, so i_size
is not updated.  This resulted in an image file I took of a 20gb fs being 124
MiB too small.  I can only assume that this is to be expected, and is the
reason for passing one byte of zero_buff to write_block instead of not giving
it any bytes to write, and just asking it to do the seek the way the loop does.

> ftruncate() happens to work today for Linux, but it's not guaranteed
> to do anything on all operating systems or even all file systems.  Per
> the standards spec:
> 
> 	If the file previously was smaller than this size, ftruncate()
> 	shall either increase the size of the file or fail.
> 
> Speaking of which, you're not checking the return value from ftruncate
> in your patch.  So I'd be happy if you checked ftruncate, and if it
> failed, falling back to the
> 
> 	if (sparse)
> 		write_block(fd, zero_buf, sparse-1, 1, -1);
> 
> code path.  That way, if ftruncate() happens to fail on NFS, or ceph,
> or some random file system that chose to meet the standards spec, but
> by failing if someone tries to increase the size of the file using
> ftruncate.  (Or some other OS; there are other operating systems,
> including GNU Hurd and BSD, and I don't know for sure how ftruncate
> behaves on all of those other OS's and file systems.)

Good idea.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPPY0BAAoJEJrBOlT6nu75ZpQH+QH0OGFfY0Tde0SZ3gl1QPeo
pbzYRA6Io6uxOMqLwYlOxfmxoaHByuQQupVDAyNtSLVEdGXvaixTNH/omu4TTYcR
54YARfgnsNlpfiJ8cYEP5jqNUvvIfqjqgBZncFYGiP/1smMh8uz56ThkHJtjaaSV
hEs1R9F6PdF+cplmsQooRAWedIR8f/Nd9KncKaKHOPiUKDr+3kbneBfbYMrqz6U9
ftoKVYNXNIb0+u9KxOFZybYMkiKoDQrMIUDkXCI39Mgkga/+3SelDZ+vl9Ax142e
oEAQfC6RrI86Oh+OjF3YeBQdreyz4ddkEnjFv/EgsfW8PPBw+iYt1NiaXiCUgd4=
=Kz4m
-----END PGP SIGNATURE-----
