From: Nick Piggin <npiggin@kernel.dk>
Subject: Re: [patch] fix up lock order reversal in writeback
Date: Thu, 18 Nov 2010 17:00:00 +1100
Message-ID: <20101118060000.GA3509@amd>
References: <20101116110058.GA4298@amd>
 <20101116130146.GG4757@quack.suse.cz>
 <4CE35A6D.2040906@redhat.com>
 <20101117043845.GA3586@amd>
 <4CE362B0.6040607@redhat.com>
 <20101117061057.GA3989@amd>
 <20101118030613.GQ3290@thunk.org>
 <20101117192900.da859ac7.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Ts'o <tytso@mit.edu>, Nick Piggin <npiggin@kernel.dk>,
	Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20101117192900.da859ac7.akpm@linux-foundation.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Nov 17, 2010 at 07:29:00PM -0800, Andrew Morton wrote:
> On Wed, 17 Nov 2010 22:06:13 -0500 "Ted Ts'o" <tytso@mit.edu> wrote:
> 
> > On Wed, Nov 17, 2010 at 05:10:57PM +1100, Nick Piggin wrote:
> > > On Tue, Nov 16, 2010 at 11:05:52PM -0600, Eric Sandeen wrote:
> > > > On 11/16/10 10:38 PM, Nick Piggin wrote:
> > > > >> as for the locking problems ... sorry about that!
> > > > > 
> > > > > That's no problem. So is that an ack? :)
> > > > > 
> > > > 
> > > > I'd like to test it with the original case it was supposed to solve; will
> > > > do that tomorrow.
> > > 
> > > OK, but it shouldn't make much difference, unless there is a lot of
> > > strange activity happening on the sb (like mount / umount / remount /
> > > freeze / etc).
> > 
> > This makes sense to me as well.
> > 
> > Acked-by: "Theodore Ts'o" <tytso@mit.edu>
> > 
> > So how do we want to send this patch to Linus?  It's a writeback
> > change, so through some mm tree?
> 
> It's in my todo pile.  Even though the patch sucks, but not as much as
> its changelog does.  Am not particularly happy merging an alleged
> bugfix where the bug is, and I quote, "I saw a lock order warning on
> ext4 trigger".  I mean, wtf?  How is anyone supposed to review the code
> based on that??  Or to understand it a year from now?

Sorry bout the confusion, it was supposed to be "i_mutex", and then it
would have been a bit more obvious.


> When I get to it I'll troll this email thread and might be able to
> kludge together a description which might be able to fool people into
> thinking it makes sense.

"Lock order reversal between s_umount and i_mutex".

i_mutex nests inside s_umount in some writeback paths (it was the end
io handler to convert unwritten extents IIRC). But hmm, wouldn't that
be a bug? We aren't allowed to take i_mutex inside writeback, are we?

