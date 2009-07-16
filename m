From: Jan Kara <jack@suse.cz>
Subject: Re: A tree to pull into linux-next
Date: Thu, 16 Jul 2009 12:45:47 +0200
Message-ID: <20090716104547.GA25725@duck.suse.cz>
References: <20090715193742.GA18583@duck.suse.cz> <20090716164826.f4edbd42.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Stephen Tweedie <sct@redhat.com>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@sun.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39064 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755149AbZGPKpu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Jul 2009 06:45:50 -0400
Content-Disposition: inline
In-Reply-To: <20090716164826.f4edbd42.sfr@canb.auug.org.au>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 16-07-09 16:48:26, Stephen Rothwell wrote:
> Hi Jan,
> 
> On Wed, 15 Jul 2009 21:37:42 +0200 Jan Kara <jack@suse.cz> wrote:
> >
> >   I've decided to create a tree through which I can occasionally merge
> > mainly ext3/JBD fixes (and possibly also fixes to filesystems which
> > don't have a maintainer). Hopefully this reduces chances that some patches
> > get lost on the way... Could you please start pulling the tree below to
> > linux-next? Thanks.
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs-2.6.git for_next
> 
> I am happy to include this, but (no offense) I would like to hear from
> the ext3 and jbd maintainers (cc'd) about it.
  Sure. BTW: Stephen Tweedie isn't doing ext3/jbd anymore for a few years
(probably we should remove him from MAINTAINERS)...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
