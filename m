From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: Avoid creating new file in append-only dir when
 open(2) return error
Date: Wed, 2 Nov 2011 15:23:15 +0100
Message-ID: <20111102142315.GA31575@quack.suse.cz>
References: <1319824987-5621-1-git-send-email-guaneryu@gmail.com>
 <20111101231034.GI18701@quack.suse.cz>
 <20111101232725.GO32161@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Eryu Guan <guaneryu@gmail.com>,
	linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59633 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753673Ab1KBOXR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Nov 2011 10:23:17 -0400
Content-Disposition: inline
In-Reply-To: <20111101232725.GO32161@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 01-11-11 19:27:25, Ted Tso wrote:
> On Wed, Nov 02, 2011 at 12:10:34AM +0100, Jan Kara wrote:
> > > 
> > > To avoid this, check EXT3_APPEND_FL flag first in ext3_create before
> > > really allocating new inode.
> >   Yes, it is nicer to not create any file when open(2) fails in the end.
> > BTW, how have you spotted this? I've taken your ext2 and ext3 patches into
> > my tree.
> 
> Note: I have a fix in my tree which removes EXTx_APPEND_FL from the
> set of flags that can be inherited from the containing directory in
> ext2, ext3, and ext4.  That addresses this issue without needing to
> make the change in this patch.
  Ah, OK. I forgot about it. I've removed the two patches from my queue.
Thanks for letting me know.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
