From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: script to find incorrect tests on unsigneds
Date: Sat, 19 Apr 2008 08:49:52 -0600
Message-ID: <20080419144952.GM20637@parisc-linux.org>
References: <4808C90A.5040600@tiscali.nl> <Pine.LNX.4.64.0804182101200.14832@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Roel Kluin <12o3l@tiscali.nl>, kernel-janitors@vger.kernel.org,
	kernelnewbies-bounce@nl.linux.org
To: Julia Lawall <julia@diku.dk>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:39842 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825AbYDSOtx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 19 Apr 2008 10:49:53 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804182101200.14832@ask.diku.dk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 18, 2008 at 09:08:55PM +0200, Julia Lawall wrote:
> I found 63 occurrences of this problem with the following semantic match
> (http://www.emn.fr/x-info/coccinelle/):
> 
> @@ unsigned int i; @@
> 
> * i < 0
> 
> I looked through all of the results by hand, and they all seem to be 
> problems.  In many cases, it seems like the variable should not be 
> unsigned as it is used to hold the return value of a function that might 
> return a negative error code, but I haven't looked into this in detail.
> 
> In the output below, the lines that begin with a single start contain a 
> test of whether an unsigned variable or structure field is less than 0.
> The output is actually generated with diff, but I converted the -s to *s 
> to avoid confusion.

> diff -u -p a/fs/ext3/inode.c b/fs/ext3/inode.c
> *** a/fs/ext3/inode.c 2008-03-12 14:13:14.000000000 +0100
> @@ -1263,7 +1263,7 @@ static int ext3_ordered_write_end(struct
>  			EXT3_I(inode)->i_disksize = new_i_size;
>  		copied = ext3_generic_write_end(file, mapping, pos, len, copied,
>  							page, fsdata);
> *		if (copied < 0)
>  			ret = copied;
>  	}
>  	ret2 = ext3_journal_stop(handle);
> @@ -1291,7 +1291,7 @@ static int ext3_writeback_write_end(stru
>  
>  	copied = ext3_generic_write_end(file, mapping, pos, len, copied,
>  							page, fsdata);
> *	if (copied < 0)
>  		ret = copied;
>  
>  	ret2 = ext3_journal_stop(handle);
> diff -u -p a/fs/ext4/inode.c b/fs/ext4/inode.c
> *** a/fs/ext4/inode.c 2008-03-12 14:13:14.000000000 +0100
> @@ -1303,7 +1303,7 @@ static int ext4_ordered_write_end(struct
>  			EXT4_I(inode)->i_disksize = new_i_size;
>  		copied = ext4_generic_write_end(file, mapping, pos, len, copied,
>  							page, fsdata);
> *		if (copied < 0)
>  			ret = copied;
>  	}
>  	ret2 = ext4_journal_stop(handle);
> @@ -1331,7 +1331,7 @@ static int ext4_writeback_write_end(stru
>  
>  	copied = ext4_generic_write_end(file, mapping, pos, len, copied,
>  							page, fsdata);
> *	if (copied < 0)
>  		ret = copied;
>  
>  	ret2 = ext4_journal_stop(handle);

Fix comparisons of an unsigned int against 0

It's not really feasible to change 'copied' into a signed int, and while
we could cast it for the purposes of this comparison, I think this
rearrangement of the tests is actually clearer than the original.

Reported-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index eb95670..60f504b 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1261,18 +1261,16 @@ static int ext3_ordered_write_end(struct file *file,
 		new_i_size = pos + copied;
 		if (new_i_size > EXT3_I(inode)->i_disksize)
 			EXT3_I(inode)->i_disksize = new_i_size;
-		copied = ext3_generic_write_end(file, mapping, pos, len, copied,
+		ret = ext3_generic_write_end(file, mapping, pos, len, copied,
 							page, fsdata);
-		if (copied < 0)
-			ret = copied;
 	}
 	ret2 = ext3_journal_stop(handle);
-	if (!ret)
+	if (ret >= 0 && ret2)
 		ret = ret2;
 	unlock_page(page);
 	page_cache_release(page);
 
-	return ret ? ret : copied;
+	return ret;
 }
 
 static int ext3_writeback_write_end(struct file *file,
@@ -1289,18 +1287,15 @@ static int ext3_writeback_write_end(struct file *file,
 	if (new_i_size > EXT3_I(inode)->i_disksize)
 		EXT3_I(inode)->i_disksize = new_i_size;
 
-	copied = ext3_generic_write_end(file, mapping, pos, len, copied,
+	ret = ext3_generic_write_end(file, mapping, pos, len, copied,
 							page, fsdata);
-	if (copied < 0)
-		ret = copied;
-
 	ret2 = ext3_journal_stop(handle);
-	if (!ret)
+	if (ret >= 0 && ret2)
 		ret = ret2;
 	unlock_page(page);
 	page_cache_release(page);
 
-	return ret ? ret : copied;
+	return ret;
 }
 
 static int ext3_journalled_write_end(struct file *file,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 945cbf6..69b29c6 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1301,18 +1301,16 @@ static int ext4_ordered_write_end(struct file *file,
 		new_i_size = pos + copied;
 		if (new_i_size > EXT4_I(inode)->i_disksize)
 			EXT4_I(inode)->i_disksize = new_i_size;
-		copied = ext4_generic_write_end(file, mapping, pos, len, copied,
+		ret = ext4_generic_write_end(file, mapping, pos, len, copied,
 							page, fsdata);
-		if (copied < 0)
-			ret = copied;
 	}
 	ret2 = ext4_journal_stop(handle);
-	if (!ret)
+	if (ret >= 0 && ret2)
 		ret = ret2;
 	unlock_page(page);
 	page_cache_release(page);
 
-	return ret ? ret : copied;
+	return ret;
 }
 
 static int ext4_writeback_write_end(struct file *file,
@@ -1329,18 +1327,16 @@ static int ext4_writeback_write_end(struct file *file,
 	if (new_i_size > EXT4_I(inode)->i_disksize)
 		EXT4_I(inode)->i_disksize = new_i_size;
 
-	copied = ext4_generic_write_end(file, mapping, pos, len, copied,
+	ret = ext4_generic_write_end(file, mapping, pos, len, copied,
 							page, fsdata);
-	if (copied < 0)
-		ret = copied;
 
 	ret2 = ext4_journal_stop(handle);
-	if (!ret)
+	if (ret >= 0 && ret2)
 		ret = ret2;
 	unlock_page(page);
 	page_cache_release(page);
 
-	return ret ? ret : copied;
+	return ret;
 }
 
 static int ext4_journalled_write_end(struct file *file,

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
