From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: e2fsck: Device or resource busy
Date: Tue, 3 Jun 2008 00:23:48 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.0806030020310.6160@sheep.housecafe.de>
References: <alpine.DEB.1.10.0806021951460.6160@sheep.housecafe.de> <20080602202144.GD23119@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:52131 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbYFBWYL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jun 2008 18:24:11 -0400
In-Reply-To: <20080602202144.GD23119@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2 Jun 2008, Theodore Tso wrote:
> The key thing that you need to do when trying to recover from RAID
> setups where you are missing one or more disks is to align the pieces
> so they are in their original places, with the missing pieces replaced
> with a /dev/zero device.

Hm, interesting, I did not consider that yet. Thanks for the links, I'll 
have a look. But again: I don't really care for the data, I was just 
playing around and wondering why it reported "Device or resource busy"
when I expected something like "unable to find superblock".

> (I'm assuming here you were using software RAID; if this was a

Yes, it was software RAID.

Thanks again,
Christian.
-- 
BOFH excuse #112:

The monitor is plugged into the serial port
