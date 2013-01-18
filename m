From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 3/5] ext4: Remove bogus wait for unwritten extents in
 ext4_ind_direct_IO
Date: Fri, 18 Jan 2013 10:15:59 +0800
Message-ID: <20130118021558.GA2804@gmail.com>
References: <1357148744-4895-1-git-send-email-jack@suse.cz>
 <1357148744-4895-4-git-send-email-jack@suse.cz>
 <20130104072437.GC31130@gmail.com>
 <20130117215814.GA7356@thunk.org>
 <20130117230239.GA10127@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:46513 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008Ab3ARCCN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Jan 2013 21:02:13 -0500
Received: by mail-pb0-f54.google.com with SMTP id wz12so1748360pbc.27
        for <linux-ext4@vger.kernel.org>; Thu, 17 Jan 2013 18:02:13 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20130117230239.GA10127@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 18, 2013 at 12:02:39AM +0100, Jan Kara wrote:
> On Thu 17-01-13 16:58:14, Ted Tso wrote:
> > On Fri, Jan 04, 2013 at 03:24:37PM +0800, Zheng Liu wrote:
> > > On Wed, Jan 02, 2013 at 06:45:42PM +0100, Jan Kara wrote:
> > > > When using indirect blocks there is no possibility to have any unwritten
> > > > extents. So wait for them in ext4_ind_direct_IO() is just bogus.
> > > > 
> > > > Signed-off-by: Jan Kara <jack@suse.cz>
> > > 
> > > Hi Jan,
> > > 
> > > Just for the note, this patch conflicts with my patch set of extent
> > > status tree.  I guess your patch series will be applied before my patch
> > > set.  So I will rebase my patch set against the latest kernel. :-)
> > 
> > Actually, the extent status tree patches are already in my tree,
> > although I'm still testing and reviewing them. so they haven't been
> > finalized yet (which is why I haven't sent an e-mail ack).  If the
> > conflict is minor, I'll take care of it.  If it's non-trivial, I'll
> > yell for help.  :-)
>   This patch actually isn't in Zheng's latest submission so there shouldn't
> be any conflict.

Hi Ted,

Sorry for the delay reply because of travelling.  As Jan said above, I
have dropped the patch of unwritten extent conversion from the patch set
of extent status tree.  So there isn't any conflict.

Thanks,
                                                - Zheng
