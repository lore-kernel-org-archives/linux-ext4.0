From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: (LONG) Delay when writing to ext4 LVM after boot
Date: Thu, 25 Apr 2013 18:10:21 -0600
Message-ID: <536ADCB2-8421-415F-9527-69A9BCD8CC87@dilger.ca>
References: <CAH5g024kghoyTHKGDaed21hupYqs=U9cofRq4N4-84V=Zzjgfg@mail.gmail.com> <57F24075-09C7-4D65-A951-AF69CF8CA824@dilger.ca> <CAH5g026gzr31zevbFEUQarWcJ+ehdZYd-uHU+rhNyOx=0+XsgA@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	ext3-users@redhat.com
To: Ken Bass <daytooner@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:58907 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932440Ab3DZAKY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Apr 2013 20:10:24 -0400
Received: by mail-pa0-f45.google.com with SMTP id lf10so2156989pab.18
        for <linux-ext4@vger.kernel.org>; Thu, 25 Apr 2013 17:10:23 -0700 (PDT)
In-Reply-To: <CAH5g026gzr31zevbFEUQarWcJ+ehdZYd-uHU+rhNyOx=0+XsgA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013-04-25, at 9:06 AM, Ken Bass wrote:
> First, thanks. I think you answered my question. You get your gold star for the day :-).
> 
> The LV fs IS formatted as ext4. There are many files, of various length: (at least 102,959 items, totalling 3.6 TB). Most are either large files, videos and the like ( > 1G) or small files like images or pdfs, etc).
> 
> FYI:
> [root@elmer ken]# time dumpe2fs -h /dev/mapper/VG_NAS-LV_NAS 
> dumpe2fs 1.42.3 (14-May-2012)
> Filesystem volume name:   <none>
> Last mounted on:          /nas
> Filesystem UUID:          fe2db0bc-5e41-4c40-99f0-29e7771090b9
> Filesystem magic number:  0xEF53
> Filesystem revision #:    1 (dynamic)
> Filesystem features:      has_journal ext_attr resize_inode dir_index filetype needs_recovery extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
> Filesystem flags:         signed_directory_hash 
> Filesystem OS type:       Linux
> Inode count:              366288896
> Block count:              1465133056
> Reserved block count:     73240735
> Free blocks:              571585703
> Free inodes:              366185906
> Block size:               4096
> Reserved GDT blocks:      674
> Blocks per group:         32768
> Fragments per group:      32768
> Flex block group size:    16

This flex_bg size is only 16 blocks (which is the default), but at best only reduces the seeks by a factor of 16 at first access time.  For your block count, this should be about 45k groups, and 2800 clusters of bitmaps.

While e2fsck will load all of those bitmaps in a single pass, it is possible that the kernel does not do this, fetching each one separately and requiring a seek wait (if not in the track cache).

You definitely have a large number of free blocks, so the allocator _should_ be able to find something quickly, but there isn't currently a "fast path" to find a free chunk of large space at mount time.

I suspect this could be worked around in some manner.  We could potentially cache some hints on disk and/or skip a lot of bitmap loads at startup time if the allocation was large.

> [root@elmer ken]# 
> [root@elmer ken]# time dumpe2fs /dev/mapper/VG_NAS-LV_NAS > /dev/null
> dumpe2fs 1.42.3 (14-May-2012)
> 
> real    1m16.634s
> user    1m16.174s
> sys    0m0.066s
> [root@elmer ken]#
> 
> So, there's the LONG delay (1.25m +).
> 
> As a s/w engineer in a previous lifetime, I would think there must be some metadata (on the disk) that keeps a coalesced mapping of free blocks. This would be analogous to a ram heap management system. Granted, most file server systems don't get powered down or reboot very often, but for a very large storage (10G plus) this must be a very significant issue. Just my 2 cents worth.

By "large" you mean "10T plus"?  :-)

> You mentioned doing this at startup. Could this be done in background, so the boot wouldn't take a minute or more extra? And also, any particular place to add this code?

It can be done in any system startup file like /etc/rc.d/rc.local, and can be run in the background either before or while the filesystem is mounted, since it is only reading from the disk.

> On Wed, Apr 24, 2013 at 8:58 AM, Andreas Dilger <adilger@dilger.ca> wrote: 
>> If there is a delay between mounting and the first write, you could prefetch the bitmaps with "dumpe2fs /dev/XXX > /dev/null" so that it loads all of the bitmaps before they are needed.  Some people do this in a startup script as a workaround for the initial write slowness.
>> 
>> Changing the allocation policy would not help in your case, since the large file would need more blocks than could be satisfied by the early groups. That is why you don't see a slowdown for small files.


Cheers, Andreas





