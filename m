From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 0/4] FS: userspace notification of errors
Date: Thu, 4 Jun 2009 14:53:21 +0200
Message-ID: <ac3eb2510906040553j294f1015wfb7deb4b4fc63afc@mail.gmail.com>
References: <1244041518-32229-1-git-send-email-ext-denis.2.karpov@nokia.com>
	<20090603115611.6bbbaf55.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Denis Karpov <ext-denis.2.karpov@nokia.com>, axboe@kernel.dk,
	hirofumi@mail.parknet.co.jp, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	adrian.hunter@nokia.com, artem.bityutskiy@nokia.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:6163 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395AbZFDMxf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Jun 2009 08:53:35 -0400
In-Reply-To: <20090603115611.6bbbaf55.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 3, 2009 at 20:56, Andrew Morton <akpm@linux-foundation.org>=
 wrote:
> On Wed, =C2=A03 Jun 2009 18:05:14 +0300 Denis Karpov <ext-denis.2.kar=
pov@nokia.com> wrote:

> hm, I'm uncertain on the desirability or otherwise of the overall fea=
ture.
>
> Are there users or distros or device manufacturers asking for this?
> Where did the requirement come from?

I think we really need something like this to propagate such errors to
userpace. Printing something to the kernel log is not an useful
interface in any way. But I don't think we want it that way, not with
uevents, not with sysfs, and not tied to block devices.

Uevents should not be used for error reporting, unless it is well
defined within the _device_ context, which a filesystem on top of a
blockdev isn't. We could argue to get events for bad blocks of a
device, but I don't think we want filesystem related stuff ever in
device uevents. For the same reason, there should be no unconditional
fs-specific sysfs file below a block device.

Block device interfaces for filesystems can not handle device-less
virtual mounts which are common these days. There is no direct
relation from the device to the filesystem - so this would only work
for simple direct mounts, which isn't sufficient for a higher-level
interface like this.

And I don't think we want several event sources for the same thing,
uevents _and_ pollable sysfs files.

We already raise events on /proc/self/mountinfo when the mount tree
changes, I guess that's where fs specific stuff belongs, and it will
work with all kind of filesystem setups, regardless of the devices
below it. This is also the established interface for flags and options
and the current state of the filesystem, and does not mix filesystem
options into block device interfaces.

/proc/self/mountinfo could also work properly with namespaces which
might have different meaning for a device in a different namespace.

Thanks,
Kay
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
