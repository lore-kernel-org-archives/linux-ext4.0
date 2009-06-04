From: Denis Karpov <ext-denis.2.karpov@nokia.com>
Subject: Re: [PATCH 0/4] FS: userspace notification of errors
Date: Thu, 4 Jun 2009 17:27:35 +0300
Message-ID: <20090604142735.GC28764@smart.research.nokia.com>
References: <1244041518-32229-1-git-send-email-ext-denis.2.karpov@nokia.com> <20090603115611.6bbbaf55.akpm@linux-foundation.org> <4A276266.8000409@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"axboe@kernel.dk" <axboe@kernel.dk>,
	"hirofumi@mail.parknet.co.jp" <hirofumi@mail.parknet.co.jp>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Hunter Adrian (Nokia-D/Helsinki)" <adrian.hunter@nokia.com>,
	sandeen@redhat.com, jamie@shareable.org, kay.sievers@vrfy.org
To: "Bityutskiy Artem (Nokia-D/Helsinki)" <Artem.Bityutskiy@nokia.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A276266.8000409@nokia.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jun 04, 2009 at 07:57:58AM +0200, Bityutskiy Artem (Nokia-D/Helsinki) wrote:
> Andrew Morton wrote:
> > hm, I'm uncertain on the desirability or otherwise of the overall feature.
> > 
> > Are there users or distros or device manufacturers asking for this? 
> > Where did the requirement come from?
> > 
> > What downstream application will handle the uevent messages?  Do you
> > have some userspace design/plan in mind?
> > 
> > IOW, it would be useful if we were told more about all of this, rather
> > than just staring at a kernel patch!
> 
> As the original idea came from me, while whole implementation
> and design was done by Denis, I'll comment on this.
> 
> Our use-case is about hand-held devices. We are particularly
> working with large FAT volumes on MMC. Do not question please
> why it is FAT and not something else :-) Anyway, FAT is very
> unreliable, and often hits errors, in which case it simply
> switches to read-only mode, and usually prints something to
> the printk ring buffer.
> 
> When FAT becomes read only out of the blue, the user-space
> reaction if very different. Often applications just start
> failing, dying, etc. From users' perspective, the hand-held
> just becomes weird.
> 
> What we want instead is to teach FAT to send the user-space a
> notification. What our user-space people think to do is to
> catch the notification and show a dialog window which tells
> something like "Please, check your FS, blah blah", and may
> be offer the user to run fsck.vfat, not exactly sure.

I only can add that we partially worked around the problem implementing
'errors=[remount-ro|continue|panic]' for FAT, just as it's done for ext2.
http://marc.info/?t=124395937100042&r=1&w=2
Still, getting a notification would help userspace.

I'll fix everything related to comments on missing documentation and bad 
naming ("fs_error" is ok, I suppose?).

Clearing the fs_error attribute from the user space is wrong, I agree. 
The attribute shall be made read-only and reset at mount time (as we 
assume we are staring with a clean^H^H^H^H good filesystem). On the 
error event, the userspace would be expected to umount the partition, 
fsck it and mount back.

> > One part of the design which you didn't describe, but which I inferred
> > is that you intend that userspace will see the FS_UNCLEAN=1 messages
> > and will then poll all the /sys/block/<bdev>/<part>/fs_unclean files to
> > work out which partition(s) got the error, correct?  Please spell all
> > that out in the changelog.
> 
> I think this part of the design needs more thought. Not
> all FSes have block devices (UBIFS, JFFS2), and some FSes
> may (theoretically) span more than one block device (btrfs?).

Big thanks to everybody participating in this thread, for reviews and critiques.
Here's a proposal/RFC for another way to implement this feature:

Taking into account Artem's and Kay's comments, indeed, having attributes
like 'fs_error' tied to a block device does not seem right. 
What we need is an object/entity that:

- is not associated to a block device
- is not associated to a partition 
- is not associated to a filesystem as a general entity
- is uniquely associated to a filesystem's 'instance': a mounted volume
  carying that filesystem
- apperas at volume mount time and disappears with volume unmount

Sounds like "fs" kobject class answers to this problem. ext4 presents an 
example of such kset and kobjects:

/sys/fs/<kset>/<kobjects_fs_volumes>/<attributes>
(e.g. /sys/fs/ext4/sda1/...)
Currently there are no uevents associated with those kobjects and their
attributes.

Currently only ext4 and fuse register kobjects/ksets in fs class.
I suggest to implement corresponding feature for FAT (and any other 
filesystem that might need to expose certain 
internal data/statistics/parameters/info to userspace).
That's what fs class was meant for, wasn't it ?

/sys/fs/<fs_name>/<volume>/{attributes}
(e.g. /sys/fs/fat/mmcblk0p1/{mount_point,fs_type,fs_error})
kset: fat
kobjects: fat volumes
attributes:
  mount_point : <path>, ro
  fs_type     : <msdos|fat|vfat>, ro
  fs_error    : <0|1>, ro, when FS is mounted this is set to 0;
                upon error this is set to 1, uevent KOBJ_CHANGE is optionally 
		sent, with following vars:

On fs volume mount/umount: KOBJ_ADD/KOBJ_REMOVE
Env vars:
  ACTION=[add|remove]
  DEVPATH=/sys/fs/fat/<partition_bdev>
  SUBSYSTEM=fs
  SEQNUM=<sequence number>
  MOUNT_POINT=[path]
  FS_TYPE=[msdos|fat|vfat]

On fs error during run-time: KOBJ_CHANGE
  ACTION=[change]
  DEVPATH=/sys/fs/fat/<partition_bdev>
  SUBSYSTEM=fs
  SEQNUM=<sequence number>
  MOUNT_POINT=[path]
  FS_NAME=[msdos|fat|vfat]
  FS_ERRORS=1

To have only sysfs structure for polling or uevents interface or both still
remains a question for me. In the context of this specific kobjects the 
uevents can be specified clearly enough.

Taking the above one step further, this could be done automatically for all
filesystems - registration of a standard kset and kobjects in fs class 
under /sys/fs. Filesystem should be able to extend standard kobjects to be
able to add it's specific attributes. Signalling with uevents can be made
optional (as a parameter of an attribute registration, not as a fs mount
option).

Answering Eric's comments, the above design would give enough flexibility
to report different types of errors/events, depending on particular
filesystem's needs.

Denis Karpov
