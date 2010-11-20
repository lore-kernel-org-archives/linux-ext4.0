From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: Add EXT4_IOC_TRIM ioctl to handle batched
 discard
Date: Fri, 19 Nov 2010 20:37:53 -0500
Message-ID: <20101120013753.GB28151@thunk.org>
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com>
 <1290065809-3976-2-git-send-email-lczerner@redhat.com>
 <20101119161929.GI10039@thunk.org>
 <alpine.LFD.2.00.1011191725400.3238@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, hch@infradead.org,
	sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:42222 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753694Ab0KTBhz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Nov 2010 20:37:55 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1011191725400.3238@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 19, 2010 at 05:26:51PM +0100, Lukas Czerner wrote:
> > If we're going to keep FITRIM defined in include/fs.h, then we should
> > just dispatch off of FITRIM below, and not define EXT4_IOC_TRIM.
> > 
> > > +	case EXT4_IOC_TRIM:
> > > +	{
> > 
> > Agreed?
> 
> I am ok either way, I was just following example of EXT4_IOC_GETFLAGS -> 
> FS_IOC_GETFLAGS etc..

The history of that was the ioctl was originally EXT4_IOC_GETFLAGS and
it was later generalized to be FS_IOC_GETFLAGS.  In this case though
we started with it being an generalized interface, so there's no need
to create an EXT4_IOC_TRIM ioctl.  I'll fix that up in your patch when
I add it to the ext4 patch queue.

						- Ted
