From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] ext4: super.c: Update logging style using PR_CONT
Date: Wed, 12 Oct 2016 07:32:10 -0700
Message-ID: <1476282730.16823.7.camel@perches.com>
References: <ac72258a7f35042014aede22502d947b59ada155.1476237454.git.joe@perches.com>
         <20161012104157.GB14664@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161012104157.GB14664@quack2.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2016-10-12 at 12:41 +0200, Jan Kara wrote:
> On Tue 11-10-16 18:57:58, Joe Perches wrote:
> > Recent commit require line continuing printks to use PR_CONT.
> > 
> > Update super.c to use PR_CONT and use vsprintf extension %pV
> > to avoid a printk/vprintk/printk("\n") sequence as well.
> 
> 
> Looks good. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Except the subject and commit bodyis broken and should use KERN_CONT not PR_CONT

Ted, can you please fix when applying or do you want a resubmit?
