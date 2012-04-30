From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Determining if an ext4 fs uses the whole partition
Date: Mon, 30 Apr 2012 12:29:50 -0500
Message-ID: <4F9ECC0E.8020201@redhat.com>
References: <CAMLZHHSi=1U=-V+qMOOunPnuSWDcTm81aSjXdnc51kvYk=n_vA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Daniel Drake <dsd@laptop.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756464Ab2D3RaE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Apr 2012 13:30:04 -0400
In-Reply-To: <CAMLZHHSi=1U=-V+qMOOunPnuSWDcTm81aSjXdnc51kvYk=n_vA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/30/12 12:19 PM, Daniel Drake wrote:
> Hi,
> 
> OLPC has started using ext4 online resizing to grow our filesystems to
> use the whole SD card on first boot - something we never did before.
> Working very nicely, thanks!
> 
> I'm trying to simplify/improve the scripts involved in doing this.
> 
> How can I programatically check if an ext4 fs already fills its
> partition, or if it has room to grow?
> 
> 
> The numbers produced by dumpe2fs (e.g. block count) or "df" don't seem
> to exactly line up with the sizes produced by fdisk.

Do you have an example of this?

For starters, use fdisk -u to get 512-byte sector units,
otherwise it's just inscrutable CHS magic.

i.e.:

# fdisk -lu /dev/sda2

Disk /dev/sda2: 526 MB, 526417920 bytes
255 heads, 63 sectors/track, 64 cylinders, total 1028160 sectors
Units = sectors of 1 * 512 = 512 bytes

so 1028160 512-byte sectors.

# dumpe2fs -h /dev/sda2 | grep "Block count\|Block size"
dumpe2fs 1.42.2 (27-Mar-2012)
Block count:              514080
Block size:               1024

so 514080 1k blocks, or 1028160 512-byte sectors, so bingo, it's full.

Of course you can't use an odd sector hanging off the end, so you'd
need to do a little rounding down to the nearest fs block size.
Otherwise, it should be straightforward.

Or, FWIW, it's harmless to invoke resize2fs if the fs already fills the
partition; it should just exit with a no-op.

> One easy solution, if possible, would be to find out the number of the
> last sector used by the filesystem. I could then very easily compare
> this to the "end" information found in sysfs for the partition. Then I
> can make the decision on whether to grow or not.

dumpe2fs should certainly be able to tell you.  Mounting the fs, and
doing statfs would, as well (f_blocks).  There should also be libext2fs
functions you could use if you want to do it in C...

-Eric
