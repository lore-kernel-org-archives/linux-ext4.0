From: Mark Lord <kernel@teksavvy.com>
Subject: Re: Ext4: batched discard support
Date: Tue, 20 Apr 2010 16:34:37 -0400
Message-ID: <4BCE0FDD.6040700@teksavvy.com>
References: <1271674527-2977-1-git-send-email-lczerner@redhat.com> <h2o87f94c371004190920h5e793818x4113da75dd21da8b@mail.gmail.com> <4BCE0D8B.5020306@teksavvy.com>
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
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:31536 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755189Ab0DTUek (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Apr 2010 16:34:40 -0400
In-Reply-To: <4BCE0D8B.5020306@teksavvy.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 20/04/10 04:24 PM, Mark Lord wrote:
> On 19/04/10 12:20 PM, Greg Freemyer wrote:
>> Adding Mark Lord in cc.
> ..
>> On Mon, Apr 19, 2010 at 6:55 AM, Lukas Czerner<lczerner@redhat.com>
>> wrote:
> ..
>>> The basic idea behind my discard support is to create an ioctl which
>>> walks through all the free extents in each allocating group and discard
>>> those extents. As an addition to improve its performance one can specify
>>> minimum free extent length, so ioctl will not bother with shorter
>>> extents.
> ..
>
> Perfect. I proposed exactly this last year, but never found time to work it further.
> Please proceed with it!
..

Ahh. here it is/was:

On August 17, 1009, Mark Lord wrote:
> Taking care of mounted RAID / LVM filesystems requires in-kernel TRIM
> support, possibly exported via an ioctl().
>
> Taking care of unmounted RAID / LVM filesystems is possible in userland,
> but would also benefit from in-kernel support, where layouts are defined
> and known better than in userland.
>
> The XFS_TRIM was an idea that Cristoph floated, as a concept for examination.
>
> I think something along those lines would be best, but perhaps with an
> interface at the VFS layer.  Something that permits a userland tool
> to work like this (below) might be nearly ideal:
>
> main() {
>     int fd = open(filesystem_device);
>     while (1) {
>         int g, ngroups = ioctl(fd, GET_NUMBER_OF_BLOCK_GROUPS);
>         for (g = 0; g < ngroups; ++g) {
>             ioctl(fd, TRIM_ALL_FREE_EXTENTS_OF_GROUP, g);
>         }
>         sleep(3600);
>     }
> }
>
> Not all filesystems have a "block group", or "allocation group" structure,
> but I suspect that it's an easy mapping in most cases.
>
> With this scheme, the kernel is absolved of the need to track/coallesce
> TRIM requests entirely.
>
> Something like that, perhaps.
>
>
