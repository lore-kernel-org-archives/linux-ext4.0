From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: e2fsprogs: mke2fs -d: copy the Extended Attributes
Date: Thu, 17 Apr 2014 12:27:07 -0400
Message-ID: <20140417162707.GK18591@thunk.org>
References: <534F7F5A.3070805@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	Zheng Liu <gnehzuil.liu@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Robert Yang <liezhi.yang@windriver.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56703 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbaDQQ1K (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Apr 2014 12:27:10 -0400
Content-Disposition: inline
In-Reply-To: <534F7F5A.3070805@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 17, 2014 at 03:14:34PM +0800, Robert Yang wrote:
> 
> The "mke2fs -d" doesn't copy the file's extended attributes into the
> device currently, I'd like to make it work and submit a patch for it
> if it is acceptable by e2fsprogs. Maybe we can add a "[-x xattr]"
> option for "mke2fs -d" to make it copy the extended attributes.

Any reason not to always copy the xattrs if they exist?

If we want to add a new option for a feature like this which is fairly
exotic, my preference would be to either use the -E mechanism and make
it be an extended option, or to put it in /etc/mke2fs.conf.

Regards,

						- Ted
