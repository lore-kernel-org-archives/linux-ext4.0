From: "Theodore Ts'o" <tytso@MIT.EDU>
Subject: [PATCH, E2FSPROGS] Fix trailing whitespace in e2fsck/problem.[ch]
Date: Mon, 31 Mar 2008 19:36:31 -0400
Message-ID: <1207006592-13980-10-git-send-email-tytso@mit.edu>
References: <20080325084039.GA10804@webber.adilger.int>
 <1207006592-13980-1-git-send-email-tytso@mit.edu>
 <1207006592-13980-2-git-send-email-tytso@mit.edu>
 <1207006592-13980-3-git-send-email-tytso@mit.edu>
 <1207006592-13980-4-git-send-email-tytso@mit.edu>
 <1207006592-13980-5-git-send-email-tytso@mit.edu>
 <1207006592-13980-6-git-send-email-tytso@mit.edu>
 <1207006592-13980-7-git-send-email-tytso@mit.edu>
 <1207006592-13980-8-git-send-email-tytso@mit.edu>
 <1207006592-13980-9-git-send-email-tytso@mit.edu>
Cc: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:63146 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751520AbYCaXnC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Mar 2008 19:43:02 -0400
In-Reply-To: <1207006592-13980-9-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/problem.c |  246 +++++++++++++++++++++++++++---------------------------
 e2fsck/problem.h |  106 ++++++++++++------------
 2 files changed, 176 insertions(+), 176 deletions(-)

diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 828be88..d9ae911 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -54,7 +54,7 @@ static const char *prompt[] = {
 	N_("Allocate"),		/* 4 */
 	N_("Expand"),		/* 5 */
 	N_("Connect to /lost+found"), /* 6 */
-	N_("Create"),		/* 7 */	
+	N_("Create"),		/* 7 */
 	N_("Salvage"),		/* 8 */
 	N_("Truncate"),		/* 9 */
 	N_("Clear inode"),	/* 10 */
@@ -104,11 +104,11 @@ static struct e2fsck_problem problem_table[] = {
 
 	/* Block bitmap not in group */
 	{ PR_0_BB_NOT_GROUP, N_("@b @B for @g %g is not in @g.  (@b %b)\n"),
-	  PROMPT_RELOCATE, PR_LATCH_RELOC }, 
+	  PROMPT_RELOCATE, PR_LATCH_RELOC },
 
 	/* Inode bitmap not in group */
 	{ PR_0_IB_NOT_GROUP, N_("@i @B for @g %g is not in @g.  (@b %b)\n"),
-	  PROMPT_RELOCATE, PR_LATCH_RELOC }, 
+	  PROMPT_RELOCATE, PR_LATCH_RELOC },
 
 	/* Inode table not in group */
 	{ PR_0_ITABLE_NOT_GROUP,
@@ -132,7 +132,7 @@ static struct e2fsck_problem problem_table[] = {
 	  "Either the @S or the partition table is likely to be corrupt!\n"),
 	  PROMPT_ABORT, 0 },
 
