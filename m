From: Dave Chinner <david@fromorbit.com>
Subject: Re: [REPOST][PATCH][RFC] vfs: add message print mechanism for the
	mount/umount into the VFS layer
Date: Sat, 16 Jan 2010 00:15:22 +1100
Message-ID: <20100115131522.GK28498@discord.disaster>
References: <20100114154837.734fff60.toshi.okajima@jp.fujitsu.com> <20100114081448.GI19799@ZenIV.linux.org.uk> <D69F3C0C-FC4A-4866-98BD-DE9558250A0B@sun.com> <20100115012421.GA28498@discord.disaster> <5E9FF033-5FD5-42B4-985B-C241F45746C1@sun.com> <20100115110220.GG28498@discord.disaster> <fa7b26051001150344u120934a2sea4f06fb8b0af559@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@sun.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	Theodore Ts'o <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	"James C. Browne" <browne@cs.utexas.edu>
To: Mike Mestnik <cheako911@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:37674 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755375Ab0AONPm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Jan 2010 08:15:42 -0500
Content-Disposition: inline
In-Reply-To: <fa7b26051001150344u120934a2sea4f06fb8b0af559@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 15, 2010 at 05:44:01AM -0600, Mike Mestnik wrote:
> On Fri, Jan 15, 2010 at 5:02 AM, Dave Chinner <david@fromorbit.com> w=
rote:
> > On Thu, Jan 14, 2010 at 11:36:25PM -0500, Andreas Dilger wrote:
> >> On 2010-01-14, at 20:24, Dave Chinner wrote:
> >>> On Thu, Jan 14, 2010 at 10:33:42AM -0500, Andreas Dilger wrote:
> >>>> Sure, it is _possible_ to do this, but you miss the fact that th=
ere
> >>>> are
> >>>> many system monitoring tools that already scrape /var/log/messag=
es
> >>>> and
> >>>> integrate with event managers. =A0What you are suggesting is tha=
t every
> >>>> such tool implement an extra, completely ad-hoc mechanism just f=
or
> >>>> monitoring the mount/unmount of filesystems on Linux. =A0That do=
esn't
> >>>> make
> >>>> sense.
> >>>
> >>> We already report various events through a netlink interface, but=
 not
> >>> to the log files (e.g. quota warnings), so those system monitorin=
g
> >>> tools are already going to be missing interesting information.
> >>>
> >>> Using log files for system event notification used to be the only
> >>> way to communicate such events. Now we have much more advanced an=
d
> >>> efficient mechanisms for notifications so I think we should use
> >>> them.
> > ....
> >> However, there are many reasons why it still makes sense to do thi=
s:
> >> - it is in plain text format. =A0I can't recall the number of time=
s
> >> =A0 people were proposing crazy schemes to have a text interface t=
o the
> >> =A0 kernel (via /sys/blah, or /debugfs/blah) for things that are m=
uch
> >> =A0 better suited to an ioctl, since they are largely handled by b=
inaries
> >> =A0 (applications), yet in the case where we have an existing plai=
n-text
> >> =A0 interface (dmesg and /var/log/messages) that are meant (at lea=
st
> >> =A0 partly) for human consumption we are proposing a binary interf=
ace
> >> - every system monitoring tool in existence has a /var/log/message=
s
> >> =A0 scraping interface, because this is the lowest common denomina=
tor,
> >> =A0 but I'd suspect that few/none have a netlink interface, or if =
they
> >> =A0 do it probably can't be easily added to by a user
> >
> > A daemon that captures the events from netlink and writes them to
> > syslog is all that is needed to support log file scraping
> > monitoring tools. The message they scrape does not have to come fro=
m
> > the kernel...
> >
> klogd.  Do we need another wheel?

That's just another syslog implementation for directing printk
messages to files. It's not an event notification framework.

Cheers,

Dave.
--=20
Dave Chinner
david@fromorbit.com
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
