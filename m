From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: evict inline data when writing to memory map
Date: Sun, 12 Mar 2017 22:39:43 -0600
Message-ID: <134D5551-C367-4B29-B83E-E536F493A230@dilger.ca>
References: <20170313004708.29838-1-ebiggers3@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_1DD492D2-E0AE-45A3-B8B0-64CB9833DD2F";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Nick Alcock <nick.alcock@oracle.com>,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:36430 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750758AbdCMEjs (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Mar 2017 00:39:48 -0400
Received: by mail-io0-f196.google.com with SMTP id 68so12328856ioh.3
        for <linux-ext4@vger.kernel.org>; Sun, 12 Mar 2017 21:39:47 -0700 (PDT)
In-Reply-To: <20170313004708.29838-1-ebiggers3@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_1DD492D2-E0AE-45A3-B8B0-64CB9833DD2F
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On Mar 12, 2017, at 6:47 PM, Eric Biggers <ebiggers3@gmail.com> wrote:
>=20
> From: Eric Biggers <ebiggers@google.com>
>=20
> Currently the case of writing via mmap to a file with inline data is =
not
> handled.  This is maybe a rare case since it requires a writable =
memory
> map of a very small file, but it is trivial to trigger with on
> inline_data filesystem, and it causes the
> 'BUG_ON(ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA));' in
> ext4_writepages() to be hit:
>=20
>    mkfs.ext4 -O inline_data /dev/vdb
>    mount /dev/vdb /mnt
>    xfs_io -f /mnt/file \
> 	-c 'pwrite 0 1' \
> 	-c 'mmap -w 0 1m' \
> 	-c 'mwrite 0 1' \
> 	-c 'fsync'
>=20
> 	kernel BUG at fs/ext4/inode.c:2723!
> 	invalid opcode: 0000 [#1] SMP
> 	CPU: 1 PID: 2532 Comm: xfs_io Not tainted =
4.11.0-rc1-xfstests-00301-g071d9acf3d1f #633
> 	Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.10.2-20170228_101828-anatol 04/01/2014
> 	task: ffff88003d3a8040 task.stack: ffffc90000300000
> 	RIP: 0010:ext4_writepages+0xc89/0xf8a
> 	RSP: 0018:ffffc90000303ca0 EFLAGS: 00010283
> 	RAX: 0000028410000000 RBX: ffff8800383fa3b0 RCX: =
ffffffff812afcdc
> 	RDX: 00000a9d00000246 RSI: ffffffff81e660e0 RDI: =
0000000000000246
> 	RBP: ffffc90000303dc0 R08: 0000000000000002 R09: =
869618e8f99b4fa5
> 	R10: 00000000852287a2 R11: 00000000a03b49f4 R12: =
ffff88003808e698
> 	R13: 0000000000000000 R14: 7fffffffffffffff R15: =
7fffffffffffffff
> 	FS:  00007fd3e53094c0(0000) GS:ffff88003e400000(0000) =
knlGS:0000000000000000
> 	CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> 	CR2: 00007fd3e4c51000 CR3: 000000003d554000 CR4: =
00000000003406e0
> 	Call Trace:
> 	 ? _raw_spin_unlock+0x27/0x2a
> 	 ? kvm_clock_read+0x1e/0x20
> 	 do_writepages+0x23/0x2c
> 	 ? do_writepages+0x23/0x2c
> 	 __filemap_fdatawrite_range+0x80/0x87
> 	 filemap_write_and_wait_range+0x67/0x8c
> 	 ext4_sync_file+0x20e/0x472
> 	 vfs_fsync_range+0x8e/0x9f
> 	 ? syscall_trace_enter+0x25b/0x2d0
> 	 vfs_fsync+0x1c/0x1e
> 	 do_fsync+0x31/0x4a
> 	 SyS_fsync+0x10/0x14
> 	 do_syscall_64+0x69/0x131
> 	 entry_SYSCALL64_slow_path+0x25/0x25
>=20
> We could try to be smart and keep the inline data in this case, or at
> least support delayed allocation when allocating the block, but these
> solutions would be more complicated and don't seem worthwhile given =
how
> rare this case seems to be.  So just fix the bug by calling
> ext4_convert_inline_data() when we're asked to make a page writable, =
so
> that any inline data gets evicted, with the block allocated =
immediately.

That is what I was going to suggest also, before I somehow lost this
thread in my inbox.  Keeping inline file data is a tiny improvement,
and any complexity to make this work is not worth it.

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> Reported-by: Nick Alcock <nick.alcock@oracle.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> fs/ext4/inode.c | 5 +++++
> 1 file changed, 5 insertions(+)
>=20
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 7385e6a6b6cb..0fc3e25ef531 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5839,6 +5839,11 @@ int ext4_page_mkwrite(struct vm_fault *vmf)
> 	file_update_time(vma->vm_file);
>=20
> 	down_read(&EXT4_I(inode)->i_mmap_sem);
> +
> +	ret =3D ext4_convert_inline_data(inode);
> +	if (ret)
> +		goto out_ret;
> +
> 	/* Delalloc case is easy... */
> 	if (test_opt(inode->i_sb, DELALLOC) &&
> 	    !ext4_should_journal_data(inode) &&
> --
> 2.12.0
>=20


Cheers, Andreas






--Apple-Mail=_1DD492D2-E0AE-45A3-B8B0-64CB9833DD2F
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFYxiKPpIg59Q01vtYRAtk9AJ4mPCUDqUbS5lS26n0SjySbAPFTJgCgoJhP
7KS45KQbiIr/fcl3YXvlguE=
=PrBS
-----END PGP SIGNATURE-----

--Apple-Mail=_1DD492D2-E0AE-45A3-B8B0-64CB9833DD2F--
