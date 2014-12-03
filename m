From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext4: ext4_da_convert_inline_data_to_extent drop locked page after error
Date: Wed, 03 Dec 2014 11:20:12 +0300
Message-ID: <877fy9du0z.fsf@openvz.org>
References: <1417530500-9958-1-git-send-email-dmonakhov@openvz.org> <20141202235913.GJ13618@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:51928 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbaLCIUk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Dec 2014 03:20:40 -0500
Received: by mail-wg0-f43.google.com with SMTP id l18so19267324wgh.16
        for <linux-ext4@vger.kernel.org>; Wed, 03 Dec 2014 00:20:39 -0800 (PST)
In-Reply-To: <20141202235913.GJ13618@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Theodore Ts'o <tytso@mit.edu> writes:

> On Tue, Dec 02, 2014 at 06:28:20PM +0400, Dmitry Monakhov wrote:
>> Testcase:
>> xfstests generic/270
>> MKFS_OPTIONS=3D"-q -I 256 -O inline_data,64bit"
>>=20
>> Call Trace:
>>  [<ffffffff81144c76>] lock_page+0x35/0x39 -------> DEADLOCK
>>  [<ffffffff81145260>] pagecache_get_page+0x65/0x15a
>>  [<ffffffff811507fc>] truncate_inode_pages_range+0x1db/0x45c
>>  [<ffffffff8120ea63>] ? ext4_da_get_block_prep+0x439/0x4b6
>>  [<ffffffff811b29b7>] ? __block_write_begin+0x284/0x29c
>>  [<ffffffff8120e62a>] ? ext4_change_inode_journal_flag+0x16b/0x16b
>>  [<ffffffff81150af0>] truncate_inode_pages+0x12/0x14
>>  [<ffffffff81247cb4>] ext4_truncate_failed_write+0x19/0x25
>>  [<ffffffff812488cf>] ext4_da_write_inline_data_begin+0x196/0x31c
>>  [<ffffffff81210dad>] ext4_da_write_begin+0x189/0x302
>>  [<ffffffff810c07ac>] ? trace_hardirqs_on+0xd/0xf
>>  [<ffffffff810ddd13>] ? read_seqcount_begin.clone.1+0x9f/0xcc
>>  [<ffffffff8114309d>] generic_perform_write+0xc7/0x1c6
>>  [<ffffffff810c040e>] ? mark_held_locks+0x59/0x77
>>  [<ffffffff811445d1>] __generic_file_write_iter+0x17f/0x1c5
>>  [<ffffffff8120726b>] ext4_file_write_iter+0x2a5/0x354
>>  [<ffffffff81185656>] ? file_start_write+0x2a/0x2c
>>  [<ffffffff8107bcdb>] ? bad_area_nosemaphore+0x13/0x15
>>  [<ffffffff811858ce>] new_sync_write+0x8a/0xb2
>>  [<ffffffff81186e7b>] vfs_write+0xb5/0x14d
>>  [<ffffffff81186ffb>] SyS_write+0x5c/0x8c
>>  [<ffffffff816f2529>] system_call_fastpath+0x12/0x17
>>=20
>> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>
> This patch makes sense but I haven't been able to duplicate the
> failure.  Maybe it's sensitive to the size of the scratch device, or
> some such?
I use xfstest-bld. So our test environment should be equals.
Unfortunately this is is not 100% reproducible, that is why I've missed
that bug on first test-run. Even more yesterday I've scheduled inline_data =
tests
to run for a whole night and it is deadlocked again in almost the same
place :)

[<ffffffff816f1698>] rwsem_down_write_failed+0x216/0x283 ->want xattr_sem -=
> DEADLOCK
[<ffffffff81414763>] call_rwsem_down_write_failed+0x13/0x20
[<ffffffff816f0eb3>] ? down_write+0x98/0xbc
[<ffffffff81249c9e>] ? ext4_inline_data_truncate+0x96/0x2c6
[<ffffffff81249c9e>] ext4_inline_data_truncate+0x96/0x2c6
[<ffffffff81210335>] ext4_truncate+0x171/0x432
[<ffffffff8124870c>] ext4_truncate_failed_write+0x21/0x25
[<ffffffff81249332>] ext4_da_write_inline_data_begin+0x1a9/0x33a ->holds xa=
ttr_sem

I'll send you updated version in a minute.

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJUfse9AAoJELhyPTmIL6kBEdYH/3k0Cvq++BluuLXwXh8oYWmj
NGRmDobD/TpnYOvRgURGpGvr8Gzpd/ocQXIfCn4co401pWMaigw2yWpNPqkmxNS4
Q9/t4/+lJ1xKP5T64uxmLLnvYv/eW6DNe3sK9oWn3Q6dFXDp3QhTFHCwLmDwHx+m
0LqcZwdsju7d6MY39ZSjGD0F0KgPtpt1pO/PH+N7CoR7XWvXewg0o9j/vQEMBA/H
lRkJtYkbWxpoKb8uq+cA3Fi7kvWbbb0B7YWO3zFkbk3fW/S3MbrTzIGsgJyIKP3z
G2EP4G8ZOO0Uqyu0tOyn+fUlsQ5VIXLNXO8y8XE9XX/1bgBIlJTCan7ZwucBmpU=
=hNQS
-----END PGP SIGNATURE-----
--=-=-=--
