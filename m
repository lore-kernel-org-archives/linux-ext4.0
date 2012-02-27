From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [RESEND] [PATCH 2/2 v2] e2fsck: Do not forget to discard last
 block group
Date: Mon, 27 Feb 2012 13:05:29 -0500
Message-ID: <20120227180529.GE1651@thunk.org>
References: <1330072490-26833-1-git-send-email-lczerner@redhat.com>
 <1330072490-26833-2-git-send-email-lczerner@redhat.com>
 <20120227170011.GB1651@thunk.org>
 <alpine.LFD.2.00.1202271838330.5540@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, psusi@ubuntu.com, sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53161 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754074Ab2B0SFa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Feb 2012 13:05:30 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1202271838330.5540@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 27, 2012 at 06:57:48PM +0100, Lukas Czerner wrote:
> 
> exactly. I am trying to benefit from the same optimization e2fsck does.
> If the BLOCK_UNINIT is set then we can easily leave that group be and
> save some time. Even though that might not be a huge problem with small
> file systems, or some *really* fast SSD's, you'll certainly notice it on
> huge thin-provisioned storage, or generally any bigger discard capable
> device.

Well, maybe then the right answer is that we make it an option.  There
*are* times when you might want to issue a discard for every single
unused block, even if you think it may have already been discarded.

For example, there are some brain-damaged thin-provisioned storage
boxes that ignore discards that are smaller than 4 megabytes, and then
only discard on 4 megabyte aligned boundaries.  So even though the
space might have been previously discarded, one of the reasons why you
might want e2fsck -E discard to force a discard of the entire block
group is because the space might not have been released if the
previous TRIM commands (perhaps issued as various 1mb files were
deleted) didn't obey whatever arbitrary restrictions that are imposed
by the storage device.

I'll agree that as a default, the optimization might make sense.  But
it would be good if there's a way to really to bypass the optimization
and issue the discard for every single unused block.

    	      	      	  	       - Ted