-	/* Fragments not supported */		  
+	/* Fragments not supported */
 	{ PR_0_NO_FRAGMENTS,
 	  N_("@S @b_size = %b, fragsize = %c.\n"
 	  "This version of e2fsck does not support fragment sizes different\n"
@@ -148,7 +148,7 @@ static struct e2fsck_problem problem_table[] = {
 	{ PR_0_FIRST_DATA_BLOCK,
 	  N_("@S first_data_@b = %b, should have been %c\n"),
 	  PROMPT_NONE, PR_AFTER_CODE, PR_0_SB_CORRUPT },
-	
+
 	/* Adding UUID to filesystem */
 	{ PR_0_ADD_UUID,
 	  N_("@f did not have a UUID; generating one.\n\n"),
@@ -169,7 +169,7 @@ static struct e2fsck_problem problem_table[] = {
 	  PROMPT_NONE, PR_AFTER_CODE, PR_0_SB_CORRUPT },
 
 	/* Error determing physical device size of filesystem */
-	{ PR_0_GETSIZE_ERROR,	  
+	{ PR_0_GETSIZE_ERROR,
 	  N_("Error determining size of the physical @v: %m\n"),
 	  PROMPT_NONE, PR_FATAL },
 
@@ -259,12 +259,12 @@ static struct e2fsck_problem problem_table[] = {
 	{ PR_0_ORPHAN_ILLEGAL_BLOCK_NUM,
 	   N_("@I @b #%B (%b) found in @o @i %i.\n"),
 	  PROMPT_NONE, 0 },
-		  
+
 	/* Already cleared block found in orphaned inode */
 	{ PR_0_ORPHAN_ALREADY_CLEARED_BLOCK,
 	   N_("Already cleared @b #%B (%b) found in @o @i %i.\n"),
 	  PROMPT_NONE, 0 },
-  
+
 	/* Illegal orphan inode in superblock */
 	{ PR_0_ORPHAN_ILLEGAL_HEAD_INODE,
 	  N_("@I @o @i %i in @S.\n"),
@@ -382,10 +382,10 @@ static struct e2fsck_problem problem_table[] = {
 	{ PR_1_PASS_HEADER,
 	  N_("Pass 1: Checking @is, @bs, and sizes\n"),
 	  PROMPT_NONE, 0 },
-		  
+
 	/* Root directory is not an inode */
 	{ PR_1_ROOT_NO_DIR, N_("@r is not a @d.  "),
-	  PROMPT_CLEAR, 0 }, 
+	  PROMPT_CLEAR, 0 },
 
 	/* Root directory has dtime set */
 	{ PR_1_ROOT_DTIME,
@@ -441,7 +441,7 @@ static struct e2fsck_problem problem_table[] = {
 	{ PR_1_BAD_I_SIZE,
 	  N_("@i %i, i_size is %Is, @s %N.  "),
 	  PROMPT_FIX, PR_PREEN_OK },
-		  
+
 	/* Inode has incorrect i_blocks */
 	{ PR_1_BAD_I_BLOCKS,
 	  N_("@i %i, i_@bs is %Ib, @s %N.  "),
@@ -465,7 +465,7 @@ static struct e2fsck_problem problem_table[] = {
 	/* Too many bad blocks in inode */
 	{ PR_1_TOO_MANY_BAD_BLOCKS,
 	  N_("Too many illegal @bs in @i %i.\n"),
-	  PROMPT_CLEAR_INODE, PR_NO_OK }, 	
+	  PROMPT_CLEAR_INODE, PR_NO_OK },
 
 	/* Illegal block number in bad block inode */
 	{ PR_1_BB_ILLEGAL_BLOCK_NUM,
@@ -482,12 +482,12 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("Duplicate or bad @b in use!\n"),
 	  PROMPT_NONE, 0 },
 
-	/* Bad block used as bad block indirect block */	  
+	/* Bad block used as bad block indirect block */
 	{ PR_1_BBINODE_BAD_METABLOCK,
 	  N_("Bad @b %b used as bad @b @i indirect @b.  "),
 	  PROMPT_CLEAR, PR_LATCH_BBLOCK },
 
-	/* Inconsistency can't be fixed prompt */	  
+	/* Inconsistency can't be fixed prompt */
 	{ PR_1_BBINODE_BAD_METABLOCK_PROMPT,
 	  N_("\nThe bad @b @i has probably been corrupted.  You probably\n"
 	     "should stop now and run ""e2fsck -c"" to scan for bad blocks\n"
@@ -495,12 +495,12 @@ static struct e2fsck_problem problem_table[] = {
 	  PROMPT_CONTINUE, PR_PREEN_NOMSG },
 
 	/* Bad primary block */
-	{ PR_1_BAD_PRIMARY_BLOCK,  
+	{ PR_1_BAD_PRIMARY_BLOCK,
 	  N_("\nIf the @b is really bad, the @f can not be fixed.\n"),
 	  PROMPT_NONE, PR_AFTER_CODE, PR_1_BAD_PRIMARY_BLOCK_PROMPT },
-		  
+
 	/* Bad primary block prompt */
-	{ PR_1_BAD_PRIMARY_BLOCK_PROMPT,	  
+	{ PR_1_BAD_PRIMARY_BLOCK_PROMPT,
 	  N_("You can remove this @b from the bad @b list and hope\n"
 	     "that the @b is really OK.  But there are no guarantees.\n\n"),
 	  PROMPT_CLEAR, PR_PREEN_NOMSG },
@@ -509,25 +509,25 @@ static struct e2fsck_problem problem_table[] = {
 	{ PR_1_BAD_PRIMARY_SUPERBLOCK,
 	  N_("The primary @S (%b) is on the bad @b list.\n"),
 	  PROMPT_NONE, PR_AFTER_CODE, PR_1_BAD_PRIMARY_BLOCK },
-		  
+
 	/* Bad primary block group descriptors */
 	{ PR_1_BAD_PRIMARY_GROUP_DESCRIPTOR,
 	  N_("Block %b in the primary @g descriptors "
 	  "is on the bad @b list\n"),
 	  PROMPT_NONE, PR_AFTER_CODE, PR_1_BAD_PRIMARY_BLOCK },
-		  
+
 	/* Bad superblock in group */
 	{ PR_1_BAD_SUPERBLOCK,
 	  N_("Warning: Group %g's @S (%b) is bad.\n"),
 	  PROMPT_NONE, PR_PREEN_OK | PR_PREEN_NOMSG },
-		  
+
 	/* Bad block group descriptors in group */
 	{ PR_1_BAD_GROUP_DESCRIPTORS,
 	  N_("Warning: Group %g's copy of the @g descriptors has a bad "
 	  "@b (%b).\n"),
 	  PROMPT_NONE, PR_PREEN_OK | PR_PREEN_NOMSG },
 
-	/* Block claimed for no reason */	  
+	/* Block claimed for no reason */
 	{ PR_1_PROGERR_CLAIMED_BLOCK,
 	  N_("Programming error?  @b #%b claimed for no reason in "
 	  "process_bad_@b.\n"),
@@ -537,27 +537,27 @@ static struct e2fsck_problem problem_table[] = {
 	{ PR_1_RELOC_BLOCK_ALLOCATE,
 	  N_("@A %N contiguous @b(s) in @b @g %g for %s: %m\n"),
 	  PROMPT_NONE, PR_PREEN_OK },
-		
+
 	/* Error allocating block buffer during relocation process */
 	{ PR_1_RELOC_MEMORY_ALLOCATE,
 	  N_("@A @b buffer for relocating %s\n"),
 	  PROMPT_NONE, PR_PREEN_OK },
-		
-	/* Relocating metadata group information from X to Y */	
+
+	/* Relocating metadata group information from X to Y */
 	{ PR_1_RELOC_FROM_TO,
 	  N_("Relocating @g %g's %s from %b to %c...\n"),
 	  PROMPT_NONE, PR_PREEN_OK },
-		
+
 	/* Relocating metatdata group information to X */
 	{ PR_1_RELOC_TO,
 	  N_("Relocating @g %g's %s to %c...\n"), /* xgettext:no-c-format */
 	  PROMPT_NONE, PR_PREEN_OK },
-		
+
 	/* Block read error during relocation process */
 	{ PR_1_RELOC_READ_ERR,
 	  N_("Warning: could not read @b %b of %s: %m\n"),
 	  PROMPT_NONE, PR_PREEN_OK },
-		
+
 	/* Block write error during relocation process */
 	{ PR_1_RELOC_WRITE_ERR,
 	  N_("Warning: could not write @b %b for %s: %m\n"),
@@ -593,25 +593,25 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("Error while iterating over @bs in @i %i: %m\n"),
 	  PROMPT_NONE, PR_FATAL },
 
-	/* Error while storing inode count information */	  
+	/* Error while storing inode count information */
 	{ PR_1_ICOUNT_STORE,
 	  N_("Error storing @i count information (@i=%i, count=%N): %m\n"),
 	  PROMPT_NONE, PR_FATAL },
 
-	/* Error while storing directory block information */	  
+	/* Error while storing directory block information */
 	{ PR_1_ADD_DBLOCK,
 	  N_("Error storing @d @b information "
 	  "(@i=%i, @b=%b, num=%N): %m\n"),
 	  PROMPT_NONE, PR_FATAL },
 
-	/* Error while reading inode (for clearing) */	  
+	/* Error while reading inode (for clearing) */
 	{ PR_1_READ_INODE,
 	  N_("Error reading @i %i: %m\n"),
 	  PROMPT_NONE, PR_FATAL },
 
 	/* Suppress messages prompt */
 	{ PR_1_SUPPRESS_MESSAGES, "", PROMPT_SUPPRESS, PR_NO_OK },
-		  
+
 	/* Imagic flag set on an inode when filesystem doesn't support it */
 	{ PR_1_SET_IMAGIC,
 	  N_("@i %i has imagic flag set.  "),
@@ -638,11 +638,11 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@f has feature flag(s) set, but is a revision 0 @f.  "),
 	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK },
 
-	/* Journal inode is not in use, but contains data */	  
+	/* Journal inode is not in use, but contains data */
 	{ PR_1_JOURNAL_INODE_NOT_CLEAR,
 	  N_("@j @i is not in use, but contains data.  "),
-	  PROMPT_CLEAR, PR_PREEN_OK },	  
-	  
+	  PROMPT_CLEAR, PR_PREEN_OK },
+
 	/* Journal has bad mode */
 	{ PR_1_JOURNAL_BAD_MODE,
 	  N_("@j is not regular file.  "),
@@ -651,14 +651,14 @@ static struct e2fsck_problem problem_table[] = {
 	/* Deal with inodes that were part of orphan linked list */
 	{ PR_1_LOW_DTIME,
 	  N_("@i %i was part of the @o @i list.  "),
-	  PROMPT_FIX, PR_LATCH_LOW_DTIME, 0 },    
+	  PROMPT_FIX, PR_LATCH_LOW_DTIME, 0 },
 
 	/* Deal with inodes that were part of corrupted orphan linked
 	   list (latch question) */
 	{ PR_1_ORPHAN_LIST_REFUGEES,
 	  N_("@is that were part of a corrupted orphan linked list found.  "),
-	  PROMPT_FIX, 0 },		  
-		  
+	  PROMPT_FIX, 0 },
+
 	/* Error allocating refcount structure */
 	{ PR_1_ALLOCATE_REFCOUNT,
 	  N_("@A refcount structure (%N): %m\n"),
@@ -678,13 +678,13 @@ static struct e2fsck_problem problem_table[] = {
 	{ PR_1_EXTATTR_READ_ABORT,
 	  N_("Error reading @a @b %b (%m).  "),
 	  PROMPT_ABORT, 0 },
-		  
+
 	/* Extended attribute reference count incorrect */
 	{ PR_1_EXTATTR_REFCOUNT,
 	  N_("@a @b %b has reference count %B, @s %N.  "),
 	  PROMPT_FIX, 0 },
-		  
-	/* Error writing Extended Attribute block while fixing refcount */ 
+
+	/* Error writing Extended Attribute block while fixing refcount */
 	{ PR_1_EXTATTR_WRITE,
 	  N_("Error writing @a @b %b (%m).  "),
 	  PROMPT_ABORT, 0 },
@@ -692,22 +692,22 @@ static struct e2fsck_problem problem_table[] = {
 	/* Multiple EA blocks not supported */
 	{ PR_1_EA_MULTI_BLOCK,
 	  N_("@a @b %b has h_@bs > 1.  "),
-	  PROMPT_CLEAR, 0},	  
+	  PROMPT_CLEAR, 0},
 
 	/* Error allocating EA region allocation structure */
 	{ PR_1_EA_ALLOC_REGION,
 	  N_("@A @a @b %b.  "),
 	  PROMPT_ABORT, 0},
-	
+
 	/* Error EA allocation collision */
 	{ PR_1_EA_ALLOC_COLLISION,
 	  N_("@a @b %b is corrupt (allocation collision).  "),
 	  PROMPT_CLEAR, 0},
-	
+
 	/* Bad extended attribute name */
 	{ PR_1_EA_BAD_NAME,
 	  N_("@a @b %b is corrupt (@n name).  "),
-	  PROMPT_CLEAR, 0},	  
+	  PROMPT_CLEAR, 0},
 
 	/* Bad extended attribute value */
 	{ PR_1_EA_BAD_VALUE,
@@ -719,7 +719,7 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@i %i is too big.  "), PROMPT_TRUNCATE, 0 },
 
 	/* Directory too big */
-	{ PR_1_TOOBIG_DIR, 
+	{ PR_1_TOOBIG_DIR,
 	  N_("@b #%B (%b) causes @d to be too big.  "),
 	  PROMPT_CLEAR, PR_LATCH_TOOBIG },
 
@@ -738,31 +738,31 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@i %i has INDEX_FL flag set on @f without htree support.\n"),
 	  PROMPT_CLEAR_HTREE, PR_PREEN_OK },
 
-	/* INDEX_FL flag set on a non-directory */	
+	/* INDEX_FL flag set on a non-directory */
 	{ PR_1_HTREE_NODIR,
 	  N_("@i %i has INDEX_FL flag set but is not a @d.\n"),
 	  PROMPT_CLEAR_HTREE, PR_PREEN_OK },
 
-	/* Invalid root node in HTREE directory */	
+	/* Invalid root node in HTREE directory */
 	{ PR_1_HTREE_BADROOT,
 	  N_("@h %i has an @n root node.\n"),
 	  PROMPT_CLEAR_HTREE, PR_PREEN_OK },
 
-	/* Unsupported hash version in HTREE directory */	
+	/* Unsupported hash version in HTREE directory */
 	{ PR_1_HTREE_HASHV,
 	  N_("@h %i has an unsupported hash version (%N)\n"),
 	  PROMPT_CLEAR_HTREE, PR_PREEN_OK },
 
-	/* Incompatible flag in HTREE root node */	
+	/* Incompatible flag in HTREE root node */
 	{ PR_1_HTREE_INCOMPAT,
 	  N_("@h %i uses an incompatible htree root node flag.\n"),
 	  PROMPT_CLEAR_HTREE, PR_PREEN_OK },
 
-	/* HTREE too deep */	
+	/* HTREE too deep */
 	{ PR_1_HTREE_DEPTH,
 	  N_("@h %i has a tree depth (%N) which is too big\n"),
 	  PROMPT_CLEAR_HTREE, PR_PREEN_OK },
-		  
+
 	/* Bad block has indirect block that conflicts with filesystem block */
 	{ PR_1_BB_FS_BLOCK,
 	  N_("Bad @b @i has an indirect @b (%b) that conflicts with\n"
@@ -774,32 +774,32 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("Resize @i (re)creation failed: %m."),
 	  PROMPT_ABORT, 0 },
 
-	/* invalid inode->i_extra_isize */	
+	/* invalid inode->i_extra_isize */
 	{ PR_1_EXTRA_ISIZE,
 	  N_("@i %i has a extra size (%IS) which is @n\n"),
 	  PROMPT_FIX, PR_PREEN_OK },
 
-	/* invalid ea entry->e_name_len */	
+	/* invalid ea entry->e_name_len */
 	{ PR_1_ATTR_NAME_LEN,
 	  N_("@a in @i %i has a namelen (%N) which is @n\n"),
 	  PROMPT_CLEAR, PR_PREEN_OK },
 
-	/* invalid ea entry->e_value_size */	
+	/* invalid ea entry->e_value_size */
 	{ PR_1_ATTR_VALUE_SIZE,
 	  N_("@a in @i %i has a value size (%N) which is @n\n"),
 	  PROMPT_CLEAR, PR_PREEN_OK },
 
-	/* invalid ea entry->e_value_offs */	
+	/* invalid ea entry->e_value_offs */
 	{ PR_1_ATTR_VALUE_OFFSET,
 	  N_("@a in @i %i has a value offset (%N) which is @n\n"),
 	  PROMPT_CLEAR, PR_PREEN_OK },
 
-	/* invalid ea entry->e_value_block */	
+	/* invalid ea entry->e_value_block */
 	{ PR_1_ATTR_VALUE_BLOCK,
 	  N_("@a in @i %i has a value @b (%N) which is @n (must be 0)\n"),
 	  PROMPT_CLEAR, PR_PREEN_OK },
 
-	/* invalid ea entry->e_hash */	
+	/* invalid ea entry->e_hash */
 	{ PR_1_ATTR_HASH,
 	  N_("@a in @i %i has a hash (%N) which is @n\n"),
 	  PROMPT_CLEAR, PR_PREEN_OK },
@@ -858,12 +858,12 @@ static struct e2fsck_problem problem_table[] = {
 	  PROMPT_NONE, 0 },
 
 	/* Duplicate/bad block(s) header */
-	{ PR_1B_DUP_BLOCK_HEADER,	  
+	{ PR_1B_DUP_BLOCK_HEADER,
 	  N_("@m @b(s) in @i %i:"),
 	  PROMPT_NONE, 0 },
 
 	/* Duplicate/bad block(s) in inode */
-	{ PR_1B_DUP_BLOCK,	  
+	{ PR_1B_DUP_BLOCK,
 	  " %b",
 	  PROMPT_NONE, PR_LATCH_DBLOCK | PR_PREEN_NOHDR },
 
@@ -871,7 +871,7 @@ static struct e2fsck_problem problem_table[] = {
 	{ PR_1B_DUP_BLOCK_END,
 	  "\n",
 	  PROMPT_NONE, PR_PREEN_NOHDR },
-		  
+
 	/* Error while scanning inodes */
 	{ PR_1B_ISCAN_ERROR,
 	  N_("Error while scanning inodes (%i): %m\n"),
@@ -898,29 +898,29 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("Pass 1C: Scanning directories for @is with @m @bs\n"),
 	  PROMPT_NONE, 0 },
 
-		  
+
 	/* Pass 1D: Reconciling multiply-claimed blocks */
 	{ PR_1D_PASS_HEADER,
 	  N_("Pass 1D: Reconciling @m @bs\n"),
 	  PROMPT_NONE, 0 },
-		  
+
 	/* File has duplicate blocks */
 	{ PR_1D_DUP_FILE,
 	  N_("File %Q (@i #%i, mod time %IM) \n"
 	  "  has %B @m @b(s), shared with %N file(s):\n"),
 	  PROMPT_NONE, 0 },
-		  
-	/* List of files sharing duplicate blocks */	
+
+	/* List of files sharing duplicate blocks */
 	{ PR_1D_DUP_FILE_LIST,
 	  N_("\t%Q (@i #%i, mod time %IM)\n"),
 	  PROMPT_NONE, 0 },
-	  
-	/* File sharing blocks with filesystem metadata  */	
+
+	/* File sharing blocks with filesystem metadata  */
 	{ PR_1D_SHARE_METADATA,
 	  N_("\t<@f metadata>\n"),
 	  PROMPT_NONE, 0 },
 
-	/* Report of how many duplicate/bad inodes */	
+	/* Report of how many duplicate/bad inodes */
 	{ PR_1D_NUM_DUP_INODES,
 	  N_("(There are %N @is containing @m @bs.)\n\n"),
 	  PROMPT_NONE, 0 },
@@ -933,7 +933,7 @@ static struct e2fsck_problem problem_table[] = {
 	/* Clone duplicate/bad blocks? */
 	{ PR_1D_CLONE_QUESTION,
 	  "", PROMPT_CLONE, PR_NO_OK },
-		  
+
 	/* Delete file? */
 	{ PR_1D_DELETE_QUESTION,
 	  "", PROMPT_DELETE, 0 },
@@ -948,24 +948,24 @@ static struct e2fsck_problem problem_table[] = {
 	{ PR_2_PASS_HEADER,
 	  N_("Pass 2: Checking @d structure\n"),
 	  PROMPT_NONE, 0 },
-		  
+
 	/* Bad inode number for '.' */
 	{ PR_2_BAD_INODE_DOT,
 	  N_("@n @i number for '.' in @d @i %i.\n"),
 	  PROMPT_FIX, 0 },
 
 	/* Directory entry has bad inode number */
-	{ PR_2_BAD_INO, 
+	{ PR_2_BAD_INO,
 	  N_("@E has @n @i #: %Di.\n"),
 	  PROMPT_CLEAR, 0 },
 
 	/* Directory entry has deleted or unused inode */
-	{ PR_2_UNUSED_INODE, 
+	{ PR_2_UNUSED_INODE,
 	  N_("@E has @D/unused @i %Di.  "),
 	  PROMPT_CLEAR, PR_PREEN_OK },
 
 	/* Directry entry is link to '.' */
-	{ PR_2_LINK_DOT, 
+	{ PR_2_LINK_DOT,
 	  N_("@E @L to '.'  "),
 	  PROMPT_CLEAR, 0 },
 
@@ -975,26 +975,26 @@ static struct e2fsck_problem problem_table[] = {
 	  PROMPT_CLEAR, 0 },
 
 	/* Directory entry contains a link to a directory */
-	{ PR_2_LINK_DIR, 
+	{ PR_2_LINK_DIR,
 	  N_("@E @L to @d %P (%Di).\n"),
 	  PROMPT_CLEAR, 0 },
 
 	/* Directory entry contains a link to the root directry */
-	{ PR_2_LINK_ROOT, 
+	{ PR_2_LINK_ROOT,
 	  N_("@E @L to the @r.\n"),
 	  PROMPT_CLEAR, 0 },
 
 	/* Directory entry has illegal characters in its name */
-	{ PR_2_BAD_NAME, 
+	{ PR_2_BAD_NAME,
 	  N_("@E has illegal characters in its name.\n"),
 	  PROMPT_FIX, 0 },
 
-	/* Missing '.' in directory inode */	  
+	/* Missing '.' in directory inode */
 	{ PR_2_MISSING_DOT,
 	  N_("Missing '.' in @d @i %i.\n"),
 	  PROMPT_FIX, 0 },
 
-	/* Missing '..' in directory inode */	  
+	/* Missing '..' in directory inode */
 	{ PR_2_MISSING_DOT_DOT,
 	  N_("Missing '..' in @d @i %i.\n"),
 	  PROMPT_FIX, 0 },
@@ -1008,7 +1008,7 @@ static struct e2fsck_problem problem_table[] = {
 	{ PR_2_2ND_NOT_DOT_DOT,
 	  N_("Second @e '%Dn' (@i=%Di) in @d @i %i @s '..'\n"),
 	  PROMPT_FIX, 0 },
-		  
+
 	/* i_faddr should be zero */
 	{ PR_2_FADDR_ZERO,
 	  N_("i_faddr @F %IF, @s zero.\n"),
@@ -1040,17 +1040,17 @@ static struct e2fsck_problem problem_table[] = {
 	  PROMPT_CLEAR, 0 },
 
 	/* directory corrupted */
-	{ PR_2_DIR_CORRUPTED,	  
+	{ PR_2_DIR_CORRUPTED,
 	  N_("@d @i %i, @b %B, offset %N: @d corrupted\n"),
 	  PROMPT_SALVAGE, 0 },
-		  
+
 	/* filename too long */
-	{ PR_2_FILENAME_LONG,	  
+	{ PR_2_FILENAME_LONG,
 	  N_("@d @i %i, @b %B, offset %N: filename too long\n"),
 	  PROMPT_TRUNCATE, 0 },
 
 	/* Directory inode has a missing block (hole) */
-	{ PR_2_DIRECTORY_HOLE,	  
+	{ PR_2_DIRECTORY_HOLE,
 	  N_("@d @i %i has an unallocated @b #%B.  "),
 	  PROMPT_ALLOCATE, 0 },
 
@@ -1077,7 +1077,7 @@ static struct e2fsck_problem problem_table[] = {
 	/* Duplicate '.' entry */
 	{ PR_2_DUP_DOT,
 	  N_("@E is duplicate '.' @e.\n"),
-	  PROMPT_FIX, 0 },	  
+	  PROMPT_FIX, 0 },
 
 	/* Duplicate '..' entry */
 	{ PR_2_DUP_DOT_DOT,
@@ -1093,7 +1093,7 @@ static struct e2fsck_problem problem_table[] = {
 	{ PR_2_FINAL_RECLEN,
 	  N_("@E has rec_len of %Dr, @s %N.\n"),
 	  PROMPT_FIX, 0 },
-		  
+
 	/* Error allocating icount structure */
 	{ PR_2_ALLOCATE_ICOUNT,
 	  N_("@A icount structure: %m\n"),
@@ -1173,7 +1173,7 @@ static struct e2fsck_problem problem_table[] = {
 	{ PR_2_FEATURE_LARGE_FILES,
 	  N_("@f contains large files, but lacks LARGE_FILE flag in @S.\n"),
 	  PROMPT_FIX, 0 },
-	  
+
 	/* Node in HTREE directory not referenced */
 	{ PR_2_HTREE_NOTREF,
 	  N_("@p @h %d: node (%B) not referenced\n"),
@@ -1197,7 +1197,7 @@ static struct e2fsck_problem problem_table[] = {
 	/* Clear invalid HTREE directory */
 	{ PR_2_HTREE_CLEAR,
 	  N_("@n @h %d (%q).  "), PROMPT_CLEAR_HTREE, 0 },
-		  
+
 	/* Bad block in htree interior node */
 	{ PR_2_HTREE_BADBLK,
 	  N_("@p @h %d (%q): bad @b number %b.\n"),
@@ -1232,22 +1232,22 @@ static struct e2fsck_problem problem_table[] = {
 	{ PR_2_HTREE_BAD_DEPTH,
 	  N_("@p @h %d: node (%B) has @n depth\n"),
 	  PROMPT_NONE, 0 },
-	
+
 	/* Duplicate directory entry found */
 	{ PR_2_DUPLICATE_DIRENT,
 	  N_("Duplicate @E found.  "),
 	  PROMPT_CLEAR, 0 },
-	
+
 	/* Non-unique filename found */
 	{ PR_2_NON_UNIQUE_FILE, /* xgettext: no-c-format */
 	  N_("@E has a non-unique filename.\nRename to %s"),
 	  PROMPT_NULL, 0 },
-	
+
 	/* Duplicate directory entry found */
 	{ PR_2_REPORT_DUP_DIRENT,
 	  N_("Duplicate @e '%Dn' found.\n\tMarking %p (%i) to be rebuilt.\n\n"),
 	  PROMPT_NONE, 0 },
-	
+
   	/* i_blocks_hi should be zero */
 	{ PR_2_BLOCKS_HI_ZERO,
 	  N_("i_blocks_hi @F %N, @s zero.\n"),
@@ -1256,7 +1256,7 @@ static struct e2fsck_problem problem_table[] = {
 	/* Unexpected HTREE block */
 	{ PR_2_UNEXPECTED_HTREE_BLOCK,
 	  N_("Unexpected @b in @h %d (%q).\n"), PROMPT_CLEAR_HTREE, 0 },
-		  
+
 	/* Inode found in group where _INODE_UNINIT is set */
 	{ PR_2_INOREF_BG_INO_UNINIT,
 	  N_("@i %i found in @g %g where _INODE_UNINIT is set.  "),
@@ -1273,12 +1273,12 @@ static struct e2fsck_problem problem_table[] = {
 	{ PR_3_PASS_HEADER,
 	  N_("Pass 3: Checking @d connectivity\n"),
 	  PROMPT_NONE, 0 },
-		  
+
 	/* Root inode not allocated */
 	{ PR_3_NO_ROOT_INODE,
 	  N_("@r not allocated.  "),
-	  PROMPT_ALLOCATE, 0 },	
-		  
+	  PROMPT_ALLOCATE, 0 },
+
 	/* No room in lost+found */
 	{ PR_3_EXPAND_LF_DIR,
 	  N_("No room in @l @d.  "),
@@ -1320,20 +1320,20 @@ static struct e2fsck_problem problem_table[] = {
 	  PROMPT_NONE, 0 },
 
 	/* Error in ext2fs_new_block while creating /lost+found */
-	{ PR_3_ERR_LPF_NEW_BLOCK, 
+	{ PR_3_ERR_LPF_NEW_BLOCK,
 	  N_("ext2fs_new_@b: %m while trying to create /@l @d\n"),
 	  PROMPT_NONE, 0 },
-		  
+
 	/* Error in ext2fs_new_inode while creating /lost+found */
 	{ PR_3_ERR_LPF_NEW_INODE,
 	  N_("ext2fs_new_@i: %m while trying to create /@l @d\n"),
 	  PROMPT_NONE, 0 },
 
-	/* Error in ext2fs_new_dir_block while creating /lost+found */	  
+	/* Error in ext2fs_new_dir_block while creating /lost+found */
 	{ PR_3_ERR_LPF_NEW_DIR_BLOCK,
 	  N_("ext2fs_new_dir_@b: %m while creating new @d @b\n"),
 	  PROMPT_NONE, 0 },
-		  
+
 	/* Error while writing directory block for /lost+found */
 	{ PR_3_ERR_LPF_WRITE_BLOCK,
 	  N_("ext2fs_write_dir_@b: %m while writing the @d @b for /@l\n"),
@@ -1349,7 +1349,7 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("Couldn't fix parent of @i %i: %m\n\n"),
 	  PROMPT_NONE, 0 },
 
-	/* Couldn't fix parent directory -- couldn't find it */	  
+	/* Couldn't fix parent directory -- couldn't find it */
 	{ PR_3_FIX_PARENT_NOFIND,
 	  N_("Couldn't fix parent of @i %i: Couldn't find parent @d @e\n\n"),
 	  PROMPT_NONE, 0 },
@@ -1362,22 +1362,22 @@ static struct e2fsck_problem problem_table[] = {
 	/* Error creating root directory */
 	{ PR_3_CREATE_ROOT_ERROR,
 	  N_("Error creating root @d (%s): %m\n"),
-	  PROMPT_NONE, PR_FATAL },	  
+	  PROMPT_NONE, PR_FATAL },
 
 	/* Error creating lost and found directory */
 	{ PR_3_CREATE_LPF_ERROR,
 	  N_("Error creating /@l @d (%s): %m\n"),
-	  PROMPT_NONE, PR_FATAL },  
+	  PROMPT_NONE, PR_FATAL },
 
 	/* Root inode is not directory; aborting */
 	{ PR_3_ROOT_NOT_DIR_ABORT,
 	  N_("@r is not a @d; aborting.\n"),
-	  PROMPT_NONE, PR_FATAL },  
+	  PROMPT_NONE, PR_FATAL },
 
 	/* Cannot proceed without a root inode. */
 	{ PR_3_NO_ROOT_INODE_ABORT,
 	  N_("Cannot proceed without a @r.\n"),
-	  PROMPT_NONE, PR_FATAL },  
+	  PROMPT_NONE, PR_FATAL },
 
 	/* Internal error: couldn't find dir_info */
 	{ PR_3_NO_DIRINFO,
@@ -1415,19 +1415,19 @@ static struct e2fsck_problem problem_table[] = {
 	{ PR_3A_OPTIMIZE_DIR,
 	  " %d",
 	  PROMPT_NONE, PR_LATCH_OPTIMIZE_DIR | PR_PREEN_NOHDR},
-		  
-	/* Rehashing dir end */	  
+
+	/* Rehashing dir end */
 	{ PR_3A_OPTIMIZE_DIR_END,
 	  "\n",
 	  PROMPT_NONE, PR_PREEN_NOHDR },
 
 	/* Pass 4 errors */
-	
+
 	/* Pass 4: Checking reference counts */
 	{ PR_4_PASS_HEADER,
 	  N_("Pass 4: Checking reference counts\n"),
 	  PROMPT_NONE, 0 },
-		  
+
 	/* Unattached zero-length inode */
 	{ PR_4_ZERO_LEN_INODE,
 	  N_("@u @z @i %i.  "),
@@ -1451,22 +1451,22 @@ static struct e2fsck_problem problem_table[] = {
 	  PROMPT_NONE, 0 },
 
 	/* Pass 5 errors */
-		  
+
 	/* Pass 5: Checking group summary information */
 	{ PR_5_PASS_HEADER,
 	  N_("Pass 5: Checking @g summary information\n"),
 	  PROMPT_NONE, 0 },
-		  
+
 	/* Padding at end of inode bitmap is not set. */
 	{ PR_5_INODE_BMAP_PADDING,
 	  N_("Padding at end of @i @B is not set. "),
 	  PROMPT_FIX, PR_PREEN_OK },
-		  
+
 	/* Padding at end of block bitmap is not set. */
 	{ PR_5_BLOCK_BMAP_PADDING,
 	  N_("Padding at end of @b @B is not set. "),
 	  PROMPT_FIX, PR_PREEN_OK },
-		
+
 	/* Block bitmap differences header */
 	{ PR_5_BLOCK_BITMAP_HEADER,
 	  N_("@b @B differences: "),
@@ -1476,13 +1476,13 @@ static struct e2fsck_problem problem_table[] = {
 	{ PR_5_BLOCK_UNUSED,
 	  " -%b",
 	  PROMPT_NONE, PR_LATCH_BBITMAP | PR_PREEN_OK | PR_PREEN_NOMSG },
-		  
+
 	/* Block used, but not marked used in bitmap */
 	{ PR_5_BLOCK_USED,
 	  " +%b",
 	  PROMPT_NONE, PR_LATCH_BBITMAP | PR_PREEN_OK | PR_PREEN_NOMSG },
 
-	/* Block bitmap differences end */	  
+	/* Block bitmap differences end */
 	{ PR_5_BLOCK_BITMAP_END,
 	  "\n",
 	  PROMPT_FIX, PR_PREEN_OK | PR_PREEN_NOMSG },
@@ -1496,13 +1496,13 @@ static struct e2fsck_problem problem_table[] = {
 	{ PR_5_INODE_UNUSED,
 	  " -%i",
 	  PROMPT_NONE, PR_LATCH_IBITMAP | PR_PREEN_OK | PR_PREEN_NOMSG },
-		  
+
 	/* Inode used, but not marked used in bitmap */
 	{ PR_5_INODE_USED,
 	  " +%i",
 	  PROMPT_NONE, PR_LATCH_IBITMAP | PR_PREEN_OK | PR_PREEN_NOMSG },
 
-	/* Inode bitmap differences end */	  
+	/* Inode bitmap differences end */
 	{ PR_5_INODE_BITMAP_END,
 	  "\n",
 	  PROMPT_FIX, PR_PREEN_OK | PR_PREEN_NOMSG },
@@ -1541,7 +1541,7 @@ static struct e2fsck_problem problem_table[] = {
 	/* Internal error: fudging end of bitmap */
 	{ PR_5_FUDGE_BITMAP_ERROR,
 	  N_("Internal error: fudging end of bitmap (%N)\n"),
-	  PROMPT_NONE, PR_FATAL },	  
+	  PROMPT_NONE, PR_FATAL },
 
 	/* Error copying in replacement inode bitmap */
 	{ PR_5_COPY_IBITMAP_ERROR,
@@ -1552,12 +1552,12 @@ static struct e2fsck_problem problem_table[] = {
 	{ PR_5_COPY_BBITMAP_ERROR,
 	  N_("Error copying in replacement @b @B: %m\n"),
 	  PROMPT_NONE, PR_FATAL },
-		  
+
 	/* Block range not used, but marked in bitmap */
 	{ PR_5_BLOCK_RANGE_UNUSED,
 	  " -(%b--%c)",
 	  PROMPT_NONE, PR_LATCH_BBITMAP | PR_PREEN_OK | PR_PREEN_NOMSG },
-		  
+
 	/* Block range used, but not marked used in bitmap */
 	{ PR_5_BLOCK_RANGE_USED,
 	  " +(%b--%c)",
@@ -1567,7 +1567,7 @@ static struct e2fsck_problem problem_table[] = {
 	{ PR_5_INODE_RANGE_UNUSED,
 	  " -(%i--%j)",
 	  PROMPT_NONE, PR_LATCH_IBITMAP | PR_PREEN_OK | PR_PREEN_NOMSG },
-		  
+
 	/* Inode range used, but not marked used in bitmap */
 	{ PR_5_INODE_RANGE_USED,
 	  " +(%i--%j)",
@@ -1637,7 +1637,7 @@ int end_problem_latch(e2fsck_t ctx, int mask)
 	struct latch_descr *ldesc;
 	struct problem_context pctx;
 	int answer = -1;
-	
+
 	ldesc = find_latch(mask);
 	if (ldesc->end_message && (ldesc->flags & PRL_LATCHED)) {
 		clear_problem_context(&pctx);
@@ -1677,7 +1677,7 @@ void clear_problem_context(struct problem_context *ctx)
 	ctx->group = -1;
 }
 
-static void reconfigure_bool(e2fsck_t ctx, struct e2fsck_problem *ptr, 
+static void reconfigure_bool(e2fsck_t ctx, struct e2fsck_problem *ptr,
 			     const char *key, int mask, const char *name)
 {
 	int	bool;
@@ -1794,11 +1794,11 @@ int fix_problem(e2fsck_t ctx, problem_t code, struct problem_context *pctx)
 			answer = ask(ctx, _(prompt[(int) ptr->prompt]), def_yn);
 		if (!answer && !(ptr->flags & PR_NO_OK))
 			ext2fs_unmark_valid(fs);
-	
+
 		if (print_answer)
 			printf("%s.\n", answer ?
 			       _(preen_msg[(int) ptr->prompt]) : _("IGNORED"));
-	
+
 	}
 
 	if ((ptr->prompt == PROMPT_ABORT) && answer)
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 7993203..ab5c4df 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -82,12 +82,12 @@ struct problem_context {
 /* Adding UUID to filesystem */
 #define PR_0_ADD_UUID		0x000009
 
-/* Relocate hint */	
+/* Relocate hint */
 #define PR_0_RELOCATE_HINT	0x00000A
 
 /* Miscellaneous superblock corruption */
 #define PR_0_MISC_CORRUPT_SUPER	0x00000B
-	
+
 /* Error determing physical device size of filesystem */
 #define PR_0_GETSIZE_ERROR	0x00000C
 
@@ -135,13 +135,13 @@ struct problem_context {
 
 /* Clearing orphan inode */
 #define PR_0_ORPHAN_CLEAR_INODE			0x000020
-	
+
 /* Illegal block found in orphaned inode */
 #define PR_0_ORPHAN_ILLEGAL_BLOCK_NUM		0x000021
 
 /* Already cleared block found in orphaned inode */
 #define PR_0_ORPHAN_ALREADY_CLEARED_BLOCK	0x000022
-	
+
 /* Illegal orphan inode in superblock */
 #define PR_0_ORPHAN_ILLEGAL_HEAD_INODE		0x000023
 
@@ -268,7 +268,7 @@ struct problem_context {
 
 /* Too many bad blocks in inode */
 #define	PR_1_TOO_MANY_BAD_BLOCKS 	0x010011
-	
+
 /* Illegal block number in bad block inode */
 #define PR_1_BB_ILLEGAL_BLOCK_NUM 	0x010012
 
@@ -277,16 +277,16 @@ struct problem_context {
 
 /* Duplicate or bad blocks in use! */
 #define PR_1_DUP_BLOCKS_PREENSTOP	0x010014
-	
-/* Bad block used as bad block indirect block */	  
+
+/* Bad block used as bad block indirect block */
 #define PR_1_BBINODE_BAD_METABLOCK	0x010015
 
 /* Inconsistency can't be fixed prompt */
 #define PR_1_BBINODE_BAD_METABLOCK_PROMPT 0x010016
-	
+
 /* Bad primary block */
 #define PR_1_BAD_PRIMARY_BLOCK		0x010017
-		  
+
 /* Bad primary block prompt */
 #define PR_1_BAD_PRIMARY_BLOCK_PROMPT	0x010018
 
@@ -302,24 +302,24 @@ struct problem_context {
 /* Bad block group descriptors in group */
 #define PR_1_BAD_GROUP_DESCRIPTORS	0x01001C
 
-/* Block claimed for no reason */	  
+/* Block claimed for no reason */
 #define PR_1_PROGERR_CLAIMED_BLOCK	0x01001D
 
 /* Error allocating blocks for relocating metadata */
 #define PR_1_RELOC_BLOCK_ALLOCATE	0x01001E
-		
+
 /* Error allocating block buffer during relocation process */
 #define PR_1_RELOC_MEMORY_ALLOCATE	0x01001F
-		
-/* Relocating metadata group information from X to Y */	
+
+/* Relocating metadata group information from X to Y */
 #define PR_1_RELOC_FROM_TO		0x010020
-		
+
 /* Relocating metatdata group information to X */
 #define PR_1_RELOC_TO			0x010021
-		
+
 /* Block read error during relocation process */
 #define PR_1_RELOC_READ_ERR		0x010022
-		
+
 /* Block write error during relocation process */
 #define PR_1_RELOC_WRITE_ERR		0x010023
 
@@ -331,7 +331,7 @@ struct problem_context {
 
 /* Error allocating icount structure */
 #define PR_1_ALLOCATE_ICOUNT		0x010026
-	
+
 /* Error allocating dbcount */
 #define PR_1_ALLOCATE_DBCOUNT		0x010027
 
@@ -341,10 +341,10 @@ struct problem_context {
 /* Error while iterating over blocks */
 #define PR_1_BLOCK_ITERATE		0x010029
 
-/* Error while storing inode count information */	  
+/* Error while storing inode count information */
 #define PR_1_ICOUNT_STORE		0x01002A
 
-/* Error while storing directory block information */	  
+/* Error while storing directory block information */
 #define PR_1_ADD_DBLOCK			0x01002B
 
 /* Error while reading inode (for clearing) */
@@ -382,7 +382,7 @@ struct problem_context {
 
 /* Error allocating refcount structure */
 #define PR_1_ALLOCATE_REFCOUNT		0x010038
-	
+
 /* Error reading Extended Attribute block */
 #define PR_1_READ_EA_BLOCK		0x010039
 
@@ -395,7 +395,7 @@ struct problem_context {
 /* Extended attribute reference count incorrect */
 #define PR_1_EXTATTR_REFCOUNT		0x01003C
 
-/* Error writing Extended Attribute block while fixing refcount */ 
+/* Error writing Extended Attribute block while fixing refcount */
 #define PR_1_EXTATTR_WRITE		0x01003D
 
 /* Multiple EA blocks not supported */
@@ -428,19 +428,19 @@ struct problem_context {
 /* INDEX_FL flag set on a non-HTREE filesystem */
 #define PR_1_HTREE_SET			0x010047
 
-/* INDEX_FL flag set on a non-directory */	
+/* INDEX_FL flag set on a non-directory */
 #define PR_1_HTREE_NODIR		0x010048
 
-/* Invalid root node in HTREE directory */	
+/* Invalid root node in HTREE directory */
 #define PR_1_HTREE_BADROOT		0x010049
 
-/* Unsupported hash version in HTREE directory */	
+/* Unsupported hash version in HTREE directory */
 #define PR_1_HTREE_HASHV		0x01004A
 
-/* Incompatible flag in HTREE root node */	
+/* Incompatible flag in HTREE root node */
 #define PR_1_HTREE_INCOMPAT		0x01004B
 
-/* HTREE too deep */	
+/* HTREE too deep */
 #define PR_1_HTREE_DEPTH		0x01004C
 
 /* Bad block has indirect block that conflicts with filesystem block */
@@ -449,7 +449,7 @@ struct problem_context {
 /* Resize inode failed */
 #define PR_1_RESIZE_INODE_CREATE	0x01004E
 
-/* inode->i_size is too long */	
+/* inode->i_size is too long */
 #define PR_1_EXTRA_ISIZE		0x01004F
 
 /* attribute name is too long */
@@ -509,7 +509,7 @@ struct problem_context {
 
 /* Duplicate/bad block(s) end */
 #define PR_1B_DUP_BLOCK_END	0x011003
-	
+
 /* Error while scanning inodes */
 #define PR_1B_ISCAN_ERROR	0x011004
 
@@ -533,13 +533,13 @@ struct problem_context {
 /* File has duplicate blocks */
 #define PR_1D_DUP_FILE		0x013001
 
-/* List of files sharing duplicate blocks */	
+/* List of files sharing duplicate blocks */
 #define PR_1D_DUP_FILE_LIST	0x013002
 
-/* File sharing blocks with filesystem metadata  */	
+/* File sharing blocks with filesystem metadata  */
 #define PR_1D_SHARE_METADATA	0x013003
 
-/* Report of how many duplicate/bad inodes */	
+/* Report of how many duplicate/bad inodes */
 #define PR_1D_NUM_DUP_INODES	0x013004
 
 /* Duplicated blocks already reassigned or cloned. */
@@ -553,7 +553,7 @@ struct problem_context {
 
 /* Couldn't clone file (error) */
 #define PR_1D_CLONE_ERROR	0x013008
-		
+
 /*
  * Pass 2 errors
  */
@@ -585,10 +585,10 @@ struct problem_context {
 /* Directory entry has illegal characters in its name */
 #define PR_2_BAD_NAME		0x020008
 
-/* Missing '.' in directory inode */	  
+/* Missing '.' in directory inode */
 #define PR_2_MISSING_DOT	0x020009
 
-/* Missing '..' in directory inode */	  
+/* Missing '..' in directory inode */
 #define PR_2_MISSING_DOT_DOT	0x02000A
 
 /* First entry in directory inode doesn't contain '.' */
@@ -611,16 +611,16 @@ struct problem_context {
 
 /* i_fsize should be zero */
 #define PR_2_FSIZE_ZERO		0x020011
-		  
+
 /* inode has bad mode */
 #define PR_2_BAD_MODE		0x020012
 
 /* directory corrupted */
 #define PR_2_DIR_CORRUPTED	0x020013
-		  
+
 /* filename too long */
 #define PR_2_FILENAME_LONG	0x020014
-		  
+
 /* Directory inode has a missing block (hole) */
 #define PR_2_DIRECTORY_HOLE	0x020015
 
@@ -641,7 +641,7 @@ struct problem_context {
 
 /* Duplicate '..' entry */
 #define PR_2_DUP_DOT_DOT	0x02001B
-	
+
 /* Internal error: couldn't find dir_info */
 #define PR_2_NO_DIRINFO		0x02001C
 
@@ -796,9 +796,9 @@ struct problem_context {
 /* Error in ext2fs_new_inode while creating /lost+found */
 #define PR_3_ERR_LPF_NEW_INODE		0x03000B
 
-/* Error in ext2fs_new_dir_block while creating /lost+found */	  
+/* Error in ext2fs_new_dir_block while creating /lost+found */
 #define PR_3_ERR_LPF_NEW_DIR_BLOCK	0x03000C
-		  
+
 /* Error while writing directory block for /lost+found */
 #define PR_3_ERR_LPF_WRITE_BLOCK	0x03000D
 
@@ -808,12 +808,12 @@ struct problem_context {
 /* Couldn't fix parent directory -- error */
 #define PR_3_FIX_PARENT_ERR		0x03000F
 
-/* Couldn't fix parent directory -- couldn't find it */	  
+/* Couldn't fix parent directory -- couldn't find it */
 #define PR_3_FIX_PARENT_NOFIND		0x030010
-	
+
 /* Error allocating inode bitmap */
 #define PR_3_ALLOCATE_IBITMAP_ERROR	0x030011
-		  
+
 /* Error creating root directory */
 #define PR_3_CREATE_ROOT_ERROR		0x030012
 
@@ -842,15 +842,15 @@ struct problem_context {
 #define PR_3A_OPTIMIZE_ITER		0x031001
 
 /* Error rehash directory */
-#define PR_3A_OPTIMIZE_DIR_ERR		0x031002		
+#define PR_3A_OPTIMIZE_DIR_ERR		0x031002
 
 /* Rehashing dir header */
 #define PR_3A_OPTIMIZE_DIR_HEADER		0x031003
 
 /* Rehashing directory %d */
 #define PR_3A_OPTIMIZE_DIR		0x031004
-		  
-/* Rehashing dir end */	  
+
+/* Rehashing dir end */
 #define PR_3A_OPTIMIZE_DIR_END		0x031005
 
 /*
@@ -878,7 +878,7 @@ struct problem_context {
 
 /* Pass 5: Checking group summary information */
 #define PR_5_PASS_HEADER		0x050000
-	
+
 /* Padding at end of inode bitmap is not set. */
 #define PR_5_INODE_BMAP_PADDING		0x050001
 
@@ -890,11 +890,11 @@ struct problem_context {
 
 /* Block not used, but marked in bitmap */
 #define PR_5_BLOCK_UNUSED		0x050004
-	  
+
 /* Block used, but not marked used in bitmap */
 #define PR_5_BLOCK_USED			0x050005
 
-/* Block bitmap differences end */	  
+/* Block bitmap differences end */
 #define PR_5_BLOCK_BITMAP_END		0x050006
 
 /* Inode bitmap differences header */
@@ -902,11 +902,11 @@ struct problem_context {
 
 /* Inode not used, but marked in bitmap */
 #define PR_5_INODE_UNUSED		0x050008
-	  
+
 /* Inode used, but not marked used in bitmap */
 #define PR_5_INODE_USED			0x050009
 
-/* Inode bitmap differences end */	  
+/* Inode bitmap differences end */
 #define PR_5_INODE_BITMAP_END		0x05000A
 
 /* Free inodes count for group wrong */
@@ -938,7 +938,7 @@ struct problem_context {
 
 /* Block range not used, but marked in bitmap */
 #define PR_5_BLOCK_RANGE_UNUSED		0x050014
-	  
+
 /* Block range used, but not marked used in bitmap */
 #define PR_5_BLOCK_RANGE_USED		0x050015
 
@@ -972,6 +972,6 @@ void clear_problem_context(struct problem_context *ctx);
 
 /* message.c */
 void print_e2fsck_message(e2fsck_t ctx, const char *msg,
-			  struct problem_context *pctx, int first, 
+			  struct problem_context *pctx, int first,
 			  int recurse);
 
-- 
1.5.4.1.144.gdfee-dirty

