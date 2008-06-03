From: Theodore Tso <tytso@mit.edu>
Subject: Re: e2fsck: Device or resource busy
Date: Mon, 2 Jun 2008 20:00:38 -0400
Message-ID: <20080603000037.GF23119@mit.edu>
References: <alpine.DEB.1.10.0806021951460.6160@sheep.housecafe.de> <20080602202144.GD23119@mit.edu> <alpine.DEB.1.10.0806030020310.6160@sheep.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:57743 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752633AbYFCAAw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jun 2008 20:00:52 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0806030020310.6160@sheep.housecafe.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 03, 2008 at 12:23:48AM +0200, Christian Kujau wrote:
> On Mon, 2 Jun 2008, Theodore Tso wrote:
>> The key thing that you need to do when trying to recover from RAID
>> setups where you are missing one or more disks is to align the pieces
>> so they are in their original places, with the missing pieces replaced
>> with a /dev/zero device.
>
> Hm, interesting, I did not consider that yet. Thanks for the links, I'll 
> have a look. But again: I don't really care for the data, I was just 
> playing around and wondering why it reported "Device or resource busy"
> when I expected something like "unable to find superblock".

That will only happen if someone else has opened the device with
O_EXCL.  Are you sure you didn't ^Z an e2fsck or some such and then
started a second one, or some such?  

Is this repeatable?

							- Ted
