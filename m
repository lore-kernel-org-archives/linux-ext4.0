From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 1/2] Add discard/nodiscard mount option for ext3
Date: Mon, 12 Jul 2010 18:01:39 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1007121753440.13784@localhost>
References: <1278508727-29135-1-git-send-email-lczerner@redhat.com> <1278508727-29135-2-git-send-email-lczerner@redhat.com> <20100712151921.GA19433@atrey.karlin.mff.cuni.cz> <alpine.LFD.2.00.1007121722230.2733@localhost>
 <20100712155007.GF3356@quack.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	jmoyer@redhat.com, rwheeler@redhat.com, eshishki@redhat.com,
	sandeen@redhat.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752997Ab0GLQBt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Jul 2010 12:01:49 -0400
In-Reply-To: <20100712155007.GF3356@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 12 Jul 2010, Jan Kara wrote:

> On Mon 12-07-10 17:26:49, Lukas Czerner wrote:
> > On Mon, 12 Jul 2010, Jan Kara wrote:
> > 
> > > > Those mount option has the same meaning as in ext4 file system. It
> > > > provide a way to enable/disable file system's trim support. The trim
> > > > support is off by default, thus nodiscard option is not actually
> > > > necessary.
> > >   I kind of miss why ext3 should have a 'discard' mount option. When
> > > user calls DISCARD ioctl on the filesystem, then he probably wants
> > > discard to be performed.
> > > 
> > > 								Honza
> > 
> > You're right that it is not necessarily needed, but it is the same as in
> > ext4.
>   For ext4 it's a bit different matter as it automatically sends discard
> requests from mballoc when a block is freed. It makes a good sense to have
> an option to enable / disable this. But even for ext4 it would make sense
> to me to be able to allow this ioctl but still disable the logic for
> automatic trimming... Thus my suggestion would be to make 'discard' mount
> option only influence automatic trimming in ext4 and consequently it does
> not make sense to have such an option for ext3...
> 
> > If you want to be really sure that no unwanted trim will be send to the
> > device, 'nodiscard' mount option becomes handy. But I do not insist on it
> > and I can easily get rid of it.
>   Yeah, but the ioctl can be unsafe only if there are HW bugs or the trim
> support is buggy. Of course, both can happen but I don't think it's serious
> enough to warrant a new mount option (as that costs us something as well -
> too much options => user confusion ;).
> 
> 								Honza

You're probably right, it is not needed for ext3. And since my patch for
ext4 removes the old 'send trim when block is freed' implementation, I guess
it is not needed there either.

-Lukas
