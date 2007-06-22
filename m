From: Theodore Tso <tytso@mit.edu>
Subject: Re: avoid leak upon failed realloc
Date: Fri, 22 Jun 2007 02:41:44 -0400
Message-ID: <20070622064144.GC17097@thunk.org>
References: <87ejkbbycq.fsf@rho.meyering.net> <1182175456.13184.7.camel@kleikamp.austin.ibm.com> <87wsy15p5n.fsf@rho.meyering.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="wac7ysb48OaltWcw"
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org, samba-technical@lists.samba.org
To: Jim Meyering <jim@meyering.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:45578 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803AbXFVGmB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Jun 2007 02:42:01 -0400
Content-Disposition: inline
In-Reply-To: <87wsy15p5n.fsf@rho.meyering.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 18, 2007 at 04:10:44PM +0200, Jim Meyering wrote:
> Here's a tiny fix to avoid a leak when realloc fails:
> 
> 2007-06-16  Jim Meyering  <jim@meyering.net>
> 
> 	* tdb.c (tdb_append): Don't leak a buffer when realloc fails.

Hi Jim,

	Thanks for the patch!  I actually automatically build the
tdb.c file from the Samba SVN tree (with a series of patches and
scripts) at: 

	svn://svnanon.samba.org/samba/branches/SAMBA_4_0/source/lib/tdb

So I'm going to forward this patch (attached) to the Samba developers.
It appears to apply cleanly to .../source/lib/tdb/common/tdb.c.  Once
they commit it into their SVN tree, I can just pick it up from there.

Regards,

						- Ted


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=tdb-patch

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
-
To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

--wac7ysb48OaltWcw--
