From: Nix <nix@esperi.org.uk>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6 (when rebooting during umount) (possibly blockdev / arcmsr at fault??)
Date: Fri, 26 Oct 2012 01:22:22 +0100
Message-ID: <871ugm2ibl.fsf_-_@spindle.srvr.nix>
References: <20121023143019.GA3040@fieldses.org>
	<874nllxi7e.fsf_-_@spindle.srvr.nix>
	<87pq48nbyz.fsf_-_@spindle.srvr.nix> <508740B2.2030401@redhat.com>
	<87txtkld4h.fsf@spindle.srvr.nix> <50876E1D.3040501@redhat.com>
	<20121024052351.GB21714@thunk.org> <878vavveee.fsf@spindle.srvr.nix>
	<20121024210819.GA5484@thunk.org> <87y5iv78op.fsf_-_@spindle.srvr.nix>
	<20121025011056.GC4559@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Bryan Schumaker <bjschuma@netapp.com>,
	Peng Tao <bergwolf@gmail.com>, Trond.Myklebust@netapp.com,
	gregkh@linuxfoundation.org,
	Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>,
	nick.cheng@areca.com.tw
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121025011056.GC4559@thunk.org> (Theodore Ts'o's message of
	"Wed, 24 Oct 2012 21:10:56 -0400")
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 25 Oct 2012, Theodore Ts'o told this:
> If that does make the problem go away, that will be a very interesting
> data point....

I'll be looking at this tomorrow, but as sod's law would have it I have
another user on this machine who didn't want it mega-rebooted tonight,
so I was reduced to trying to reproduce the problem in virtualization
under qemu.

I failed, for one very simple reason: on 3.6.3, even with a umount -l
still in the process of unmounting the fs and flushing changes, even on
an fs mounted nobarrier,journal_async_commit, even when mounted atop
LVM, reboot(2) will block until umount's writeout is complete (and lvm
vgchange refuses to deactivate the volume group while that is happening,
but I don't bother deactivating volume groups on the afflicted machine
so I know that can't be related). Obviously, this suffices to ensure
that a reboot is not possible while umounts are underway -- though a
power cut is still possible, I suppose.

On the afflicted machine (with a block device stack running LVM, then
libata/arcmsr), as far as I can tell reboot(8) is *not* blocking if a
unmount is underway: it shoots down everything and restarts at once. I
have no direct proof of this yet, but during the last week I've
routinely seen it reboot with lots of writes underway and umount -l log
messages streaming up the screen: it certainly doesn't wait for all the
umount -l's to be done the way it is in virtualization. I have no idea
how this can be possible: I thought fses on a block device had to be
quiesced (thus, in the case of an ongoing umount, unmounted and flushed)
before any attempt at all was made to shut the underlying block device
down, and I'd be fairly surprised if a flush wasn't done even if
nobarrier was active (it certainly seems to be for virtio-blk, but that
may well be a special case). But arcmsr (or libata? I should test with a
simulated libata rather than virtio-blk next) appears to be getting
around that somehow. This would probably explain all sorts of horrible
corruption if umounting during a reboot, right?

So maybe it's the stack of block devices that's at fault, and not the
filesystem at all! I'll admit I don't really understand what happens at
system halt time well enough to be sure, and getting log info from a
machine in the middle of reboot(8) appears likely to be a complete sod
(maybe halt(8) would be better: at least I could take a photo of the
screen then). If that's true, it would *certainly* explain why nobody
else can see this problem: only arcmsr users who also do umount -l's
would have a chance, and that population probably has a size of one.


I'll try to prove this tomorrow by writing a few gigs of junk to a temp
filesytem held open by a temporary cat /dev/null, umount -l'ing it and
killing off the cat the instant before the reboot -f call. If I don't
see the reboot call blocking, the hypothesis is proved. (This is much
what I did in virtualization, where I observe reboot blocking.)

(Another blockdev-related possibility, if reboot *is* observed to block,
is that arcmsr may be throwing away very-recently-written data when the
adapter is shut down right before reboot.)


Argh. How can rebooting a system be so damn complicated. Bring back the
C64 or BBC Master where I could just pull the power lead out and stick
it back in. :)
