From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: remove readpage() check up for mmap file
Date: Tue, 15 Jul 2014 12:16:03 -0400
Message-ID: <20140715161603.GB1491@thunk.org>
References: <1404368274-10404-1-git-send-email-zhenzhang.zhang@huawei.com>
 <53B4F5B7.7060209@huawei.com>
 <20140715134328.GB32728@thunk.org>
 <100D68C7BA14664A8938383216E40DE0407A9B2C@FMSMSX114.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zhang Zhen <zhenzhang.zhang@huawei.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"wangnan0@huawei.com" <wangnan0@huawei.com>,
	"Zwisler, Ross" <ross.zwisler@intel.com>
To: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36267 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbaGOQQb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jul 2014 12:16:31 -0400
Content-Disposition: inline
In-Reply-To: <100D68C7BA14664A8938383216E40DE0407A9B2C@FMSMSX114.amr.corp.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 15, 2014 at 02:16:40PM +0000, Wilcox, Matthew R wrote:
> Are you sure about the origins of that check, Ted?  It's not there
> in current ext2, and current XIP code calls the generic
> xip_file_mmap() method, not an ext2/4 specific one.

That was my memory, but I admit I haven't gone diving into the pre-git
linux-history tree to make sure.....

But in any case, the only possible potential conflict would have been
on the XIP patch set, and it doesn't seem to be an issue there.

(BTW, what's the current status on the XIP patch set?  I admit I've
gotten too busy to track its status lately.  There were a bunch of
comments from mm and core vfs folks, but that was a while ago.  What's
still left to be resolved at this point?)

      	      	 	     	  - Ted
