From: Ted Ts'o <tytso@mit.edu>
Subject: Re: ext4: Fix 32bit overflow in ext4_ext_find_goal()
Date: Sun, 2 Jan 2011 23:11:57 -0500
Message-ID: <20110103041157.GE11955@thunk.org>
References: <4D05B132.3060402@sx.jp.nec.com>
 <20110102214031.GA10889@thunk.org>
 <F02D88CD-7463-4E10-A012-D2CE362D1E88@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kazuya Mio <k-mio@sx.jp.nec.com>, ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33941 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653Ab1ACEMF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 2 Jan 2011 23:12:05 -0500
Content-Disposition: inline
In-Reply-To: <F02D88CD-7463-4E10-A012-D2CE362D1E88@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 02, 2011 at 08:35:39PM -0700, Andreas Dilger wrote:
> It was written that way because HPC applications writing to a shared
> file normally write to an offset of task_num * task_data_size so
> they do not overlap, and end up with a dense file. Similarly,
> bittorrent and parallel FTP clients will write dense files after
> seeking randomly around the file, and database files often end up
> dense as well.
> 
> I'd rather fix the relatively few applications that expect
> permanently sparse files to use fadvise() to notify the kernel of
> this.

Agreed, and I'm not sure there are enough applications that expect
permanently sparse files that's worth adding a new fadvise().  But if
we do add a new fadvise(), the default should clearly be the current
behavior.

If someone knows of use cases where permanently sparse files are
common, please let us know!

						- Ted
