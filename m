From: tytso@mit.edu
Subject: Re: Ext4 inode & trim errors on Micron eUSB SSD with 2.6.37 kernel
Date: Thu, 24 Apr 2014 23:51:00 +0000
Message-ID: <20140424235028.GA15873@thunk.org>
References: <CAFZh4h9avyDGPMcJnbHZxLFKHr2fAopz_26LqmnSn3Hobni+nA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Brian Hutchinson <b.hutchman@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59940 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754604AbaDXXvB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Apr 2014 19:51:01 -0400
Content-Disposition: inline
In-Reply-To: <CAFZh4h9avyDGPMcJnbHZxLFKHr2fAopz_26LqmnSn3Hobni+nA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 24, 2014 at 04:05:26PM -0400, Brian Hutchinson wrote:
> Hi,
> 
> First post here but have been lurking and searching archives for a while.
> 
> I have a custom embedded board that I support which is running Yocto
> 1.5.  The mkfs.ext4 and all other efs2progs files are fairly
> up-to-date ... the kernel is just kind of old (yea, I know, I need to
> move up some but that is easier said than done on this thing).

Huh?  Yocto 1.5 ships with the 3.10 kernel (and Yocto 1.6 should be
shipping soon with an even newer kernel.)

2.6.37 dates back to 2011, and there have been a *huge* number of bug
fixes since then.

If you can't upgrade to a newer kernel, you might be better off
falling back to ext3, and see if the problem still presents itself
there.  Ext3 will create much more flash wear, but that's the price you
pay for staying on an ancient kernel.  :-)

    		      	      	       - Ted
