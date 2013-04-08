From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: optimize ext4_end_io memory usage
Date: Mon, 8 Apr 2013 23:38:44 +0200
Message-ID: <20130408213844.GC25878@quack.suse.cz>
References: <1364793468-1302-1-git-send-email-dmonakhov@openvz.org>
 <20130405093514.GA3848@quack.suse.cz>
 <20130408171052.GB4598@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Dmitry Monakhov <dmonakhov@openvz.org>,
	linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53931 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935728Ab3DHViq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Apr 2013 17:38:46 -0400
Content-Disposition: inline
In-Reply-To: <20130408171052.GB4598@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 08-04-13 13:10:52, Ted Tso wrote:
> On Fri, Apr 05, 2013 at 11:35:14AM +0200, Jan Kara wrote:
> > On Mon 01-04-13 09:17:48, Dmitry Monakhov wrote:
> > > ext4_end_io->pages array has is used only for buffered writes and usless
> > > in case of DIO. This patch allow us to save 1K for each DIO request.
> >   I have actually a more complete solution to this in my patch queue -
> > there isn't any need to reference pages from io_end after my patches.
> > Hopefully I'll be able to send things out later today...
> 
> Hi Jan,
> 
> Did you have a chance to send out your patches?
  Not on Friday but the patch bomb has landed just now (finally I was able
to sort out all the failures in dioread_nolock mode). I'd just note that
my version of Dmitry's patch is patch 1/29.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
