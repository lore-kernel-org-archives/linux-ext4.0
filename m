From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: large directory entry
Date: Fri, 1 May 2015 10:31:47 -0400
Message-ID: <20150501143147.GB9936@thunk.org>
References: <alpine.DEB.2.20.7.1504301634450.29119@trent.utfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39328 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828AbbEAObu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 May 2015 10:31:50 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.7.1504301634450.29119@trent.utfs.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 30, 2015 at 10:02:58PM -0700, Christian Kujau wrote:
> 
> I have a somewhat larger "directory entry" on this ext4 filesystem, and it 
> takes quite some time to list its contents:
> 
> ------------------------------------
> # time ls -lah /var/lib/php5
> total 18M
> drwxrwx--T.  6 root     www-data  18M Apr 28 04:41 .
> drwxr-xr-x. 48 root     root     4.0K Apr 28 06:03 ..
> drwxr-xr-x.  5 root     root     4.0K Apr 28 04:41 modules
> drwxr-xr-x.  2 www-data www-data 4.0K Oct  9  2014 owncloud-51d9c764244bc
> drwxr-xr-x.  2 www-data www-data 4.0K Jan  6 23:27 owncloud-oc55674097b9
> drwx-wx-wt.  2 root     root      92K May  1 01:14 sessions
> 
> real    0m39.292s
> user    0m0.000s
> sys     0m3.964s
> ------------------------------------
> 
> Notice the "18M" entry for "." - I realize this is a directory for 
> temporary files, meaning that lots of files are generated here, but
> the server is not _that_ busy; according to lsof(8) no files are
> currently open in /var/lib/php5 and only the "sessions" directory
> contains 100 files, there are far less files below the other directories.

That's simply because shrinking directories while the file system is
mounted is... tricky.  At some point we might try to get this
supported, but until we do, there are two workarounds:

1)  Recreate the directory, i.e.,

    mkdir /var/lib/php5.new
    chown root:www-data /var/lib/php5.new
    chmod 1770 /var/lib/lib/php5.new
    mv /var/lib/php5/* /var/lib/php5.new ; mv /var/lib/php5 /var/lib/php5.old  ; mv /var/lib/php5.new /var/lib/php5
    rmdir /var/lib/php5

2) Run "e2fsck -fD /dev/sdXX" on the device containing /var while the file system is unmounted.

Obviously, both of these will require temporarily pausing your web
server, and the second will probably require going to single user
mode or booting from a rescue CD.

> I feel like this is some kind of FAQ, but I could not find anything 
> similar for Ext4. The only similar thing I could think of is an older 
> bug[0] in JFS, where a directory slowly grows when many files are 
> generated & deleted, but I could not reproduce this for Ext4.


I'm not sure I would call this a bug; it's a long standing proper of
ext2/3/4, the BSD FFS, etc., which is directories can't get shurnk by
the file system.  At some point the directory had enough files in it
that it grew to that size, and once having grown to that size, it
won't shirnk on its own.

It would be possible to enhance ext4 to be able to shrink directories
on-line, but it would require adding a new file system (to allow
sparse directories), getting a new version of e2fsck, and then writing
a bunch of new code, and it's just one of those things we've never
gotten around to doing, mainly because for most use cases it rarely
hits people, and the fix should be realtive well understood, as
various Linux/Unix systems have suffered from this for decades.

I'd accept patches to address this, and would even sketch out the
design to some interested summer student interested in a Google Summer
of Code project (for example), but it just hasn't happened yet.

Regards,

						- Ted
