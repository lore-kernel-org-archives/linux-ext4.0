From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] mke2fs: don't accept too-high revision levels
Date: Thu, 14 Jan 2016 12:36:11 -0700
Message-ID: <AF0456DC-B670-4840-A5A4-82222C8ED53A@dilger.ca>
References: <5362A6A2.7040504@redhat.com> <5697EA79.40902@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: multipart/signed; boundary="Apple-Mail=_F3E59E56-66CC-4EA5-965D-7785B3244433"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:33279 "EHLO
	mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850AbcANTgR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Jan 2016 14:36:17 -0500
Received: by mail-pf0-f174.google.com with SMTP id e65so104813588pfe.0
        for <linux-ext4@vger.kernel.org>; Thu, 14 Jan 2016 11:36:17 -0800 (PST)
In-Reply-To: <5697EA79.40902@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_F3E59E56-66CC-4EA5-965D-7785B3244433
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=windows-1252


> On Jan 14, 2016, at 11:35 AM, Eric Sandeen <sandeen@redhat.com> wrote:
> 
> Came across this, still not merged, so ping?
> 
> On 5/1/14 2:55 PM, Eric Sandeen wrote:
>> It's a bit strange to accept revision levels higher than
>> the code creating the filesystem can understand, so don't
>> allow it.
>> 
>> At least the kernel will mount the fs readonly if it's too
>> high, but no other utility will touch it, so you can't
>> fix the error.
>> 
>> Just reject anything > EXT2_MAX_SUPP_REV at mkfs time.
>> 
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

>> ---
>> 
>> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
>> index aecd5d5..82019dc 100644
>> --- a/misc/mke2fs.c
>> +++ b/misc/mke2fs.c
>> @@ -1679,9 +1679,10 @@ profile_error:
>> 			break;
>> 		case 'r':
>> 			r_opt = strtoul(optarg, &tmp, 0);
>> -			if (*tmp) {
>> +			if (*tmp || (r_opt > EXT2_MAX_SUPP_REV)) {
>> 				com_err(program_name, 0,
>> -					_("bad revision level - %s"), optarg);
>> +					_("bad revision level - %s (max %d)"),
>> +					   optarg, EXT2_MAX_SUPP_REV);
>> 				exit(1);
>> 			}
>> 			fs_param.s_rev_level = r_opt;
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_F3E59E56-66CC-4EA5-965D-7785B3244433
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVpf4rHKl2rkXzB/gAQjduA//c7UgKMbqtFZaMU6xH8dL1LxvSA0eRk2n
/fCrxCKHf7qS8+aIMxC0IW2tYGCefUQhbh5ty5x7iYZP/b/iYDIzbzQxe3ZPfnx1
V52AFkHuBrvvFpSvn8qn+I2Moj+SD0M4F7ifghfVh/vXWdrR7k3ilX6fHkz8nQAa
pRUwgcVySCY+3BcR1dsz2ryIWs0z+loSR+Zn3YDKpMNyuAhPI9FSaa5536SY++5k
mbFa2ZmcD/IYg2W3o12XBhoNcP1h7p0ABGhoo/Utw4OtAZdh2RjiSPiOFrsdTFYc
lDQTu40G2WdvD8kSPFC8rFlRA1MuFK2bOMRCrrD4MHM8iOZOAzNkrh7t19K28pkh
elKGYOkUhXKUykWQD4tJ1Yx6QPgyKjqtqIAQBhPypsnm4hd3xz0m8qZXYuTb4qLf
9ylDW5Dq8dz8HjGwMWaI05P7W8kiGv17fVdpIB/Nx2qrIcWH7MSzfnBGpAxBXGkw
/7zuibw92McasowWigqr5dNFLUWeiRjiBzkvCNosOSq/wDRscYcyzcpEN56Cop+b
isg2Y7qLbn6J7DaIWZA/iS3mxtrFbw6wyC1F3PyTzlq7Kk55wE0859KAeL6GbVuv
6BLJXlP9/JMrhkPHN/8ZoExRA/ycr7mamlcQCGhrnnS4zh+QR3ZY6EwWi2arKBJc
NGMJtzhf9QM=
=k1+Y
-----END PGP SIGNATURE-----

--Apple-Mail=_F3E59E56-66CC-4EA5-965D-7785B3244433--
