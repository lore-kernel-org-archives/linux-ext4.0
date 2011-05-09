From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] mke2fs: Avoid segmentation fault in
 ext2fs_alloc_generic_bmap.
Date: Mon, 9 May 2011 12:09:47 -0400
Message-ID: <20110509160947.GD19811@thunk.org>
References: <1304955207-4066-1-git-send-email-tm@tao.ma>
 <alpine.LFD.2.00.1105091743330.3694@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tao Ma <tm@tao.ma>, linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34366 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953Ab1EIQJv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 May 2011 12:09:51 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1105091743330.3694@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 09, 2011 at 05:45:28PM +0200, Lukas Czerner wrote:
> 
> I have actually sent the same patch a while ago:
> 
> http://www.spinics.net/lists/linux-ext4/msg23763.html
> 
> but Ted have not picked up this yet.

I picked it up just the other day, and it's in the "next" branch of
e2fsprogs.

I thought I had sent an e-mail ack, but I may have forgotten to do so
with this patch; my apologies if that was the case!

						- Ted
