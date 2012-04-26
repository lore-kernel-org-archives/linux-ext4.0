From: Xie Miao <miaoxie1984@gmail.com>
Subject: Re: [PATCH 1/4] vfs: introduce try_to_writeback_inodes_sb(_nr)
Date: Thu, 26 Apr 2012 15:55:52 +0800
Message-ID: <CAAW_DMg9VLEtV40=qAbT3WZ4tN+ejZxToFHO0AiqDmjvV=V4eA@mail.gmail.com>
References: <4F98B9A7.8060209@gmail.com>
	<20120426031156.GY9541@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christoph Hellwig <hch@infradead.org>,
	Linux FSDevel <linux-fsdevel@vger.kernel.org>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	miaox@cn.fujitsu.com, Kamal Mostafa <kamal@canonical.com>,
	Linux Ext4 <linux-ext4@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20120426031156.GY9541@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Apr 26, 2012 at 11:11 AM, Dave Chinner <david@fromorbit.com> wrote:
> > writeback_inodes_sb(_nr) grabs s_umount lock when it want to start
> > writeback,
> > it may bring us deadlock problem when doing umount. So we introduce new
> > functions -- try_to_writeback_inodes_sb(_nr) -- which use
> > down_read_trylock()
> > instead of down_read() to avoid that deadlock problem.
> >
> > This idea came from Christoph Hellwig.
> > Some code is from the patch of Kamal Mostafa.
>
> This just re-implements writeback_inodes_[nr]_sb_if_idle() with a
> trylock instead of a blocking lock.
>
> Just replace the blocking lock in writeback_inodes_[nr]_sb_if_idle()
> with a trylock and use that.

The change of these two functions is relative to three modules,  so I think
the patch set now is easy to be reviewed by the developers of each module.

Thanks
Miao
