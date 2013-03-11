From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] mke2fs: restore verbose message for BLKDISCARD
Date: Mon, 11 Mar 2013 09:08:20 -0500
Message-ID: <513DE554.6020508@redhat.com>
References: <1362515118-30344-1-git-send-email-swarren@wwwdotorg.org> <alpine.LFD.2.00.1303060753500.24359@localhost> <5138EEBD.5000705@wwwdotorg.org> <alpine.LFD.2.00.1303080818510.24359@localhost> <513A1D56.1010402@wwwdotorg.org> <20130308190019.GB12008@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Stephen Warren <swarren@wwwdotorg.org>,
	=?windows-1252?Q?Luk=E1=9A_?= =?windows-1252?Q?Czerner?=
	<lczerner@redhat.com>, Chris Ball <cjb@laptop.org>,
	linux-ext4@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479Ab3CKOIY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Mar 2013 10:08:24 -0400
In-Reply-To: <20130308190019.GB12008@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/8/13 1:00 PM, Theodore Ts'o wrote:
> I hate to suggest this, but there's so many crappy devices out there
> that I'm wondering if we need to figure out some way of maintaining a
> black list of devices that don't handle discard properly.  For
> example, the Sandisk U100 advertises a max discard granularity of 512
> bytes, but I've been advised that if you don't use a discard
> granularity of 256k, aligned on 256k, you'll be very, very, sorry.

> It sounds like Stephen's device is probably an example of Yet Another
> Busted Trim implementation.  The problem is that manufacturers will be
> releasing more broken products faster than we can update a blacklist
> in the kernel.  So any blacklist would have to be maintained online on
> the web, and dynamically updated by distro installers.   :-(

Yeah I think it may be time for a blacklist.

TBH I think we should revisit discard-at-mkfs-time by default as well.

It seemed like a decent idea at the time, but now we have handy
fstrim as well as online/dynamic/realtime trim, and trim at mkfs
makes mke2fs completely un-doable in the event of fat fingers.

-Eric


> 
>     	     		 	    	   		 - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

