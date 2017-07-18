From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/2] e2p: Fix segfault in e2p_os2string.
Date: Tue, 18 Jul 2017 14:04:52 -0600
Message-ID: <0C49EE02-6D84-4CD8-A0A7-C0224AF9916F@dilger.ca>
References: <20170718192919.32406-1-abuchbinder@google.com>
 <20170718192919.32406-3-abuchbinder@google.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_DA3F1874-3D72-4122-862B-E6E943C2B345";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4@vger.kernel.org
To: Adam Buchbinder <abuchbinder@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:33495 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751839AbdGRUE5 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 18 Jul 2017 16:04:57 -0400
Received: by mail-io0-f196.google.com with SMTP id n64so320185ioo.0
        for <linux-ext4@vger.kernel.org>; Tue, 18 Jul 2017 13:04:57 -0700 (PDT)
In-Reply-To: <20170718192919.32406-3-abuchbinder@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_DA3F1874-3D72-4122-862B-E6E943C2B345
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Jul 18, 2017, at 1:29 PM, Adam Buchbinder <abuchbinder@google.com> wrote:
> 
> Passing in a negative integer would lead to a segfault, and
> a crafted filesystem image could trigger that.
> 
> Signed-off-by: Adam Buchbinder <abuchbinder@google.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

Note that it would be better to land this patch as 1/2, and the test which
causes the segfault as 2/2, otherwise it could break git bisect.

Cheers, Andreas
> ---
> lib/e2p/ostype.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/e2p/ostype.c b/lib/e2p/ostype.c
> index 7f088446..c5fd8ab3 100644
> --- a/lib/e2p/ostype.c
> +++ b/lib/e2p/ostype.c
> @@ -30,7 +30,7 @@ char *e2p_os2string(int os_type)
>         const char	*os;
> 	char 		*ret;
> 
> -	if (os_type <= EXT2_OS_LITES)
> +	if (os_type >= 0 && os_type <= EXT2_OS_LITES)
> 		os = os_tab[os_type];
> 	else
> 		os = "(unknown os)";




Cheers, Andreas






--Apple-Mail=_DA3F1874-3D72-4122-862B-E6E943C2B345
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZbmnkpIg59Q01vtYRAqNcAKCjaCwN3okscrN0q4NVLvbuoh3BaACfS+08
PS8Fi77H0JM5X8yxewbppgo=
=oOtc
-----END PGP SIGNATURE-----

--Apple-Mail=_DA3F1874-3D72-4122-862B-E6E943C2B345--
