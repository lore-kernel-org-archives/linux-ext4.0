From: Russell Cattelan <cattelan@thebarn.com>
Subject: Re: [PATCH 0/4] FS: userspace notification of errors
Date: Thu, 04 Jun 2009 09:29:52 -0500
Message-ID: <4A27DA60.3010602@xfs.org>
References: <1244041518-32229-1-git-send-email-ext-denis.2.karpov@nokia.com> 	<20090603115611.6bbbaf55.akpm@linux-foundation.org> <ac3eb2510906040553j294f1015wfb7deb4b4fc63afc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Denis Karpov <ext-denis.2.karpov@nokia.com>, axboe@kernel.dk,
	hirofumi@mail.parknet.co.jp, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	adrian.hunter@nokia.com, artem.bityutskiy@nokia.com
To: Kay Sievers <kay.sievers@vrfy.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <ac3eb2510906040553j294f1015wfb7deb4b4fc63afc@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Kay Sievers wrote:
> On Wed, Jun 3, 2009 at 20:56, Andrew Morton
> <akpm@linux-foundation.org> wrote:
>> On Wed,  3 Jun 2009 18:05:14 +0300 Denis Karpov
>> <ext-denis.2.karpov@nokia.com> wrote:
>
>> hm, I'm uncertain on the desirability or otherwise of the overall
>> feature.
>>
>> Are there users or distros or device manufacturers asking for
>> this? Where did the requirement come from?
>
> I think we really need something like this to propagate such errors
> to userpace. Printing something to the kernel log is not an useful
> interface in any way. But I don't think we want it that way, not
> with uevents, not with sysfs, and not tied to block devices.
>
> Uevents should not be used for error reporting, unless it is well
> defined within the _device_ context, which a filesystem on top of a
>  blockdev isn't. We could argue to get events for bad blocks of a
> device, but I don't think we want filesystem related stuff ever in
> device uevents. For the same reason, there should be no
> unconditional fs-specific sysfs file below a block device.
>
> Block device interfaces for filesystems can not handle device-less
> virtual mounts which are common these days. There is no direct
> relation from the device to the filesystem - so this would only
> work for simple direct mounts, which isn't sufficient for a
> higher-level interface like this.
>
> And I don't think we want several event sources for the same thing,
>  uevents _and_ pollable sysfs files.
>
> We already raise events on /proc/self/mountinfo when the mount tree
>  changes, I guess that's where fs specific stuff belongs, and it
> will work with all kind of filesystem setups, regardless of the
> devices below it. This is also the established interface for flags
> and options and the current state of the filesystem, and does not
> mix filesystem options into block device interfaces.
Given the infrastructure of /proc/self/mountinfo already exists it
seems like a better place to add
fs_fault notifications.

What I'm wondering is that going to be enough? What actions should be
taken next to correct the
issue? I can see in the case of a hand held device using  FAT on mmc
the options are limited,
but in large SAN environments the fault may be due to any number of
failures and thus require
various very different actions.

Coming up with an interface that has a little more rich error
reporting would probably be better
in the long run. usespace utils could then decide if the error is
something it can handle automatically
or leave alone and let the admin/user handle it.

>
> /proc/self/mountinfo could also work properly with namespaces which
>  might have different meaning for a device in a different
> namespace.
>
> Thanks, Kay -- To unsubscribe from this list: send the line
> "unsubscribe linux-fsdevel" in the body of a message to
> majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFKJ9o+NRmM+OaGhBgRAttkAJ9cTSqDMdjTztLu4UMt4PYpG8vB0gCfYBog
3RpJbi2pE+qRSBCUL/ka8bo=
=Nkoe
-----END PGP SIGNATURE-----

