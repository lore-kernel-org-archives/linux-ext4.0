From: tytso@mit.edu
Subject: Re: [PATCH 4/4] ext4: trivial quota cleanup
Date: Wed, 24 Feb 2010 11:55:32 -0500
Message-ID: <20100224165532.GG5166@thunk.org>
References: <1265115954-2616-1-git-send-email-dmonakhov@openvz.org>
 <1265115954-2616-2-git-send-email-dmonakhov@openvz.org>
 <1265115954-2616-3-git-send-email-dmonakhov@openvz.org>
 <1265115954-2616-4-git-send-email-dmonakhov@openvz.org>
 <20100202134604.GD7056@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:42511 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755821Ab0BXQze (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Feb 2010 11:55:34 -0500
Content-Disposition: inline
In-Reply-To: <20100202134604.GD7056@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 02, 2010 at 02:46:04PM +0100, Jan Kara wrote:
> On Tue 02-02-10 16:05:54, Dmitry Monakhov wrote:
> > The patch is aimed to reorganize and simplify quota code a bit.
> > Quota code is itself complex enouth, but we can make it more readable
> > in some places:
> > - Move quota option parsing to separate functions.
> > - Simplify old-quota and journaled-quota mix check.
> > 
> > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>   Looks good.
> 
> Acked-by: Jan Kara <jack@suse.cz>
> 

Added to the ext4 patch queue.

					- Ted
