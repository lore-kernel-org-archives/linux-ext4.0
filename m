From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/4] ext4: Wait for proper transaction commit on fsync
Date: Wed, 9 Dec 2009 12:30:16 +0100
Message-ID: <20091209113016.GG4863@quack.suse.de>
References: <1256647729-29834-1-git-send-email-jack@suse.cz>
 <1256647729-29834-5-git-send-email-jack@suse.cz>
 <20091116004641.GM4323@mit.edu>
 <20091116104331.GB23231@duck.suse.cz>
 <20091209035120.GA27692@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52474 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418AbZLILaO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Dec 2009 06:30:14 -0500
Content-Disposition: inline
In-Reply-To: <20091209035120.GA27692@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 08-12-09 22:51:20, tytso@mit.edu wrote:
> On Mon, Nov 16, 2009 at 11:43:31AM +0100, Jan Kara wrote:
> > > Why do we need an atomic_t here at all?  It's not clear it's
> > > necessary.  What specific race are you worried about?
> >   Well, i_[data]sync_tid are set and read from several places which aren't
> > currently synchronized against each other and I din't want to introduce any
> > synchronization. So atomic_t seemed like a clean way of making clear that
> > loads / stores from those fields are atomic, regardless of architecture,
> > memory alignment or whatever insanity that might make us see just half
> > overwritten field.  On all archs where this means just plain stores / loads
> > (such as x86), there's no performance hit since the operations are
> > implemented as such.
> 
> Sorry for not responding to this one sooner, but see this URL:
> 
> http://digitalvampire.org/blog/index.php/2007/05/13/atomic-cargo-cults/
  Thanks for the pointer :) It's a good reading...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
