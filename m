From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: remove deprecated oldalloc
Date: Mon, 15 Aug 2011 17:50:53 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1108151747260.3695@dhcp-27-109.brq.redhat.com>
References: <1307453714-2741-1-git-send-email-lczerner@redhat.com> <alpine.LFD.2.00.1108111658520.29009@dhcp-27-109.brq.redhat.com> <BF21E0BA-332B-4ADD-901C-5B0E8590898A@dilger.ca> <alpine.LFD.2.00.1108151612120.19095@dhcp-27-109.brq.redhat.com>
 <20110815152729.GE6597@quack.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>,
	Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org,
	tytso@mit.edu
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754600Ab1HOPvI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Aug 2011 11:51:08 -0400
In-Reply-To: <20110815152729.GE6597@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 15 Aug 2011, Jan Kara wrote:

> On Mon 15-08-11 16:21:27, Lukas Czerner wrote:
> > On Thu, 11 Aug 2011, Andreas Dilger wrote:
> > > On 2011-08-11, at 8:58 AM, Lukas Czerner wrote:
> > > > On Tue, 7 Jun 2011, Lukas Czerner wrote:
> > > >> For a long time now orlov is the default block allocator in the ext4. It
> > > >> performs better than the old one and no one seems to claim otherwise so
> > > >> we can safely drop it and make oldalloc and orlov mount option
> > > >> deprecated.
> > > >> 
> > > >> This is a part of the effort to reduce number of ext4 options hence the
> > > >> test matrix.
> > > >> 
> > > >> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > > > 
> > > > ping
> > > 
> > > I'm OK with removing this, I don't think anyone uses it, and it has almost
> > > no meaning with flex_bg anyway.
> > > 
> > > That said, "orlov" is also mostly meaningless with flex_bg as well, since
> > > there is very little real benefit/affinity from inodes being "close" to
> > > their data blocks.  We gain far more benefit from keeping the inodes
> > > together than spreading them out and keeping them close to the data blocks.
> > 
> > What about removing it for ext3 as well ? I can prepare a patch.
>   OK, let's start warning the option is deprecated and will be removed from
> ext3. We can remove it after 2-3 releases...

Is that really necessary ? It is not like we are removing a feature which
would not work anymore.

> 
> > Also note that there is a bug in the OLDALLOC where if there is
> > approximately the same number of inodes in all of the allocation groups
> > it might result in the state where no group has less free inode count
> > than the average, hence we get ENOSPC even though there is enough space
> > for the inode to be allocated. It is unlikely, but it is there.
>   Fix for this would be nice.

Will, I was kind of hoping that we will ditch that instead of fixing it,
but I can do that if it is not going away right now.

> 
> > So Ted, could you take the patch ?
>   ext3 patches go through my tree.

I know, the was meant to the patch that started this thread which is for
ext4.

> 
> 								Honza
> 

Thanks!
-Lukas
