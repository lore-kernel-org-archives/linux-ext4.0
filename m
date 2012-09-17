From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: NULL pointer dereference in ext4_ext_remove_space on 3.5.1
Date: Mon, 17 Sep 2012 18:48:06 +0400
Message-ID: <87d31keme1.fsf@openvz.org>
References: <CABRT9RAOhaxcYdCxMn5neJ9WT85r=h=7WgZ2dmLaOs-MMqDW9A@mail.gmail.com> <20120816024654.GB3781@thunk.org> <87fw6get5z.fsf@openvz.org> <20120917135215.GA26919@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Marti Raudsepp <marti@juffo.org>,
	Kernel hackers <linux-kernel@vger.kernel.org>,
	ext4 hackers <linux-ext4@vger.kernel.org>, maze@google.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:33064 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282Ab2IQOsK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Sep 2012 10:48:10 -0400
In-Reply-To: <20120917135215.GA26919@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 17 Sep 2012 09:52:15 -0400, Theodore Ts'o <tytso@mit.edu> wrote:
> On Mon, Sep 17, 2012 at 04:21:44PM +0400, Dmitry Monakhov wrote:
> > On Wed, 15 Aug 2012 22:46:54 -0400, Theodore Ts'o <tytso@mit.edu> wrote:
> > > On Wed, Aug 15, 2012 at 09:33:29PM +0300, Marti Raudsepp wrote:
> > > > I was moving and deleting some files between two of my ext4 partitions
> > > > when it suddenly crashed and dropped me into an kernel oops screen
> > > > (below). I'm using ext4 on kernel 3.5.1 (Arch Linux). 
> > Ohh, I've missed that gigantic topic, but still i've found the bug.
> > patch is available here http://patchwork.ozlabs.org/patch/183649/
> 
> Dmitry, we have a patch in mainline already which addresses this, and
> it's already backported to v3.5.3 or later.
> 
> What version was your patch series based against?
patch-set was prepared against d0f56971992a0bcc7 (old ext4.git's HEAD)
And you right your patch fixed the issue. So you can ignore my version.
but other patches from the 'Bunch of DIO/AIO fixes V2' queue are still
valid an applies to recent git tree w/o problems.
Should i resend whole series or you'll pick original one?
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
