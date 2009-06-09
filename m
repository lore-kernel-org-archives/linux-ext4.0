From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/4] FS: userspace notification of errors
Date: Tue, 9 Jun 2009 15:49:22 +0200
Message-ID: <20090609134921.GB13755@atrey.karlin.mff.cuni.cz>
References: <1244041518-32229-1-git-send-email-ext-denis.2.karpov@nokia.com> <20090603115611.6bbbaf55.akpm@linux-foundation.org> <ac3eb2510906040553j294f1015wfb7deb4b4fc63afc@mail.gmail.com> <4A28FC8F.5020802@nokia.com> <20090605115127.GF28764@smart.research.nokia.com> <ac3eb2510906050606u7527654dv789364549b36f3e7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Bityutskiy Artem (Nokia-D/Helsinki)" <Artem.Bityutskiy@nokia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"axboe@kernel.dk" <axboe@kernel.dk>,
	"hirofumi@mail.parknet.co.jp" <hirofumi@mail.parknet.co.jp>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Hunter Adrian (Nokia-D/Helsinki)" <adrian.hunter@nokia.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34269 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761472AbZFINtU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Jun 2009 09:49:20 -0400
Content-Disposition: inline
In-Reply-To: <ac3eb2510906050606u7527654dv789364549b36f3e7@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Fri, Jun 5, 2009 at 13:51, Denis Karpov<ext-denis.2.karpov@nokia.com> wrote:
> > This is doable, e.g. in the form of optional fields "tag[:value]"
> > (field 7, Documentation/filesystems/proc.txti for mountinfo).
> 
> > But is using procfs generally a good idea ? Last several years all a lot of
> > stuff moved out from procfs into sysfs. Not to forget what procfs is
> > originally meant for: storing the proceses related information.
> 
> Yeah, but mounted volumes are namespace dependent, and namespaces are
> process dependent. So events for your current namespace wouldn't be
> too bad here. There might be reasons we don't want the mountinfo file,
> but the "use sysfs for new stuff" does not count in this case. :)
  As much as I don't like the using /proc/mountinfo for this, it also
has the advantage that it nicely solves the problem with a filesystem
being bind-mounted on several directories...  Otherwise you have to
solve the problem which mountpoint of the filesystem should be used
(especially because the real root of the filesystem need not be
accessible from the namespace of the process).

> > - /sys/fs seems to be a perfect fit for the purpose judging by ext4 example
> > cons:
> > - uevent interface is unneeded extra(?); can be made optional, per attribute
> 
> You can not pass the mount path with the uevent, like you example
> shows, you just don't know that reliably, and there can be many mount
> points.
> 
> How do you want to name the /sys/fs/ device? By "dev_t st_dev" or the
> underlying block device name? How do you indentify the mountpoint in
> your current namespace, of the device that raised the error? The event
> might be for a filesystem you can not reach at all in your mount tree.
> 
> The /sys/fs/ approach sounds very much like an "export known
> superblocks in /sys/fs/", something like this could be useful, but we
> need to check carefully with other people what are the issues of such
> an interface, and if there is something that should not be exported
> that way.
> 
> How are device-less superblocks like btrfs handled in such an
> interface, how is the device named, if it does not have a direct block
> device underneath?
  Generally, it is an unclear question how should kernel identify a
filesystem where the problem happened. We could have a kobject for
superblock but it's still unclear how to map this to a device /
mountpoints because that's what userspace ultimately wants to tell the
sysadmin and possibly make some automated decision.
  What currently seems as the cleanest solution to me, is to add some
"filesystem identifier" field to /proc/self/mountinfo (which could be
UUID, superblock pointer or whatever) and pass this along with the error
message to userspace. Passing could be done either via sysfs (but I
agree it isn't the best fit because a filesystem need not be bound to a
device) or just via generic netlink (which has the disadvantage that you
cannot use the udev framework everyone knows)...

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
