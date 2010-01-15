From: Dave Chinner <david@fromorbit.com>
Subject: Re: [REPOST][PATCH][RFC] vfs: add message print mechanism for the
	mount/umount into the VFS layer
Date: Fri, 15 Jan 2010 12:24:21 +1100
Message-ID: <20100115012421.GA28498@discord.disaster>
References: <20100114154837.734fff60.toshi.okajima@jp.fujitsu.com> <20100114081448.GI19799@ZenIV.linux.org.uk> <D69F3C0C-FC4A-4866-98BD-DE9558250A0B@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Al Viro <viro@zeniv.linux.org.uk>,
	Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	tytso@mit.edu, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <D69F3C0C-FC4A-4866-98BD-DE9558250A0B@sun.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jan 14, 2010 at 10:33:42AM -0500, Andreas Dilger wrote:
> On 2010-01-14, at 03:14, Al Viro wrote:
>> I am not going to apply that.  For one thing, printk is improper  
>> mechanism
>> for "observing [normal] operations".  Vague references to "enterprise
>> users" wanting that do not constitute a valid rationale.
>>
>> What's more, there is absolutely no point in taking care to have  
>> mount(2)
>> spew something in log when explicitly asked to do so; caller can  
>> bloody
>> well do it itself.  From userland.
>
> Sure, it is _possible_ to do this, but you miss the fact that there are 
> many system monitoring tools that already scrape /var/log/messages and 
> integrate with event managers.  What you are suggesting is that every 
> such tool implement an extra, completely ad-hoc mechanism just for 
> monitoring the mount/unmount of filesystems on Linux.  That doesn't make 
> sense.

We already report various events through a netlink interface, but not
to the log files (e.g. quota warnings), so those system monitoring
tools are already going to be missing interesting information.

Using log files for system event notification used to be the only
way to communicate such events. Now we have much more advanced and
efficient mechanisms for notifications so I think we should use
them.

FWIW, having a general event channel for reporting filesystem events like
mount, enospc, corruption, etc makes a lot of sense to me.
Especially from the point of view that they can be also be tied into
automated filesystem test harnesses easily....

> Conversely, adding a new monitor for a message in /var/log/messages is  
> simply a matter of adding a scanf() format string to their existing list 
> of format strings - a 5-minute exercise for a junior sysadmin.

Writing a netlink interface for listening to events is not that much
harder, either....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
