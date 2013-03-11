From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: torrent hash failures since 3.9.0-rc1
Date: Mon, 11 Mar 2013 21:13:34 +0100
Message-ID: <20130311201334.GA444@x4>
References: <20130311171824.GA434@x4>
 <20130311191753.GA439@x4>
 <20130311194159.GB3579@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Dave Jones <davej@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130311194159.GB3579@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2013.03.11 at 15:41 -0400, Dave Jones wrote:
> On Mon, Mar 11, 2013 at 08:17:53PM +0100, Markus Trippelsdorf wrote:
>  > On 2013.03.11 at 18:18 +0100, Markus Trippelsdorf wrote:
>  > > I get hash failures on "completed" torrents since 3.9.0-rc1 (Linux 3.8
>  > > seems to be fine). What happens is that the torrents apparently complete
>  > > successfully. After reboot however the hash check fails and there are
>  > > missing (or corrupted) chunks. I've tested this with two different
>  > > clients (rtorrent and aria2c) and both are affected. So I think this
>  > > might be a filesystem issue.
>  > > 
>  > > /dev/sda       ext4      1.4T  666G  640G  51% /var
>  > > /dev/sda on /var type ext4 (rw,noatime,data=ordered)
>  > > 
>  > > I use ECC memory (and there is nothing in the logs).
>  > 
>  > To reproduce this issue just do the following:
>  > 
>  >  % wget http://torrents.linuxmint.com/torrents/linuxmint-12-gnome-cd-nocodecs-64bit.iso.torrent
>  >  % rtorrent linuxmint-12-gnome-cd-nocodecs-64bit.iso.torrent
>  >  (Wait until the torrent finishes)
>  >  % sudo echo 3 > /proc/sys/vm/drop_caches
>  >  (Rehash the torrent (Ctrl-R))
>  >  The torrent doesn't rehash successfully and a few hunks are
>  >  missing/corrupted and need to be downloaded again.
> 
> Worked fine for me on two separate machines.  Could it be a network problem
> perhaps ? If something is mangling the packet before it hits the disk,
> that would explain it.  What NIC do you use ?

I normally use ATL1E, but I've dusted off my E100 and the issue is also
reproducible on the Intel card.

> Or maybe you could isolate it to a filesystem problem using something
> like fsx ?

I've found fsx on your homepage, but I've no idea on how to use this
tool. Any pointers?

-- 
Markus
