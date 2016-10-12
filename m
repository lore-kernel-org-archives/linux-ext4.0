From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: super.c: Update logging style using PR_CONT
Date: Wed, 12 Oct 2016 18:13:28 -0400
Message-ID: <20161012221328.pkglnedwbkigtrko@thunk.org>
References: <ac72258a7f35042014aede22502d947b59ada155.1476237454.git.joe@perches.com>
 <20161012104157.GB14664@quack2.suse.cz>
 <1476282730.16823.7.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1476282730.16823.7.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Oct 12, 2016 at 07:32:10AM -0700, Joe Perches wrote:
> On Wed, 2016-10-12 at 12:41 +0200, Jan Kara wrote:
> > On Tue 11-10-16 18:57:58, Joe Perches wrote:
> > > Recent commit require line continuing printks to use PR_CONT.
> > > 
> > > Update super.c to use PR_CONT and use vsprintf extension %pV
> > > to avoid a printk/vprintk/printk("\n") sequence as well.
> > 
> > 
> > Looks good. You can add:
> > 
> > Reviewed-by: Jan Kara <jack@suse.cz>
> 
> Except the subject and commit bodyis broken and should use KERN_CONT not PR_CONT
> 
> Ted, can you please fix when applying or do you want a resubmit?

I'll fix it up, no worries!.

					- Ted
