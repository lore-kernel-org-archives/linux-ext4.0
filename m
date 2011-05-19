From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/3] Make block_page_mkwrite() handle frozen fs (V2)
Date: Thu, 19 May 2011 14:24:33 +0200
Message-ID: <20110519122433.GH8417@quack.suse.cz>
References: <1305731882-8334-1-git-send-email-jack@suse.cz>
 <20110518181321.GC10163@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
	tytso@mit.edu
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:34286 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360Ab1ESMYz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 May 2011 08:24:55 -0400
Content-Disposition: inline
In-Reply-To: <20110518181321.GC10163@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 18-05-11 14:13:21, Christoph Hellwig wrote:
> On Wed, May 18, 2011 at 05:17:59PM +0200, Jan Kara wrote:
> > from Christoph in the patches which resulted in some patch reorg. I'd like to
> > get these patches reviewed and then get them merged possibly via ext4-tree
> > (although the first two patches might go via Al but that would complicate
> > merging of ext4 part where I expect more conflicts with ongoing work).
> 
> The core canges are clear VFS tree material, and given that they are
> needed for the stable pages patches as well it really doesn't make sense
> to funnel this through a fs tree.  It might make sense to include the
> ext4 patch in the VFS pile if that makes merging easier.
  OK, I'll merge the first two patches via Al.

								Honza
