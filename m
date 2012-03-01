From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: mkfs.ext4 vs. e2fsck discard oddities
Date: Thu, 1 Mar 2012 15:54:37 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1203011540180.6491@dhcp-27-109.brq.redhat.com>
References: <4F4D1020.5060204@redhat.com> <alpine.LFD.2.00.1202290801510.4926@dhcp-27-109.brq.redhat.com> <34CA4C93-194F-45F3-9A94-E181A7DFEBCE@mit.edu> <alpine.LFD.2.00.1203010804410.6491@dhcp-27-109.brq.redhat.com> <20120301143834.GA30578@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>,
	Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442Ab2CAOyn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Mar 2012 09:54:43 -0500
In-Reply-To: <20120301143834.GA30578@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 1 Mar 2012, Ted Ts'o wrote:

> On Thu, Mar 01, 2012 at 08:12:44AM +0100, Lukas Czerner wrote:
> > 
> > actually mke2fs does discard block by default. It has been like that
> > since the beginning. Back then we only had '-K' argument to 'keep'
> > blocks and do not attempt to discard. Nowadays user can do '-E
> > nodiscard', but it is users choice.
> 
> Ah, you're right.  The defaults had changed back and forth a couple of
> times over time and I had lost track of how things had been settled
> for mke2fs (which is different from e2fsck).  At least at one point it
> was _not_ the default, and in fact the man page was out of sync with
> the behavior of the mke2fs.

I am really not sure about that, I know that there was a discussion
whether to disable it by default, but I think that we never did that.
But that's not important.

> 
> The point remains the same, though, if the file system was created
> with mke2fs -E nodiscard, how do you undo that decision if there's no
> way to force the discard of BLOCK_UNINIT blocks?
> 
> 						- Ted
> 

Well, it is not default right ? So the user should better know what is
he doing. Moreover it is not like it is end of the world when we do not
provide that option, since SSD's will handle over provisioning to some
extent even without slowdown, and as for thin-provisioned devices you
should know why you're overriding defaults and what it means for you.

Anyway, if people really want this another option to discard all the
block groups including those UNINIT ones, I guess I can not resist that
:). '-E discard_all' maybe ?

Thanks!
-Lukas
