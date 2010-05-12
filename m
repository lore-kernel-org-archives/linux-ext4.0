From: tytso@mit.edu
Subject: Re: [PATCH] e2fsck: make -y -y answer "no" to Abort?
Date: Wed, 12 May 2010 19:02:07 -0400
Message-ID: <20100512230207.GD1398@thunk.org>
References: <4BB7AD20.1080307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:47682 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564Ab0ELXCM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 May 2010 19:02:12 -0400
Content-Disposition: inline
In-Reply-To: <4BB7AD20.1080307@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 03, 2010 at 04:03:28PM -0500, Eric Sandeen wrote:
> RH Bug 484913 - Change verbage of e2fsck questioning to make the "-y"
> switch more useful
> 
> demonstrates:
> 
> sh-3.2# e2fsck -y /dev/VolGroup00/VolVol02
> e2fsck 1.41.3 (12-Oct-2008)
> The filesystem size (according to the superblock) is 14090240 blocks
> The physical size of the device is 8847360 blocks
> Either the superblock or the partition table is likely to be corrupt!
> 
> Abort? yes

I looked at this more closely, and there are a bunch of e2fsck
problems marked with PROMPT_ABORT that aren't correctly using
PROMPT_ABORT.  In fact they should be PROMPT_NONE, PR_FATAL --- and
then we need to carefully rework the code so that the e2fsck does the
right thing if the user answers "don't abort".  Right now there are
some failures where it doesn't matter whether the user answers "yes"
or "no" to the "Abort?" question --- e2fsck just aborts anyway.  I
have a patch that fixes this, attached below.

Once I take out these bogus PROMPT_ABORT questions, the ones that are
left are ones where I'm *very* nervous about how much damage could be
done if we blindly go on after getting one of these ABORT? questions.
So in fact I'm rather nervous about allowing -y -y to mean, "D*mn the
torpedos full speed ahead", or "We're in the North Atlantic, light the
last four boilers and speed up the RMS Titanic!"  At the very least I
would **never** want to allow Ubuntu users access to -y -y, because
then they would bitch and moan on Launchpad how it destroyed their
data.

So it seems to me that the better way to do this is to very carefully
go through each of the problems in e2fsck which are currently using
PROMPT_ABORT or PR_FATAL, and see if we can find a *safe* way for
e2fsck to continue, either by default if the user uses -y (in the case
of PROMPT_ABORT) and then convert that PROMPT_CONTINUE, or allow
e2fsck to recover cleanly and then remove the PR_FATAL flag.

       	  	  	      	   	      - Ted

commit a6217f5ae2ca02f2f12c259b34615cbd7f4110d6
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Wed May 12 18:58:53 2010 -0400

    e2fsck: Fix a number of problems that were inappropriately using PROMPT_ABORT
    
    There were a number of problems that were prompting the user whether
    or not to ABORT, but then would abort regardless of whether the user
    answered yes or no.  Change those to be PROMPT_NONE, PR_FATAL.
    
    Also, fix PR_1_RESIZE_INODE_CREATE so that it recovers appropriately
    after failing to create the resize inode.  This problem now uses
    PROMPT_CONTINUE instead of PROMPT_ABORT, and if the user says, "no",
    the code will abort.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index a0249ff..3b65e8a 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1126,16 +1126,20 @@ void e2fsck_pass1(e2fsck_t ctx)
 		clear_problem_context(&pctx);
 		pctx.errcode = ext2fs_create_resize_inode(fs);
 		if (pctx.errcode) {
-			fix_problem(ctx, PR_1_RESIZE_INODE_CREATE, &pctx);
-			/* Should never get here */
-			ctx->flags |= E2F_FLAG_ABORT;
-			return;
+			if (!fix_problem(ctx, PR_1_RESIZE_INODE_CREATE,
+					 &pctx)) {
+				ctx->flags |= E2F_FLAG_ABORT;
+				return;
+			}
+			pctx.errcode = 0;
+		}
+		if (!pctx.errcode) {
+			e2fsck_read_inode(ctx, EXT2_RESIZE_INO, inode,
+					  "recreate inode");
+			inode->i_mtime = ctx->now;
+			e2fsck_write_inode(ctx, EXT2_RESIZE_INO, inode,
+					   "recreate inode");
 		}
