From: Valerie Aurora <vaurora@redhat.com>
Subject: Re: E2fsprogs master branch now has all 64-bit patch applied
Date: Mon, 14 Jun 2010 16:26:55 -0400
Message-ID: <20100614202655.GB14808@shell>
References: <E1OO9sy-0006P1-Nr@closure.thunk.org> <4C168DEC.1040106@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755830Ab0FNU07 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Jun 2010 16:26:59 -0400
Content-Disposition: inline
In-Reply-To: <4C168DEC.1040106@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 14, 2010 at 03:15:40PM -0500, Eric Sandeen wrote:
> On 06/14/2010 08:39 AM, Theodore Ts'o wrote:
> > It's taken way too long, but I've finally finished integrating the
> > 64-bit patches into e2fsprogs's mainline repository.  All of the
> > necessary patches should now be in the master branch for e2fsprogs.
> 
> FWIW, this:
> 
> commit cf828f1a72ec1eb0c1e819307137879447c909b7
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Sun Oct 25 21:46:01 2009 -0400
> 
>     libext2fs: Byte-swap 64-bit block group descriptors
> 
>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> is blowing up all over on ppc, with glibc-detected memory problems like:

I took a quick look at this patch and saw one obvious thing:

diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index 52f56c0..7b325a1 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -322,7 +322,7 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 #ifdef WORDS_BIGENDIAN
                gdp = (struct ext2_group_desc *) dest;
                for (j=0; j < groups_per_block*first_meta_bg; j++)
-                       ext2fs_swap_group_desc(gdp++);
+                       ext2fs_swap_group_desc2(fs, gdp++);
 #endif
                dest += fs->blocksize*first_meta_bg;
        }
@@ -332,9 +332,11 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
                if (retval)
                        goto cleanup;
 #ifdef WORDS_BIGENDIAN
-               gdp = (struct ext2_group_desc *) dest;
-               for (j=0; j < groups_per_block; j++)
-                       ext2fs_swap_group_desc(gdp++);
+               for (j=0; j < groups_per_block; j++) {
+                       /* The below happens to work... be careful. */
+                       gdp = ext2fs_group_desc(fs, blk, j);
+                       ext2fs_swap_group_desc2(fs, gdp);
+               }
 #endif
                dest += fs->blocksize;
        }

I think the first hunk should use the same code as the second hunk -
the first bit is always incrementing by the size of struct
ext2_group_desc, when it needs to increment by the size of struct
ext4_group_desc on 64-bit file systems.  ext2fs_group_desc() does the
right thing.

Also, there's a teensy bit of whitespace damage in the second hunk in
csum.c.

Looks like there's a lot of low-hanging fruit just compiling for
big-endian.

-VAL
