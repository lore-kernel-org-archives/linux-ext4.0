From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 2/2] Add batched discard support for ext4 - using
 rbtree
Date: Mon, 26 Apr 2010 20:42:58 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1004262038310.29999@localhost>
References: <1271674527-2977-2-git-send-email-lczerner@redhat.com> <1271674527-2977-3-git-send-email-lczerner@redhat.com> <r2k87f94c371004201421se796c0ekbae28495e62a9eb7@mail.gmail.com> <4BCE6243.5010209@teksavvy.com> <4BCE66C5.3060906@redhat.com>
 <v2w87f94c371004211159ue3a48923u6a543e8090dcdfa6@mail.gmail.com> <4BCF4C53.3010608@redhat.com> <x49zl0w1uhh.fsf@segfault.boston.devel.redhat.com> <k2y87f94c371004211344xfd17387fwc62432d022145376@mail.gmail.com> <alpine.LFD.2.00.1004230944070.2814@localhost>
 <20100426165527.GB21179@atrey.karlin.mff.cuni.cz> <alpine.LFD.2.00.1004261903260.2797@localhost> <4BD5D2EA.1070008@redhat.com> <alpine.LFD.2.00.1004261957001.29999@localhost> <x49hbmy2hmz.fsf@segfault.boston.devel.redhat.com>
 <alpine.LFD.2.00.1004262036070.29999@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jeff Moyer <jmoyer@redhat.com>, Ric Wheeler <rwheeler@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Mark Lord <kernel@teksavvy.com>, linux-ext4@vger.kernel.org,
	Edward Shishkin <eshishki@redhat.com>,
	Eric Sandeen <esandeen@redhat.com>,
	Christoph Hellwig <hch@infradead.org>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280Ab0DZSnC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Apr 2010 14:43:02 -0400
In-Reply-To: <alpine.LFD.2.00.1004262036070.29999@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 26 Apr 2010, Lukas Czerner wrote:

> Create an ioctl which walks through all the free extents in each
> allocating group and discard those extents. As an addition to improve
> its performance one can specify minimum free extent length, so ioctl
> will not bother with shorter extents.
> 
> This of course means, that with each invocation the ioctl must walk
> through whole file system, checking and discarding free extents, which
> is not very efficient. The best way to avoid this is to keep track of
> deleted (freed) blocks. Then the ioctl have to trim just those free
> extents which were recently freed.
> 
> In order to implement this I have created new structure
> ext4_deleted_data which represents deleted extent in per-group rbtree.
> When blocks are freed, extents are stored in the tree (possibly merged
> with other extents). The ioctl then can walk through the tree, take out
> extents from the tree, compare them with the free extents and possibly
> trim them.
> 
> Note that there is support for setting minimum extent length in ioctl
> call, so it will not bother with shorter extents. Also, when the
> previously deleted range is taken from the tree and it is not entirely
> free, the free fragments are discarded and extents shorter than minlen
> are NOT returned back to the tree to avoid fragmentation of the tree
> which could lead to the big memory consumption.
> 
> But you may notice, that there is one problem. bb_bitmap_deleted does
> not survive umount. To bypass the problem the first ioctl call have to
> walk through whole file system trimming all free extents.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

For now it just ignores the small extents to avoid fragmentation. As I
said before, I agree that they should not be ignored, I just need to
figure out the way to do this efficiently. 

Also it was not properly tested yet.


-Lukas.
