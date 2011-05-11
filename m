From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 0/3] Rewrite ext4_page_mkwrite, fix fs freezing
Date: Wed, 11 May 2011 09:48:36 -0700
Message-ID: <20110511164836.GG18929@tux1.beaverton.ibm.com>
References: <1305066574-1573-1-git-send-email-jack@suse.cz> <20110511003012.GC6933@thunk.org> <20110511092752.GA5057@quack.suse.cz>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Ted Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:38721 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757740Ab1EKQss (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 May 2011 12:48:48 -0400
Content-Disposition: inline
In-Reply-To: <20110511092752.GA5057@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 11, 2011 at 11:27:52AM +0200, Jan Kara wrote:
> On Tue 10-05-11 20:30:12, Ted Tso wrote:
> > On Wed, May 11, 2011 at 12:29:31AM +0200, Jan Kara wrote:
> > > 
> > >   following three patches reimplement ext4_page_mkwrite() so that it returns
> > > locked pages (which is necessary for stable pages work and also for fixing of
> > > freezing code). As a bonus we also avoid taking i_alloc_sem as it's not
> > > necessary and use generic block_page_mkwrite() helper. The common delalloc
> > > path should be more straightforward now.
> > 
> > How does this relate to Darrick Wong's patches?  Are your patches in
> > addition to or instead of his?
>   It's in addition to those (although with my patches, a generic change to
> block_page_mkwrite() would be enough for ext4). If you plan to merge those
> now, I can rediff on top of those patches.

Just to be clear, your new __block_page_mkwrite still needs a patch to call
wait_on_page_writeback to provide stable page writes, correct?

I think we'd still need a wait_on_page_writeback for the "all buffers are
mapped" VM_FAULT_LOCKED exit from ext4_page_mkwrite?

--D
