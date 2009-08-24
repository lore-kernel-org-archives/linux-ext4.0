From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
 possible
Date: Mon, 24 Aug 2009 17:55:53 +0300
Message-ID: <4A92A9F9.10706@gmail.com>
References: <20090312092114.GC6949@elf.ucw.cz> <200903121413.04434.rob@landley.net> <20090316122847.GI2405@elf.ucw.cz> <200903161426.24904.rob@landley.net> <20090323104525.GA17969@elf.ucw.cz> <87ljqn82zc.fsf@frosties.localdomain> <20090824093143.GD25591@elf.ucw.cz> <82k50tjw7u.fsf@mid.bfk.de> <20090824130125.GG23677@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Florian Weimer <fweimer@bfk.de>, Pavel Machek <pavel@ucw.cz>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20090824130125.GG23677@mit.edu>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Theodore,

thanks for the insightful writing.

On 08/24/2009 04:01 PM, Theodore Tso wrote:

=2E..snip ...

> It's for this reason that I've never been completely sure how useful
> Pavel's proposed treatise about file systems expectations really are
> --- because all storage subsystems *usually* provide these guarantees=
,
> but it is the very rare storage system that *always* provides these
> guarantees.

There is a thing called eMMC (embedded MMC) in the embedded world. You
may consider it as a non-removable MMC. This thing is a block device fr=
om
the Linux POW, and you may mount ext3 on top of it. And people do this.

The device seems to have a decent FTL, and does not look bad.

However, there are subtle things which mortals never think about. In
case of eMMC - power cuts may make some sectors unreadable - eMMC retur=
ns
ECC errors on reads. Namely, the sectors which were being written at
the very moment when the power cut happened may become unreadable.
And this makes ext3 refuse mounting the file-system, this makes
chkfs.ext3 refuse the file-system. Although this should be fixable in
SW, but we did not find time to do this so far.

Anyway, my point is that documenting subtle things like this is a very
good thing to do, just because nowadays we are trying to use existing
software with flash-based storage devices, which may violate these
subtle assumptions, or introduce other ones.

Probably, Pavel did too good job in generalizing things, and it could b=
e
better to make a doc about HDD vs SSD or HDD vs Flash-based-storage.
Not sure. But the idea to document subtle FS assumption is good, IMO.

--=20
Best Regards,
Artem Bityutskiy (=D0=90=D1=80=D1=82=D1=91=D0=BC =D0=91=D0=B8=D1=82=D1=8E=
=D1=86=D0=BA=D0=B8=D0=B9)
