From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: bcache with existing ext4 filesystem
Date: Wed, 26 Jul 2017 17:41:30 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1707261728460.9683@mail.ewheeler.net>
References: <20170724185703.GA31422@amd> <64c810cf-a95c-f862-f25a-ebd7419b2632@thelounge.net> <20170724191548.GA32425@amd> <20170724192718.t7n5zgualz5lillg@thunk.org> <20170724200451.GA4318@amd> <20170725045156.kbyaxj4mmi75yyt5@thunk.org> <20170725064304.GA11723@amd>
 <20170725103248.GA12869@suse.com> <20170725111210.GA5667@amd> <alpine.LRH.2.11.1707251810091.9683@mail.ewheeler.net> <20170725220221.GA32240@amd>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Vojtech Pavlik <vojtech@ucw.cz>, Theodore Ts'o <tytso@mit.edu>,
        Reindl Harald <h.reindl@thelounge.net>,
        linux-ext4@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        kent.overstreet@gmail.com, linux-bcache@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <20170725220221.GA32240@amd>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 26 Jul 2017, Pavel Machek wrote:

> Hi!
> 
> > > > > Unfortunately, that would mean shifting 400GB data 8KB forward, and
> > > > > compatibility problems. So I'd prefer adding bcache superblock into
> > > > > the reserved space, so I can have caching _and_ compatibility with
> > > > > grub2 etc (and avoid 400GB move):
> > > > 
> > > > The common way to do that is to move the beginning of the partition,
> > > > assuming your ext4 lives in a partition.
> > > 
> > > Well... if I move the partition, grub2 (etc) will be unable to access
> > > data on it. (Plus I do not have free space before some of the
> > > partitions I'd like to be cached).
> > 
> > Why not use dm-linear and prepend space for the bcache superblock?  If 
> > this is your boot device, then you would need to write a custom 
> > initrd hook too.
> 
> Thanks for a pointer. That would actually work, but I'd have to be
> very, very careful using it...
> 
> ...because if I, or systemd or some kind of automounter sees the
> underlying device (sda4) and writes to it (it is valid ext4 after
> all), I'll have inconsistent base device and cache ... and that will
> be asking for major problems (even in writethrough mode).

Sigh.  Gone are the days when distributions would only mount filesystems 
if you ask them to.  

If this is a desktop, then I'm not sure what to suggest.  But for server 
with no GUI, turn off the grub2 osprober (GRUB_DISABLE_OS_PROBER="true" in 
/etc/sysconfig/grub).  If this was LVM, then I would suggest also setting 
global_filter in lvm.conf.  If you find other places that need poked to 
prevent automounting then please let me know!

As for ext4 feature bits, can they be arbitrarily named? (I think they are 
bits, so maybe not).  Maybe propose a patch to ext4 to provide a 
"disable_mount" feature.  This would prevent mounting altogether, and you 
would set/clear it when you care to.  A strange feature indeed.  Doing 
this as an obscure feature on a single filesystem doesn't quite seem 
right.


It might be better to have a block-layer device-mount mask so devices that 
are allowed to be mounted can be whitelisted on the kernel cmdline or 
something.  blk.allow_mount=8:16,253:*,...  or blk.disallow_mount=8:32 (or 
probably both).

Just ideas, but it would be great to allow mounting only those 
major/minors which are authorized, particularly with increasingly complex 
block-device stacks.  


--
Eric Wheeler




> 
> Actually, this already would be usable, if we killed content of cache
> device on every mount. Hmmm. I have reasonably long uptimes these days.
> 
> If possible, I'd like something more clever: bcache saves mtime of the
> ext4 filesystem on shutdown. If the mtime does not match on the next
> startup, it means someone fsck-ed the filesystem or mounted it
> directly or something, and cache is invalid.
> 
> Bonus would be some kind of interlock with "incompatible feature"
> bits. If the bcache has dirty data in write-back cache, it would be
> nice to have "incompatible feature" bit set, so that tools that don't
> have access to the cache refuse to touch it.
> 
> Best regards,
> 
> 									Pavel
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> 
