From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Commit Interval and Delayed Allocation
Date: Fri, 9 Nov 2012 21:58:38 -0500
Message-ID: <20121110025838.GA5974@thunk.org>
References: <0408C81F72528E40A0D3235A1F67FFC83ECD9881@SN2PRD0202MB144.namprd02.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Nelson, John R" <John_Nelson@student.uml.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60318 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810Ab2KJC6l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 9 Nov 2012 21:58:41 -0500
Content-Disposition: inline
In-Reply-To: <0408C81F72528E40A0D3235A1F67FFC83ECD9881@SN2PRD0202MB144.namprd02.prod.outlook.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Nov 10, 2012 at 12:40:42AM +0000, Nelson, John R wrote:
> Hi,
>   Say if ext4 commits every 5 seconds, does this mean whatever is
>buffered for delayed allocation is flushed every 5 seconds as well?

No; there is a separate 30 second timer which is used for writeback
thread.

For ext3 in data=ordered mode, we will flush out dirty pages for
inodes which have been written to make sure that stale data can never
get revealed.

But in delayed allocation, there is no risk that stale data can get
revealed until we actually allocate the data blocks.

	       	  	   	    	- Ted
