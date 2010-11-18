From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [patch] fix up lock order reversal in writeback
Date: Wed, 17 Nov 2010 22:06:13 -0500
Message-ID: <20101118030613.GQ3290@thunk.org>
References: <20101116110058.GA4298@amd>
 <20101116130146.GG4757@quack.suse.cz>
 <4CE35A6D.2040906@redhat.com>
 <20101117043845.GA3586@amd>
 <4CE362B0.6040607@redhat.com>
 <20101117061057.GA3989@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Nick Piggin <npiggin@kernel.dk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20101117061057.GA3989@amd>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Nov 17, 2010 at 05:10:57PM +1100, Nick Piggin wrote:
> On Tue, Nov 16, 2010 at 11:05:52PM -0600, Eric Sandeen wrote:
> > On 11/16/10 10:38 PM, Nick Piggin wrote:
> > >> as for the locking problems ... sorry about that!
> > > 
> > > That's no problem. So is that an ack? :)
> > > 
> > 
> > I'd like to test it with the original case it was supposed to solve; will
> > do that tomorrow.
> 
> OK, but it shouldn't make much difference, unless there is a lot of
> strange activity happening on the sb (like mount / umount / remount /
> freeze / etc).

This makes sense to me as well.

Acked-by: "Theodore Ts'o" <tytso@mit.edu>

So how do we want to send this patch to Linus?  It's a writeback
change, so through some mm tree?  Or it lives in fs/fs-writeback.c
(which I always thought was weird; why is it not in mm/?), so maybe
through the VFS tree, even though I don't think Al would really care
about this patch.

Or I can push it to Linus through the ext4 tree....

     	      	    	  	      	   - Ted
