From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: release ->i_mutex and resume unlocked dio in
 swap_inode_boot_loader() (Re: mutex_unlock is missed ...)
Date: Wed, 12 Feb 2014 11:49:50 -0500
Message-ID: <20140212164950.GF14520@thunk.org>
References: <CAFZT-j+KqKfx5sEr3G9JbesUNgp60vi9Zn_tT=78S-WrVmmxKw@mail.gmail.com>
 <20140209122745.GA12554@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ahmed Tamrawi <ahmedtamrawi@gmail.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57115 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbaBLQtz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Feb 2014 11:49:55 -0500
Content-Disposition: inline
In-Reply-To: <20140209122745.GA12554@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 09, 2014 at 08:27:45PM +0800, Zheng Liu wrote:
> 
> In swap_inode_boot_loader() we forgot to release ->i_mutex and resume
> unlocked dio for inode and inode_bl.  This commit fixes this issue.
> 
> Reported-by: Ahmed Tamrawi <ahmedtamrawi@gmail.com>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Dr. Tilmann Bubeck <t.bubeck@reinform.de>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>

Thanks, applied.

					- Ted
