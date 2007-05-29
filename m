From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: e2fsprogs coverity patch <cid-33.diff>
Date: Tue, 29 May 2007 17:10:25 -0600
Message-ID: <20070529231025.GH5181@schatzie.adilger.int>
References: <200702100211.l1A2BTRb007321@igsi.llnl.gov> <465C75A8.5080506@redhat.com> <20070529205141.GB5181@schatzie.adilger.int> <465C938C.3060101@redhat.com> <20070529222009.GA669@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	"Brian D. Behlendorf" <behlendorf1@llnl.gov>,
	linux-ext4@vger.kernel.org, wartens2@llnl.gov
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:58332 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbXE2XK0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 May 2007 19:10:26 -0400
Content-Disposition: inline
In-Reply-To: <20070529222009.GA669@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On May 29, 2007  18:20 -0400, Theodore Tso wrote:
> On Tue, May 29, 2007 at 03:56:44PM -0500, Eric Sandeen wrote:
> > >I still have it in my "apply atop 1.39-WIP" series, so it appears not
> > >to have made it into Ted's repo.  I'm including the patch again for
> > >posterity.
> > 
> > Thanks Andreas - near as I can tell, it never made it to the list.
> 
> Yeah, I wondered about that numbering discontinuity --- but IIRC it
> wasn't the only one.  I had assumed that the "missing" cid's were ones
> were human examination of the Coverity report lead to the conclusion
> that it really wasn't a problem....

I also have another outstanding patch:

===========================================================================
Coverity ID: 6: Forward Null

At the second conditional iter->file could still be NULL. We need to check for
it again.

Index: e2fsprogs+chaos/e2fsck/profile.c
===================================================================
--- e2fsprogs+chaos.orig/e2fsck/profile.c
+++ e2fsprogs+chaos/e2fsck/profile.c
@@ -1260,7 +1260,7 @@ errcode_t profile_node_iterator(void **i
 	 * If the file has changed, then the node pointer is invalid,
 	 * so we'll have search the file again looking for it.
 	 */
-	if (iter->node && (iter->file->upd_serial != iter->file_serial)) {
+	if (iter->node && (iter->file && iter->file->upd_serial != iter->file_serial)) {
 		iter->flags &= ~PROFILE_ITER_FINAL_SEEN;
 		skip_num = iter->num;
 		iter->node = 0;
===========================================================================

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
