From: Theodore Tso <tytso@mit.edu>
Subject: Re: [e2fsprogs] Bug in salvage_directory
Date: Mon, 9 Jul 2007 12:50:16 -0400
Message-ID: <20070709165016.GA21922@thunk.org>
References: <1183973522.3889.10.camel@garfield.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:38226 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303AbXGIQuU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Jul 2007 12:50:20 -0400
Content-Disposition: inline
In-Reply-To: <1183973522.3889.10.camel@garfield.linsyssoft.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jul 09, 2007 at 03:02:02PM +0530, Kalpak Shah wrote:
> Hi Ted,
> 
> Recently, one of our customers found this message in pass2 of e2fsck while doing some regression testing:
> "Entry '4, 0x695a, 0x81ff, 0x0040, 0x8320, 0xa192, 0x0021' in ??? (136554) has
> rec_len of 14200, should be 26908."
> 
> Both the displayed rec_len and the "should be" value are bogus. The
> reason is that salvage_directory sets a offset beyond blocksize
> leading to bogus messages.

Do you have a test case where this happens?  I don't think your patch
is right, because if dirent->rec_len is too big, this yes, your patch
will make sure offset doesn't get set beyond fs->blocksize, but it
ends up leaving prev->rec_len also pointing beyond fs->blocksize ---
which means a 2nd e2fsck should result in a complaint about that.

>  	if (prev && dirent->rec_len && (dirent->rec_len % 4) == 0) {
>  		prev->rec_len += dirent->rec_len;
			      ^^^^^^^^^^^^^^^^^^^
> -		*offset += dirent->rec_len;
> +		if (*offset + dirent->rec_len <= fs->blocksize)
> +			*offset += dirent->rec_len;
> +		else
> +			*offset = fs->blocksize;


I think this is a better fix for the problem:

diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index e235348..5e088e2 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -675,11 +675,12 @@ static void salvage_directory(ext2_filsys fs,
 		return;
 	}
 	/*
-	 * If the directory entry is a multiple of four, so it is
-	 * valid, let the previous directory entry absorb the invalid
-	 * one. 
+	 * If the record length of the directory entry is a multiple
+	 * of four, and not too big, such that it is valid, let the
+	 * previous directory entry absorb the invalid one.
 	 */
-	if (prev && dirent->rec_len && (dirent->rec_len % 4) == 0) {
+	if (prev && dirent->rec_len && (dirent->rec_len % 4) == 0 &&
+	    (*offset + dirent->rec_len <= fs->blocksize)) {
 		prev->rec_len += dirent->rec_len;
 		*offset += dirent->rec_len;
 		return;

If the dirent->rec_len is too big, then the default salvage method
which follows will do the right thing.

I'd like to have a test case to make sure this works, though, so if
you have a quick test case whipped up, that would be great.  Otherwise
I'll have to cons one up when I have a moment.

Thanks, regards,

     	     	      	      	       - Ted
