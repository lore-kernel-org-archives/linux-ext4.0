From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 2/2] ext4: Add EXT4_IOC_TRIM ioctl to handle batched
 discard
Date: Fri, 19 Nov 2010 17:26:51 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1011191725400.3238@dhcp-lab-213.englab.brq.redhat.com>
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com> <1290065809-3976-2-git-send-email-lczerner@redhat.com> <20101119161929.GI10039@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	hch@infradead.org, sandeen@redhat.com
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144Ab0KSQ1D (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Nov 2010 11:27:03 -0500
In-Reply-To: <20101119161929.GI10039@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 19 Nov 2010, Ted Ts'o wrote:

> On Thu, Nov 18, 2010 at 08:36:49AM +0100, Lukas Czerner wrote:
> > @@ -541,6 +541,7 @@ struct ext4_new_group_data {
> >   /* note ioctl 11 reserved for filesystem-independent FIEMAP ioctl */
> >  #define EXT4_IOC_ALLOC_DA_BLKS		_IO('f', 12)
> >  #define EXT4_IOC_MOVE_EXT		_IOWR('f', 15, struct move_extent)
> > +#define EXT4_IOC_TRIM			FITRIM
> 
> If we're going to keep FITRIM defined in include/fs.h, then we should
> just dispatch off of FITRIM below, and not define EXT4_IOC_TRIM.
> 
> > +	case EXT4_IOC_TRIM:
> > +	{
> 
> Agreed?

I am ok either way, I was just following example of EXT4_IOC_GETFLAGS -> 
FS_IOC_GETFLAGS etc..

-Lukas

> 
> There's no point making this look like an EXT4-specific interface; if
> other file systems want to implement FITRIM as an ioctl, they are free
> to do so.
> 
> 						- Ted
> 
