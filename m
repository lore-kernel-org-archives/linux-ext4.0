From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/5] ext4: Remove bogus wait for unwritten extents in
 ext4_ind_direct_IO
Date: Thu, 17 Jan 2013 16:58:14 -0500
Message-ID: <20130117215814.GA7356@thunk.org>
References: <1357148744-4895-1-git-send-email-jack@suse.cz>
 <1357148744-4895-4-git-send-email-jack@suse.cz>
 <20130104072437.GC31130@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44071 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754033Ab3AQV6S (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Jan 2013 16:58:18 -0500
Content-Disposition: inline
In-Reply-To: <20130104072437.GC31130@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 04, 2013 at 03:24:37PM +0800, Zheng Liu wrote:
> On Wed, Jan 02, 2013 at 06:45:42PM +0100, Jan Kara wrote:
> > When using indirect blocks there is no possibility to have any unwritten
> > extents. So wait for them in ext4_ind_direct_IO() is just bogus.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> Hi Jan,
> 
> Just for the note, this patch conflicts with my patch set of extent
> status tree.  I guess your patch series will be applied before my patch
> set.  So I will rebase my patch set against the latest kernel. :-)

Actually, the extent status tree patches are already in my tree,
although I'm still testing and reviewing them. so they haven't been
finalized yet (which is why I haven't sent an e-mail ack).  If the
conflict is minor, I'll take care of it.  If it's non-trivial, I'll
yell for help.  :-)

					- Ted
