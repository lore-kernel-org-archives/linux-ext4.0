From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] ext3: make ext3 mount default to barrier=1
Date: Thu, 14 Jul 2011 11:19:09 -0400
Message-ID: <20110714151909.GA8875@infradead.org>
References: <20110711182532.GA12099@infradead.org>
 <20110711182558.GB12099@infradead.org>
 <1310476587-sup-1581@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	viro <viro@zeniv.linux.org.uk>, jeffm <jeffm@suse.com>,
	jack <jack@suse.cz>,
	reiserfs-devel <reiserfs-devel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <reiserfs-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1310476587-sup-1581@shiny>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jul 12, 2011 at 09:24:47AM -0400, Chris Mason wrote:
> Excerpts from Christoph Hellwig's message of 2011-07-11 14:25:59 -0400:
> > From: Chris Mason <mason@suse.com>
> > 
> 
> Thanks for digging this out, you can toss in a sob for me.  Probably
> best to give yourself credit in the from:, since you went to all the
> trouble of diving in the vendor kernels.
> 
> Then again, if you're using the old email to try and throw Andrew off
> our trail, go for it.

Given that it's trivial one liners, and suse actually had config options
around them that I had to remove I might as well claim the patches as
mine.  I'll resend them with my From and Signoff lines.

