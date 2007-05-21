From: Jan Kara <jack@suse.cz>
Subject: Re: ext2/3/4 online defrag
Date: Mon, 21 May 2007 12:33:19 +0200
Message-ID: <20070521103319.GA29416@atrey.karlin.mff.cuni.cz>
References: <1178770799.26695.11.camel@eric-laptop> <20070517161119.GB3230@atrey.karlin.mff.cuni.cz> <1179465114.7891.17.camel@eric-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Eric <erpo41@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:39586 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756569AbXEUKdU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 May 2007 06:33:20 -0400
Content-Disposition: inline
In-Reply-To: <1179465114.7891.17.camel@eric-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> On Thu, 2007-05-17 at 18:11 +0200, Jan Kara wrote:
> > But me (and several other people
> > independently as I've learnt recently) have written some tools which
> > should result in something useful. If you're interested, you can join
> > prefetch-devel@googlegroups.com - it's led by one guy who is doing
> > defrag and stuff as his google summer of code project.
> 
> Is this different from the ext4/extent-based defrag patch that's been
> mentioned on this list?
  Yes, it is different. In particular, it's offline only tool so far...

> > > *An implementation of an ext* filesystem driver can work with any
> > > ext2/3/4 filesystem as long as it supports the necessary revision
> > > (GOOD_OLD_REV or DYNAMIC_REV) and feature flags set in the filesystem.
> >   Not sure what you mean here...
> 
> The "ext2 filesystem"/"ext3 filesystem"/"ext4 filesystem" terminology
> was confusing to me when I first started reading about them. In my mind,
> it implied that those three filesystems were more different than they
> actually are.
> 
> I think it would be more accurate to say that they are all essentially
> the same filesystem, and that any filesystem driver that can mount a
> given filesystem can mount any other ext2/3/4 filesystem of the same
> revision with the same feature flags set.
> 
> I was asking for confirmation of this assumption, but I've since found a
> lot of really good documentation that has cleared up a lot of things.
  Yes, basically it's just a question of a feature set. But for example
current online defrag from Takashi requires extents, which are not
available for ext2 or ext3.

								Honza

-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
