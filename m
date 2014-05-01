From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH V2] mke2fs: prevent creation of filesystem with unsupported revision
Date: Thu, 1 May 2014 16:20:40 -0600
Message-ID: <4C8AA9B5-1F12-4016-9EFB-1960A565DD09@dilger.ca>
References: <5362A6A2.7040504@redhat.com> <5362B105.9080702@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: multipart/signed; boundary="Apple-Mail=_61AA2EEA-8D29-4355-BC52-7219D1F5EE0B"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Frank Sorenson <fsorenso@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:42586 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbaEAWVX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 May 2014 18:21:23 -0400
Received: by mail-pd0-f170.google.com with SMTP id x10so3798683pdj.15
        for <linux-ext4@vger.kernel.org>; Thu, 01 May 2014 15:21:22 -0700 (PDT)
In-Reply-To: <5362B105.9080702@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_61AA2EEA-8D29-4355-BC52-7219D1F5EE0B
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=iso-8859-1

On May 1, 2014, at 2:39 PM, Eric Sandeen <sandeen@redhat.com> wrote:

> From: Frank Sorenson <fsorenso@redhat.com>
> 
> Don't create a filesystem with an unsupported revision number

I like the commit comment on the original patch better...

Cheers, Andreas

> Signed-off-by: Frank Sorenson <fsorenso@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> V2: Frank did this independently, and it's better.  I forgot about
> using com_err here.
> 
> --- a/misc/mke2fs.c	
> +++ a/misc/mke2fs.c	
> @@ -1684,6 +1684,11 @@ profile_error:
> 					_("bad revision level - %s"), optarg);
> 				exit(1);
> 			}
> +			if (r_opt > EXT2_MAX_SUPP_REV) {
> +				com_err(program_name, EXT2_ET_REV_TOO_HIGH,
> +					_("while trying to create revision %d"), r_opt);
> +				exit(1);
> +			}
> 			fs_param.s_rev_level = r_opt;
> 			break;
> 		case 's':	/* deprecated */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_61AA2EEA-8D29-4355-BC52-7219D1F5EE0B
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBU2LIuXKl2rkXzB/gAQK4Jw/8Dfsjc655DZoYWjZYN+P2yxk/LGJG5YNN
YVvCG6IugHv9mo4U+ogz2KsYw9luSKRWU9Sz59MeQ4q6NU3wrNwPkAupbogDso7C
aC9XGpGjJoeBGFXe6pf7prlw2iCOC8bUOmNU3P4b90LUkiLW111FVmBzSsuQLjcu
kyWfmHtzdf0LDLo1Aic4M3qGHE+pxeMGxBJnGgmBbuYuXCvdLllG4XMUokh/EjG7
UvChBNcBbHX12ffDbXdtahucCLbDX/Bl/mIQIdTxfYzttIH2sMlY7OJihuhXrJ2w
2OFH/SkMqzbsAmALph7Ur261R9xDPBVzt7PfhmGSfVRhhrr0/LGDWbBnee6KumZ3
y5HXvX++7U9LRKf/tK8meChP8DdWU8Ok/9VZLy1wlVcAIEC7PUnQ/gBfi67vGCDP
ZJeU5MSpgfvMOysrNbxbaosfuAiFG8Y229k7xJeZ0iCVrSjXR7Zaw+7Mq2+fKdzM
GKFWJLSWcO6f+/GfUUruuaDmHoZmHUSBCpnUUYapiOu01AAw4v1Do+phwCMvcwkZ
P+zHkTxoUlI+L6uXT7Oy4qC0ErH8aJUV7V+WiRkU1qzRU3GzbvGdZqCJFpJzOetS
PKlPaHRqQ4ZgSKaeYwo9EDp2tYBaC7nGJpgIZEs5MpHDtIL6E0FW2h6NfODQ+0fK
EK6+MKC9rZ0=
=yd1/
-----END PGP SIGNATURE-----

--Apple-Mail=_61AA2EEA-8D29-4355-BC52-7219D1F5EE0B--
