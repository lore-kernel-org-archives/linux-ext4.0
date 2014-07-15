From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: remove readpage() check up for mmap file
Date: Tue, 15 Jul 2014 09:43:28 -0400
Message-ID: <20140715134328.GB32728@thunk.org>
References: <1404368274-10404-1-git-send-email-zhenzhang.zhang@huawei.com>
 <53B4F5B7.7060209@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	wangnan0@huawei.com, "Zwisler, Ross" <ross.zwisler@intel.com>,
	Matthew Wilcox <matthew.r.wilcox@intel.com>
To: Zhang Zhen <zhenzhang.zhang@huawei.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35927 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbaGOOJE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jul 2014 10:09:04 -0400
Content-Disposition: inline
In-Reply-To: <53B4F5B7.7060209@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 03, 2014 at 02:18:31PM +0800, Zhang Zhen wrote:
> There is no kind of file does not supply page reading function.

The code in question originally came from ext2, when the a_ops used in
XIP mode did not have a readpage function.  And since there is an
outstanding XIP patch set that Matthew Wilcox has been working on, I
was going to NACK this.  Howeveer, it looks like the lines in question
are getting removed in the most recent version of the XIP patch set
that I've seen, so it it seems the only problem is this will cause a
minor patch conflict with XIP.

So I'll accept this, and assume the XIP folks aren't going to object....

   	       	     	 	    	- Ted
