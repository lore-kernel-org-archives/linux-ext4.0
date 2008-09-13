From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH 1/4] vfs: vfs-level fiemap interface
Date: Sat, 13 Sep 2008 18:41:21 -0400
Message-ID: <20080913224121.GG26128@mit.edu>
References: <E1Kea9F-0004L5-Ds@closure.thunk.org> <1221331767-16870-1-git-send-email-tytso@mit.edu> <2EC8176B-0AFA-4B36-A2F5-E51753A576A5@cam.ac.uk> <20080913212903.GF26128@mit.edu> <20080913214532.GJ10844@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Anton Altaparmakov <aia21@cam.ac.uk>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	akpm@linuxfoundation.org, Mark Fasheh <mfasheh@suse.com>
To: Matthew Wilcox <matthew@wil.cx>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:62820 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751825AbYIMWmD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 13 Sep 2008 18:42:03 -0400
Content-Disposition: inline
In-Reply-To: <20080913214532.GJ10844@parisc-linux.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 13, 2008 at 03:45:33PM -0600, Matthew Wilcox wrote:
> On Sat, Sep 13, 2008 at 05:29:03PM -0400, Theodore Tso wrote:
> > Otherwise, the thou-shalt-not-anticipate-the-needs-of-any-future-
> > users-of-the-interface nazi's will strike again, and more months will
> > go by with absolutely no progress....
> 
> Ted, I appreciate you're feeling frustration, but there's no call for
> this kind of language.  Please moderate your tone.

Well, being polite and us trying to be constructive hasn't gotten us
anywhere, except getting (completely groundless) accusations that one
of the ext4 developers was trying to "sneak this in" for the benefit
of his company --- and months and months and months of time wasted.

I really am beginning to wish that I had ignored Cristoph's whinging
and just pushed an ext4-specific ioctl to Linus, instead of trying to
develop a filesystem-generic interface.  It's just an ioctl.  Let's
get this done, and move on.  If we need to allocate another ioctl, we
can do so.  Heck, we have five or six different stat interfaces...

I have no problem adding support so we can support filesystems with
compressed extents.  What I don't want to have happen is one patch
version where we add a feature, and then get another complaint from
someone else demanding that we remove that self-same feature from the
interface, repeating, ad infinitum.  We shouldn't tolerate this kind
of sh*t.

       	    	     	       	      		     - Ted
