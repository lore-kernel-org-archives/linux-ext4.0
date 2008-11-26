From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V1] ext4: Use new buffer_head flag to check uninit
	group bitmaps initialization
Date: Wed, 26 Nov 2008 21:50:35 +0530
Message-ID: <20081126162035.GB28952@skywalker>
References: <1227711250-13934-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20081126155643.GA8741@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, Alex.Zhuravlev@Sun.COM,
	linux-ext4@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:36311 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbYKZQUp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Nov 2008 11:20:45 -0500
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp04.in.ibm.com (8.13.1/8.13.1) with ESMTP id mAQGKgL8023393
	for <linux-ext4@vger.kernel.org>; Wed, 26 Nov 2008 21:50:42 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mAQGKh0f3567618
	for <linux-ext4@vger.kernel.org>; Wed, 26 Nov 2008 21:50:43 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.13.1/8.13.3) with ESMTP id mAQGKfT8026656
	for <linux-ext4@vger.kernel.org>; Thu, 27 Nov 2008 03:20:42 +1100
Content-Disposition: inline
In-Reply-To: <20081126155643.GA8741@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 26, 2008 at 10:56:43AM -0500, Theodore Tso wrote:
> On Wed, Nov 26, 2008 at 08:24:10PM +0530, Aneesh Kumar K.V wrote:
> > diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> > index 4932b34..6694561 100644
> > --- a/include/linux/jbd2.h
> > +++ b/include/linux/jbd2.h
> > @@ -329,6 +329,7 @@ enum jbd_state_bits {
> >  	BH_State,		/* Pins most journal_head state */
> >  	BH_JournalHead,		/* Pins bh->b_private and jh->b_bh */
> >  	BH_Unshadow,		/* Dummy bit, for BJ_Shadow wakeup filtering */
> > +	BH_JBD_State_bits_End,
> >  };
> >  
> >  BUFFER_FNS(JBD, jbd)
> 
> Note: this conflicts with a patch by Mark Fasheh which does something
> very similar, since OCFS2 also needs some private BH flags.  He used
> the name BH_JBDPrivateStart, though.
> 
> Originally the plan was going to be that Mark was going to send this
> to Linus, but given that we need it as well, I suggest that we drop it
> into both the OCFS2 and ext4 trees, and whichever one hits Linus's
> tree first will win, and in the other case the magic of git's merge
> algorithms should make the right thing happen in the second.  (Or the
> other team can drop the patch before they merge; either will do the
> right thing.)
> 
> For this path, it would mean dropping this hunk and adding Mark's
> patch to the ext4 tree.  If this makes sense to everyone, Aneesh, you
> don't need to send a patch; I can fix up the one you sent easily
> enough.

Should be fine.

-aneesh
