From: Mark Lord <kernel@teksavvy.com>
Subject: Re: Ext4: batched discard support
Date: Tue, 20 Apr 2010 16:24:43 -0400
Message-ID: <4BCE0D8B.5020306@teksavvy.com>
References: <1271674527-2977-1-git-send-email-lczerner@redhat.com> <h2o87f94c371004190920h5e793818x4113da75dd21da8b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	Jeff Moyer <jmoyer@redhat.com>,
	Edward Shishkin <eshishki@redhat.com>,
	Eric Sandeen <esandeen@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>, Mark Lord <liml@rtr.ca>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:43390 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755020Ab0DTUYr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Apr 2010 16:24:47 -0400
In-Reply-To: <h2o87f94c371004190920h5e793818x4113da75dd21da8b@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 19/04/10 12:20 PM, Greg Freemyer wrote:
> Adding Mark Lord in cc.
..
> On Mon, Apr 19, 2010 at 6:55 AM, Lukas Czerner<lczerner@redhat.com>  wrote:
..
>> The basic idea behind my discard support is to create an ioctl which
>> walks through all the free extents in each allocating group and discard
>> those extents. As an addition to improve its performance one can specify
>> minimum free extent length, so ioctl will not bother with shorter extents.
..

Perfect.  I proposed exactly this last year, but never found time to work it further.
Please proceed with it!

..
>> But you may notice, that there is one problem. bb_bitmap_deleted does
>> not survive umount. To bypass the problem the first ioctl call have to
>> walk through whole file system trimming all free extents. But there is a
>> better solution to this problem. The bb_bitmap_deleted can be stored on
>> disk an can be restored in mount time along with other bitmaps, but I
>> think it is a quite big change and should be discussed further.
..

That's not necessary.  It is a simple matter to TRIM a clean filesystem
before it is mounted R/W during the boot sequence.  No new information
is required for that operation.

My wiper.sh script already shows walking the freelists and trimming all
available space, something which takes only a couple of seconds on a 120GB
filesystem that has not been kept up-to-date with on-the-fly trim.

Cheers
