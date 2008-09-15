From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] vfs: vfs-level fiemap interface
Date: Mon, 15 Sep 2008 10:49:48 -0400
Message-ID: <20080915144948.GB16491@infradead.org>
References: <E1Kea9F-0004L5-Ds@closure.thunk.org> <1221331767-16870-1-git-send-email-tytso@mit.edu> <2EC8176B-0AFA-4B36-A2F5-E51753A576A5@cam.ac.uk> <20080913212903.GF26128@mit.edu> <20080914134859.GB21746@infradead.org> <20080914175810.GB13074@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Anton Altaparmakov <aia21@cam.ac.uk>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	akpm@linuxfoundation.org, Mark Fasheh <mfasheh@suse.com>
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080914175810.GB13074@mit.edu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Sep 14, 2008 at 01:58:10PM -0400, Theodore Tso wrote:
> On Sun, Sep 14, 2008 at 09:48:59AM -0400, Christoph Hellwig wrote:
> > Let's make it clear, I've said to not add it unless we have users.  And
> > What Anton brought up is exactly the reason for that - to support
> > encrypted extents we actually need more information in the structure.
> > That's why we need to have this broad and sometimes a little slow
> > discussion on fsdevel instead of just rushing in some flag for future
> > use that won't make any sense in the end.
> 
> You're incorrect here.  Encrypted extents does not require any
> additional information in the structure.  Compressed extents are a bit
> more useful if we allow the the filesystem to return the amount of
> space used on the storage device,

Sorry, should have written compressed and not encrypted above.

> cramfs).  But that being said, the fundamental question here is
> whether we should try to plan for future users of the data structure,
> and reserve space now for the, or not.  Your approach of saying Nein!
> Nein!  Nein! for every single feature where we don't have
> implementation pretty much guarantees that we will need to expand the
> structure later to make room for these extra fields, and then we'll
> need to define a new ioctl and have similar complexity to the stat
> system call to support multiple userspace interfaces.  If we try to
> anticipate new users in advance, then there is at least a *chance*
> we'll get it right up front.

I agree to you (or someone elses - don't remember anymore) suggestion
to put in more padding so we can add fields later.  I strongly disagree
putting in features now that we neither have a user, nor a usecase or
testcase for.

