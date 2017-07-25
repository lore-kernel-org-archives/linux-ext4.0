From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: bcache with existing ext4 filesystem
Date: Tue, 25 Jul 2017 18:13:09 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1707251810091.9683@mail.ewheeler.net>
References: <20170724185703.GA31422@amd> <64c810cf-a95c-f862-f25a-ebd7419b2632@thelounge.net> <20170724191548.GA32425@amd> <20170724192718.t7n5zgualz5lillg@thunk.org> <20170724200451.GA4318@amd> <20170725045156.kbyaxj4mmi75yyt5@thunk.org> <20170725064304.GA11723@amd>
 <20170725103248.GA12869@suse.com> <20170725111210.GA5667@amd>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Vojtech Pavlik <vojtech@ucw.cz>, Theodore Ts'o <tytso@mit.edu>,
        Reindl Harald <h.reindl@thelounge.net>,
        linux-ext4@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        kent.overstreet@gmail.com, linux-bcache@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170725111210.GA5667@amd>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 25 Jul 2017, Pavel Machek wrote:

> On Tue 2017-07-25 12:32:48, Vojtech Pavlik wrote:
> > On Tue, Jul 25, 2017 at 08:43:04AM +0200, Pavel Machek wrote:
> > > On Tue 2017-07-25 00:51:56, Theodore Ts'o wrote:
> > > > On Mon, Jul 24, 2017 at 10:04:51PM +0200, Pavel Machek wrote:
> > > > > Question for you was... Is the first 1KiB of each ext4 filesystem still
> > > > > free and "reserved for a bootloader"?
> > > > 
> > > > Yes.
> > > 
> > > Thanks.
> > > 
> > > > > If I needed more for bcache superblock (8KiB, IIRC), would that be
> > > > > easy to accomplish on existing filesystem?
> > > > 
> > > > Huh?  Why would the bcache superblock matter when you're talking about
> > > > the ext4 layout?  The bcache superblock will be on the bcache
> > > > device/partition, and the ext4 superblock will be on the ext4
> > > > device/partition.
> > > 
> > > I'd like to enable bcache on already existing ext4 partition. AFAICT
> > > normal situation, even on the backing device, is:
> > > 
> > > | 8KiB bcache superblock | 1KiB reserved | ext4 superblock | 400GB data |
> > > 
> > > Unfortunately, that would mean shifting 400GB data 8KB forward, and
> > > compatibility problems. So I'd prefer adding bcache superblock into
> > > the reserved space, so I can have caching _and_ compatibility with
> > > grub2 etc (and avoid 400GB move):
> > 
> > The common way to do that is to move the beginning of the partition,
> > assuming your ext4 lives in a partition.
> 
> Well... if I move the partition, grub2 (etc) will be unable to access
> data on it. (Plus I do not have free space before some of the
> partitions I'd like to be cached).

Why not use dm-linear and prepend space for the bcache superblock?  If 
this is your boot device, then you would need to write a custom 
initrd hook too.

Note that if bcache comes up without its cache, you will need to:
	echo 1 > /sys/block/sdX/bcache/running

This is of course unsafe with writeback but should be fine with 
writethrough.


--
Eric Wheeler


> 
> > I don't see how overlapping the ext4 and the bcache backing device
> > starts would give you what you want, because bcache assumes the
> > backing device data starts with an offset.
> 
> My plan is to make offset 0. AFAICT bcache superblock can be shrunk.
> 
> 									Pavel
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> 
