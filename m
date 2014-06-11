From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] blkid: remove unnecessary header and comment
Date: Wed, 11 Jun 2014 13:00:24 -0600
Message-ID: <A80DE6BB-0E01-4CF2-A613-6C2F1A86596A@dilger.ca>
References: <1402512044-29544-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: multipart/signed; boundary="Apple-Mail=_2DFBA7B1-1E37-4511-914D-7FF58D5C0CA3"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:54707 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbaFKTAR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jun 2014 15:00:17 -0400
Received: by mail-pa0-f54.google.com with SMTP id et14so95175pad.13
        for <linux-ext4@vger.kernel.org>; Wed, 11 Jun 2014 12:00:16 -0700 (PDT)
In-Reply-To: <1402512044-29544-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_2DFBA7B1-1E37-4511-914D-7FF58D5C0CA3
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

I noticed there is more that could be cleaned up if we don't need
to check for the <sys/queue.h> header at all.  New patch follows.

Cheers, Andreas

On Jun 11, 2014, at 12:40 PM, Andreas Dilger <adilger@dilger.ca> wrote:

> The LIST_HEAD macro is not directly used in getsize.c, so
> <sys/queue.h> is not needed at all, and could cause confusion at
> some later point if the Linux-style list macros are ever used.
> 
> Build was verified on MacOS which defined HAVE_SYS_DISK_H true.
> I manually inspected the sources for recent *BSD headers to check
> if this was needed there or not.  MacOS and FreeBSD <sys/disk.h>
> do not use lists at all.  NetBSD and OpenBSD <sys/disk.h> include
> <sys/queue.h> internally.
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>
> ---
> lib/blkid/getsize.c  | 4 ----
> lib/ext2fs/getsize.c | 3 ---
> 2 files changed, 7 deletions(-)
> 
> diff --git a/lib/blkid/getsize.c b/lib/blkid/getsize.c
> index c2a8f72..a5c40aa 100644
> --- a/lib/blkid/getsize.c
> +++ b/lib/blkid/getsize.c
> @@ -12,7 +12,6 @@
> #define _LARGEFILE_SOURCE
> #define _LARGEFILE64_SOURCE
> 
> -/* include this before sys/queues.h! */
> #include "config.h"
> #include "blkidP.h"
> 
> @@ -34,9 +33,6 @@
> #include <sys/disklabel.h>
> #endif
> #ifdef HAVE_SYS_DISK_H
> -#ifdef HAVE_SYS_QUEUE_H
> -#include <sys/queue.h> /* for LIST_HEAD */
> -#endif
> #include <sys/disk.h>
> #endif
> #ifdef __linux__
> diff --git a/lib/ext2fs/getsize.c b/lib/ext2fs/getsize.c
> index a9a4812..a227155 100644
> --- a/lib/ext2fs/getsize.c
> +++ b/lib/ext2fs/getsize.c
> @@ -34,9 +34,6 @@
> #include <sys/disklabel.h>
> #endif
> #ifdef HAVE_SYS_DISK_H
> -#ifdef HAVE_SYS_QUEUE_H
> -#include <sys/queue.h> /* for LIST_HEAD */
> -#endif
> #include <sys/disk.h>
> #endif
> #ifdef __linux__
> -- 
> 1.8.0
> 


Cheers, Andreas






--Apple-Mail=_2DFBA7B1-1E37-4511-914D-7FF58D5C0CA3
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBU5inSHKl2rkXzB/gAQLiMw/+PdC9yfmvWFMsw6COVgLWLrKezT6wv44Z
SWpAO4NbWtyo+BQLAjrgw6adIPJQTLTapVH7u42EkZk+E8AFDotytV0aHtQwUwx7
zYQkrIL3S/G3kLnVbCXbPLTtRMifRNR9mZAfWDpLCQEvu8LL13nq36R48cezRPZC
DlmXRKH91JsikrAmw/kv28I4hYNRJ2lFrLIIHbAACQO8Lc7TXUR3NbA63K0o+Q7K
enAmyBjpNCVEFmwKkcKfyBgWjGqDNAp/BCsBCR+xm8KcjTEfztyOZoSt0jDR4idW
paXeFypuwHKTOGzMVE3cxuO5CuIQhyrKayMS3ThAjX44Fw4p2dNQVwtEhHYt2jO1
+sslhxXGR1iKfA+brjihjZbZeME8UECqCgVZV3evMcSdRhKouG9hXRjIdkvgr4hB
XXqfLyNFyxACaqQkKFAlEsszLsuRCeaWSUX7KdKGSLyBiHs4/qt1WujDRsr+wM6t
zkd6614/Gqp5EDCE2DVDUGQkbxuyEkt40OTz6KvNF/SppPH9qe9AglmRO777kNzH
rGnPp+6CS0R1x4uH71rt8Nwi/sBblWVgFmERfsiq5USVrIuiakzyQzP9cDiS5tUC
jBXXRSjiDgfxpfOWltZXGzMiE76FodPLdQjBOKphjKtCSuM50cdzjUazfRU3f18t
HoNfcmBAb0g=
=Ss6i
-----END PGP SIGNATURE-----

--Apple-Mail=_2DFBA7B1-1E37-4511-914D-7FF58D5C0CA3--
