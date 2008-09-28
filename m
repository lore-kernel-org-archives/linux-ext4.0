From: Theodore Tso <tytso@mit.edu>
Subject: Re: inode and blocks
Date: Sun, 28 Sep 2008 17:01:18 -0400
Message-ID: <20080928210118.GD8711@mit.edu>
References: <2d08ef090809280319m64555696nfe1a446e010f921f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kernelnewbies <kernelnewbies@nl.linux.org>,
	ext4 <linux-ext4@vger.kernel.org>
To: Rohit Sharma <imreckless@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:34591 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752006AbYI1VBV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 28 Sep 2008 17:01:21 -0400
Content-Disposition: inline
In-Reply-To: <2d08ef090809280319m64555696nfe1a446e010f921f@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 28, 2008 at 03:49:04PM +0530, Rohit Sharma wrote:
> Suppose i have a file named abc.txt and i want to specify that
> all the *.txt files must be allocated between block groups no. 100 -
> 200 in ext2 fs.
> 
> Is there a way to do this?
> 
> can we modify function ext2_new_inode and find_group_orlov for this?

You would have to modify kernel code to do this; the main question
which comes to mind is *why* would you want to do something like this?
It seems like an ideal problem set that a professor might give to a
student, since it would force them to try to get from an inode to the
pathname used to open the file.  So it seems to be one of these really
pointless things that isn't particularly useful in real life, except
for pedagogical purposes.

							- Ted
