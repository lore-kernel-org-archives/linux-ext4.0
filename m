From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext3: make ext3 mount default to barrier=1
Date: Mon, 11 Jul 2011 18:23:10 -0400
Message-ID: <20110711222310.GR28763@thunk.org>
References: <20110711182532.GA12099@infradead.org>
 <20110711182558.GB12099@infradead.org>
 <20110711191735.GG5482@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, viro@zeniv.linux.org.uk,
	jeffm@suse.com, chris.mason@oracle.com,
	reiserfs-devel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110711191735.GG5482@quack.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jul 11, 2011 at 09:17:35PM +0200, Jan Kara wrote:
> On Mon 11-07-11 14:25:59, Christoph Hellwig wrote:
> > From: Chris Mason <mason@suse.com>
> > 
> > This patch turns on barriers by default for ext3.  mount -o barrier=0
> > will turn them off.
> > 
> > Acked-by: Jeff Mahoney <jeffm@suse.com>
>   This patch misses signed-off-by. Feel free to add
> Acked-by: Jan Kara <jack@suse.cz>

I'm also completely in favor of this change.

    	 	       	     	     - Ted
