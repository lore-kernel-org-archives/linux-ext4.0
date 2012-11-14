From: Kimmo Mustonen <k-20121112-81452+linux-ext4@tzimmola.net>
Subject: Re: resize2fs running out of reserved gdt blocks.
Date: Wed, 14 Nov 2012 03:07:24 +0200 (EET)
Message-ID: <alpine.DEB.1.10.1211140254320.2903@wormhole.tzimmola.net>
References: <alpine.DEB.1.10.1211121241000.2903@wormhole.tzimmola.net> <20121112144020.GD4895@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Kimmo Mustonen <k-20121112-81452+linux-ext4@tzimmola.net>,
	linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wormhole.tzimmola.net ([83.150.105.79]:52514 "EHLO
	wormhole.tzimmola.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052Ab2KNBH2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Nov 2012 20:07:28 -0500
In-Reply-To: <20121112144020.GD4895@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 12 Nov 2012, Theodore Ts'o wrote:

> If you are willing to temporarily boot a bleeding edge 3.7 kernel and
> use the resize2fs from e2fsprogs 1.42.6, you'll be able to resizing
> your partition.  After you do this, you could fall back to the Debian

After a bit of fighting generating a proper .config file I managed to boot 
into 3.7.0-rc5 and resize the partition. And I just noticed that I 
accidentally used e2fsprogs 1.42.5 for doing that. Should I be worried 
about that? Now back running 3.2.0-0.bpo.3-amd64 kernel. I'm running 
e2fsck-1.42.6 to check it now. BTW, resize from 12T to 15T was amazingly 
fast (about 30 seconds) now when comparing to the "old" behaviour where it 
took hours to complete. Thanks!

> stable kernel and things should work w/o problems; the latest kernel
> and e2fsprogs code is needed just for the online resize operation.

If I continue to increase the array using 3.7.0-rc5 and resize2fs-1.42.6, 
when do you expect me to encounter problems or hit the next barrier? Is 
going past 16TB safe? How about 32TB? What is the maximum size I can reach 
with this setup? The filesystem was made with 64bit flag.

Regards,
Kimmo
