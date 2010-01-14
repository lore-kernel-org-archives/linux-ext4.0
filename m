From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [REPOST][PATCH][RFC] vfs: add message print mechanism for the
	mount/umount into the VFS layer
Date: Thu, 14 Jan 2010 08:14:48 +0000
Message-ID: <20100114081448.GI19799@ZenIV.linux.org.uk>
References: <20100114154837.734fff60.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100114154837.734fff60.toshi.okajima@jp.fujitsu.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jan 14, 2010 at 03:48:37PM +0900, Toshiyuki Okajima wrote:
> Hi. 
> 
> Now, on the VFS-layer any messages aren't printed at mount/umount time 
> (when the operation normally terminates).
> But there are some filesystems which print their own specific messages at those
> times.
> 
> For the purpose of the system management and so on, users (especially, 
> enterprise users) want to observe their system operations from the system logs.
> We may manage to observe some filesystems' operations (mount/umount) from the 
> logs. But the filesystems of which we can observe the operations are not all.
> 
> Therefore to achieve the observations for all filesystems is to add the common
> message mechanism into the VFS layer. If any filesystems' specific messages at 
> mount/umount time are added into this, we can distinguish more easily each 
> message among the system logs for our systems' observations. 
> 
> This patch provides the following:
> - message output of common format from VFS at mount/umount time
> - the functions of printing the filesystem's specific information at 
>   mount/umount time
 
I am not going to apply that.  For one thing, printk is improper mechanism
for "observing [normal] operations".  Vague references to "enterprise
users" wanting that do not constitute a valid rationale.

What's more, there is absolutely no point in taking care to have mount(2)
spew something in log when explicitly asked to do so; caller can bloody
well do it itself.  From userland.  And on umount side your logics is
simply b0rken, since the presence of report depends on the order of vfsmount
demise in case when there are several vfsmounts over given superblock.

I can see a value in having something e.g. in /proc that would report the
list of active filesystems (or active filesystems of given type).  poll()able,
a-la /proc/mounts.  Format of such thing would have to be considered
carefully, but at least it's something that might make sense.
