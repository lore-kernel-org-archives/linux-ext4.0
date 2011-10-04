From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: Oops in block/ext4 layer on USB3 hard drive connect
Date: Tue, 4 Oct 2011 08:52:23 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1110040851040.4206@dhcp-27-109.brq.redhat.com>
References: <20111003185235.GA12865@xanatos>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jens Axboe <axboe@kernel.dk>, "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org,
	USB Storage List <usb-storage@lists.one-eyed-alien.net>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624Ab1JDGwj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Oct 2011 02:52:39 -0400
In-Reply-To: <20111003185235.GA12865@xanatos>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 3 Oct 2011, Sarah Sharp wrote:

> Hi Jens, Ted, and Andreas,
> 
> A co-worker of mine found a 100% reproducible oops that happens when a
> IOMEGA USB 3.0 hard drive is plugged into a particular machine.  It
> looks like an oops in the block or EXT4 layer, and it doesn't seem to be
> in the xHCI (USB 3.0 host controller) driver.  (Although looking at the
> log again, it seems show a cut-off oops at the beginning of the log...)
> 
> This appears on the 3.0.4 stable kernel.  dmesg is attached.  Let me
> know if you need any other info to help solve this issue.
> 
> Sarah Sharp
> 

Hello,

looking at the dmesg it really looks like there is a trace missing,
could you post the full oops ?

Thanks!
-Lukas
