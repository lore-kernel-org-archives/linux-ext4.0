From: Andreas Dilger <adilger@sun.com>
Subject: Re: [REPOST][PATCH][RFC] vfs: add message print mechanism for the
 mount/umount into the VFS layer
Date: Thu, 14 Jan 2010 10:33:42 -0500
Message-ID: <D69F3C0C-FC4A-4866-98BD-DE9558250A0B@sun.com>
References: <20100114154837.734fff60.toshi.okajima@jp.fujitsu.com>
 <20100114081448.GI19799@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>, tytso@mit.edu,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-reply-to: <20100114081448.GI19799@ZenIV.linux.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2010-01-14, at 03:14, Al Viro wrote:
> I am not going to apply that.  For one thing, printk is improper  
> mechanism
> for "observing [normal] operations".  Vague references to "enterprise
> users" wanting that do not constitute a valid rationale.
>
> What's more, there is absolutely no point in taking care to have  
> mount(2)
> spew something in log when explicitly asked to do so; caller can  
> bloody
> well do it itself.  From userland.

Sure, it is _possible_ to do this, but you miss the fact that there  
are many system monitoring tools that already scrape /var/log/messages  
and integrate with event managers.  What you are suggesting is that  
every such tool implement an extra, completely ad-hoc mechanism just  
for monitoring the mount/unmount of filesystems on Linux.  That  
doesn't make sense.

Conversely, adding a new monitor for a message in /var/log/messages is  
simply a matter of adding a scanf() format string to their existing  
list of format strings - a 5-minute exercise for a junior sysadmin.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

