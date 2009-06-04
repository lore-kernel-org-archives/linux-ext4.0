From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: Re: [PATCH 0/4] FS: userspace notification of errors
Date: Thu, 04 Jun 2009 08:57:58 +0300
Message-ID: <4A276266.8000409@nokia.com>
References: <1244041518-32229-1-git-send-email-ext-denis.2.karpov@nokia.com> <20090603115611.6bbbaf55.akpm@linux-foundation.org>
Reply-To: Artem.Bityutskiy@nokia.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Karpov Denis.2 (EXT-Teleca/Helsinki)" <ext-denis.2.karpov@nokia.com>,
	"axboe@kernel.dk" <axboe@kernel.dk>,
	"hirofumi@mail.parknet.co.jp" <hirofumi@mail.parknet.co.jp>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Hunter Adrian (Nokia-D/Helsinki)" <adrian.hunter@nokia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090603115611.6bbbaf55.akpm@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andrew Morton wrote:
> hm, I'm uncertain on the desirability or otherwise of the overall fea=
ture.
>=20
> Are there users or distros or device manufacturers asking for this?=20
> Where did the requirement come from?
>=20
> What downstream application will handle the uevent messages?  Do you
> have some userspace design/plan in mind?
>=20
> IOW, it would be useful if we were told more about all of this, rathe=
r
> than just staring at a kernel patch!

As the original idea came from me, while whole implementation
and design was done by Denis, I'll comment on this.

Our use-case is about hand-held devices. We are particularly
working with large FAT volumes on MMC. Do not question please
why it is FAT and not something else :-) Anyway, FAT is very
unreliable, and often hits errors, in which case it simply
switches to read-only mode, and usually prints something to
the printk ring buffer.

When FAT becomes read only out of the blue, the user-space
reaction if very different. Often applications just start
failing, dying, etc. From users' perspective, the hand-held
just becomes weird.

What we want instead is to teach FAT to send the user-space a
notification. What our user-space people think to do is to
catch the notification and show a dialog window which tells
something like "Please, check your FS, blah blah", and may
be offer the user to run fsck.vfat, not exactly sure.

> One part of the design which you didn't describe, but which I inferre=
d
> is that you intend that userspace will see the FS_UNCLEAN=3D1 message=
s
> and will then poll all the /sys/block/<bdev>/<part>/fs_unclean files =
to
> work out which partition(s) got the error, correct?  Please spell all
> that out in the changelog.

I think this part of the design needs more thought. Not
all FSes have block devices (UBIFS, JFFS2), and some FSes
may (theoretically) span more than one block device (btrfs?).

Probably it is better to go without any sysfs file and
just send udev events.

> What use is the FS_UNCLEAN=3D0 message?  I don't get that.  Again, pl=
ease
> cover this in the description.

Yes, the description should be improved. I think the idea is that
we add an udev rule which invokes a certain user-space script/app
on "FAT became R/O" events.

--=20
Best Regards,
Artem Bityutskiy (=D0=90=D1=80=D1=82=D1=91=D0=BC =D0=91=D0=B8=D1=82=D1=8E=
=D1=86=D0=BA=D0=B8=D0=B9)
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
