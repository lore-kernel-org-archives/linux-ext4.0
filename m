Return-Path: <SRS0=y2Es=52=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3522C352B6
	for <linux-ext4@archiver.kernel.org>; Fri, 10 Apr 2020 04:33:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A62BC20CC7
	for <linux-ext4@archiver.kernel.org>; Fri, 10 Apr 2020 04:33:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgDJEd2 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 10 Apr 2020 00:33:28 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:34677 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725844AbgDJEd2 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Apr 2020 00:33:28 -0400
Received: from callcc.thunk.org (pool-72-93-95-157.bstnma.fios.verizon.net [72.93.95.157])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 03A4XLVH013579
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Apr 2020 00:33:22 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 6F0BB42013D; Fri, 10 Apr 2020 00:33:21 -0400 (EDT)
Date:   Fri, 10 Apr 2020 00:33:21 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 2/2] ext2fs: Fix off-by-one in dx_grow_tree()
Message-ID: <20200410043321.GM45598@mit.edu>
References: <20200330090932.29445-1-jack@suse.cz>
 <20200330090932.29445-3-jack@suse.cz>
 <20200330132712.ckevhpof4vrsx5rw@work>
 <20200330145531.GF26544@quack2.suse.cz>
 <20200331113303.huhzo3jxdnhoupwv@work>
 <20200331143035.GB13528@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200331143035.GB13528@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Mar 31, 2020 at 04:30:35PM +0200, Jan Kara wrote:
> > > > Don't we have basically the same off-by-one in
> > > > e2fsck/pass1.c handle_htree() ?
> > > > 
> > > >        if ((root->indirect_levels > ext2_dir_htree_level(fs)) &&
> > > >            fix_problem(ctx, PR_1_HTREE_DEPTH, pctx))
> > > 
> > 
> > root->indirect_levels is zero based, while ext2_dir_htree_level()
> > returns the maximum number of levels (that is 3 by default). If I am
> > right then indirect_levels must always be smaller then
> > ext2_dir_htree_level() and that is how we use it everywhere else - the
> > palce I am pointing out is an exception and I think it's a bug.
> > 
> > Indeed it looks like the bug got introduced in
> > 3f0cf647539970474be8f607017ca7eccfc2fbbe
> > 
> > -       if ((root->indirect_levels > 1) &&
> > +       if ((root->indirect_levels > ext2_dir_htree_level(fs)) &&
> > 
> > Or am I missing something ?
> 
> Ah, you're indeed right! e2fsck/pass2.c even has a correct version of the
> condition. Just the condition in pass1.c is wrong.

I've applied the following fix on the maint branch.

     	     	 	       	      	    - Ted

commit 759b387775bfd5c9d3692680e5e4b929c3848d51
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Fri Apr 10 00:30:52 2020 -0400

    e2fsck: fix off-by-one check when validating depth of an htree
    
    Fixes: 3f0cf6475399 ("e2fsprogs: add support for 3-level htree")
    
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index c9e8bf82..38afda48 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2685,7 +2685,7 @@ static int handle_htree(e2fsck_t ctx, struct problem_context *pctx,
 		return 1;
 
 	pctx->num = root->indirect_levels;
-	if ((root->indirect_levels > ext2_dir_htree_level(fs)) &&
+	if ((root->indirect_levels >= ext2_dir_htree_level(fs)) &&
 	    fix_problem(ctx, PR_1_HTREE_DEPTH, pctx))
 		return 1;
 
