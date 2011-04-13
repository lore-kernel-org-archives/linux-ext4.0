From: Jan Kara <jack@suse.cz>
Subject: Re: recursive mtime patches
Date: Wed, 13 Apr 2011 23:39:37 +0200
Message-ID: <20110413213937.GB4648@quack.suse.cz>
References: <BANLkTim6NYYnr+m4mqawSD4-Mbbzj699hQ@mail.gmail.com>
 <20110412154830.GF5246@quack.suse.cz>
 <BANLkTinO7G1YxZCP1-PXG5Nvyas=QdAunQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45382 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932906Ab1DMVji (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Apr 2011 17:39:38 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTinO7G1YxZCP1-PXG5Nvyas=QdAunQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 13-04-11 21:16:40, Amir Goldstein wrote:
> On Tue, Apr 12, 2011 at 5:48 PM, Jan Kara <jack@suse.cz> wrote:
> > modification stamps have possibly larger race windows but I haven't really
> > tried how much (I just know that even mtime races are not that hard to
> > trigger if you try). So it really depends on how big reliability do you
> > expect and I personally don't find much value in just rescanning and
> > checking for mtime after a crash. Reading all the data and doing checksum
> > certainly has more value but at a high cost.
> >
> 
> What do you thing about the approach to store recursively modified dir inodes in
> a journal "modified inode descriptor block" and update the recursive mtime of
> those dirs on journal recovery?
  The trouble is you don't know the number of directories that may need
to have timestamp updated - you find that out only as you travel upwards.
So it's hard to reserve any fixed space for this.

> I would also consider to use a mount option rec_mtime and then just
> store recursive
> mtime in the directory's inode mtime instead of an extended attribute.
> That doesn't break any contract with user space, it's just a re-interpretation
> of the dir modification notion.
  It breaks POSIX specification - POSIX pretty much specifies when mtime is
supposed to be changed - so I'm not sure we really want to do that... 

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
