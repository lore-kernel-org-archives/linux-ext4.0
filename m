From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd/jbd2: remove obsolete summarise_journal_usage.
Date: Mon, 9 May 2011 13:05:25 +0200
Message-ID: <20110509110525.GG4122@quack.suse.cz>
References: <1304610859-480-1-git-send-email-tm@tao.ma>
 <20110505161454.GM5323@quack.suse.cz>
 <20110509001441.GA4138@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Tao Ma <tm@tao.ma>,
	linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51849 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678Ab1EILF1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 May 2011 07:05:27 -0400
Content-Disposition: inline
In-Reply-To: <20110509001441.GA4138@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun 08-05-11 20:14:41, Ted Tso wrote:
> On Thu, May 05, 2011 at 06:14:54PM +0200, Jan Kara wrote:
> > On Thu 05-05-11 23:54:19, Tao Ma wrote:
> > > From: Tao Ma <boyu.mt@taobao.com>
> > > 
> > > summarise_journal_usage seems to be obsolete for a long time,
> > > so remove it.
> >   Yes. Added to my tree. Thanks.
> 
> Hi Jan,
> 
> Did you take the whole patch (removing it for both jbd and jbd2) or
> just for jbd?  I'm fine either way, I just want to know if I need to
> worry about this patch.
  I've taken both jbd and jbd2 parts (as I figured it's trivial enough and
won't conflict with anything anyway).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
