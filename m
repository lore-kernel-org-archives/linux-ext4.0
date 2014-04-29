From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [RFC] Defragmentation strategies
Date: Tue, 29 Apr 2014 13:23:31 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1404291312520.2183@localhost.localdomain>
References: <87k3a9d8jh.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15045 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933858AbaD2LXg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Apr 2014 07:23:36 -0400
In-Reply-To: <87k3a9d8jh.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 28 Apr 2014, Dmitry Monakhov wrote:

> Date: Mon, 28 Apr 2014 14:59:14 +0400
> From: Dmitry Monakhov <dmonakhov@openvz.org>
> To: ext4 development <linux-ext4@vger.kernel.org>
> Subject: [RFC] Defragmentation strategies
> 
> 
> Hi. 
> In ext4 we have EXT4_IOC_MOVE_EXT ioctl which allow to
> migrate data block. At this moment the only defragmentation
> strategy we have in e4defrag(8) is defragmentation of big files.
> But one can imagine different defragmentation strategies for
> different file sizes and different purposes. I would like to start a 
> discussion about list of strategies which can be usable for us:
> 
> * Big file defragmentation
>   Good known strategy to make big files
> ** Example: In fact fragmented for big files may appear only in such cases
>    1) Creation big files on FS which has low free space
>    2) weird io pattern (multi-threaded small chunks random io + fsync) or
>       punch_hole/collapse_range etc.

Hi,

Some files might be be even worth to try to optimize (like those
accessed with random io) and rather use the available contiguous
space for files which will benefit more.

> 
> * Compact small old files to continuous chunks.
> **  Example:
>      news, mail, web or cache server contains a lot of small files in
>      each directory. And files are periodically created and unlinked
>      after some period of time. Files has different(unpredictable)
>      life-time which result in fragmented fs because block allocator tries
>      to compact new files to each other, but later unlink result in
>      fragmentation.  In case of thin-provision target this also result
>      in significant waste of space.
> ** Proposed strategy:
>    Scan directory and collect small old files it to continuous chunks.
>    Core idea is similar to block allocations smaller than
>    s_mb_stream_request. But at this moment we have more information about
>    file history because if mtime is close to ctime then append is
>    unlikely to happen in future so compaction is effective.

Makes sense to me, utilizing the information about when the file has
been modified might be useful for packing "read-only" files together
to make free space fragmentation a little bit better.

> 
> * Compact files according to IO access pattern.
>   Various tracers may collect statistics about IO access pattern, so
>   we can place such block close to each other and reduce number of seeks.
> ** Example:
>    1) Boot io pattern are almost identical across boots
>    2) Firefox start-up speedup http://glandium.org/blog/?p=1296

This also sounds good. Having a general solution or a way to
configure, or script a way to "defragment" different files with a
different strategy might be very useful.

This configuration file, or script or receipt or whatever you want
to call it would have to be user generated so the way to create it
should be relatively easy to use. Of course we could provide generic
ones as well.

Thanks!
-Lukas

> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
