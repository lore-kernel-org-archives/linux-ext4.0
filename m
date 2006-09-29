From: Theodore Tso <tytso@mit.edu>
Subject: Re: Newbie ext2 forensics question...
Date: Fri, 29 Sep 2006 09:37:45 -0400
Message-ID: <20060929133745.GC5016@thunk.org>
References: <loom.20060929T063450-383@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:18400 "EHLO thunker.thunk.org")
	by vger.kernel.org with ESMTP id S1751065AbWI2Nhp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Sep 2006 09:37:45 -0400
To: Dave Edwards <ext2@dpe.lusars.net>
Content-Disposition: inline
In-Reply-To: <loom.20060929T063450-383@post.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Sep 29, 2006 at 04:47:38AM +0000, Dave Edwards wrote:
> I'm trying to tune a linux system to spin down its (ext2-formatted) disk when
> the system is idle. I've worked down to two problematic applications that
> periodically spin up the disk, even though the (tiny) file they're writing is
> (allegedly) on a tmpfs partition (/tmp/application/datafile, as it happens).

If you are using a distribution that has SystemTap preinstalled,
something that may be simpler to use would be a SystemTap script which
logs which process id's are calling the write system call.  Yes,
you'll get false negatives for processes writing to pty's and serial
devices, et. al.  If you only have ext3 filesystems on your system,
you can could modify the SystemTap script to print a message including
the pid each time there is a call to ext3_file_write().

(With more advanced SystemTap-foo it would be possible to extract out
the inode information and print the inode #, but you'd have to contact
a SystemTap user's mailing list for help doing something like that.
Still, I suspect getting the process ID is hopefully enough for your
purposes.)

Regards,

						- Ted
