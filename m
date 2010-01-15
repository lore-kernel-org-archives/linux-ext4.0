From: Dave Chinner <david@fromorbit.com>
Subject: Re: [REPOST][PATCH][RFC] vfs: add message print mechanism for the
	mount/umount into the VFS layer
Date: Fri, 15 Jan 2010 22:02:20 +1100
Message-ID: <20100115110220.GG28498@discord.disaster>
References: <20100114154837.734fff60.toshi.okajima@jp.fujitsu.com> <20100114081448.GI19799@ZenIV.linux.org.uk> <D69F3C0C-FC4A-4866-98BD-DE9558250A0B@sun.com> <20100115012421.GA28498@discord.disaster> <5E9FF033-5FD5-42B4-985B-C241F45746C1@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Al Viro <viro@zeniv.linux.org.uk>,
	Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	Theodore Ts'o <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
	"linux-ext4@vger.kernel.org development" <linux-ext4@vger.kernel.org>,
	"James C. Browne" <browne@cs.utexas.edu>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:35855 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751456Ab0AOLCm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Jan 2010 06:02:42 -0500
Content-Disposition: inline
In-Reply-To: <5E9FF033-5FD5-42B4-985B-C241F45746C1@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 14, 2010 at 11:36:25PM -0500, Andreas Dilger wrote:
> On 2010-01-14, at 20:24, Dave Chinner wrote:
>> On Thu, Jan 14, 2010 at 10:33:42AM -0500, Andreas Dilger wrote:
>>> Sure, it is _possible_ to do this, but you miss the fact that there  
>>> are
>>> many system monitoring tools that already scrape /var/log/messages  
>>> and
>>> integrate with event managers.  What you are suggesting is that every
>>> such tool implement an extra, completely ad-hoc mechanism just for
>>> monitoring the mount/unmount of filesystems on Linux.  That doesn't  
>>> make
>>> sense.
>>
>> We already report various events through a netlink interface, but not
>> to the log files (e.g. quota warnings), so those system monitoring
>> tools are already going to be missing interesting information.
>>
>> Using log files for system event notification used to be the only
>> way to communicate such events. Now we have much more advanced and
>> efficient mechanisms for notifications so I think we should use
>> them.
....
> However, there are many reasons why it still makes sense to do this:
> - it is in plain text format.  I can't recall the number of times
>   people were proposing crazy schemes to have a text interface to the
>   kernel (via /sys/blah, or /debugfs/blah) for things that are much
>   better suited to an ioctl, since they are largely handled by binaries
>   (applications), yet in the case where we have an existing plain-text
>   interface (dmesg and /var/log/messages) that are meant (at least
>   partly) for human consumption we are proposing a binary interface
> - every system monitoring tool in existence has a /var/log/messages
>   scraping interface, because this is the lowest common denominator,
>   but I'd suspect that few/none have a netlink interface, or if they
>   do it probably can't be easily added to by a user

A daemon that captures the events from netlink and writes them to
syslog is all that is needed to support log file scraping
monitoring tools. The message they scrape does not have to come from
the kernel...

> If we are going to propose adding a binary interface for kernel status
> notification, then we should discuss a proper interface for such that
> is a real improvement over what we have today.  Things like having
> proper error message numbers, error levels, subsystem identifiers,
> timestamps, name=value status fields, not doing printf formatting in
> the kernel, etc.

Event notifications don't need this sort of complexity - classifying
an event is something for the userspace side of the notification -
it is the policy part of the equation.  Different applications will
do this differently. e.g. system monitoring might write it to syslog
for the scraper to read, while a desktop subsystem might deliver it
to a taskbar notification mechanism to generate a usre visible popup
message.

IMO, using printk() for such notifications provides none of the
flexibility that modern systems require, but events can easily be
used to support legacy methods of event reporting. Hence it seems to
me like a no brainer to use events rather than printk for all new
notifications....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
