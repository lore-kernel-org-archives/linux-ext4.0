From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 2/3 v2] ext4: let us fully support punching hole feature
 in fallocate
Date: Tue, 20 Nov 2012 15:43:35 +0800
Message-ID: <20121120074335.GA6191@gmail.com>
References: <1353329718-2075-1-git-send-email-wenqing.lz@taobao.com>
 <1353329718-2075-3-git-send-email-wenqing.lz@taobao.com>
 <20121120063505.GA11117@yanx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Guo Chao <yan@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37422 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab2KTHay (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Nov 2012 02:30:54 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so4076211pbc.19
        for <linux-ext4@vger.kernel.org>; Mon, 19 Nov 2012 23:30:54 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20121120063505.GA11117@yanx>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 20, 2012 at 02:35:05PM +0800, Guo Chao wrote:
> Hi, Zheng:
> 
> On Mon, Nov 19, 2012 at 08:55:17PM +0800, Zheng Liu wrote:
> > From: Zheng Liu <wenqing.lz@taobao.com>
> > 
> > After adding indirect punching hole feature, we need to enable it in fallocate.
> > For this purpose, some sanity checks need to be adjusted.  Currently we need to
> > check FALLOC_FL_PUNCH_HOLE flag before other sanity checks.
> > 
> > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> > ---
> >  fs/ext4/extents.c | 14 +++++++-------
> >  1 file changed, 7 insertions(+), 7 deletions(-)
> > 
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index 7011ac9..b43b3e9 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -4420,13 +4420,6 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
> >  	struct ext4_map_blocks map;
> >  	unsigned int credits, blkbits = inode->i_blkbits;
> > 
> > -	/*
> > -	 * currently supporting (pre)allocate mode for extent-based
> > -	 * files _only_
> > -	 */
> > -	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
> > -		return -EOPNOTSUPP;
> > -
> >  	/* Return error if mode is not supported */
> >  	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
> >  		return -EOPNOTSUPP;
> 
> Checking these mode flags seems redundant here, VFS already checked them.
> Maybe you can remove it by the way.

Yeah, I see.  Not only ext4, other filesystems also check it in themselves,
such as xfs, btrfs.  I am not very familiar with why we need to do this,
but IMHO a better way might be removing it from all filesystems in another
patch series.  I will send it out.  Thanks for your suggestion.

Regards,
                                                - Zheng
