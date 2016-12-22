From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [RFC PATCH v1 00/30] fs: inode->i_version rework and
 optimization
Date: Thu, 22 Dec 2016 09:42:04 -0500
Message-ID: <1482417724.3924.39.camel@redhat.com>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
         <20161222084549.GA8833@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20161222084549.GA8833@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2016-12-22 at 00:45 -0800, Christoph Hellwig wrote:
> On Wed, Dec 21, 2016 at 12:03:17PM -0500, Jeff Layton wrote:
> > 
> > Only btrfs, ext4, and xfs implement it for data changes. Because of
> > this, these filesystems must log the inode to disk whenever the
> > i_version counter changes. That has a non-zero performance impact,
> > especially on write-heavy workloads, because we end up dirtying the
> > inode metadata on every write, not just when the times change. [1]
> 
> Do you have numbers to justify these changes?

I have numbers. As to whether they justify the changes, I'm not sure.
This helps a lot on a (admittedly nonsensical) 1-byte write workload. On
XFS, with this fio jobfile:

--------------------8<------------------
[global]
direct=0
size=2g
filesize=512m
bsrange=1-1
timeout=60
numjobs=1
directory=/mnt/scratch

[f1]
filename=randwrite
rw=randwrite
--------------------8<------------------

Unpatched kernel:
  WRITE: io=7707KB, aggrb=128KB/s, minb=128KB/s, maxb=128KB/s, mint=60000msec, maxt=60000msec

Patched kernel:
  WRITE: io=12701KB, aggrb=211KB/s, minb=211KB/s, maxb=211KB/s, mint=60000msec, maxt=60000msec

So quite a difference there and it's pretty consistent across runs. If I
change the jobfile to have "direct=1" and "bsrange=4k-4k", then any
variation between the two doesn't seem to be significant (numbers vary
as much between runs on the same kernels and are roughly the same).

Playing with buffered I/O sizes between 1 byte and 4k shows that as the
I/O sizes get larger, this makes less difference (which is what I'd
expect).

Previous testing with ext4 shows roughly the same results. btrfs shows
some benefit here but significantly less than with ext4 or xfs. Not sure
why that is yet -- maybe CoW effects?

That said, I don't have a great test rig for this. I'm using VMs with a
dedicated LVM volume that's on a random SSD I had laying around. It
could use testing on a wider set of configurations and workloads.

I was also hoping that others may have workloads that they think might
be (postively or negatively) affected by these changes. If you can think
of any in particular, then I'm interested to hear about them.

-- 
Jeff Layton <jlayton@redhat.com>
