From: Andreas Dilger <adilger@sun.com>
Subject: Re: [REPOST][PATCH][RFC] vfs: add message print mechanism for the
 mount/umount into the VFS layer
Date: Thu, 14 Jan 2010 23:36:25 -0500
Message-ID: <5E9FF033-5FD5-42B4-985B-C241F45746C1@sun.com>
References: <20100114154837.734fff60.toshi.okajima@jp.fujitsu.com>
 <20100114081448.GI19799@ZenIV.linux.org.uk>
 <D69F3C0C-FC4A-4866-98BD-DE9558250A0B@sun.com>
 <20100115012421.GA28498@discord.disaster>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: Al Viro <viro@zeniv.linux.org.uk>,
	Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
	"linux-ext4@vger.kernel.org development" <linux-ext4@vger.kernel.org>,
	"James C. Browne" <browne@cs.utexas.edu>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:35574 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab0AOEga (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Jan 2010 23:36:30 -0500
In-reply-to: <20100115012421.GA28498@discord.disaster>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-01-14, at 20:24, Dave Chinner wrote:
> On Thu, Jan 14, 2010 at 10:33:42AM -0500, Andreas Dilger wrote:
>> Sure, it is _possible_ to do this, but you miss the fact that there  
>> are
>> many system monitoring tools that already scrape /var/log/messages  
>> and
>> integrate with event managers.  What you are suggesting is that every
>> such tool implement an extra, completely ad-hoc mechanism just for
>> monitoring the mount/unmount of filesystems on Linux.  That doesn't  
>> make
>> sense.
>
> We already report various events through a netlink interface, but not
> to the log files (e.g. quota warnings), so those system monitoring
> tools are already going to be missing interesting information.
>
> Using log files for system event notification used to be the only
> way to communicate such events. Now we have much more advanced and
> efficient mechanisms for notifications so I think we should use
> them.
>
> FWIW, having a general event channel for reporting filesystem events  
> like
> mount, enospc, corruption, etc makes a lot of sense to me.
> Especially from the point of view that they can be also be tied into
> automated filesystem test harnesses easily....


I agree, of course, that /var/log/messages is an inefficient channel for
reporting status information from the kernel.

However, there are many reasons why it still makes sense to do this:
- it is in plain text format.  I can't recall the number of times
   people were proposing crazy schemes to have a text interface to the
   kernel (via /sys/blah, or /debugfs/blah) for things that are much
   better suited to an ioctl, since they are largely handled by binaries
   (applications), yet in the case where we have an existing plain-text
   interface (dmesg and /var/log/messages) that are meant (at least
   partly) for human consumption we are proposing a binary interface
- every system monitoring tool in existence has a /var/log/messages
   scraping interface, because this is the lowest common denominator,
   but I'd suspect that few/none have a netlink interface, or if they
   do it probably can't be easily added to by a user

If we are going to propose adding a binary interface for kernel status
notification, then we should discuss a proper interface for such that
is a real improvement over what we have today.  Things like having
proper error message numbers, error levels, subsystem identifiers,
timestamps, name=value status fields, not doing printf formatting in
the kernel, etc.

There are several major HPC sites that I know of that would LOVE to add
something like that, because they need to process the logs for thousands
of nodes in a cluster, and have people to work on it.  If there is  
interest
in the upstream kernel maintainers (i.e. Linus, Andrew) for reformatting
the printk() messages in the kernel to using a new binary interface  
(with
the option to format and dump them to the console for compatibility),
then great, I'm all for it.

However, it is doesn't make sense to me to suggest that people add  
random
binary status messages to netlink at random times without any kind of
planning or coordination, since it will just result in a mishmash of
ad-hoc messages, tools, etc, that will be far worse than what we have
today instead of improving what exists in /var/log/messages today.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