-		e2fsck_read_inode(ctx, EXT2_RESIZE_INO, inode,
-				  "recreate inode");
-		inode->i_mtime = ctx->now;
-		e2fsck_write_inode(ctx, EXT2_RESIZE_INO, inode,
-				   "recreate inode");
 		fs->block_map = save_bmap;
 		ctx->flags &= ~E2F_FLAG_RESIZE_INODE;
 	}
@@ -1391,7 +1395,8 @@ static void adjust_extattr_refcount(e2fsck_t ctx, ext2_refcount_t refcount,
 			pctx.errcode = ext2fs_write_ext_attr(fs, blk,
 							     block_buf);
 			if (pctx.errcode) {
-				fix_problem(ctx, PR_1_EXTATTR_WRITE, &pctx);
+				fix_problem(ctx, PR_1_EXTATTR_WRITE_ABORT,
+					    &pctx);
 				continue;
 			}
 		}
@@ -1505,7 +1510,7 @@ static int check_ext_attr(e2fsck_t ctx, struct problem_context *pctx,
 
 	region = region_create(0, fs->blocksize);
 	if (!region) {
-		fix_problem(ctx, PR_1_EA_ALLOC_REGION, pctx);
+		fix_problem(ctx, PR_1_EA_ALLOC_REGION_ABORT, pctx);
 		ctx->flags |= E2F_FLAG_ABORT;
 		return 0;
 	}
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index ceb2ae9..5825f5b 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -703,7 +703,7 @@ static struct e2fsck_problem problem_table[] = {
 	/* Error reading Extended Attribute block while fixing refcount */
 	{ PR_1_EXTATTR_READ_ABORT,
 	  N_("Error reading @a @b %b (%m).  "),
-	  PROMPT_ABORT, 0 },
+	  PROMPT_NONE, PR_FATAL },
 
 	/* Extended attribute reference count incorrect */
 	{ PR_1_EXTATTR_REFCOUNT,
@@ -711,9 +711,9 @@ static struct e2fsck_problem problem_table[] = {
 	  PROMPT_FIX, 0 },
 
 	/* Error writing Extended Attribute block while fixing refcount */
-	{ PR_1_EXTATTR_WRITE,
+	{ PR_1_EXTATTR_WRITE_ABORT,
 	  N_("Error writing @a @b %b (%m).  "),
-	  PROMPT_ABORT, 0 },
+	  PROMPT_NONE, PR_FATAL },
 
 	/* Multiple EA blocks not supported */
 	{ PR_1_EA_MULTI_BLOCK,
@@ -721,9 +721,9 @@ static struct e2fsck_problem problem_table[] = {
 	  PROMPT_CLEAR, 0},
 
 	/* Error allocating EA region allocation structure */
-	{ PR_1_EA_ALLOC_REGION,
+	{ PR_1_EA_ALLOC_REGION_ABORT,
 	  N_("@A @a @b %b.  "),
-	  PROMPT_ABORT, 0},
+	  PROMPT_NONE, PR_FATAL},
 
 	/* Error EA allocation collision */
 	{ PR_1_EA_ALLOC_COLLISION,
@@ -798,7 +798,7 @@ static struct e2fsck_problem problem_table[] = {
 	/* Resize inode failed */
 	{ PR_1_RESIZE_INODE_CREATE,
 	  N_("Resize @i (re)creation failed: %m."),
-	  PROMPT_ABORT, 0 },
+	  PROMPT_CONTINUE, 0 },
 
 	/* invalid inode->i_extra_isize */
 	{ PR_1_EXTRA_ISIZE,
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index b1bc97f..7c4c156 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -413,13 +413,13 @@ struct problem_context {
 #define PR_1_EXTATTR_REFCOUNT		0x01003C
 
 /* Error writing Extended Attribute block while fixing refcount */
-#define PR_1_EXTATTR_WRITE		0x01003D
+#define PR_1_EXTATTR_WRITE_ABORT	0x01003D
 
 /* Multiple EA blocks not supported */
 #define PR_1_EA_MULTI_BLOCK		0x01003E
 
 /* Error allocating EA region allocation structure */
-#define PR_1_EA_ALLOC_REGION		0x01003F
+#define PR_1_EA_ALLOC_REGION_ABORT	0x01003F
 
 /* Error EA allocation collision */
 #define PR_1_EA_ALLOC_COLLISION		0x010040
