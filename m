From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: improve smp scalability for inode generation
Date: Fri, 10 Nov 2017 15:55:06 -0700
Message-ID: <6322DD2C-F546-47A9-8511-33527B75FF0F@dilger.ca>
References: <8760bcpdc8.fsf@openvz.org>
 <00F078D1-39E9-4F16-8B5B-6952645846E5@dilger.ca>
 <20171109032320.dnuhngfcvldliysz@thunk.org>
 <9ED44C7F-4946-434F-9889-A7F2BA123A5F@dilger.ca>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_386255B0-A30E-4E52-ABA5-A547F260AA6A";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:50547 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753825AbdKJWzK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Nov 2017 17:55:10 -0500
Received: by mail-io0-f193.google.com with SMTP id 97so15131328iok.7
        for <linux-ext4@vger.kernel.org>; Fri, 10 Nov 2017 14:55:10 -0800 (PST)
In-Reply-To: <9ED44C7F-4946-434F-9889-A7F2BA123A5F@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_386255B0-A30E-4E52-ABA5-A547F260AA6A
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On Nov 10, 2017, at 3:39 PM, Andreas Dilger <adilger@dilger.ca> wrote:
>=20
> On Nov 8, 2017, at 8:23 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>> commit f0e922e7235e1b5ba6fd964e2cf8dafed3248a15
>> Author: Theodore Ts'o <tytso@mit.edu>
>> Date:   Wed Nov 8 22:21:58 2017 -0500
>>=20
>>   ext4: improve smp scalability for inode generation
>>=20
>>   ->s_next_generation is protected by s_next_gen_lock but its usage
>>   pattern is very primitive.  We don't actually need sequentailly
>>   increasing new generation numbers, so let's use prandom_u32() =
instead.
>=20
> We discussed this on the ext4 concall this week, but came to the =
conclusion
> that a 32-bit random number has an unacceptably high chance of =
collision
> (about 1/2^16 allocations) due to the birthday paradox.
>=20
> Instead, an approach like the following should be OK:
> 1. num_gen_per_cpu =3D 2^32/num_online_cpus()
> 2. initialize CPU0 generation =3D prandom_u32()
> 3. initialize CPUn generation =3D CPU0 + n * num_gen_per_cpu
> 4. use sequential generation numbers for each local CPU
> 5. after num_gen_per_cpu generations per CPU hit on any CPU, goto 2.

Actually, never mind.  I wrote a test program to verify this, and this
pointed out the flaw in my argument, namely that the birthday paradox
only matters if each random number is compared against all other random
numbers in the pool.

In this case, we only care whether i_generation.old =3D=3D =
i_generation.new
for each individual inode, and not whether i_generation.new is the same
as _any_ old generation.

That means there is a 1/2^32 chance of collisions for each allocated
inode, rather than 1/2^16.  With only prandom_u32() there is always
a 1/2^32 chance that creating and deleting the same inode in a loop
will result in two identical sequential generation numbers.

There was also a chance of collisions with the old code, though it
wouldn't happen for a long time when the workload was reusing the
same set of inodes repeatedly (e.g. create and delete in a single
directory).  Instead, it would be more likely to hit for old inodes
that were recently deleted and re-allocated, or after a reboot.

This (mostly|only) affects NFS exports, so I'm not sure how likely
it is to happen in real life.

Cheers, Andreas

>>=20
>>   Reported-by: Dmitry Monakhov <dmonakhov@openvz.org>
>>   Signed-off-by: Theodore Ts'o <tytso@mit.edu>
>>=20
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index 53ce95b52fd8..5e6d7b6f50c7 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -1355,8 +1355,6 @@ struct ext4_sb_info {
>> 	int s_first_ino;
>> 	unsigned int s_inode_readahead_blks;
>> 	unsigned int s_inode_goal;
>> -	spinlock_t s_next_gen_lock;
>> -	u32 s_next_generation;
>> 	u32 s_hash_seed[4];
>> 	int s_def_hash_version;
>> 	int s_hash_unsigned;	/* 3 if hash should be signed, 0 if not =
*/
>> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
>> index ee823022aa34..da79eb5dba40 100644
>> --- a/fs/ext4/ialloc.c
>> +++ b/fs/ext4/ialloc.c
>> @@ -1138,9 +1138,7 @@ struct inode *__ext4_new_inode(handle_t =
*handle, struct inode *dir,
>> 			   inode->i_ino);
>> 		goto out;
>> 	}
>> -	spin_lock(&sbi->s_next_gen_lock);
>> -	inode->i_generation =3D sbi->s_next_generation++;
>> -	spin_unlock(&sbi->s_next_gen_lock);
>> +	inode->i_generation =3D prandom_u32();
>>=20
>> 	/* Precompute checksum seed for inode metadata */
>> 	if (ext4_has_metadata_csum(sb)) {
>> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
>> index 144bbda2b808..98ad8172dfd3 100644
>> --- a/fs/ext4/ioctl.c
>> +++ b/fs/ext4/ioctl.c
>> @@ -17,6 +17,7 @@
>> #include <linux/uuid.h>
>> #include <linux/uaccess.h>
>> #include <linux/delay.h>
>> +#include <linux/random.h>
>> #include "ext4_jbd2.h"
>> #include "ext4.h"
>> #include <linux/fsmap.h>
>> @@ -157,10 +158,8 @@ static long swap_inode_boot_loader(struct =
super_block *sb,
>>=20
>> 	inode->i_ctime =3D inode_bl->i_ctime =3D current_time(inode);
>>=20
>> -	spin_lock(&sbi->s_next_gen_lock);
>> -	inode->i_generation =3D sbi->s_next_generation++;
>> -	inode_bl->i_generation =3D sbi->s_next_generation++;
>> -	spin_unlock(&sbi->s_next_gen_lock);
>> +	inode->i_generation =3D prandom_u32();
>> +	inode_bl->i_generation =3D prandom_u32();
>>=20
>> 	ext4_discard_preallocations(inode);
>>=20
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index 3a278faf5868..9f2e3eb5131f 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -3982,8 +3982,6 @@ static int ext4_fill_super(struct super_block =
*sb, void *data, int silent)
>> 	}
>>=20
>> 	sbi->s_gdb_count =3D db_count;
>> -	get_random_bytes(&sbi->s_next_generation, sizeof(u32));
>> -	spin_lock_init(&sbi->s_next_gen_lock);
>>=20
>> 	timer_setup(&sbi->s_err_report, print_daily_error_info, 0);
>>=20
>=20
>=20
> Cheers, Andreas


Cheers, Andreas






--Apple-Mail=_386255B0-A30E-4E52-ABA5-A547F260AA6A
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFaBi5KpIg59Q01vtYRAtkgAJ94U1uGLGikl5acrAJbf2dU/FjW6wCg0War
ZZt/qqO+00Y+VfmLCDnVng0=
=Jpk6
-----END PGP SIGNATURE-----

--Apple-Mail=_386255B0-A30E-4E52-ABA5-A547F260AA6A--
