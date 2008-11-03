From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext3: wait on all pending commits in ext3_sync_fs
Date: Mon, 3 Nov 2008 16:19:29 -0500
Message-ID: <20081103211929.GA18117@mit.edu>
References: <4908C951.2000309@redhat.com> <20081103184426.GA31894@ajones-laptop.nbttech.com> <20081103113318.35b0c266.akpm@linux-foundation.org> <20081103201428.GB30565@ajones-laptop.nbttech.com> <20081103123750.67c96224.akpm@linux-foundation.org> <20081103205854.GC30565@ajones-laptop.nbttech.com> <20081103131313.e9ae2f93.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arthur Jones <ajones@riverbed.com>, sandeen@redhat.com,
	linux-ext4@vger.kernel.org, sct@redhat.com,
	linux-kernel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:49473 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753649AbYKCVTq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Nov 2008 16:19:46 -0500
Content-Disposition: inline
In-Reply-To: <20081103131313.e9ae2f93.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 03, 2008 at 01:13:13PM -0800, Andrew Morton wrote:
> On Mon, 3 Nov 2008 12:58:54 -0800
> Arthur Jones <ajones@riverbed.com> wrote:
> 
> > Hi Andrew, ...
> > 
> > On Mon, Nov 03, 2008 at 12:37:50PM -0800, Andrew Morton wrote:
> > > [...]
> > > OK.  But still, questions remain.
> > > 
> > > - should we clear s_dirt if log_wait_commit() didn't work?
> > > 
> > > - ext3_force_commit() clears s_dirt also
> > > 
> > > - should ext3_sync_fs() be dropping the ext3_force_commit() return
> > >   value on the floor?

Should all the callers of ->sync_fs also be dropping the error returns
on the floor?

> > 
> > - does ext4 have a similar issue (ext4_sync_fs looks the same)?
> > 
> 
> I'm sure it does.  Someone(tm) should prepare the ext4 patch once we've
> settled on the ext3 patch.

I'll take care of it.  And I would reflect the error returns up to
ext3_sync_fs's callers, although at the moment it's not clear it would
make much of a difference.  :-(

						- Ted
