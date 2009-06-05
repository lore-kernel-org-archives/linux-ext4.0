From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 0/4] FS: userspace notification of errors
Date: Fri, 5 Jun 2009 15:06:52 +0200
Message-ID: <ac3eb2510906050606u7527654dv789364549b36f3e7@mail.gmail.com>
References: <1244041518-32229-1-git-send-email-ext-denis.2.karpov@nokia.com>
	<20090603115611.6bbbaf55.akpm@linux-foundation.org> <ac3eb2510906040553j294f1015wfb7deb4b4fc63afc@mail.gmail.com>
	<4A28FC8F.5020802@nokia.com> <20090605115127.GF28764@smart.research.nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "Bityutskiy Artem (Nokia-D/Helsinki)" <Artem.Bityutskiy@nokia.com>,
	Kay Sievers <kay.sievers@vrfy.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"axboe@kernel.dk" <axboe@kernel.dk>,
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:57271 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbZFENHI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Jun 2009 09:07:08 -0400
In-Reply-To: <20090605115127.GF28764@smart.research.nokia.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 5, 2009 at 13:51, Denis Karpov<ext-denis.2.karpov@nokia.com=
> wrote:
> This is doable, e.g. in the form of optional fields "tag[:value]"
> (field 7, Documentation/filesystems/proc.txti for mountinfo).

> But is using procfs generally a good idea ? Last several years all a =
lot of
> stuff moved out from procfs into sysfs. Not to forget what procfs is
> originally meant for: storing the proceses related information.

Yeah, but mounted volumes are namespace dependent, and namespaces are
process dependent. So events for your current namespace wouldn't be
too bad here. There might be reasons we don't want the mountinfo file,
but the "use sysfs for new stuff" does not count in this case. :)

> /proc/self/mountinfo solution:
> pros:
> - existing solution
> cons:
> - polling only
> - dedicated userspace tool to poll/parse/act
> - additional parsing overhead and event filtering (mountinfo changes =
for many
> =C2=A0reasons)
> - probably this info does not belong to procfs

Userspace polls it today already on most boxes, to find out if and
where something was mounted.

> /sys/fs/<fs>/<volume>/{attributes,..} solution:
> pros:
> - nice hierarchy reflecting structure of entities in the kernel
> - extensible (other errors, conditions, events can be reflected)
> - no parsing: dedicated file for each attribute
> - uevent interface with existing userspace tool (udev);
> =C2=A0(polling is still possible)

The uevent interface would need a rate limit inside the kernel.
Uevents are very expensive in userspace and you need to make sure,
that such an error reporting can never raise hundreds or thousands of
events, in no situation.

> - /sys/fs seems to be a perfect fit for the purpose judging by ext4 e=
xample
> cons:
> - uevent interface is unneeded extra(?); can be made optional, per at=
tribute

You can not pass the mount path with the uevent, like you example
shows, you just don't know that reliably, and there can be many mount
points.

How do you want to name the /sys/fs/ device? By "dev_t st_dev" or the
underlying block device name? How do you indentify the mountpoint in
your current namespace, of the device that raised the error? The event
might be for a filesystem you can not reach at all in your mount tree.

The /sys/fs/ approach sounds very much like an "export known
superblocks in /sys/fs/", something like this could be useful, but we
need to check carefully with other people what are the issues of such
an interface, and if there is something that should not be exported
that way.

How are device-less superblocks like btrfs handled in such an
interface, how is the device named, if it does not have a direct block
device underneath?

In any case, we definitely need something better than dmesg to pass
filesystem errors from the kernel to userspace, so this discussion is
much appreciated.

Thanks,
Kay
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
