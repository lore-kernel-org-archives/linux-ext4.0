From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC PATCH v2 2/2] ext4: Add 64-bit inode number support
Date: Tue, 7 Nov 2017 22:51:46 -0700
Message-ID: <59B9FB5B-EB59-464A-9D97-A539A77A6473@dilger.ca>
References: <20171101212455.47964-1-artem.blagodarenko@gmail.com>
 <20171101212455.47964-3-artem.blagodarenko@gmail.com>
 <20171107190439.GB6233@magnolia>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_982D6D55-5583-49C7-BEFF-ABEB4FE8AFD5";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Artem Blagodarenko <artem.blagodarenko@gmail.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:55476 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750922AbdKHFvw (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Nov 2017 00:51:52 -0500
Received: by mail-io0-f193.google.com with SMTP id p186so4692380ioe.12
        for <linux-ext4@vger.kernel.org>; Tue, 07 Nov 2017 21:51:52 -0800 (PST)
In-Reply-To: <20171107190439.GB6233@magnolia>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_982D6D55-5583-49C7-BEFF-ABEB4FE8AFD5
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 7, 2017, at 12:04 PM, Darrick J. Wong <darrick.wong@oracle.com> =
wrote:
>=20
> On Thu, Nov 02, 2017 at 12:24:55AM +0300, Artem Blagodarenko wrote:
>>=20
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index ead9406d9cff..a06252f9aada 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -3489,6 +3489,12 @@ static int ext4_fill_super(struct super_block =
*sb, void *data, int silent)
>> 		goto cantfind_ext4;
>> 	}
>>=20
>> +	if (ext4_has_feature_inode64(sb) &&
>> +	    (sizeof(u64) !=3D sizeof(unsigned long))) {
>> +		ext4_msg(sb, KERN_ERR, "64 bit inodes need 64 bit =
kernel.");
>=20
> Is there an architectural reason in ext4 for not supporting 64-bit
> inodes on 32-bit kernels, or is this simply a statement that we don't
> intend to support that configuration?  Particularly since 32-bit
> userspace never got updated to know about 64-bit inode numbers.

The main reason (AFAIK) is that struct inode has "unsigned long i_ino",
so there is no convenient place to store the 64-bit inode number, and
the 32-bit interfaces will all be unable to stat the inodes.  Since this
also requires a _minimum_ of 4B * (512 + 4096) =3D 18TB just to store =
the
inodes and one 4KB block per file, this already exceeds the block device
size limit for 32-bit kernels...

> Also, I don't know if this has already been talked about, but have you
> checked all the places where we export file handles to make sure that =
we
> refuse to give out a handle if the handle isn't big enough to fit a
> large inode?  (I think that only affects pre-2000 nfs setups?  XFS has
> some weird warts to handle those safely, but perhaps in 2017 we don't
> have to care.)

I seem to recall a thread about "we don't care about old NFSv2 file
handles at this point" not so long ago.  Maybe I misremember?

Cheers, Andreas

>> +		goto failed_mount;
>> +	}
>> +
>> 	/* Load the checksum driver */
>> 	if (ext4_has_feature_metadata_csum(sb) ||
>> 	    ext4_has_feature_ea_inode(sb)) {
>> @@ -4248,7 +4254,7 @@ static int ext4_fill_super(struct super_block =
*sb, void *data, int silent)
>> 				  GFP_KERNEL);
>> 	if (!err) {
>> 		unsigned long freei =3D ext4_count_free_inodes(sb);
>> -		sbi->s_es->s_free_inodes_count =3D cpu_to_le32(freei);
>> +		ext4_set_free_inodes_count(sb, freei);
>> 		err =3D percpu_counter_init(&sbi->s_freeinodes_counter, =
freei,
>> 					  GFP_KERNEL);
>> 	}
>> @@ -4705,9 +4711,9 @@ static int ext4_commit_super(struct super_block =
*sb, int sync)
>> 			EXT4_C2B(EXT4_SB(sb), =
percpu_counter_sum_positive(
>> 				&EXT4_SB(sb)->s_freeclusters_counter)));
>> 	if =
(percpu_counter_initialized(&EXT4_SB(sb)->s_freeinodes_counter))
>> -		es->s_free_inodes_count =3D
>> -			cpu_to_le32(percpu_counter_sum_positive(
>> -				&EXT4_SB(sb)->s_freeinodes_counter));
>> +		ext4_set_free_inodes_count(sb,
>> +				cpu_to_le32(percpu_counter_sum_positive(
>> +				&EXT4_SB(sb)->s_freeinodes_counter)));
>> 	BUFFER_TRACE(sbh, "marking dirty");
>> 	ext4_superblock_csum_set(sb);
>> 	if (sync)
>> --
>> 2.13.5 (Apple Git-94)


Cheers, Andreas






--Apple-Mail=_982D6D55-5583-49C7-BEFF-ABEB4FE8AFD5
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFaAptypIg59Q01vtYRAivhAKCZA6pO9dXHKVmEMbp6aQgFDvr5NgCgtCwF
tycZivOVgiqIrHcoff6ech0=
=gCgD
-----END PGP SIGNATURE-----

--Apple-Mail=_982D6D55-5583-49C7-BEFF-ABEB4FE8AFD5--
