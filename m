From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH -V1] ext4: Use new buffer_head flag to check uninit
	group bitmaps initialization
Date: Wed, 26 Nov 2008 10:56:43 -0500
Message-ID: <20081126155643.GA8741@mit.edu>
References: <1227711250-13934-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, Alex.Zhuravlev@Sun.COM,
	linux-ext4@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:46229 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752393AbYKZP4t (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Nov 2008 10:56:49 -0500
Content-Disposition: inline
In-Reply-To: <1227711250-13934-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 26, 2008 at 08:24:10PM +0530, Aneesh Kumar K.V wrote:
> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index 4932b34..6694561 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -329,6 +329,7 @@ enum jbd_state_bits {
>  	BH_State,		/* Pins most journal_head state */
>  	BH_JournalHead,		/* Pins bh->b_private and jh->b_bh */
>  	BH_Unshadow,		/* Dummy bit, for BJ_Shadow wakeup filtering */
> +	BH_JBD_State_bits_End,
>  };
>  
>  BUFFER_FNS(JBD, jbd)

Note: this conflicts with a patch by Mark Fasheh which does something
very similar, since OCFS2 also needs some private BH flags.  He used
the name BH_JBDPrivateStart, though.

Originally the plan was going to be that Mark was going to send this
to Linus, but given that we need it as well, I suggest that we drop it
into both the OCFS2 and ext4 trees, and whichever one hits Linus's
tree first will win, and in the other case the magic of git's merge
algorithms should make the right thing happen in the second.  (Or the
other team can drop the patch before they merge; either will do the
right thing.)

For this path, it would mean dropping this hunk and adding Mark's
patch to the ext4 tree.  If this makes sense to everyone, Aneesh, you
don't need to send a patch; I can fix up the one you sent easily
enough.

						- Ted
