Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795334987;
	b=YVboYqCzqjjz2mAocOK5NxMQh4OuN11Ctiv1pnXX468rnI6klJTh+yRnIxz+ITQCFYJT
	 HqV1hdTWqgxpv7BbZT/yjWjnaMAoIK1fRTqDInRERwv7x7GfZnKv3lsF/8AqeMxSJw4jt
	 bO2mF2UtZkATGOZHMHm5JfuvU2bZzyoyiU52wKNFpI8XsAruK6HZOmyk64XfhlKpEASnV
	 pJgwNvcbCAPIVPnObul9jsrzeZ1VdoOGnP37h9JqTdHi88D7NInr8CzmxN9mtW8dXaT8R
	 tlWUiVUCYOPHZJ4y7Q+L8Po479FUv7lM/EMRSXIkMq455repqQTkTu40bZmQ4uf6DVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795334987;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=UFkYduOFNcFJoBhuclWQkXj0yTUPFFOabKnZfAvorO8=;
	b=qZ+QJ7npo6rbaBhFPoBMGW9GcRMciY3LCrqZZZBmkXlenX5ijo7P8MPb2H/T//hU2r0t
	 bPLsYr6/qlWQ2bmyVwQc5dXY0QxQwxcuHI/aZkB2CN/UjswMRv/ogzjjkZGBIpQiTyYNR
	 35CSc9qcK1VNmaYWhPFyLM7aOiheK4JcJQ1QsbMj0ZyWAcsh1kaLroxJDX7VANMGhd4DV
	 FrFL98KARVqStmLKeHN8pAPy0LUBSZ8LxIpATS0AuP4XyNA0x8OCBowWHWI/w3ixfuPOu
	 rvHRZDLKvSzdc5D8U9X0dlvjLGBnX1nCBOZ0dugZVJbyaXGr9wUB3y15bZ3eG25e0lQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cxy2VzCx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E476F606A320
	for <linux-ext4@vger.kernel.org>; Sun, 22 Nov 2026 08:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cxy2VzCx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E04D1F000C4;
	Sun, 22 Nov 2026 08:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795334986;
	bh=UFkYduOFNcFJoBhuclWQkXj0yTUPFFOabKnZfAvorO8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cxy2VzCx/KPOvSzijiKwiyzBK/7ULCz/3q4r80gcdqiYHU1W0qgIfHsJy/uqjV2LE
	 lXa3tydL/IOuniwEoJA5EBkLILi59/ne4KmH480s0o5INk2YvImNNcct4B/phVONcE
	 r3cu8xxtsmk/2klXVhOztNPKTjEeLWgroxi785n2NOr+4REhhJdK9mG93aP3pKMFpB
	 C1fxZWAcY9rZatvc76diU6pyN4Qy4pNKbabqbGu5uBkryoyYpTSMhoMYPbdWncrnqd
	 k4lX6ruf1nmNdcKjdf4N9CeQEyfREbnFmZm+lN7zi3VAZ9JIUw9PhvAgKc0Zp+bvLN
	 Ac0X+4w9n6NJQ==
Message-ID: <sashiko-outbox-227808@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: bound xattr journal credits to transaction limit
Reply-To: sashiko-reviews@lists.linux.dev
To: arzuagapozosergio@gmail.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261122075355.81772-1-arzuagapozosergio@gmail.com>
References: <20261122075355.81772-1-arzuagapozosergio@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 22 Nov 2026 08:09:45 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 5 potential
issues to consider:
- [Medium] ext4: ext4_xattr_set_credits() bound check omits default
  revoke block credits
- [Medium] ext4: __ext4_xattr_set_credits() overcharges for deferred
  ea_inode eviction
- [Medium] selftests: ext4: helper binary listed in TEST_GEN_PROGS
  breaks make run_tests
- [Low] selftests: ext4: missing kselftest helpers, fd close, and mount
  skip handling
- [Low] ext4: redundant xattr block reads and lookups during credit
  calculation
--

commit c2bfcf812ed8b979038bd6d5afa72dc0e3e9494f
Author: Ryuji Hiroshi <182191995+root465-lipcripto@users.noreply.github.com>

ext4: bound xattr journal credits to transaction limit

This commit looks up existing xattr entries to charge journal credits for
the actual old ea_inode value size instead of XATTR_SIZE_MAX, rejects
estimates exceeding JBD2's maximum transaction credits, and adds an ext4
selftest.

Link: https://syzbot.org/bug?extid=3D25d45c0bd716f2b794a7

> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 5c310747b9650..a904ea1dc05bc 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -949,7 +949,7 @@ static void ext4_xattr_inode_free_quota(struct inode =
*parent,
> =20
>  int __ext4_xattr_set_credits(struct super_block *sb, struct inode *inode,
>  			     struct buffer_head *block_bh, size_t value_len,
> -			     bool is_create)
> +			     bool is_create, size_t old_ea_value_len)
>  {
>  	int credits;
>  	int blocks;
> @@ -998,14 +998,15 @@ int __ext4_xattr_set_credits(struct super_block *sb=
, struct inode *inode,
>  	/* Blocks themselves. */
>  	credits +=3D blocks;
> =20
> -	if (!is_create) {
> +	if (!is_create && old_ea_value_len) {
>  		/* Dereference ea_inode holding old xattr value.
>  		 * Old ea_inode, inode map, block bitmap, group descriptor.
>  		 */
>  		credits +=3D 4;
> =20
>  		/* Data blocks for old ea_inode. */
> -		blocks =3D XATTR_SIZE_MAX >> sb->s_blocksize_bits;
> +		blocks =3D (old_ea_value_len + sb->s_blocksize - 1) >>
> +			 sb->s_blocksize_bits;
> =20
>  		/* Indirection block or one level of extent tree for old
>  		 * ea_inode.

[Severity: Medium]
Does the setxattr transaction actually free the old ea_inode's data blocks
here?

ext4_xattr_set_entry() only calls ext4_xattr_inode_dec_ref() (which
dirties old_ea_inode and adds it to the orphan list when ref_count reaches
0, using 2 credits) and then releases the reference via
ext4_put_ea_inode().  Because ext4_put_ea_inode() defers the final iput()
and ext4_evict_inode() truncation to sbi->s_ea_inode_work in a separate
transaction, charging 2 * blocks credits for old_ea_value_len here causes
in-place replacements of large ea_inode xattrs on small-journal
filesystems to fail with -ENOSPC.

[ ... ]

> @@ -2415,6 +2393,38 @@ ext4_xattr_set_handle(handle_t *handle, struct ino=
de *inode, int name_index,
>  		error =3D ext4_xattr_block_find(inode, &i, &bs);
>  	if (error)
>  		goto cleanup;
> +
> +	/* Check journal credits under write lock using the old value size. */
> +	if (ext4_handle_valid(handle)) {
> +		struct ext4_xattr_entry *entry =3D NULL;
> +		size_t old_ea_value_len =3D 0;
> +		int credits;
> +
> +		if (!is.s.not_found)
> +			entry =3D is.s.here;
> +		else if (!bs.s.not_found)
> +			entry =3D bs.s.here;
> +		if (entry && entry->e_value_inum &&
> +		    !(flags & XATTR_CREATE))
> +			old_ea_value_len =3D le32_to_cpu(entry->e_value_size);
> +
> +		struct buffer_head *bh =3D ext4_xattr_get_block(inode);
> +
> +		if (IS_ERR(bh)) {
> +			error =3D PTR_ERR(bh);
> +			goto cleanup;
> +		}
> +		credits =3D __ext4_xattr_set_credits(inode->i_sb, inode, bh,
> +						   value_len,
> +						   flags & XATTR_CREATE,
> +						   old_ea_value_len);
> +		brelse(bh);
> +		if (jbd2_handle_buffer_credits(handle) < credits) {
> +			error =3D -ENOSPC;
> +			goto cleanup;
> +		}
> +		WARN_ON_ONCE(!(current->flags & PF_MEMALLOC_NOFS));
> +	}

[Severity: Low]
When is.s.not_found is true, ext4_xattr_block_find() has already read and
validated EXT4_I(inode)->i_file_acl into bs.bh, so calling
ext4_xattr_get_block() again here (and below in ext4_xattr_set_credits())
repeats the buffer read and block validation while bs.bh is already held.
In addition, bh is declared after statements here, and
ext4_xattr_set_credits() unconditionally reads and searches the inode and
xattr block even when !ext4_has_feature_ea_inode(inode->i_sb) or is_create
is true.

[ ... ]

> @@ -2500,28 +2510,76 @@ ext4_xattr_set_handle(handle_t *handle, struct in=
ode *inode, int name_index,
>  	return error;
>  }
> =20
> -int ext4_xattr_set_credits(struct inode *inode, size_t value_len,
> +int ext4_xattr_set_credits(struct inode *inode, int name_index,
> +			   const char *name, size_t value_len,
>  			   bool is_create, int *credits)
>  {

[ ... ]

> +	{
> +		struct buffer_head *bh =3D ext4_xattr_get_block(inode);
> +
> +		if (IS_ERR(bh)) {
> +			err =3D PTR_ERR(bh);
> +			goto out;
> +		}
>  		*credits =3D __ext4_xattr_set_credits(inode->i_sb, inode, bh,
> -						    value_len, is_create);
> +						    value_len, is_create,
> +						    old_ea_value_len);
>  		brelse(bh);
> -		err =3D 0;
>  	}
> +	max_credits =3D jbd2_journal_get_max_transaction_buffers(journal);
> +	err =3D *credits > max_credits ? -ENOSPC : 0;

[Severity: Medium]
Can *credits still trigger the WARN_ON(1) in start_this_handle() when
*credits is equal to max_credits?

Every caller of ext4_xattr_set_credits() passes *credits to
ext4_journal_start(), which passes
ext4_trans_default_revoke_credits(inode->i_sb) as revoke_records to
jbd2__journal_start():

fs/jbd2/transaction.c:jbd2__journal_start() {
    ...
	nblocks +=3D DIV_ROUND_UP(revoke_records,
				journal->j_revoke_records_per_block);
	handle =3D new_handle(nblocks);
    ...
}

start_this_handle() then checks handle->h_total_credits (which includes at
least 1 revoke descriptor block) against
jbd2_max_user_trans_buffers(journal).  On the 1 KiB-block, 1 MiB-journal
filesystem from the test (max_credits =3D 334), replacing a 61-block
(62464-byte) ea_inode xattr with a 64-block (65296-byte) value yields
*credits =3D 334, passing this check and requesting 335 credits in
start_this_handle().

> diff --git a/tools/testing/selftests/filesystems/ext4/Makefile b/tools/te=
sting/selftests/filesystems/ext4/Makefile
> new file mode 100644
> index 0000000000000..b271567c0a46d
> --- /dev/null
> +++ b/tools/testing/selftests/filesystems/ext4/Makefile
> @@ -0,0 +1,6 @@
> +# SPDX-License-Identifier: GPL-2.0
> +
> +TEST_GEN_PROGS :=3D ext4_xattr_journal_credits
> +TEST_PROGS :=3D ext4_xattr_journal_credits.sh
> +
> +include ../../lib.mk

[Severity: Medium]
Won't listing ext4_xattr_journal_credits in TEST_GEN_PROGS cause make
run_tests to fail?

lib.mk executes every binary in TEST_GEN_PROGS directly as a standalone
test with no arguments, which hits the argc !=3D 2 check in
ext4_xattr_journal_credits.c and exits with status 2.  Helper binaries
invoked by TEST_PROGS scripts belong in TEST_GEN_PROGS_EXTENDED.

> diff --git a/tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_=
credits.c b/tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_cre=
dits.c
> new file mode 100644
> index 0000000000000..13f4f6673408b
> --- /dev/null
> +++ b/tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_credits=
.c
> @@ -0,0 +1,89 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#define _GNU_SOURCE
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <sys/xattr.h>
> +#include <unistd.h>
> +
> +#define LARGE_VALUE_SIZE 65296
> +
> +static int fail(const char *what)
> +{
> +	fprintf(stderr, "FAIL: %s: %s\n", what, strerror(errno));
> +	return 1;
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	char path[4096];
> +	char *value, *readback;
> +	int path_len;
> +	static const char large_name[] =3D "security.ima";
> +	static const char small_name[] =3D "user.ext4-credit-test";
> +	static const char small_value[] =3D "small-xattr";
> +	char small_readback[sizeof(small_value)];
> +
> +	if (argc !=3D 2) {
> +		fprintf(stderr, "Usage: %s MOUNTPOINT\n", argv[0]);
> +		return 2;
> +	}
> +	path_len =3D snprintf(path, sizeof(path), "%s/credit-test", argv[1]);
> +	if (path_len < 0 || (size_t)path_len >=3D sizeof(path)) {
> +		fprintf(stderr, "Mount path is too long\n");
> +		return 2;
> +	}
> +
> +	if (creat(path, 0600) < 0)
> +		return fail("create test file");
> +
> +	value =3D malloc(LARGE_VALUE_SIZE);
> +	readback =3D malloc(LARGE_VALUE_SIZE);
> +	if (!value || !readback)
> +		return fail("allocate xattr buffers");

[Severity: Low]
Could this test use the kselftest.h or kselftest_harness.h reporting
helpers instead of custom fprintf()/puts() and raw return codes?

Also, using "security.ima" for large_name fails when
CONFIG_EXT4_FS_SECURITY is disabled or when IMA/EVM validates the
attribute format (whereas a user.* attribute avoids both), creat() leaks
its returned file descriptor, and the error paths after malloc() do not
free value or readback.

> diff --git a/tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_=
credits.sh b/tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_cr=
edits.sh
> new file mode 100755
> index 0000000000000..837329fbd859b
> --- /dev/null
> +++ b/tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_credits=
.sh
> @@ -0,0 +1,41 @@

[ ... ]

> +truncate -s 32M "$test_dir/fs.img" || exit 1
> +mkfs.ext4 -q -F -b 1024 -O ea_inode -J size=3D1 "$test_dir/fs.img" || ex=
it 1
> +mkdir "$test_dir/mnt" || exit 1
> +mount -t ext4 -o loop "$test_dir/fs.img" "$test_dir/mnt" || exit 1

[Severity: Low]
Should a mount failure here call skip instead of exiting with 1 so kernels
built without CONFIG_EXT4_FS or CONFIG_BLK_DEV_LOOP skip the test rather
than failing?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122075355.8177=
2-1-arzuagapozosergio@gmail.com?part=3D1
