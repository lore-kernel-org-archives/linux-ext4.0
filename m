From: Mike Mestnik <cheako911@gmail.com>
Subject: Re: [REPOST][PATCH][RFC] vfs: add message print mechanism for the
	mount/umount into the VFS layer
Date: Fri, 15 Jan 2010 05:44:01 -0600
Message-ID: <fa7b26051001150344u120934a2sea4f06fb8b0af559@mail.gmail.com>
References: <20100114154837.734fff60.toshi.okajima@jp.fujitsu.com>
	 <20100114081448.GI19799@ZenIV.linux.org.uk>
	 <D69F3C0C-FC4A-4866-98BD-DE9558250A0B@sun.com>
	 <20100115012421.GA28498@discord.disaster>
	 <5E9FF033-5FD5-42B4-985B-C241F45746C1@sun.com>
	 <20100115110220.GG28498@discord.disaster>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Al Viro <viro@zeniv.linux.org.uk>,
	Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	"James C. Browne" <browne@cs.utexas.edu>
To: Dave Chinner <david@fromorbit.com>,
	Andreas Dilger <adilger@sun.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100115110220.GG28498@discord.disaster>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jan 15, 2010 at 5:02 AM, Dave Chinner <david@fromorbit.com> wro=
te:
> On Thu, Jan 14, 2010 at 11:36:25PM -0500, Andreas Dilger wrote:
>> On 2010-01-14, at 20:24, Dave Chinner wrote:
>>> On Thu, Jan 14, 2010 at 10:33:42AM -0500, Andreas Dilger wrote:
>>>> Sure, it is _possible_ to do this, but you miss the fact that ther=
e
>>>> are
>>>> many system monitoring tools that already scrape /var/log/messages
>>>> and
>>>> integrate with event managers. =A0What you are suggesting is that =
every
>>>> such tool implement an extra, completely ad-hoc mechanism just for
>>>> monitoring the mount/unmount of filesystems on Linux. =A0That does=
n't
>>>> make
>>>> sense.
>>>
>>> We already report various events through a netlink interface, but n=
ot
>>> to the log files (e.g. quota warnings), so those system monitoring
>>> tools are already going to be missing interesting information.
>>>
>>> Using log files for system event notification used to be the only
>>> way to communicate such events. Now we have much more advanced and
>>> efficient mechanisms for notifications so I think we should use
>>> them.
> ....
>> However, there are many reasons why it still makes sense to do this:
>> - it is in plain text format. =A0I can't recall the number of times
>> =A0 people were proposing crazy schemes to have a text interface to =
the
>> =A0 kernel (via /sys/blah, or /debugfs/blah) for things that are muc=
h
>> =A0 better suited to an ioctl, since they are largely handled by bin=
aries
>> =A0 (applications), yet in the case where we have an existing plain-=
text
>> =A0 interface (dmesg and /var/log/messages) that are meant (at least
>> =A0 partly) for human consumption we are proposing a binary interfac=
e
>> - every system monitoring tool in existence has a /var/log/messages
>> =A0 scraping interface, because this is the lowest common denominato=
r,
>> =A0 but I'd suspect that few/none have a netlink interface, or if th=
ey
>> =A0 do it probably can't be easily added to by a user
>
> A daemon that captures the events from netlink and writes them to
> syslog is all that is needed to support log file scraping
> monitoring tools. The message they scrape does not have to come from
> the kernel...
>
klogd.  Do we need another wheel?

Moving this to userland as suggested seams like it would create more
problems then it would solve.

>> If we are going to propose adding a binary interface for kernel stat=
us
>> notification, then we should discuss a proper interface for such tha=
t
>> is a real improvement over what we have today. =A0Things like having
>> proper error message numbers, error levels, subsystem identifiers,
>> timestamps, name=3Dvalue status fields, not doing printf formatting =
in
>> the kernel, etc.
>
> Event notifications don't need this sort of complexity - classifying
> an event is something for the userspace side of the notification -
> it is the policy part of the equation. =A0Different applications will
> do this differently. e.g. system monitoring might write it to syslog
> for the scraper to read, while a desktop subsystem might deliver it
> to a taskbar notification mechanism to generate a usre visible popup
> message.
>
> IMO, using printk() for such notifications provides none of the
> flexibility that modern systems require, but events can easily be
> used to support legacy methods of event reporting. Hence it seems to
> me like a no brainer to use events rather than printk for all new
> notifications....
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
