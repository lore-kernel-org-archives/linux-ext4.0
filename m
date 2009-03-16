From: Rob Landley <rob@landley.net>
Subject: Re: ext2/3: document conditions when reliable operation is possible
Date: Mon, 16 Mar 2009 16:43:14 -0500
Message-ID: <200903161643.15887.rob@landley.net>
References: <20090312092114.GC6949@elf.ucw.cz> <20090316123051.GJ2405@elf.ucw.cz> <20090316194057.GA27897@silver.sucs.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Pavel Machek <pavel@ucw.cz>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	tytso@mit.edu, rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:33369
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045AbZCPVnV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Mar 2009 17:43:21 -0400
In-Reply-To: <20090316194057.GA27897@silver.sucs.org>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Monday 16 March 2009 14:40:57 Sitsofe Wheeler wrote:
> On Mon, Mar 16, 2009 at 01:30:51PM +0100, Pavel Machek wrote:
> > +	Unfortunately, none of the cheap USB/SD flash cards I've seen
> > +	do behave like this, and are thus unsuitable for all Linux
> > +	filesystems I know.
>
> When you say Linux filesystems do you mean "filesystems originally
> designed on Linux" or do you mean "filesystems that Linux supports"?
> Additionally whatever the answer, people are going to need help
> answering the "which is the least bad?" question and saying what's not
> good without offering alternatives is only half helpful... People need
> to put SOMETHING on these cheap (and not quite so cheap) devices... The
> last recommendation I heard was that until btrfs/logfs/nilfs arrive
> people are best off sticking with FAT -
> http://marc.info/?l=linux-kernel&m=122398315223323&w=2 . Perhaps that
> should be mentioned?

Actually, the best filesystem for USB flash devices is probably UDF.  (Yes, 
the DVD filesystem turns out to be writeable if you put it on a writeable 
media.  The ISO spec requires write support, so any OS that supports DVDs also 
supports this.)

The reasons for this are:

A) It's the only filesystem other than FAT that's supported out of the box by 
windows, mac, _and_ Linux for hotpluggable media.

B) It doesn't have the horrible limitations of FAT (such as a max filesize of 
2 gigabytes).

C) Microsoft doesn't claim to own it, and thus hasn't sued anybody over 
patents on it.

However, when it comes to cutting the power on a mounted filesystem (either by 
yanking the device or powering off the machine) without losing your data, 
without warning, they all suck horribly.

If you yank a USB flash disk in the middle of a write, and the device has 
decided to wipe a 2 megabyte erase sector that's behind a layer of wear 
levelling and thus consists of a series of random sectors scattered all over 
the disk, you're screwed no matter what filesystem you use.  You know the 
vinyl "record scratch" sound?  Imagine that, on a digital level.  Bad Things 
Happen to the hardware, cannot compensate in software.

> > +* either write caching is disabled, or hw can do barriers and they are
> > enabled. +
> > +	   (Note that barriers are disabled by default, use "barrier=1"
> > +	   mount option after making sure hw can support them).
> > +
> > +	   hdparm -I reports disk features. If you have "Native
> > +	   Command Queueing" is the feature you are looking for.
>
> The document makes it sound like nearly everything bar battery backed
> hardware RAIDed SCSI disks (with perfect firmware) is bad  - is this
> the intent?

SCSI disks?  They still make those?

Everything fails, it's just a question of how.  Rotational media combined with 
journaling at least fails in fairly understandable ways, so ext3 on sata is 
reasonable.

Flash gets into trouble when it presents the _interface_ of rotational media 
(a USB block device with normal 512 byte read/write sectors, which never wear 
out) which doesn't match what the hardware's actually doing (erase block sizes 
of up to several megabytes at a time, hidden behind a block remapping layer 
for wear leveling).

For devices that have built in flash that DON'T pretend to be a conventional 
block device, but instead expose their flash erase granularity and let the OS 
do the wear levelling itself, we have special flash filesystems that can be 
reasonably reliable.  It's just that ext3 isn't one of them, jffs2 and ubifs 
and logfs are.  The problem with these flash filesystems is they ONLY work on 
flash, if you want to mount them on something other than flash you need 
something like a loopback interface to make a normal block device pretend to 
be flash.  (We've got a ramdisk driver called "mtdram" that does this, but 
nobody's bothered to write a generic wrapper for a normal block device you can 
wrap over the loopback driver.)

Unfortunately, when it comes to USB flash (the most common type), the USB 
standard defines a way for a USB device to provide a normal block disk 
interface as if it was rotational media.  It does NOT provide a way to expose 
the flash erase granularity, or a way for the operating system to disable any 
built-in wear levelling (which is needed because windows doesn't _do_ wear 
levelling, and thus burns out the administrative sectors of the disk really 
fast while the rest of the disk is still fine unless the hardware wear-levels 
for it).

So every USB flash disk pretends to be a normal disk, which it isn't, and 
Linux can't _disable_ this emulation.  Which brings us back to UDF as the 
least sucky alternative.  (Although the UDF tools kind of suck.  If you 
reformat a FAT disk as UDF with mkudffs, it'll still be autodetected as FAT 
because it won't overwrite the FAT root directory.  You have to blank the 
first 64k by hand with dd.  Sad, isn't it?)

Rob
