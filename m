From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: add sysfs entry showing whether the fs contains
 errors
Date: Wed, 7 May 2014 10:36:46 -0400
Message-ID: <20140507143646.GB28814@thunk.org>
References: <1399464274-16310-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54434 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755872AbaEGOgt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 May 2014 10:36:49 -0400
Content-Disposition: inline
In-Reply-To: <1399464274-16310-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 07, 2014 at 02:04:34PM +0200, Lukas Czerner wrote:
> 
> cat /sys/fs/ext4/sda/errors
> 
> If the file system is not marked as containing errors then the file
> returns just 0. Otherwise it would print out the following information:
> 
> <error count> first <first_error_time> <first_error_func>:<first_error_line> \
> last <last_error_time> <last_error_func>:<last_error_line>

This goes against the typical way in which information is returned in
sysfs.  Personally, I've always preferred the scheme used by, for
example /proc/acpi/battery/BAT0/info, versus needing to read N
different files in /sys/class/power_supply/BAT0/*, but the argument is
that it's easier for programs to parse information if they are in
separate files.

It's one of the reasons why I've kept /proc/fs/ext4/sda3/mb_groups,
since trying to convert that file over to the Church of Sysfs's style
guidelines was far more work than it was worth.

I'm not actually sure it's that important to be able to expose the
error function and error line number via sysfs or procfs.  If a
process wants a complete record of all of the various errors, then
dmesg or maybe some netlink socket is really the best interface for
getting this information.

For sysfs, I suspect the primary use will be answering the questions:
"is this file system healthy or not", and "when did it first become
unhealthy".  And for questoins like this, the errors_count and
first_error_time and last_error_time is probably the most useful bits
of information to expose.

Cheers,

					- Ted
