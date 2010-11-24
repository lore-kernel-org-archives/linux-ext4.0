From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] ext3: Add FITRIM handle for ext3
Date: Wed, 24 Nov 2010 17:32:08 +0100
Message-ID: <20101124163208.GU6113@quack.suse.cz>
References: <1290425358-16253-1-git-send-email-lczerner@redhat.com>
 <1290425358-16253-2-git-send-email-lczerner@redhat.com>
 <20101122174220.GC5012@quack.suse.cz>
 <alpine.LFD.2.00.1011231126380.3139@dhcp-lab-213.englab.brq.redhat.com>
 <20101124130147.GP6113@quack.suse.cz>
 <alpine.LFD.2.00.1011241522530.3293@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, tytso@mit.edu,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1011241522530.3293@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 24-11-10 15:32:59, Lukas Czerner wrote:
> On Wed, 24 Nov 2010, Jan Kara wrote:
> > On Tue 23-11-10 11:32:46, Lukas Czerner wrote:
> > > On Mon, 22 Nov 2010, Jan Kara wrote:
> > > 
> > > > On Mon 22-11-10 12:29:18, Lukas Czerner wrote:
> > > > > It takes fstrim_range structure as an argument. fstrim_range is definec in
> > > > > the include/linux/fs.h.
> > > > > 
> > > > > After the FITRIM is done, the number of actually discarded Bytes is stored
> > > > > in fstrim_range.len to give the user better insight on how much storage
> > > > > space has been really released for wear-leveling.
> > > >   Umm, why do we have to do this when FITRIM is already handled in
> > > > fs/ioctl.c? I'd expect us to just provide .trim_fs ioctl, no?
> > > 
> > > Hi,
> > > 
> > > see upstream commits:
> > > 93bb41f4f8b89ac8b4d0a734bc59634cb0a29a89
> > > e681c047e47c0abe67bf95857f23814372793cb0
> > > 
> > > unfortunately people was not happy with generic ioctl interface for that
> > > purpose, there were concerned that it is no common enough to be included
> > > in core vfs and there is no need for new super operation since each
> > > filesystem can easily setup its own ioctl handling.
> > > 
> > > When I say people I need to clarify that it was mainly Christoph Hellwig
> > > who had objections against the former implementation and I must say that
> > > he had a point.
> > OK, I see. I had a fresh look at the patches and I've found a few
> > suboptimal things which I've fixed. Most notably I don't think we have to
> > issue a warning when underlying device does not support FITRIM. Returning
> > EOPNOTSUPP should be enough. And I also think that remounting the
> > filesystem read-only or even panicking (the result of calling
> > ext3_std_error()) is necessary when sb_issue_discard() fails for whatever
> 
> Did you meant "is NOT necessary" ? Just for clarification.
  Yes.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
