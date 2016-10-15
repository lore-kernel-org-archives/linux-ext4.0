From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Add missing KERN_CONT to a few more debugging uses
Date: Sat, 15 Oct 2016 10:10:48 -0400
Message-ID: <20161015141048.b522ymjtwtpcvpsa@thunk.org>
References: <98ce665bb759e671506bf269041238553a3df8f1.1476384526.git.joe@perches.com>
 <979B5118-0012-411A-B094-3045A9989CBB@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Joe Perches <joe@perches.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <979B5118-0012-411A-B094-3045A9989CBB@dilger.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Oct 13, 2016 at 03:23:11PM -0600, Andreas Dilger wrote:
> On Oct 13, 2016, at 12:50 PM, Joe Perches <joe@perches.com> wrote:
> > 
> > Recent commits require line continuing printks to always use
> > pr_cont or KERN_CONT.  Add these markings to a few more printks.
> > 
> > Miscellaneaous:
> > 
> > o Integrate the ea_idebug and ea_bdebug macros to use a single
> >  call to printk(KERN_DEBUG instead of 3 separate printks
> > o Use the more common varargs macro style
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> 
> Looks fine.
> 
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>

Applied, thanks.

					- Ted
