From: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: Ext4 tree backports for 2.6.27.13 and 2.6.28.2
Date: Wed, 11 Feb 2009 15:37:27 -0500
Message-ID: <20090211153727.008033fd@dhcp-100-2-144.bos.redhat.com>
References: <E1LT8MN-0003Ps-Ur@closure.thunk.org>
	<20090210183602.404ee561@dhcp-100-2-144.bos.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:56361 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757614AbZBKUkR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Feb 2009 15:40:17 -0500
In-Reply-To: <20090210183602.404ee561@dhcp-100-2-144.bos.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 10 Feb 2009 18:36:02 -0500
Chuck Ebbert <cebbert@redhat.com> wrote:

> On Sat, 31 Jan 2009 00:25:39 -0500
> "Theodore Ts'o" <tytso@mit.edu> wrote:
> 
> > I've updated the ext4 backport branches on the ext4 git tree:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git
> >    http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git
> > 
> > The for-stable branch is branched off of 2.6.28.2, and has a candidate
> > set of patches to be included in the next stable release.  The
> > for-stable-2.6.27 branch is branched off of 2.6.27.13.  
> > 
> > I'm more confident with the 2.6.28 stable candidate than the 2.6.27
> > stable candidates at the moment, but given that we just missed the
> > 2.6.27.14 and 2.6.28.3 release cycles, that should give us plenty of
> > time to test the patches.
> > 
> 
> .27 has a bug and one patch got merged in .27.14...
> 
> > 
> > mainline 2.6.28  2.6.27
> >     commit-description
> > -------------------------------------------------------------------------
> > c894058d -----   71ae3e25
> >     ext4: Use an rbtree for tracking blocks freed during transaction.
> > 
> 
> The chunk that creates the ext4_free_block_extents cache is misapplied: it
> ended up at the end of ext4_mb_use_preallocated() instead of
> init_ext4_mballoc(). The null cache pointer then causes oopses when trying
> to delete files.
> 

Here's the fix for that:


Move init of the ext4_free_block_extents cache to the right place.
Original patch that misapplies this is at:
http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=commitdiff;h=71ae3e256af82b77100bd2e7392fd510aca0b8b9
"ext4: Use an rbtree for tracking blocks freed during transaction."

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>

Index: linux-2.6.27.noarch/fs/ext4/mballoc.c
===================================================================
--- linux-2.6.27.noarch.orig/fs/ext4/mballoc.c
+++ linux-2.6.27.noarch/fs/ext4/mballoc.c
@@ -3060,6 +3060,16 @@ int __init init_ext4_mballoc(void)
 		kmem_cache_destroy(ext4_pspace_cachep);
 		return -ENOMEM;
 	}
+
+	ext4_free_ext_cachep =
+		kmem_cache_create("ext4_free_block_extents",
+				     sizeof(struct ext4_free_data),
+				     0, SLAB_RECLAIM_ACCOUNT, NULL);
+	if (ext4_free_ext_cachep == NULL) {
+		kmem_cache_destroy(ext4_pspace_cachep);
+		kmem_cache_destroy(ext4_ac_cachep);
+		return -ENOMEM;
+	}
 #ifdef CONFIG_PROC_FS
 	proc_root_ext4 = proc_mkdir("fs/ext4", NULL);
 	if (proc_root_ext4 == NULL)
@@ -3597,15 +3607,6 @@ ext4_mb_use_preallocated(struct ext4_all
 		return 1;
 	}
 
-	ext4_free_ext_cachep =
-		kmem_cache_create("ext4_free_block_extents",
-				     sizeof(struct ext4_free_data),
-				     0, SLAB_RECLAIM_ACCOUNT, NULL);
-	if (ext4_free_ext_cachep == NULL) {
-		kmem_cache_destroy(ext4_pspace_cachep);
-		kmem_cache_destroy(ext4_ac_cachep);
-		return -ENOMEM;
-	}
 	return 0;
 }
 
