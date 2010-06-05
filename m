From: tytso@mit.edu
Subject: Re: [PATCH 1/2] ext4: force block allocation on quota_off
Date: Sat, 5 Jun 2010 10:55:30 -0400
Message-ID: <20100605145530.GA9159@thunk.org>
References: <20100531191130.GE5334@quack.suse.cz>
 <1275377988-4299-1-git-send-email-dmonakhov@openvz.org>
 <20100601121107.GE4275@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:50922 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756622Ab0FEOzj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 5 Jun 2010 10:55:39 -0400
Content-Disposition: inline
In-Reply-To: <20100601121107.GE4275@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 01, 2010 at 02:11:08PM +0200, Jan Kara wrote:
> On Tue 01-06-10 11:39:47, Dmitry Monakhov wrote:
> > Perform full sync procedure to guarantee quota consistency.
>   The patch looks OK to me. Acked-by: Jan Kara <jack@suse.cz>
> Ted, will you merge it or should I do it?

I'll take it, but I don't think either of these is critical enough to
merge now that the merge window is closed.  Agreed?

      	       	   	 	   - Ted
