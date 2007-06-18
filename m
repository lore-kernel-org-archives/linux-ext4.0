From: Jim Meyering <jim@meyering.net>
Subject: Re: avoid leak upon failed realloc
Date: Mon, 18 Jun 2007 16:10:44 +0200
Message-ID: <87wsy15p5n.fsf@rho.meyering.net>
References: <87ejkbbycq.fsf@rho.meyering.net>
	<1182175456.13184.7.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp3-g19.free.fr ([212.27.42.29]:58759 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213AbXFROKq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Jun 2007 10:10:46 -0400
Received: from mx.meyering.net (mx.meyering.net [82.230.74.64])
	by smtp3-g19.free.fr (Postfix) with ESMTP id C4D895A279
	for <linux-ext4@vger.kernel.org>; Mon, 18 Jun 2007 16:10:44 +0200 (CEST)
In-Reply-To: <1182175456.13184.7.camel@kleikamp.austin.ibm.com> (Dave Kleikamp's message of "Mon\, 18 Jun 2007 09\:04\:16 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Dave Kleikamp <shaggy@linux.vnet.ibm.com> wrote:
> Not a big deal, but this part could be simplified to:
>
> 		if (new_dptr == NULL)
> 			free(dbuf.dptr);
> 		dbuf.dptr = new_dptr;

Of course!
Thanks!

In case it helps, here's the updated patch:

Here's a tiny fix to avoid a leak when realloc fails:

2007-06-16  Jim Meyering  <jim@meyering.net>

	* tdb.c (tdb_append): Don't leak a buffer when realloc fails.

diff -r 777972a573b3 lib/ext2fs/tdb.c
--- a/lib/ext2fs/tdb.c	Fri Jun 15 18:05:09 2007 +0200
+++ b/lib/ext2fs/tdb.c	Mon Jun 18 16:08:24 2007 +0200
@@ -3460,8 +3460,12 @@ int tdb_append(struct tdb_context *tdb,
 	if (dbuf.dptr == NULL) {
 		dbuf.dptr = (unsigned char *)malloc(new_dbuf.dsize);
 	} else {
-		dbuf.dptr = (unsigned char *)realloc(dbuf.dptr,
-						     dbuf.dsize + new_dbuf.dsize);
+		unsigned char *new_dptr
+		  = (unsigned char *)realloc(dbuf.dptr,
+					     dbuf.dsize + new_dbuf.dsize);
+		if (new_dptr == NULL)
+			free(dbuf.dptr);
+		dbuf.dptr = new_dptr;
 	}
 
 	if (dbuf.dptr == NULL) {

Signed-off-by: Jim Meyering <jim@meyering.net>
