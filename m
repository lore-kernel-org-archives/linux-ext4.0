From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] Add discard/nodiscard mount option for ext3
Date: Mon, 12 Jul 2010 17:50:08 +0200
Message-ID: <20100712155007.GF3356@quack.suse.cz>
References: <1278508727-29135-1-git-send-email-lczerner@redhat.com>
 <1278508727-29135-2-git-send-email-lczerner@redhat.com>
 <20100712151921.GA19433@atrey.karlin.mff.cuni.cz>
 <alpine.LFD.2.00.1007121722230.2733@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	jmoyer@redhat.com, rwheeler@redhat.com, eshishki@redhat.com,
	sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:55965 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572Ab0GLPua (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Jul 2010 11:50:30 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1007121722230.2733@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 12-07-10 17:26:49, Lukas Czerner wrote:
> On Mon, 12 Jul 2010, Jan Kara wrote:
> 
> > > Those mount option has the same meaning as in ext4 file system. It
> > > provide a way to enable/disable file system's trim support. The trim
> > > support is off by default, thus nodiscard option is not actually
> > > necessary.
> >   I kind of miss why ext3 should have a 'discard' mount option. When
> > user calls DISCARD ioctl on the filesystem, then he probably wants
> > discard to be performed.
> > 
> > 								Honza
> 
> You're right that it is not necessarily needed, but it is the same as in
> ext4.
  For ext4 it's a bit different matter as it automatically sends discard
requests from mballoc when a block is freed. It makes a good sense to have
an option to enable / disable this. But even for ext4 it would make sense
to me to be able to allow this ioctl but still disable the logic for
automatic trimming... Thus my suggestion would be to make 'discard' mount
option only influence automatic trimming in ext4 and consequently it does
not make sense to have such an option for ext3...

> If you want to be really sure that no unwanted trim will be send to the
> device, 'nodiscard' mount option becomes handy. But I do not insist on it
> and I can easily get rid of it.
  Yeah, but the ioctl can be unsafe only if there are HW bugs or the trim
support is buggy. Of course, both can happen but I don't think it's serious
enough to warrant a new mount option (as that costs us something as well -
too much options => user confusion ;).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
