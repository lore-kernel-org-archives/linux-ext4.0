From: "Bram Neijt" <bneijt@gmail.com>
Subject: Re: User permissions or UID/GIDs for portable disks?
Date: Thu, 25 Oct 2007 12:23:28 +0200
Message-ID: <46c2f4ab0710250323y28107ce7qf13b608954f86c4f@mail.gmail.com>
References: <46c2f4ab0710241110o582dcc27pbd6d2c31474b526b@mail.gmail.com>
	 <1193279915.25351.18.camel@eric-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.186]:34838 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758338AbXJYKX3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Oct 2007 06:23:29 -0400
Received: by rv-out-0910.google.com with SMTP id k20so430646rvb
        for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 03:23:29 -0700 (PDT)
In-Reply-To: <1193279915.25351.18.camel@eric-laptop>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

First of all thank you for your reply.

To your question about allowing users to access/write to your files, I
would awnser yes. This is the whole point: allowing the owner of the
object full access without root privileges. I want to be able to
substitute a floppy or rewritable CD with an usbstick. Giving the
device to somebody will allow them to go any terminal with root access
and do anything they want anyway (unless I use encryption).

As I see it, the problem is that only the creator/owner of the
portable media knows what should be allowed by a non-root user when it
is plugged into another system. When I use it as a portable data
system for file interchange (like a rewritable cdrom or an
old-fashioned floppy), there is no way of telling the receiving system
that it should allow users to modify anything on this device. Without,
mind you, allowing any user of the system to modify anything on all
USB attached devices. Those devices may be usb disks with critical
work data that should be read-only for any work colleague but me.

One solution I can come up with, which would push the problem a level
higher, is by using a special disk label or UUID. But using a special
UUID for all "read and write anywhere" usb media, would probably
violate the whole "unique" idea about it ;-). A special label would
suffice, but may be perceived as ugly. So the best solution I can come
up with: make all attached media with a point at the end of their
label user owned.

Because I have the idea it should either be a globally agreed method
on every system I encounter or it should be something I can convey in
the filesystem/attributes when formatting, I thought I would ask
everybody on this list about it.

Greets,
  Bram

PS As soon as anyboby feels that this discussion should not be held on
this mailinglist, please feel free to kindly redirect me to another
location.

On 10/25/07, Eric <erpo41@gmail.com> wrote:
> On Wed, 2007-10-24 at 20:10 +0200, Bram Neijt wrote:
> > One of the best solutions I can come up with is if the filesystem
> > would allow for a switch that would help ignore these permissions as
> > part of the filesystem.
>
> Ignoring file permissions on removable, user-supplied media sounds like
> something that ought to be done above the level of individual
> filesystems, just like how we ignore device files and suid/sgid files in
> certain cases. Maybe this is something that ought to be one level up
> from the ext2/3/4 filesystem driver?
>
> In any case, this raises interesting questions. If we ignore permissions
> on removable media, then anyone logged into your work computer (to which
> you do not have root access) will be able to muck about with your files.
> Is that something you want?
>
> Cheers,
>
> Eric
>
>
>
