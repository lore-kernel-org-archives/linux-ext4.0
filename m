From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 1/4] vfs: introduce try_to_writeback_inodes_sb(_nr)
Date: Thu, 26 Apr 2012 11:12:00 -0400
Message-ID: <20120426151159.GB25603@dhcp231-144.rdu.redhat.com>
References: <4F98B9A7.8060209@gmail.com>
 <20120426031156.GY9541@dastard>
 <CAAW_DMg9VLEtV40=qAbT3WZ4tN+ejZxToFHO0AiqDmjvV=V4eA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christoph Hellwig <hch@infradead.org>,
	Linux FSDevel <linux-fsdevel@vger.kernel.org>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	miaox@cn.fujitsu.com, Kamal Mostafa <kamal@canonical.com>,
	Linux Ext4 <linux-ext4@vger.kernel.org>
To: Xie Miao <miaoxie1984@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAAW_DMg9VLEtV40=qAbT3WZ4tN+ejZxToFHO0AiqDmjvV=V4eA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Apr 26, 2012 at 03:55:52PM +0800, Xie Miao wrote:
> On Thu, Apr 26, 2012 at 11:11 AM, Dave Chinner <david@fromorbit.com> wrote:
> > > writeback_inodes_sb(_nr) grabs s_umount lock when it want to start
> > > writeback,
> > > it may bring us deadlock problem when doing umount. So we introduce new
> > > functions -- try_to_writeback_inodes_sb(_nr) -- which use
> > > down_read_trylock()
> > > instead of down_read() to avoid that deadlock problem.
> > >
> > > This idea came from Christoph Hellwig.
> > > Some code is from the patch of Kamal Mostafa.
> >
> > This just re-implements writeback_inodes_[nr]_sb_if_idle() with a
> > trylock instead of a blocking lock.
> >
> > Just replace the blocking lock in writeback_inodes_[nr]_sb_if_idle()
> > with a trylock and use that.
> 
> The change of these two functions is relative to three modules,  so I think
> the patch set now is easy to be reviewed by the developers of each module.
> 

I agree with David, there's no sense in making something completely seperate,
this function was introduced soley to kick off background writeout if we could
with no garuntees, if the other users suddenly don't like the behavior they can
creating something different for themselves.  Thanks,

Josef
