From: Kyle Moffett <kyle@moffetthome.net>
Subject: Re: ext2/3: document conditions when reliable operation is possible
Date: Tue, 17 Mar 2009 00:55:04 -0400
Message-ID: <f73f7ab80903162155p2f9de16aj122978d7fc220f40@mail.gmail.com>
References: <20090312092114.GC6949@elf.ucw.cz>
	 <20090316123051.GJ2405@elf.ucw.cz>
	 <20090316194057.GA27897@silver.sucs.org>
	 <200903161643.15887.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, Pavel Machek <pavel@ucw.cz>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	tytso@mit.edu, rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Rob Landley <rob@landley.net>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <200903161643.15887.rob@landley.net>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Mar 16, 2009 at 5:43 PM, Rob Landley <rob@landley.net> wrote:
> Flash gets into trouble when it presents the _interface_ of rotationa=
l media
> (a USB block device with normal 512 byte read/write sectors, which ne=
ver wear
> out) which doesn't match what the hardware's actually doing (erase bl=
ock sizes
> of up to several megabytes at a time, hidden behind a block remapping=
 layer
> for wear leveling).
>
> For devices that have built in flash that DON'T pretend to be a conve=
ntional
> block device, but instead expose their flash erase granularity and le=
t the OS
> do the wear levelling itself, we have special flash filesystems that =
can be
> reasonably reliable. =C2=A0It's just that ext3 isn't one of them, jff=
s2 and ubifs
> and logfs are. =C2=A0The problem with these flash filesystems is they=
 ONLY work on
> flash, if you want to mount them on something other than flash you ne=
ed
> something like a loopback interface to make a normal block device pre=
tend to
> be flash. =C2=A0(We've got a ramdisk driver called "mtdram" that does=
 this, but
> nobody's bothered to write a generic wrapper for a normal block devic=
e you can
> wrap over the loopback driver.)

The really nice SSDs actually reserve ~15-30% of their internal
block-level storage and actually run their own log-structured virtual
disk in hardware.  From what I understand the Intel SSDs are that way.
 Real-time garbage collection is tricky, but if you require (for
example) a max of ~80% utilization then you can provide good latency
and bandwidth guarantees.  There's usually something like a
log-structured virtual-to-physical sector map as well.  If designed
properly with automatic hardware checksumming, such a system can
actually provide atomic writes and barriers with virtually no impact
on performance.

With firmware-level hardware knowledge and the ability to perform
extremely efficient parallel reads of flash blocks, such a
log-structured virtual block device can be many times more efficient
than a general purpose OS running a log-structured filesystem.  The
result is that for an ordinary ext3-esque filesystem with 4k blocks
you can treat the SSD as though it is an atomic-write seek-less block
device.

Now if only I had the spare cash to go out and buy one of the shiny
Intel ones for my laptop... :-)

Cheers,
Kyle Moffett
