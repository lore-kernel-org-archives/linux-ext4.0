From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH 0/4] fs: introduce new writeback error tracking
 infrastructure and convert ext4 to use it
Date: Wed, 5 Apr 2017 19:55:30 -0700
Message-ID: <20170406025530.GB31725@bombadil.infradead.org>
References: <20170403191602.GF30811@bombadil.infradead.org>
 <1491250577.2673.20.camel@redhat.com>
 <87h924kh6t.fsf@notabene.neil.brown.name>
 <20170404115358.GH30811@bombadil.infradead.org>
 <1491308268.20445.4.camel@redhat.com>
 <20170404161247.GJ30811@bombadil.infradead.org>
 <1491323146.309.1.camel@redhat.com>
 <20170404170909.GK30811@bombadil.infradead.org>
 <1491421792.18658.20.camel@redhat.com>
 <87efx6tnbr.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Layton <jlayton@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        akpm@linux-foundation.org, tytso@mit.edu, jack@suse.cz
To: NeilBrown <neilb@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87efx6tnbr.fsf@notabene.neil.brown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Apr 06, 2017 at 10:02:48AM +1000, NeilBrown wrote:
> If you are concerned about space in 'struct address_space', just prune
> some wastage.

I'm trying to (via wlists).  still buggy though.

> The "host" field brings no value.  It is only ever assigned in
> inode_init_always():
> 
> 	struct address_space *const mapping = &inode->i_data;
> ......
> 	mapping->host = inode;
> 
> So you could change all references to use
>    container_of(mapping, struct inode, i_data)

Alas, no:

drivers/dax/dax.c:      inode->i_mapping->host = dax_dev->inode;
fs/gfs2/glock.c:                mapping->host = s->s_bdev->bd_inode;
fs/gfs2/ops_fstype.c:   mapping->host = sb->s_bdev->bd_inode;
fs/nilfs2/page.c:       mapping->host = inode;
