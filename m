From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: avoid leak upon failed realloc
Date: Mon, 18 Jun 2007 09:04:16 -0500
Message-ID: <1182175456.13184.7.camel@kleikamp.austin.ibm.com>
References: <87ejkbbycq.fsf@rho.meyering.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Jim Meyering <jim@meyering.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:43166 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762522AbXFROES (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Jun 2007 10:04:18 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5IE4IUC028166
	for <linux-ext4@vger.kernel.org>; Mon, 18 Jun 2007 10:04:18 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5IE4HpE471646
	for <linux-ext4@vger.kernel.org>; Mon, 18 Jun 2007 10:04:17 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5IE4HF5021332
	for <linux-ext4@vger.kernel.org>; Mon, 18 Jun 2007 10:04:17 -0400
In-Reply-To: <87ejkbbycq.fsf@rho.meyering.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, 2007-06-16 at 19:31 +0200, Jim Meyering wrote:
> Here's a tiny fix to avoid a leak when realloc fails:
> 
> 2007-06-16  Jim Meyering  <jim@meyering.net>
> 
> 	* tdb.c (tdb_append): Don't leak a buffer when realloc fails.
> 
> diff -r 777972a573b3 lib/ext2fs/tdb.c
> --- a/lib/ext2fs/tdb.c	Fri Jun 15 18:05:09 2007 +0200
> +++ b/lib/ext2fs/tdb.c	Sat Jun 16 19:28:50 2007 +0200
> @@ -3460,8 +3460,15 @@ int tdb_append(struct tdb_context *tdb,
>  	if (dbuf.dptr == NULL) {
>  		dbuf.dptr = (unsigned char *)malloc(new_dbuf.dsize);
>  	} else {
> -		dbuf.dptr = (unsigned char *)realloc(dbuf.dptr,
> -						     dbuf.dsize + new_dbuf.dsize);
> +		unsigned char *new_dptr
> +		  = (unsigned char *)realloc(dbuf.dptr,
> +					     dbuf.dsize + new_dbuf.dsize);
> +		if (new_dptr == NULL) {
> +			free(dbuf.dptr);
> +			dbuf.dptr = NULL;
> +		} else {
> +			dbuf.dptr = new_dptr;
> +		}

Not a big deal, but this part could be simplified to:

		if (new_dptr == NULL)
			free(dbuf.dptr);
		dbuf.dptr = new_dptr;

>  	}
> 
>  	if (dbuf.dptr == NULL) {
> 
> Signed-off-by: Jim Meyering <jim@meyering.net>
-- 
David Kleikamp
IBM Linux Technology Center
