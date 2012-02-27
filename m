From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [RESEND] [PATCH 2/2 v2] e2fsck: Do not forget to discard last
 block group
Date: Mon, 27 Feb 2012 19:33:19 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1202271922520.5540@dhcp-27-109.brq.redhat.com>
References: <1330072490-26833-1-git-send-email-lczerner@redhat.com> <1330072490-26833-2-git-send-email-lczerner@redhat.com> <20120227170011.GB1651@thunk.org> <alpine.LFD.2.00.1202271838330.5540@dhcp-27-109.brq.redhat.com> <20120227180529.GE1651@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	psusi@ubuntu.com, sandeen@redhat.com
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654Ab2B0SdZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Feb 2012 13:33:25 -0500
In-Reply-To: <20120227180529.GE1651@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 27 Feb 2012, Ted Ts'o wrote:

> On Mon, Feb 27, 2012 at 06:57:48PM +0100, Lukas Czerner wrote:
> > 
> > exactly. I am trying to benefit from the same optimization e2fsck does.
> > If the BLOCK_UNINIT is set then we can easily leave that group be and
> > save some time. Even though that might not be a huge problem with small
> > file systems, or some *really* fast SSD's, you'll certainly notice it on
> > huge thin-provisioned storage, or generally any bigger discard capable
> > device.
> 
> Well, maybe then the right answer is that we make it an option.  There
> *are* times when you might want to issue a discard for every single
> unused block, even if you think it may have already been discarded.

I would really like to avoid another option if we can avoid it.

> 
> For example, there are some brain-damaged thin-provisioned storage
> boxes that ignore discards that are smaller than 4 megabytes, and then
> only discard on 4 megabyte aligned boundaries.  So even though the
> space might have been previously discarded, one of the reasons why you
> might want e2fsck -E discard to force a discard of the entire block
> group is because the space might not have been released if the
> previous TRIM commands (perhaps issued as various 1mb files were
> deleted) didn't obey whatever arbitrary restrictions that are imposed
> by the storage device.

I have to admit I do not really understand the example. If the block
group is flagged with BLOCK_UNINIT there was never any file allocated
from that group right ? Also, mke2fs issues initial full device discard
before the file system creation. So if you have this brain-damaged
thin-provisioned storage, discarding BLOCK_UNINIT groups would not
actually bring you anything.

> 
> I'll agree that as a default, the optimization might make sense.  But
> it would be good if there's a way to really to bypass the optimization
> and issue the discard for every single unused block.

Well, if the user really want to discard everything which is free in the
file system, then there is still wiper.sh which is not fs specific.
However it would have some unneeded consequences.

> 
>     	      	      	  	       - Ted
> 
