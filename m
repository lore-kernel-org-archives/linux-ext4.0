From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext4: fix suboptimal seek_{data,hole} extents traversial
Date: Fri, 28 Nov 2014 18:02:02 +0300
Message-ID: <873893id1x.fsf@openvz.org>
References: <87egu7k6ym.fsf@openvz.org> <1413552334-32240-1-git-send-email-dmonakhov@openvz.org> <20141125211433.GB28449@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141125211433.GB28449@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Theodore Ts'o <tytso@mit.edu> writes:

> On Fri, Oct 17, 2014 at 05:25:34PM +0400, Dmitry Monakhov wrote:
>> It is rediculus practice to scan inode block by block, this technique
>> applicable only for old indirect files. This takes signifficant amount
>> of time for really large files. Let's reuse ext4_fiemap which already
>> traverse inode-tree in most optimal meaner.
>>=20
>> TESTCASE:
>> ftruncate64(fd, 0);
>> ftruncate64(fd, 1ULL << 40);
>> /* lseek will spin very long time */
>> lseek64(fd, 0, SEEK_DATA);
>> lseek64(fd, 0, SEEK_HOLE);
>>=20
>>=20
>> Original report: https://lkml.org/lkml/2014/10/16/620
>>=20
>> ##################################
>> BTW: Why do we need i_mutex here?
>>=20
>> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>
> Note: this patch causes generic/285 to loop forever in inline-data
> mode.  My guess is in the special case handling of inline data in
> ext4_fiemap not playing well with this change, but I haven't had a
> chance to look deeply into this yet.
FYI: inline_data feature is fatally broken

1) incorrect lock order (journal_start vs grab_cache_page_write_begin )
   ext4_da_write_inline_data_begin
   ->start_journal
   ->grab_cache_page_write_begin
     ->pagecache_get_page -> FS_REENTRANCE->DEADLOCK

2) ext4_inline_data_fiemap(0 ignores start and len arguments from ext4_file=
map()
   which obviously result in endless loop for anyone who want to use
   fiemap for inline files (which my patch try to do)

I'll send patches soon.
>
> 					- Ted

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJUeI5qAAoJELhyPTmIL6kBXuMH/jQrNxh0jAuiyKZ1/nQuD13J
yIe6t+pOXgmBP2DIqcFRtBKb6YdKsRKulDSjw5KfSOMf7l9ELNTzKdkgjNTdH1gn
4K5+kjz1Am9p1eX3/rFafLw3f4mEpcww4dzsGLl4sFaAZALomPCGmlNXrXFjlQU2
FahB9CCbptdhvkNyO0kI/TLnWcHKt7U64ogZryFQfJ3gx5+2mJFxu+t1dk2d8cXi
EUpaMWpmT5rxLHXWdXbZusdwqi+9AwuMes7aTiB9zIhcCx5HuMFLZ4yOV5maUTcV
L1sCFHGH2jB1/Ogp8xWXlXZWgrzWtvxkbb1q9eT98Ns8AB8x0h2n7CLZW6wszW8=
=ZeSd
-----END PGP SIGNATURE-----
--=-=-=--
