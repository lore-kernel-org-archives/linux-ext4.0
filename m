From: Jan Kara <jack@suse.cz>
Subject: Re: ext2_discard_prealloc() called on each iput?
Date: Tue, 29 May 2007 12:25:45 +0200
Message-ID: <20070529102544.GA25278@duck.suse.cz>
References: <20070522161127.GC13633@duck.suse.cz> <20070523123743.GD5608@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="3MwIy2ne0vdjdPXF"
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:52464 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754407AbXE2KOC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 May 2007 06:14:02 -0400
Content-Disposition: inline
In-Reply-To: <20070523123743.GD5608@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed 23-05-07 08:37:43, Theodore Tso wrote:
> >   Also I found slightly misleading the comment at ext2_release_file().
> > As far as I understand the code it isn't when /all/ files are closed but
> > rather when all fd's for given filp are closed. I.e. if you open the same
> > file two times, ->release will get called once for each open. Am I right?
  <snip>
> still patches to fix the comments might not be a bad idea, since it
> might save confusion by others later on.
  OK, attached is a patch that fixes the comment. Andrew, please put it
into your patch queue... Thanks.

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs

--3MwIy2ne0vdjdPXF
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="ext2-2.6.21-1-comment_fix.diff"

Fix a comment when ext2_release_file() is called.

Signed-off-by: Jan Kara <jack@suse.cz>

diff -rupX /home/jack/.kerndiffexclude linux-2.6.21/fs/ext2/file.c linux-2.6.21-1-ext2_comment_fix/fs/ext2/file.c
--- linux-2.6.21/fs/ext2/file.c	2007-05-15 14:18:47.000000000 +0200
+++ linux-2.6.21-1-ext2_comment_fix/fs/ext2/file.c	2007-05-29 12:15:59.000000000 +0200
@@ -24,9 +24,9 @@
 #include "acl.h"
 
 /*
- * Called when an inode is released. Note that this is different
- * from ext2_open_file: open gets called at every open, but release
- * gets called only when /all/ the files are closed.
+ * Called when filp is released. This happens when all file descriptors
+ * for a single struct file are closed. Note that different open() calls
+ * for the same file yield different struct file structures.
  */
 static int ext2_release_file (struct inode * inode, struct file * filp)
 {

--3MwIy2ne0vdjdPXF--
