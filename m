From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
Date: Mon, 19 Mar 2012 14:31:26 -0400
Message-ID: <20120319183126.GA6031@thunk.org>
References: <20120319153133.GA2502@thunk.org>
 <CAJL_dMtC9fnOsY=4uDVJD=-h5u-qW=xjaf64gtDcgnKX2brhPw@mail.gmail.com>
 <20120319161425.GB2502@thunk.org>
 <20120319.141402.934377752041508724.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: anca.emanuel@gmail.com, joe@perches.com, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43917 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965009Ab2CSSb2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Mar 2012 14:31:28 -0400
Content-Disposition: inline
In-Reply-To: <20120319.141402.934377752041508724.davem@davemloft.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 19, 2012 at 02:14:02PM -0400, David Miller wrote:
> 
> Not the same, since moving to pr_*() allows us to standardize on
> kernel log output formatting, amongst other things, so it has a real
> practical impact unlike the spelling fix.

I've *already* gone far beyond the pr_fmt standardization, with the
ext4_msg() and ext4_error() system --- not only does it standardize
the prefix, it also standardizes information about the file system,
block numbers, inode numbers, so that it's easier for dmesg scrapers
to collate that information and use it for cluster-wide monitoring ---
which is happening *today* using printk() on far more machines than
probably anywhere else in the world.

One of the other reasons why I don't like the pr_* system because it
doesn't go far enough for the pain that's involved with making such a
change pervasively across the entire kernel.  What I'd really like to
see is a system that allows for semi-structured logging --- where
structured data such as the block device involved, whether it's at a
device driver driver, block layer, cfq or proportional I/O layer, or
file system layer, was consistently named, and squirted out a high
efficiency interface such as netlink or an ftrace ring buffer.

*That* would allow userspace to correlate errors from multiple kernel
subsystems for a particular device, and use a much more efficient and
less error-prone system than screen scraping dmesg output.  But the
proposed pr_* system is totally inadequate for this purpose, and if
all you're going to be able to do is make it slightly easier
standardize the prefix, it's just not interesting as far as I'm
concerned.

						- Ted
