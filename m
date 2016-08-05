From: Johannes Stezenbach <js@sig21.net>
Subject: Re: 4.7.0-rc7 ext4 error in dx_probe
Date: Fri, 5 Aug 2016 12:35:44 +0200
Message-ID: <20160805103544.kbt7znbzypvi5ofx@sig21.net>
References: <20160718141723.GA8809@sig21.net>
 <7849bcd2-142d-0a12-0a04-7d0c3b6d788f@etorok.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-kernel@vger.kernel.org, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwin@etorok.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7849bcd2-142d-0a12-0a04-7d0c3b6d788f@etorok.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Aug 03, 2016 at 05:50:26PM +0300, Török Edwin wrote:
> I have just encountered a similar problem after I've recently upgraded to 4.7.0:
> [Wed Aug  3 11:08:57 2016] EXT4-fs error (device dm-1): dx_probe:740: inode #13295: comm python: Directory index failed checksum
> [Wed Aug  3 11:08:57 2016] Aborting journal on device dm-1-8.
> [Wed Aug  3 11:08:57 2016] EXT4-fs (dm-1): Remounting filesystem read-only
> [Wed Aug  3 11:08:57 2016] EXT4-fs error (device dm-1): ext4_journal_check_start:56: Detected aborted journal
> 
> I've rebooted in single-user mode, fsck fixed the filesystem, and rebooted, filesystem is rw again now.
> 
> inode #13295 seems to be this and I can list it now:
> stat /usr/lib64/python3.4/site-packages
>   File: '/usr/lib64/python3.4/site-packages'
>   Size: 12288     	Blocks: 24         IO Block: 4096   directory
> Device: fd01h/64769d	Inode: 13295       Links: 180
> Access: (0755/drwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
> Access: 2016-05-09 11:29:44.056661988 +0300
> Modify: 2016-08-01 00:34:24.029779875 +0300
> Change: 2016-08-01 00:34:24.029779875 +0300
>  Birth: -
> 
> The filesystem was /, I only noticed it was readonly after several hours when I tried to install something:
> /dev/mapper/vg--ssd-root on / type ext4 (rw,noatime,errors=remount-ro,data=ordered)
> 
> $ uname -a
> Linux bolt 4.7.0-gentoo-rr #1 SMP Thu Jul 28 11:28:56 EEST 2016 x86_64 AMD FX(tm)-8350 Eight-Core Processor AuthenticAMD GNU/Linux
> 
> FWIW I've been using ext4 for years and this is the first time I see this message.
> Prior to 4.7 I was on 4.6.1 -> 4.6.2 -> 4.6.3 -> 4.6.4.
> 
> The kernel is from gentoo-sources + a patch for enabling AMD LWP (I had that patch since 4.6.3 and its not related to I/O).
> 
> If I see this message again what should I do to obtain more information to trace down the root cause?

It just happened again to me, this time hitting /usr/sbin/
on root fs.  Meanwhile I ran memtest86 7.0 for two nights,
it didn't find anything.  I'm using hibernate regularly
and I think so this only happened after a few hibernate/resume
cycles, but no idea if that means anything.
Now I'm back at 4.4.16 to see if it reproduces.

Johannes
