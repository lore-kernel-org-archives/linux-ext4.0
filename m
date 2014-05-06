From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 metadata corruption bug?
Date: Tue, 6 May 2014 11:42:39 -0400
Message-ID: <20140506154239.GA5012@thunk.org>
References: <20140420163211.GT10985@gradx.cs.jhu.edu>
 <20140423072311.GD10163@dot.freshdot.net>
 <20140423143642.GA29925@thunk.org>
 <20140501162503.GL5136@gradx.cs.jhu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, admins@acm.jhu.edu
To: Nathaniel W Filardo <nwf@cs.jhu.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52300 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932434AbaEFPmn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 May 2014 11:42:43 -0400
Content-Disposition: inline
In-Reply-To: <20140501162503.GL5136@gradx.cs.jhu.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 01, 2014 at 12:25:03PM -0400, Nathaniel W Filardo wrote:
> Here's another kernel report, this time from /dev/sda1, which is a QEMU-IDE
> view of a local LVM volume and is only 4060864 blocks big, so it falls into
> neither the "Ceph's fault" nor "8TB is special" bins:
> 
> [922646.672586] EXT4-fs error (device sda1): ext4_mb_generate_buddy:756: group 17, 24652 clusters in bitmap, 24651 in gd; block bitmap corrupt.

So this is a different report from the ones where we see this error:

[817576.492468] EXT4-fs error (device vdd): ext4_mb_release_inode_pa:3729: group 59035, free 14, pa_free 12

Have you seen any more of these errors?

> [922646.712017] BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
> [922646.712017] IP: [<ffffffffa014a7cc>] __ext4_error_inode+0x2c/0x150 [ext4]

FYI, this BUG (which can happens after certain jbd2 errors, which in
your case happened after the journal was aborted) is fixed with commit
66a4cb187b9 which will be in v3.15.

	    	  				- Ted


