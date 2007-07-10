From: Theodore Tso <tytso@mit.edu>
Subject: Re: Random corruption test for e2fsck
Date: Tue, 10 Jul 2007 10:58:55 -0400
Message-ID: <20070710145855.GB27033@thunk.org>
References: <1184072860.4440.39.camel@garfield.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:42521 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754328AbXGJO66 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jul 2007 10:58:58 -0400
Content-Disposition: inline
In-Reply-To: <1184072860.4440.39.camel@garfield.linsyssoft.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jul 10, 2007 at 06:37:40PM +0530, Kalpak Shah wrote:
> Hi,
> 
> This is a random corruption test which can be included in the e2fsprogs
> regression tests. 
> 1) Create an test fs and format it with ext2/3/4 and random selection of
> features.
> 2) Mount it and copy data into it.

This requires root privileges in order to mount the loop filesystem.
Any chance you could change it to use debugfs to populate the
filesystem, so we don't need root privs in order to mount it.

This will increase the number of people that will actually run the
test, and more importantly not encourage people from running "make
check" as root.

> 3) Move around the blocks of the filesystem randomly causing corruption.
> Also overwrite some random blocks with garbage from /dev/urandom. Create
> a copy of this corrupted filesystem.
>
> 4) Unmount and run e2fsck. If the first run of e2fsck produces any
> errors like uncorrected errors, library error, segfault, usage error,
> etc. then it is deemed a bug. But in any case, a second run of e2fsck is
> done to check if it renders the filesystem clean. 

Err, you do unmount the filesystem first before you start corrupting
it, right?  (Checking script; sure looks like it.)

> 5) If the test went by without any errors the test image is deleted and
> in case of any errors the user is notified that the log of this test run
> should be mailed to linux-ext4@ and the image should be preserved.

I certainly like the general concept!!

I wonder if the code to create a random filesystem and corrupting it
should be kept as separate shell script, since it can be reused in
another of interesting ways.  One thought would be to write a test
script that mounts corrupted filesystems using UML and then does some
exercises on it (tar cvf on the filesyste, random renames on the
filesystem, rm -rf of all of the contents of the filesystems), to see
whether we can provoke a kernel oops.

Regards,

							- Ted
