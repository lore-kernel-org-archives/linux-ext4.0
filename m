From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [Bug 42859] New: kernel BUG at fs/ext4/extents.c:1953
Date: Sun, 4 Mar 2012 20:51:21 -0500
Message-ID: <20120305015121.GB9087@thunk.org>
References: <bug-42859-13602@https.bugzilla.kernel.org/>
 <20120304202708.GA9087@thunk.org>
 <4F53E874.5050201@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org
To: Matthias Erll <merll@web.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35818 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755314Ab2CEBvX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 4 Mar 2012 20:51:23 -0500
Content-Disposition: inline
In-Reply-To: <4F53E874.5050201@web.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Mar 04, 2012 at 11:11:00PM +0100, Matthias Erll wrote:
> 
> In the three cases I can reproduce, the inode number has been identical.
> Please find the debugfs output below.

Thanks, this is helpful.  It is indeed a bug in e2fsck; it's not
noticing the case where the extent length is zero (but the extent
header was still valid).  The workaround is to run the following
commands with the file system unmounted:

# debugfs -w -R "clri <1312385>" /dev/sda2
# e2fsck -f /dev/sda2

I'll get this fixed in the next maintenance release of e2fsprogs.

     	      	       	   	- Ted
