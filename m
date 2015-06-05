From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [Qemu-devel] Re-2:  Strange problems with lseek in qemu-img
 map
Date: Fri, 5 Jun 2015 17:14:14 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1506051711390.13926@localhost.localdomain>
References: <00056481.556F34D3@pegasus.munzinger.de> <20150605140515.GB30104@stefanha-thinkpad.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: David Weber <wb@munzinger.de>, qemu-devel@nongnu.org,
	linux-ext4@vger.kernel.org, wency@cn.fujitsu.com,
	wenqing.lz@taobao.com
To: Stefan Hajnoczi <stefanha@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422723AbbFEPOW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Jun 2015 11:14:22 -0400
In-Reply-To: <20150605140515.GB30104@stefanha-thinkpad.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 5 Jun 2015, Stefan Hajnoczi wrote:

> Date: Fri, 5 Jun 2015 15:05:15 +0100
> From: Stefan Hajnoczi <stefanha@gmail.com>
> To: David Weber <wb@munzinger.de>
> Cc: qemu-devel@nongnu.org, linux-ext4@vger.kernel.org,
>     Lukas Czerner <lczerner@redhat.com>, wency@cn.fujitsu.com
> Subject: Re: [Qemu-devel] Re-2:  Strange problems with lseek in qemu-img map
> 
> On Wed, Jun 03, 2015 at 03:09:40PM +0000, David Weber wrote:
> > > > I then startet a fedora 22 live system and I saw the same problem. It 
> > > > happens 
> > > > on both the ramdisk and a ext4 filesystem.
> > > 
> > > "it" == qemu-img map hangs or takes a very long time?
> > I never waited for it to complete but I guess it just takes very long.
> > 
> > > 
> > > Can you post a shell script that reproduces this with a ramdisk?  That
> > > seems like the easiest way to get people debugging it.
> > 
> > You can use the following commands.
> > 
> > mkfs.ext4 /dev/ram0
> > mkdir -p /mnt/tmp
> > mount /dev/ram0 /mnt/tmp
> > cd /mnt/tmp
> > qemu-img create test 500G
> > time qemu-img map test
> > 
> > This takes foreover on all my systems.
> 
> I experience the same thing on Linux 4.1.0-rc5 with ext4 (4 KB file
> system block size, 512B device sector size).
> 
> The lseek() calls take *seconds* to complete on a completely empty
> (sparse) 500G file.
> 
> Here is the perf-top(1) output:
> 
>   34.08%  [kernel]                         [k] _raw_read_lock
>   21.11%  [kernel]                         [k] ext4_es_lookup_extent
>   20.67%  [kernel]                         [k] ext4_es_find_delayed_extent_range
>    8.68%  [kernel]                         [k] ext4_map_blocks
>    4.99%  [kernel]                         [k] ext4_llseek
>    1.90%  [kernel]                         [k] rb_next
>    0.14%  [kernel]                         [k] __fget
> 
> Yikes!
> 
> The syscall causing this is just:
> 
> lseek(7, 0, SEEK_DATA)
> 
> Lukas: I've CCed you because you have helped with ext4 issues in the
> past.  Not sure if you have time or if this is your area.
> 
> Stefan

Hi,

this is definitely an issue with extent status tree and I have not seen
it before. I'll look at it first thing next week, but meanwhile I'll
add Zheng Liu who is the author of the extent status tree so he
might be able to help you.

Regards,
-Lukas
