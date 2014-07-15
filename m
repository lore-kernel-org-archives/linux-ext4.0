From: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>
Subject: RE: [PATCH v2] ext4: remove readpage() check up for mmap file
Date: Tue, 15 Jul 2014 14:16:40 +0000
Message-ID: <100D68C7BA14664A8938383216E40DE0407A9B2C@FMSMSX114.amr.corp.intel.com>
References: <1404368274-10404-1-git-send-email-zhenzhang.zhang@huawei.com>
 <53B4F5B7.7060209@huawei.com>,<20140715134328.GB32728@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"wangnan0@huawei.com" <wangnan0@huawei.com>,
	"Zwisler, Ross" <ross.zwisler@intel.com>
To: Theodore Ts'o <tytso@mit.edu>,
	Zhang Zhen <zhenzhang.zhang@huawei.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:53438 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbaGOOQs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Jul 2014 10:16:48 -0400
In-Reply-To: <20140715134328.GB32728@thunk.org>
Content-Language: en-CA
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Are you sure about the origins of that check, Ted?  It's not there in current ext2, and current XIP code calls the generic xip_file_mmap() method, not an ext2/4 specific one.

In any case, yes, no objection from my side to removing this check.
________________________________________
From: Theodore Ts'o [tytso@mit.edu]
Sent: July 15, 2014 6:43 AM
To: Zhang Zhen
Cc: linux-ext4@vger.kernel.org; wangnan0@huawei.com; Zwisler, Ross; Wilcox, Matthew R
Subject: Re: [PATCH v2] ext4: remove readpage() check up for mmap file

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
