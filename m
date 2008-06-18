From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH]e2fsprogs: Fix broken "make check"
Date: Wed, 18 Jun 2008 16:12:01 -0500
Message-ID: <48597A21.7070606@redhat.com>
References: <20080613140401.208b6f86@rx8>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:54714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681AbYFRVSJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Jun 2008 17:18:09 -0400
In-Reply-To: <20080613140401.208b6f86@rx8>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jose R. Santos wrote:
> Commit: 51d12cebb61ca00f5455fe6e25938cd79fea15ab in pu fails to build
> "make check".

ACK :)

I put this into the fedora build, thanks.

-Eric

> Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
> ---
> 
>  e2fsck/Makefile.in |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/e2fsck/Makefile.in b/e2fsck/Makefile.in
> index 32743bc..0186112 100644
> --- a/e2fsck/Makefile.in
> +++ b/e2fsck/Makefile.in
> @@ -143,12 +143,12 @@ tst_crc32: $(srcdir)/crc32.c $(LIBEXT2FS)
>  tst_refcount: ea_refcount.c
>  	@echo "	LD $@"
>  	@$(CC) -o tst_refcount $(srcdir)/ea_refcount.c \
> -		$(ALL_CFLAGS) -DTEST_PROGRAM -lcom_err
> +		$(ALL_CFLAGS) -DTEST_PROGRAM -L$(LIB) -lcom_err
>  
>  tst_region: region.c
>  	@echo "	LD $@"
>  	@$(CC) -o tst_region $(srcdir)/region.c \
> -		$(ALL_CFLAGS) -DTEST_PROGRAM -lcom_err
> +		$(ALL_CFLAGS) -DTEST_PROGRAM -L$(LIB) -lcom_err
>  
>  check:: tst_refcount tst_region tst_crc32
>  	./tst_refcount
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

