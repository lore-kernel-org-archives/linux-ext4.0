From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH, RFC] fs: only call sync_filesystem() when remounting
 read-only
Date: Sat, 8 Mar 2014 11:08:18 -0500
Message-ID: <20140308160818.GC11633@thunk.org>
References: <20140305141343.GA26225@xanadu.blop.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	"linux-fsdevel@vger.kernel.org Emmanuel Jeanvoine"
	<emmanuel.jeanvoine@inria.fr>
To: Lucas Nussbaum <lucas.nussbaum@loria.fr>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38771 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555AbaCHQIW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Mar 2014 11:08:22 -0500
Content-Disposition: inline
In-Reply-To: <20140305141343.GA26225@xanadu.blop.info>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 05, 2014 at 03:13:43PM +0100, Lucas Nussbaum wrote:
> TL;DR: we experience long temporary hangs when doing multiple mount -o
> remount at the same time as other I/O on an ext4 filesystem.
> 
> When starting hundreds of LXC containers simultaneously on a system, the
> boot of some containers was hanging. We tracked this down to an
> initscript's use of mount -o remount, which was hanging in D state.
> 
> We reproduced the problem outside of LXC, with the script available at
> [0]. That script initiates 1000 mount -o remount, and performs some
> writes using a big cp to the same filesystem during the remounts....

+linux-fsdevel since the patch modifies fs/super.c

Lukas, can you try this patch?  I'm pretty sure this is what's going
on.  It turns out each "mount -o remount" is implying an fsync(), so
your test case is identical to copying a large file while having
thousand of processes calling syncfs() on the file system, with the
predictable results.

Folks on linux-fsdevel, any objections if I carry this patch in the
ext4 tree?  I don't think it should cause problems for other file
systems, since any file system that tries to rely on the implied
syncfs() is going to be subject to races, but it might make such a
race condition bug much more visible...

					- Ted

commit 8862c3c69acc205b59b00baed67e50446e2fd093
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sat Mar 8 11:05:35 2014 -0500

    fs: only call sync_filesystem() when remounting read-only
    
    Currently "mount -o remount" always implies an syncfs() on the file
    system.  This can cause a problem if a workload calls "mount -o
    remount" many, many times while concurrent I/O is happening:
    
       http://article.gmane.org/gmane.comp.file-systems.ext4/42876
    
    Whether it would ever be sane for a workload to call "mount -o
    remount" gazillions of times when they are effectively no-ops, it
    seems stupid for a remount to imply an fsync().
    
    It's possible that there is some file system which is relying on the
    implied fsync(), but that's arguably broken, since aside for the
    remount read-only case, there's nothing that will prevent other writes
    from sneaking in between the sync_filesystem() and the call to
    sb->s_op->remount_fs().
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/super.c b/fs/super.c
index 80d5cf2..0fc87ac 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -717,10 +717,9 @@ int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
 			if (retval)
 				return retval;
 		}
+		sync_filesystem(sb);
 	}
 
-	sync_filesystem(sb);
