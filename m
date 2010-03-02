From: tytso@mit.edu
Subject: Re: [PATCH 1/2] ext4: quota_write cross block boundary behaviour
Date: Tue, 2 Mar 2010 08:15:32 -0500
Message-ID: <20100302131532.GF6077@thunk.org>
References: <1266338022-24298-1-git-send-email-dmonakhov@openvz.org>
 <20100216184654.GD3153@quack.suse.cz>
 <878wab6p3s.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:45978 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237Ab0CBNPe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Mar 2010 08:15:34 -0500
Content-Disposition: inline
In-Reply-To: <878wab6p3s.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 02, 2010 at 12:37:43PM +0300, Dmitry Monakhov wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> > On Tue 16-02-10 19:33:41, Dmitry Monakhov wrote:
> >> We always assume what dquot update result in changes in one data block
> >> But ext4_quota_write() function may handle cross block boundary writes
> >> In fact if this ever happen it will result in incorrect journal credits
> >> reservation. And later bug_on triggering. As soon this never happen the
> >> boundary cross loop is NOOP. In order to make things straight
> >> let's remove this loop and assert cross boundary condition.
> >> 
> >> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> >   Yeah, originally I thought it might be useful to support a possibility of
> > multiblock writes but in the end we never needed it and currently e.g. OCFS2
> > would already BUG on that so yes, this is a good simplification.
> >   Acked-by: Jan Kara <jack@suse.cz>
> >
> >   I've merged the ext3 version of the patch into my tree. Ted, will you
> > merge this ext4 cleanup please?
> Ted please take a look at the patch.

Sorry, I had lost track of this patch.  I've added it to the ext4 patch queue.

       	     	  	   		- Ted
