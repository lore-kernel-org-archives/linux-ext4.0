From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] [RESEND] ext3: set i_extra_isize of 11th inode
Date: Thu, 9 Sep 2010 18:38:08 +0200
Message-ID: <20100909163807.GA3281@quack.suse.cz>
References: <20100823095056.ACBA.61FB500B@jp.fujitsu.com>
 <20100824131735.GD3713@quack.suse.cz>
 <20100825090551.DEB3.61FB500B@jp.fujitsu.com>
 <20100825230442.GH2738@quack.suse.cz>
 <8B4A0D91-D3E1-4328-890C-BD66189598B5@dilger.ca>
 <20100826122754.GI3294@quack.suse.cz>
 <771B1868-889A-4DD1-A247-9E183395E627@dilger.ca>
 <20100827135838.GC3274@quack.suse.cz>
 <608119C2-BE41-4BC1-AAA3-A215C06720FE@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:58528 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558Ab0IIQi6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Sep 2010 12:38:58 -0400
Content-Disposition: inline
In-Reply-To: <608119C2-BE41-4BC1-AAA3-A215C06720FE@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 27-08-10 12:57:47, Andreas Dilger wrote:
> On 2010-08-27, at 07:58, Jan Kara wrote:
> >  first let me explain one thing: I definitely agree that the issue
> > spotted by Masayoshi MIZUMA is more serious than some possible problem
> > with ancient e2fsprogs. What I was discussing about is, whether we should
> > fix the issue with the original patch (removing the workaround from
> > ext3_iget) or with my patch (putting the same logic into ext3_new_inode so
> > that it does not create xattrs which ext3_iget will just ignore).
> 
> I agree that this is a safe fix, but it will propagate the workaround far
> into the future instead of actually fixing it.
> 
> >  The disadvantage of my fix is that xattrs for inos <= EXT3_FIRST_INO will
> > be always stored out of inode, the disadvantage of the original patch is
> > the remote possibility of problems with ancient e2fsprogs.
> 
> I don't think there are realistic chances of problems with older
> filesystems running newer kernels.  I think the workaround that was
> suggested below is also totally safe - instead of silently erasing the
> xattr (as kernels do today), or returning an error with a bad
> i_extra_isize (as would happen with the originally proposed patch) it
> will "know" that this bad value on low-numbered inodes was caused by
> mke2fs and just reset it instead of returning the error.
  Sigh, sorry to bring this up again... I wanted to use the original patch
with the workaround you suggested but realized there's still a hole. The
new patched kernel will happily use extra inode space for xattrs for inode
11 but if you mount the filesystem with older kernel it will reset
i_extra_size to zero and thus you'll lose the stored xattrs.
  So to get out of this compatibility trap we'd have to accept xattrs in
the extended inode space but never store it there and after a sufficiently
long time, we could remove the workaround. But this seems not worth the
effort to me given we speak about a single inode and rather trivial
workaround in ext3_iget and ext3_new_inode.
  Any ideas Andreas?

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
