From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC 4/5] inode reservation v0.1 (benchmark result)
Date: Thu, 24 May 2007 14:21:44 -0600
Message-ID: <20070524202144.GS5181@schatzie.adilger.int>
References: <1179943697.4179.55.camel@coly-t43.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: coly <colyli@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1179943697.4179.55.camel@coly-t43.site>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On May 24, 2007  02:08 +0800, coly wrote:
> Due to the bad design of magic inode and the on-disk layout of magic
> inode. When 30 files created alternatively in each directory, no
> performance advantage exists. When 50 files created alternatively in
> each directory, the patched ext4 will use double time on removing all
> the files and directories.

I don't think the use of magic inodes is the right approach.  One possibility
to avoid changing the on-disk format at all is to only do the reservation in
memory, scaling the reservation with the size of the directory.

The only issue that arises is how to regenerate the same reservation
after a remount.  This might be possible to do by looking into the leaf
block at create time to see which inode numbers are already in use for
that leaf and checking whether there are free inodes in each group.

One way to get the "best" mapping is possibly checking groups in order of
decreasing number of inodes for that leaf in each group and once a suitable
group has been found doing a few name->hash->inode numbers to get the old
mapping back.  Once this leaf->group mapping has been established it
can be re-used for a given leaf block until that window is full.

Since you need to scan all of a leaf block's dir entries in a hash block
at insert time to look for duplicate names, and the inode numbers are
in the dir entries, this shouldn't introduce any additional disk IO.

Also, regardless of what the mapping turns out to be - the goal is to place
inodes with a similar hash into nearby inodes, and this heuristic works
relatively well for that.  Once the given leaf block's inode range is full
then new inodes can be allocated from a new window as it was done for the
newly-created directory.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

