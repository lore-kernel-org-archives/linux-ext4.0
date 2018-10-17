Return-Path: <SRS0=48F3=M5=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-io1-f65.google.com ([209.85.166.65]:42470 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727186AbeJRH1D (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Oct 2018 03:27:03 -0400
Received: by mail-io1-f65.google.com with SMTP id n18-v6so19879442ioa.9
        for <linux-ext4@vger.kernel.org>; Wed, 17 Oct 2018 16:29:00 -0700 (PDT)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <EA9B5AA4-DA21-4B1D-9E89-8C9F16EB8986@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_C878ED81-577A-481B-B30C-166BF18D6A8B";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH] ext4: direct return when jinode allocate failed
Date: Wed, 17 Oct 2018 17:28:55 -0600
In-Reply-To: <201810171026448096961@zte.com.cn>
Cc: "Theodore Y. Ts'o" <tytso@mit.edu>, fishland@aliyun.com,
        wang.yi59@zte.com.cn,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: liu.song11@zte.com.cn
References: <20181016145526.3288-1-fishland@aliyun.com,20181016190840.GF24131@thunk.org>
 <201810171026448096961@zte.com.cn>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_C878ED81-577A-481B-B30C-166BF18D6A8B
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On Oct 16, 2018, at 8:26 PM, liu.song11@zte.com.cn wrote:
>=20
>> On Tue, Oct 16, 2018 at 10:55:26PM +0800, fishland wrote:
>>> The jinode does not need protected by *i_lock*, we can return
>>> directly if memory allocation fails.
>>>=20
>>=20
>> I don't see anything wrong with this patch, but at the same time, I'm
>> not sure I see the benefit, either.  Checking for the allocation
>> failure is cheap, and moving it out spinlock doesn't buy much; not to
>> mention that the allocation failure is going to be highly uncommon.
>>=20
>> What inspired this commit?
>>=20
>> - Ted
>=20
> Hi, Ted
> I found this during code reading. All code logic is very smooth, when
> reading here, need to spin_unlock before "return -ENOMEM", which I
> feel this could more close to the allocate. I refer to other =
processing
> logic for this situation in "inode.c", found that they all return =
immediately
> after memory application failed. I agree with you that the benefit of =
this
> patch is almost none, however it can slightly improve the code in rare =
case.

Looking at the patch there are two effects that it has:
- optimize a very rare case where there is an allocation failure before =
locking
- return an unnecessary error if "ei->jinode" is allocated before =
locking

I don't think it is worthwhile to optimize this case, since allocation =
failures
will have a serious impact on the application, and I'd rather avoid the =
rare
case where we don't return an unnecessary error than make the error case =
faster.

Cheers, Andreas

>=20
>>> Signed-off-by: Liu Song <liu.song11@zte.com.cn>
>>> Reviewed-by: Wang Yi <wang.yi59@zte.com.cn>
>>> ---
>>> fs/ext4/inode.c | 7 +++----
>>> 1 file changed, 3 insertions(+), 4 deletions(-)
>>>=20
>>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>>> index d767e993591d..67ba6f062de5 100644
>>> --- a/fs/ext4/inode.c
>>> +++ b/fs/ext4/inode.c
>>> @@ -4384,12 +4384,11 @@ int ext4_inode_attach_jinode(struct inode =
*inode)
>>>         return 0;
>>>=20
>>>  	jinode =3D jbd2_alloc_inode(GFP_KERNEL);
>>> +	if (!jinode)
>>> +	return -ENOMEM;
>>> +
>>>  	spin_lock(&inode->i_lock);
>>>  	if (!ei->jinode) {
>>> -		if (!jinode) {
>>> -			spin_unlock(&inode->i_lock);
>>> -			return -ENOMEM;
>>> -		}
>>>  		ei->jinode =3D jinode;
>>>  		jbd2_journal_init_jbd_inode(ei->jinode, inode);
>>>  		jinode =3D NULL;
>>> --
>>> 2.17.1


Cheers, Andreas






--Apple-Mail=_C878ED81-577A-481B-B30C-166BF18D6A8B
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlvHxbgACgkQcqXauRfM
H+CCcA/+OMy3TvcdQXystp7YhvSJYGSfFRnvWBSczl3DvC5KzEbxk6owU8I1ZgLW
xy39xc/gZur31Qsqquj7R+SHJshQ06xOd2Uzv7YfjIuKdYCoQNx89xstOqyNRjER
u15kqBFHj5yadbHOslcr+qd1nslzZUg601c/ef6T0jxHcMjFD8lUBnQEktbTTOBx
1CiCNpp03/tQFElX8ZKOVsMs2toTdNWNEIC8PvWqfpgDaFeT4+Sr3z5NfZQ17u0Q
UGNlN3FrtKEch2nMBgz2z38TxdEVJrr/XAOZ3X6GEbvwVhgHNQHLQwRyz0RC9vQJ
bl/3D/8rnOSu2mHL7cUzbquCWFL2w58IW9XqraVFDUp7U4nS0Qg4SatT3mxKFVfI
clheMhNxylzVIMx9+BD/f40B+68zapPEMJSKzKzxpGCClzV7aJ+oi7u4V4RUkrcc
zaNR0X7C4h2flTX5MATfNX4sCoT4luaoAeytlsLfugCLCc5un4+ZnBUDO4DOsOUX
U8lZHJ5TWCWIVDg6YyX66uQA9g1YtqeT10c489ho83vbxt6FimXtEcEz43HVRit5
trI/Rzj8ZfaP5GS5puwOB6+qZmQer7YFhMamlp0Zd8T2hqabMHvq/cOlwglcArRw
+5uAgdA+SvGe1ykBDKfpGO+lBhA8YcA/BUV4l1nST6H+otysn58=
=hWNJ
-----END PGP SIGNATURE-----

--Apple-Mail=_C878ED81-577A-481B-B30C-166BF18D6A8B--
