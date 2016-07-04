From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC PATCH] coredump: avoid ext4 auto_da_alloc for core file
Date: Sun, 3 Jul 2016 22:24:55 -0400
Message-ID: <20160704022455.GA28883@thunk.org>
References: <5cdda475417b2719dced162cce89a283153cb818.1466012020.git.osandov@fb.com>
 <20160629183444.GA3030@vader>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, kernel-team@fb.com
To: Omar Sandoval <osandov@osandov.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160629183444.GA3030@vader>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 29, 2016 at 11:34:44AM -0700, Omar Sandoval wrote:
> > Someone at Facebook reported that their coredumps were much faster when
> > using a pipe helper than when dumping directly to a file, which doesn't
> > make much sense. It turns out that this difference is because in
> > do_coredump(), we truncate the core file and thus trigger the ext4
> > auto_da_alloc heuristic. We can't use O_TRUNC because we might bail out
> > of do_coredump() in certain conditions, so instead, avoid truncating
> > when the file is already empty. In cases where we're actually
> > overwriting a core file, this won't help, but the common case will be
> > much better.
> > 
> > Signed-off-by: Omar Sandoval <osandov@fb.com>
> > ---
> > Hi, Al and Ted,
> > 
> > This is probably the wrong solution to the problem I described in the
> > commit message. Do you guys have any better ideas? Something like
> > 0eab928221ba ("ext4: Don't treat a truncation of a zero-length file as
> > replace-via-truncate") would also work, but that apparently wasn't
> > right, as it was reverted in 5534fb5bb35a ("ext4: Fix the alloc on close
> > after a truncate hueristic").

Does this fix things for you?

						- Ted

>From bf21c027d84ded545d2c08fa01fd184d29641458 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Sun, 3 Jul 2016 22:20:49 -0400
Subject: [PATCH] ext4: in ext4_setattr(), only call ext4_truncate() if there is no data to drop

If there are no blocks associated with the inode (and no inline data),
there's no point calling ext4_truncate().  This avoids setting the
replace-via-truncate hueristic if there is an attempt to truncate a
file which is already zero-length --- which is something that happens
in the core dumping code, in case there is an already existing core
file.  In the comon case, there is not a previous core file, so by not
enabling the replace-via-truncate hueristic, we can speed up core
dumps.

Reported-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 44ee5d9..cd757f8 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5171,7 +5171,7 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 		 * in data=journal mode to make pages freeable.
 		 */
 		truncate_pagecache(inode, inode->i_size);
-		if (shrink)
+		if (shrink && (inode->i_blocks || ext4_has_inline_data(inode)))
 			ext4_truncate(inode);
 		up_write(&EXT4_I(inode)->i_mmap_sem);
 	}
-- 
2.5.0

