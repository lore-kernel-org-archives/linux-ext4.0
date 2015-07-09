From: Laurent Navet <laurent.navet@gmail.com>
Subject: Re: [PATCH] ext4 crypto: remove unneeded assignation
Date: Thu, 9 Jul 2015 21:04:55 +0200
Message-ID: <CAH7P7Ni7=-kgyPtjnXQdyZ5VcYcUQxpU+OPCADXJrz3eRt2u+g@mail.gmail.com>
References: <1436385075-22559-1-git-send-email-laurent.navet@gmail.com>
	<20150708200108.GC10037@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150708200108.GC10037@birch.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Make sense,
I send a v2, thank's

2015-07-08 22:01 UTC+02:00, Darrick J. Wong <darrick.wong@oracle.com>:
> On Wed, Jul 08, 2015 at 09:51:15PM +0200, Laurent Navet wrote:
>> Return value of ext4_derive_key_aes() is stored but never used befor=
e
>> being overwritten.
>> Also fix coverity CID 1309760.
>>
>> Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
>> ---
>>  fs/ext4/crypto_key.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/ext4/crypto_key.c b/fs/ext4/crypto_key.c
>> index 442d24e..92f9172 100644
>> --- a/fs/ext4/crypto_key.c
>> +++ b/fs/ext4/crypto_key.c
>> @@ -218,7 +218,7 @@ retry:
>>  	BUILD_BUG_ON(EXT4_AES_128_ECB_KEY_SIZE !=3D
>>  		     EXT4_KEY_DERIVATION_NONCE_SIZE);
>>  	BUG_ON(master_key->size !=3D EXT4_AES_256_XTS_KEY_SIZE);
>> -	res =3D ext4_derive_key_aes(ctx.nonce, master_key->raw,
>> +	ext4_derive_key_aes(ctx.nonce, master_key->raw,
>>  				  raw_key);
>
> I don't think it's a good idea to drop the error code on the floor an=
d keep
> going as if nothing bad had happened.
>
> --D
>
>>  got_key:
>>  	ctfm =3D crypto_alloc_ablkcipher(cipher_str, 0, 0);
>> --
>> 2.1.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


--=20
=C2=AB On ne r=C3=A9sout pas un probl=C3=A8me avec les modes de pens=C3=
=A9e qui l=E2=80=99ont engendr=C3=A9. =C2=BB
=C2=AB You cannot solve current problems with current thinking. Current
problems are the result of current thinking =C2=BB
