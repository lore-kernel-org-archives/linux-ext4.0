From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Noticeable usability weakness of ext4 recovery, especially
 during boot
Date: Sun, 20 Mar 2016 17:51:23 -0400
Message-ID: <20160320215123.GC3331@thunk.org>
References: <20160320171053.GA24115@rhlx01.hs-esslingen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-kernel@vger.kernel.org
To: Andreas Mohr <andi@lisas.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160320171053.GA24115@rhlx01.hs-esslingen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Mar 20, 2016 at 06:10:53PM +0100, Andreas Mohr wrote:
> [   18.164828] EXT4-fs (sda2): mounting ext3 file system using the ext4 subsyste
> [  248.211176] EXT4-fs (sda2): recovery complete
> [  249.595977] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: 
> (null)
> 
> (note the HUGE gap in dmesg timestamps above)
> 
> All that *may* have been acceptable, if it were not for the fact
> that especially during boot
> certain activity progress is not readily visible,
> thus there's a *lot* of confusion of what is [not] happening with the system
> (as strongly opposed to a situation where one is mounting an ext4 partition
> directly via the shell, where it's quite obvious that mount is hanging
> right at the shell prompt,
> and diagnostic verification via dmesg etc. is readily reachable,
> as opposed to system boot).

I'm curious --- what kind of removable USB drive is your sda drive?

Normally journal replay does *not* take nearly four minutes.  It
usually only takes at most a few seconds --- which is why we've not
bothered to put in any kind of progress notification scheme.  (Which
on most Linux distribution would be covered by some boot graphics
anyway, so it would be largely wasted.)

There *is* such a progress bar system for a file system consistency
check, which normally is what can take minutes.

> - progress may easily not be determinable via "out of band signalling" ;)
>   (completely silent USB stick rather than plain old metal platters HDD!!)

Ah, it's some USB stick.  I'm guessing it must be a *really* crappy
USB stick that doesn't do random writes well at all.  Even so, though
this is quite unusual.  This is much more normal:

[8583.604009] sd 9:0:0:0: [sdc] Attached SCSI removable disk
[8589.049603] EXT4-fs (sdc1): recovery complete
[8589.055767] EXT4-fs (sdc1): mounted filesystem with ordered data mode. Opts: (null)

This is with an amazingly craptastic 1GB USB stick drive made of
plastic which looks like it would fall apart if you twisted it
slightly as you insert or remove it, and for which I paid less than
$4.00 USD.  (Basically something I treat as completely disposable.  :-)

And as it turns out, most of this time is the delay between when the
kernel notified udevd, and when udisks actually got around to mounting
the device.  After a clean unmount, where no recovery / journal replay
is needed:

[9108.564843] sd 15:0:0:0: [sdc] Attached SCSI removable disk
[9113.746002] EXT4-fs (sdc1): mounted filesystem with ordered data mode. Opts: (null)

> Thus, the question here would be
> which parts may need to be sufficiently improved
> to achieve an acceptable level of usability.
> I'd think that even simply adding a message
> that one is about to enter a potentially longer-term operation
> (with a details message such as "recovery")
> rather than "standard" mount activity
> would be sufficient,
> both for text boot *and* GUI boot with some sufficiently accessible
> "boot details" window.

Well, we could, but on most devices, it's largely wasted.  Perhaps the
more interesting question is why is your USB stick so slow?  Because
that's going to have a much larger usability issue for you...

Cheers,

							- Ted
