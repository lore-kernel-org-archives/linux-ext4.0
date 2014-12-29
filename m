From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Forbid journal_async_commit in data=ordered mode
Date: Mon, 29 Dec 2014 20:19:44 +0100
Message-ID: <20141229191944.GA4577@quack.suse.cz>
References: <1416930975-13676-1-git-send-email-jack@suse.cz>
 <549A6BEA.1050302@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: alex chen <alex.chen@huawei.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42256 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542AbaL2TTt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Dec 2014 14:19:49 -0500
Content-Disposition: inline
In-Reply-To: <549A6BEA.1050302@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 24-12-14 15:31:54, alex chen wrote:
> On 2014/11/25 23:56, Jan Kara wrote:
> > Option journal_async_commit breaks gurantees of data=ordered mode as it
> > sends only a single cache flush after writing a transaction commit
> > block. Thus even though the transaction including the commit block is
> > fully stored on persistent storage, file data may still linger in drives
> > caches and will be lost on power failure. Since all checksums match on
> > journal recovery, we replay the transaction thus possibly exposing stale
> > user data.
> > 
> 
> Hi Jan Kara,
> I have two questions:
> 1. Is the scenario you mentioned above based on local disks, in which
> data will be lost along with the host upon power failure?
  Yes.

> 2. If we use LUNs from IPSAN, I think the scenario you mentioned above
> will not happen, because data on ipsan LUN will not be lost as it is
> not affected by the host, and IPSAN LUNs are prevented from power
> failure, and have mechanisms to guarantee data duration, Am I right?
  I cannot tell how IPSAN storage behaves. You are right that storage
arrays often have battery backed writeback caches or they are attached to a
UPS so data is not lost when power goes out. In such case you may mount the
filesystem with barrier=0 mount option to disable cache flushes which makes
journal_async_commit mount option much less interesting anyway.

That being said journal_async_commit may still be unsafe in data=ordered
mode as in theory data may still be sitting in the block layer while we
submit commit block and thus the machine could submit the commit block to
the SAN before the data blocks and thus on power failure we could still see
the transaction written while data blocks are not written which breaks
guarantees of data=ordered mode. So to summarize journal_async_commit may
break guarantees of data=ordered mode even for storage arrays with battery
backed caches.

								Honza

> > To fix this data exposure issue, remove the possibility to use
> > journal_async_commit in data=ordered mode.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/ext4/super.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> > index b53c243a142b..c62445cb01ca 100644
> > --- a/fs/ext4/super.c
> > +++ b/fs/ext4/super.c
> > @@ -1701,6 +1701,12 @@ static int parse_options(char *options, struct super_block *sb,
> >  			return 0;
> >  		}
> >  	}
> > +	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_ORDERED_DATA &&
> > +	    test_opt(sb, JOURNAL_ASYNC_COMMIT)) {
> > +		ext4_msg(sb, KERN_ERR, "can't mount with journal_async_commit "
> > +			 "in data=ordered mode");
> > +		return 0;
> > +	}
> >  	return 1;
> >  }
> >  
> > 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
