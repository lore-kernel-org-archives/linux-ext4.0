From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] vfs: freeze filesystems just prior to reboot
Date: Fri, 19 May 2017 12:01:15 -0700
Message-ID: <20170519190115.GJ4519@birch.djwong.org>
References: <20170519002032.GA21202@birch.djwong.org>
 <1495202431.1896310.982081664.066926F8@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
To: Colin Walters <walters@verbum.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1495202431.1896310.982081664.066926F8@webmail.messagingengine.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, May 19, 2017 at 10:00:31AM -0400, Colin Walters wrote:
> On Thu, May 18, 2017, at 08:20 PM, Darrick J. Wong wrote:
> 
> > Therefore, add a reboot hook to freeze all filesystems (which in general
> > will induce ext4/xfs/btrfs to checkpoint the log) just prior to reboot.
> > This is an unfortunate and insufficient workaround for multiple layers
> > of inadequate external software, but at least it will reduce boot time
> > surprises for the "OS updater failed to disengage the filesystem before
> > rebooting" case.
> 
> As a maintainer of one of those userspace tools
> (https://github.com/ostreedev/ostree), which I don't think is the one
> in question here, but likely has the same issue - I'd like to have
> some sort of API to fix this - maybe flush the journal *without*
> remounting r/o?

The convention (at least among ext4 and xfs) is that fs freeze should be
checkpointing the journal.

> Unlike the case you're talking about with rebooting into a special
> update mode, libostree constructs a new root with hardlinks while
> the system is running.  Hence, system downtime is just reboot, like
> dual-partition update systems, except we're more flexible.
> 
> Although hm...I guess an API to flush the journal would only narrow
> the race.
> 
> Is the single partition case really just doomed?  

Probably.  TBH given the current behavior of grub, I would always have a
separate /boot to minimize the amount it's allowed to touch. :)

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
