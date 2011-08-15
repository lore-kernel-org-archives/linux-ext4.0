From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: remove deprecated oldalloc
Date: Mon, 15 Aug 2011 17:27:29 +0200
Message-ID: <20110815152729.GE6597@quack.suse.cz>
References: <1307453714-2741-1-git-send-email-lczerner@redhat.com>
 <alpine.LFD.2.00.1108111658520.29009@dhcp-27-109.brq.redhat.com>
 <BF21E0BA-332B-4ADD-901C-5B0E8590898A@dilger.ca>
 <alpine.LFD.2.00.1108151612120.19095@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, Jan Kara <jack@suse.cz>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60043 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754256Ab1HOP1c (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Aug 2011 11:27:32 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1108151612120.19095@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 15-08-11 16:21:27, Lukas Czerner wrote:
> On Thu, 11 Aug 2011, Andreas Dilger wrote:
> > On 2011-08-11, at 8:58 AM, Lukas Czerner wrote:
> > > On Tue, 7 Jun 2011, Lukas Czerner wrote:
> > >> For a long time now orlov is the default block allocator in the ext4. It
> > >> performs better than the old one and no one seems to claim otherwise so
> > >> we can safely drop it and make oldalloc and orlov mount option
> > >> deprecated.
> > >> 
> > >> This is a part of the effort to reduce number of ext4 options hence the
> > >> test matrix.
> > >> 
> > >> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > > 
> > > ping
> > 
> > I'm OK with removing this, I don't think anyone uses it, and it has almost
> > no meaning with flex_bg anyway.
> > 
> > That said, "orlov" is also mostly meaningless with flex_bg as well, since
> > there is very little real benefit/affinity from inodes being "close" to
> > their data blocks.  We gain far more benefit from keeping the inodes
> > together than spreading them out and keeping them close to the data blocks.
> 
> What about removing it for ext3 as well ? I can prepare a patch.
  OK, let's start warning the option is deprecated and will be removed from
ext3. We can remove it after 2-3 releases...

> Also note that there is a bug in the OLDALLOC where if there is
> approximately the same number of inodes in all of the allocation groups
> it might result in the state where no group has less free inode count
> than the average, hence we get ENOSPC even though there is enough space
> for the inode to be allocated. It is unlikely, but it is there.
  Fix for this would be nice.

> So Ted, could you take the patch ?
  ext3 patches go through my tree.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
