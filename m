From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/5] ext4: Convert to generic reserved quota's space
 management. [V5]
Date: Mon, 14 Dec 2009 18:26:13 +0100
Message-ID: <20091214172613.GF4731@quack.suse.cz>
References: <1260793276-8511-1-git-send-email-dmonakhov@openvz.org>
 <1260793276-8511-2-git-send-email-dmonakhov@openvz.org>
 <1260793276-8511-3-git-send-email-dmonakhov@openvz.org>
 <20091214143551.GC4867@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53705 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932305AbZLNRzu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Dec 2009 12:55:50 -0500
Content-Disposition: inline
In-Reply-To: <20091214143551.GC4867@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 14-12-09 09:35:51, tytso@mit.edu wrote:
> On Mon, Dec 14, 2009 at 03:21:14PM +0300, Dmitry Monakhov wrote:
> > This patch fix write vs chown race condition.
> > 
> > Changes from V4
> >  - Coding style cleanup according to Jan's comment.
> > Changes from V2:
> >  - add missed i_reserved_quota iniatilization.
> > 
> > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> 
> Acked-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> Jan, I assume you'll push this along with the other quota-related
> changes out from your tree?  We have some ext4-related quota bugs that
> I think may be related to this fix (and a bunch of distros are
> planning on using 2.6.32), so if you could review this and get pushed
> this patch series pushed out for 2.6.32 it would be appreciated,
> thanks.
  Yes, I'll push it via my tree and take care of pushing into 2.6.32 stable
tree as well.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
