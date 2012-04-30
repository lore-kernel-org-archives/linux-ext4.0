From: Ted Ts'o <tytso@mit.edu>
Subject: Re: ext4: calculate and verify checksums of directory leaf blocks
Date: Mon, 30 Apr 2012 07:40:55 -0400
Message-ID: <20120430114054.GA28308@thunk.org>
References: <20120430110535.GA22505@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: djwong@us.ibm.com, linux-ext4@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54619 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441Ab2D3Ll1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Apr 2012 07:41:27 -0400
Content-Disposition: inline
In-Reply-To: <20120430110535.GA22505@elgon.mountain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 30, 2012 at 02:05:35PM +0300, Dan Carpenter wrote:
> Hello Darrick J. Wong,
> 
> This is a semi-automatic email about new static checker warnings.
> 
> The patch b0336e8d2108: "ext4: calculate and verify checksums of 
> directory leaf blocks" from Apr 29, 2012, leads to the following 
> Smatch complaint:
> 
> fs/ext4/namei.c:1615 add_dirent_to_buf()
> 	 warn: variable dereferenced before check 'inode' (see line 1577)
> 
> fs/ext4/namei.c
>   1575          if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
>                                                ^^^^^^^^^^^
> New dereference.
> 
>   1615		if (inode) {
>                     ^^^^^
> Old check.
> 
>   1616			de->inode = cpu_to_le32(inode->i_ino);
>   1617			ext4_set_de_type(dir->i_sb, de, inode->i_mode);

Dan, thanks for the heads up.

It *looks* to me like old check is unnecessary, and the else clause is
dead code that never executes.  As near as I can tell none of the
callers of add_dirent_to_buf() ever pass in a NULL inode pointer.  And
this tends to be confirmed by the fact that I ran Darrick's patches
through the xfs regression suite, and we never oops over the
dereference at line 1575.

Anyone see something which I missed?  As always, a double check would
be appreciated.  If not, I plan to add the following patch (see
below).

Thanks,

						- Ted

>From dec338b4d903f16c91b588d682f2f6f52cdf795a Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Mon, 30 Apr 2012 07:40:00 -0400
Subject: [PATCH] ext4: remove unnecessary check in add_dirent_to_buf()

None of this function callers ever pass in a NULL inode pointer, so
this check is unnecessary, and the else clause is dead code.  (This
change should make the code coverage people a little happier.  :-)

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/namei.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 5861d64..a9fd5f4 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1612,11 +1612,8 @@ static int add_dirent_to_buf(handle_t *handle, struct dentry *dentry,
 		de = de1;
 	}
 	de->file_type = EXT4_FT_UNKNOWN;
-	if (inode) {
-		de->inode = cpu_to_le32(inode->i_ino);
-		ext4_set_de_type(dir->i_sb, de, inode->i_mode);
-	} else
-		de->inode = 0;
+	de->inode = cpu_to_le32(inode->i_ino);
+	ext4_set_de_type(dir->i_sb, de, inode->i_mode);
 	de->name_len = namelen;
 	memcpy(de->name, name, namelen);
 	/*
-- 
1.7.10.rc3

