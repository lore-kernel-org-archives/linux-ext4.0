From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: remove deprecated oldalloc
Date: Tue, 16 Aug 2011 15:26:27 +0200
Message-ID: <20110816132627.GC23416@quack.suse.cz>
References: <1307453714-2741-1-git-send-email-lczerner@redhat.com>
 <alpine.LFD.2.00.1108111658520.29009@dhcp-27-109.brq.redhat.com>
 <BF21E0BA-332B-4ADD-901C-5B0E8590898A@dilger.ca>
 <alpine.LFD.2.00.1108151612120.19095@dhcp-27-109.brq.redhat.com>
 <20110815152729.GE6597@quack.suse.cz>
 <alpine.LFD.2.00.1108151747260.3695@dhcp-27-109.brq.redhat.com>
 <20110815184945.GB16369@quack.suse.cz>
 <alpine.LFD.2.00.1108161035540.3675@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>,
	linux-ext4@vger.kernel.org, tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38650 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430Ab1HPN0c (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Aug 2011 09:26:32 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1108161035540.3675@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 16-08-11 10:40:12, Lukas Czerner wrote:
> On Mon, 15 Aug 2011, Jan Kara wrote:
> 
> > On Mon 15-08-11 17:50:53, Lukas Czerner wrote:
> > > On Mon, 15 Aug 2011, Jan Kara wrote:
> > > > On Mon 15-08-11 16:21:27, Lukas Czerner wrote:
> > > > > On Thu, 11 Aug 2011, Andreas Dilger wrote:
> > > > > > On 2011-08-11, at 8:58 AM, Lukas Czerner wrote:
> > > > > > > On Tue, 7 Jun 2011, Lukas Czerner wrote:
> > > > > > >> For a long time now orlov is the default block allocator in the ext4. It
> > > > > > >> performs better than the old one and no one seems to claim otherwise so
> > > > > > >> we can safely drop it and make oldalloc and orlov mount option
> > > > > > >> deprecated.
> > > > > > >> 
> > > > > > >> This is a part of the effort to reduce number of ext4 options hence the
> > > > > > >> test matrix.
> > > > > > >> 
> > > > > > >> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > > > > > > 
> > > > > > > ping
> > > > > > 
> > > > > > I'm OK with removing this, I don't think anyone uses it, and it has almost
> > > > > > no meaning with flex_bg anyway.
> > > > > > 
> > > > > > That said, "orlov" is also mostly meaningless with flex_bg as well, since
> > > > > > there is very little real benefit/affinity from inodes being "close" to
> > > > > > their data blocks.  We gain far more benefit from keeping the inodes
> > > > > > together than spreading them out and keeping them close to the data blocks.
> > > > > 
> > > > > What about removing it for ext3 as well ? I can prepare a patch.
> > > >   OK, let's start warning the option is deprecated and will be removed from
> > > > ext3. We can remove it after 2-3 releases...
> > > 
> > > Is that really necessary ? It is not like we are removing a feature which
> > > would not work anymore.
> >   Well, we are removing a mount option so if someone is using it e.g. in
> > /etc/fstab, his machine will fail to mount the filesystem. Or did I
> > misunderstood your intention?
> 
> It will not fail to boot, see the patch at the beginning of the thread.
> It will just print KERN_WARNING that we are ignoring this option. Since
> we are not removing a feature that will be missing, we can do that. Also
> note that this is the same thing what we have done to nobh option, and
> there are probably even other examples.
  Ah, OK. That would be fine I guess. I can take such patch.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
