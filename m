From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH v2] ext4: add sysfs entry showing whether the fs contains
 errors
Date: Wed, 7 May 2014 17:35:54 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1405071714470.2128@localhost.localdomain>
References: <1399464274-16310-1-git-send-email-lczerner@redhat.com> <20140507143646.GB28814@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755443AbaEGPf7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 May 2014 11:35:59 -0400
In-Reply-To: <20140507143646.GB28814@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 7 May 2014, Theodore Ts'o wrote:

> Date: Wed, 7 May 2014 10:36:46 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: [PATCH v2] ext4: add sysfs entry showing whether the fs contains
>     errors
> 
> On Wed, May 07, 2014 at 02:04:34PM +0200, Lukas Czerner wrote:
> > 
> > cat /sys/fs/ext4/sda/errors
> > 
> > If the file system is not marked as containing errors then the file
> > returns just 0. Otherwise it would print out the following information:
> > 
> > <error count> first <first_error_time> <first_error_func>:<first_error_line> \
> > last <last_error_time> <last_error_func>:<last_error_line>
> 
> This goes against the typical way in which information is returned in
> sysfs.  Personally, I've always preferred the scheme used by, for
> example /proc/acpi/battery/BAT0/info, versus needing to read N
> different files in /sys/class/power_supply/BAT0/*, but the argument is
> that it's easier for programs to parse information if they are in
> separate files.

What about /sys/class/power_supply/BAT0/uevent ? It it is easily
parsable and has all the information in
/sys/class/power_supply/BAT0/*

Also something like /sys/block/sda/stat seems to differ from the
rest.

> 
> It's one of the reasons why I've kept /proc/fs/ext4/sda3/mb_groups,
> since trying to convert that file over to the Church of Sysfs's style
> guidelines was far more work than it was worth.

I tried to find sysfs guidelines but I can not see any in
Documentation speaking about the contents of the files.

What are the guidelines then ?

> 
> I'm not actually sure it's that important to be able to expose the
> error function and error line number via sysfs or procfs.  If a
> process wants a complete record of all of the various errors, then
> dmesg or maybe some netlink socket is really the best interface for
> getting this information.

Maybe not important, but it seems useful enough. However we might
want to restrict read permissions to owner only, since it does not
seem like a good idea to expose this information to the world.

> 
> For sysfs, I suspect the primary use will be answering the questions:
> "is this file system healthy or not", and "when did it first become
> unhealthy".  And for questoins like this, the errors_count and
> first_error_time and last_error_time is probably the most useful bits
> of information to expose.

So you're suggesting to have three sysfs files ?

errors_count
first_error_time
last_error_time

-Lukas

> 
> Cheers,
> 
> 					- Ted
> 
