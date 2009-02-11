From: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: Ext4 tree backports for 2.6.27.13 and 2.6.28.2
Date: Wed, 11 Feb 2009 15:33:28 -0500
Message-ID: <20090211153328.37ef255f@dhcp-100-2-144.bos.redhat.com>
References: <E1LT8MN-0003Ps-Ur@closure.thunk.org>
	<20090211075914.GC20842@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:40065 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755473AbZBKUgC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Feb 2009 15:36:02 -0500
In-Reply-To: <20090211075914.GC20842@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 11 Feb 2009 13:29:14 +0530
"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:

> On Sat, Jan 31, 2009 at 12:25:39AM -0500, Theodore Ts'o wrote:
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
> > 						- Ted
> > 
> > 
> > 8556e8f3 18d5cb0 fd3bd090
> >     ext4: Don't allow new groups to be added during block allocation
> > 
> 
> This commit on for-stable-2.6.27 is not complete.
> ac->alloc_semp is not assigned in the code.
> 

I think this fixes that one:


Add missing pieces to the below patch in the 2.6.27 ext4 patchset.
http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=commitdiff;h=fd3bd090d7cc93292d3fa361b9c323752417bd7b
"ext4: Don't allow new groups to be added during block allocation"

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>

Index: linux-2.6.27.noarch/fs/ext4/mballoc.c
===================================================================
--- linux-2.6.27.noarch.orig/fs/ext4/mballoc.c
+++ linux-2.6.27.noarch/fs/ext4/mballoc.c
@@ -1055,7 +1055,8 @@ static void ext4_mb_release_desc(struct 
 	if (e4b->bd_buddy_page)
 		page_cache_release(e4b->bd_buddy_page);
 	/* Done with the buddy cache */
-	up_read(e4b->alloc_semp);
+	if (e4b->alloc_semp)
+		up_read(e4b->alloc_semp);
 }
 
 
@@ -1375,6 +1376,9 @@ static void ext4_mb_use_best_found(struc
 	get_page(ac->ac_bitmap_page);
 	ac->ac_buddy_page = e4b->bd_buddy_page;
 	get_page(ac->ac_buddy_page);
+	/* on allocation we use ac to track the held semaphore */
+	ac->alloc_semp =  e4b->alloc_semp;
+	e4b->alloc_semp = NULL;
 	/* store last allocated for subsequent stream allocation */
 	if ((ac->ac_flags & EXT4_MB_HINT_DATA)) {
 		spin_lock(&sbi->s_md_lock);
