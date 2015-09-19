From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: resize2fs: Should never happen: resize inode corrupt! - lost key
 inodes
Date: Sat, 19 Sep 2015 11:02:25 -0400
Message-ID: <20150919150225.GG2921@thunk.org>
References: <55CBC212.6000507@harvyl.se>
 <20150813132716.GB26095@thunk.org>
 <55CCDE20.3010108@harvyl.se>
 <55E8C6AC.5000308@harvyl.se>
 <55F3FE07.9030807@harvyl.se>
 <55F73DAD.6020807@harvyl.se>
 <55F85B90.3000709@harvyl.se>
 <B9C846A3-35D0-480C-9888-3F46E8A9C6A5@dilger.ca>
 <20150919024725.GV3902@dastard>
 <55FD6D26.1010706@harvyl.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>,
	Andreas Dilger <adilger@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Johan Harvyl <johan@harvyl.se>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60075 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754944AbbISPC3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 19 Sep 2015 11:02:29 -0400
Content-Disposition: inline
In-Reply-To: <55FD6D26.1010706@harvyl.se>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 19, 2015 at 04:11:50PM +0200, Johan Harvyl wrote:
> 
> Should this be reported in a bug tracker rather than here?

Yes, please do.  I can reproduce this using e2fsprogs 1.43's next
branch, so there is definitely a real bug in e2fsprogs's resize2fs.

The fastest way to reproduce this is using tmpfs (it only requires
275MB of ram):

#!/bin/bash
FS=/tmp/foo.img
touch $FS
mkfs.ext4 $FS -i 262144 -m 0 -O 64bit 15627548672k
resize2fs -p $FS 19534435840k
resize2fs -p $FS 23441323008k
debugfs -c $FS -R "stat <2>"

Cheers,

						- Ted
