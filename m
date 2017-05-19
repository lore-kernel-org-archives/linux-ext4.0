From: Colin Walters <walters@verbum.org>
Subject: Re: [PATCH] vfs: freeze filesystems just prior to reboot
Date: Fri, 19 May 2017 10:00:31 -0400
Message-ID: <1495202431.1896310.982081664.066926F8@webmail.messagingengine.com>
References: <20170519002032.GA21202@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: "linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
        "linux-ext4" <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        xfs <linux-xfs@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170519002032.GA21202@birch.djwong.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, May 18, 2017, at 08:20 PM, Darrick J. Wong wrote:

> Therefore, add a reboot hook to freeze all filesystems (which in general
> will induce ext4/xfs/btrfs to checkpoint the log) just prior to reboot.
> This is an unfortunate and insufficient workaround for multiple layers
> of inadequate external software, but at least it will reduce boot time
> surprises for the "OS updater failed to disengage the filesystem before
> rebooting" case.

As a maintainer of one of those userspace tools (https://github.com/ostreedev/ostree),
which I don't think is the one in question here, but likely has the same
issue - I'd like to have some sort of API to fix this - maybe flush the journal *without*
remounting r/o?

Unlike the case you're talking about with rebooting into a special
update mode, libostree constructs a new root with hardlinks while
the system is running.  Hence, system downtime is just reboot, like
dual-partition update systems, except we're more flexible.

Although hm...I guess an API to flush the journal would only narrow
the race.

Is the single partition case really just doomed?  
