From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 1/2] Add discard/nodiscard mount option for ext3
Date: Mon, 12 Jul 2010 18:15:23 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1007121813100.2733@localhost>
References: <1278508727-29135-1-git-send-email-lczerner@redhat.com> <1278508727-29135-2-git-send-email-lczerner@redhat.com> <20100712151921.GA19433@atrey.karlin.mff.cuni.cz> <4C3B3CDE.9060505@redhat.com> <alpine.LFD.2.00.1007121802590.13784@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ric Wheeler <rwheeler@redhat.com>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, jmoyer@redhat.com, eshishki@redhat.com,
	sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320Ab0GLQPa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Jul 2010 12:15:30 -0400
In-Reply-To: <alpine.LFD.2.00.1007121802590.13784@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 12 Jul 2010, Lukas Czerner wrote:

> On Mon, 12 Jul 2010, Ric Wheeler wrote:
> 
> > On 07/12/2010 11:19 AM, Jan Kara wrote:
> > > > Those mount option has the same meaning as in ext4 file system. It
> > > > provide a way to enable/disable file system's trim support. The trim
> > > > support is off by default, thus nodiscard option is not actually
> > > > necessary.
> > >    I kind of miss why ext3 should have a 'discard' mount option. When
> > > user calls DISCARD ioctl on the filesystem, then he probably wants
> > > discard to be performed.
> > > 
> > > 								Honza
> > > 
> > 
> > Sorry I misunderstood your original question.
> > 
> > One reason that you might want to have a "discard" option is to allow a system
> > admin to mount without barriers to protect flaky hardware (we have had some
> > mixed results for example). As you say, the user probably wants to have the
> > ioctl do the discard and should be reasonable for doing it only on solid
> > devices,
> 
> The question is what in does on device other than SSD. I know it does
> not harm the deivce, but is there some kernel logic preventing the trim
> command to be send to device that does not support it ? I hope so.
> 

Yes, there is a check whether device support trim in blkdev_issue_discard
code.

-Lukas

> 
> > 
> > Regards,
> > 
> > Ric
> > 
> 

-- 
