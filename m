From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: inplace xattr block update fails to deduplicate
 blocks
Date: Sat, 5 Aug 2017 22:50:42 -0400
Message-ID: <20170806025042.anluiwr3bsr2z4ng@thunk.org>
References: <20170715002529.31045-1-tahsin@google.com>
 <EAEB944F-E38E-41CE-ACE6-AC9BE0E28598@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tahsin Erdogan <tahsin@google.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <EAEB944F-E38E-41CE-ACE6-AC9BE0E28598@dilger.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Jul 15, 2017 at 02:49:05AM -0700, Andreas Dilger wrote:
> On Jul 14, 2017, at 5:25 PM, Tahsin Erdogan <tahsin@google.com> wrote:
> > 
> > When an xattr block has a single reference, block is updated inplace
> > and it is reinserted to the cache. Later, a cache lookup is performed
> > to see whether an existing block has the same contents. This cache
> > lookup will most of the time return the just inserted entry so
> > deduplication is not achieved.
> > 
> > Running the following test script will produce two xattr blocks which
> > can be observed in "File ACL: " line of debugfs output:
> > 
> >  mke2fs -b 1024 -I 128 -F -O extent /dev/sdb 1G
> >  mount /dev/sdb /mnt/sdb
> > 
> >  touch /mnt/sdb/{x,y}
> > 
> >  setfattr -n user.1 -v aaa /mnt/sdb/x
> >  setfattr -n user.2 -v bbb /mnt/sdb/x
> > 
> >  setfattr -n user.1 -v aaa /mnt/sdb/y
> >  setfattr -n user.2 -v bbb /mnt/sdb/y
> > 
> >  debugfs -R 'stat x' /dev/sdb | cat
> >  debugfs -R 'stat y' /dev/sdb | cat
> > 
> > This patch defers the reinsertion to the cache so that we can locate
> > other blocks with the same contents.
> > 
> > Signed-off-by: Tahsin Erdogan <tahsin@google.com>
> 
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.

					- Ted
