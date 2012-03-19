From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
Date: Mon, 19 Mar 2012 11:46:13 -0700
Message-ID: <1332182773.3908.11.camel@joe2Laptop>
References: <20120319153133.GA2502@thunk.org>
	 <CAJL_dMtC9fnOsY=4uDVJD=-h5u-qW=xjaf64gtDcgnKX2brhPw@mail.gmail.com>
	 <20120319161425.GB2502@thunk.org>
	 <20120319.141402.934377752041508724.davem@davemloft.net>
	 <20120319183126.GA6031@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>, anca.emanuel@gmail.com,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:40433 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756688Ab2CSSqO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Mar 2012 14:46:14 -0400
In-Reply-To: <20120319183126.GA6031@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2012-03-19 at 14:31 -0400, Ted Ts'o wrote:
> On Mon, Mar 19, 2012 at 02:14:02PM -0400, David Miller wrote:
> I've *already* gone far beyond the pr_fmt standardization, with the
> ext4_msg() and ext4_error() system

Please note the defects that were recently corrected there
which occurred because of a lack of standardization both
in prefix and termination style.

> One of the other reasons why I don't like the pr_* system because it
> doesn't go far enough for the pain that's involved with making such a
> change pervasively across the entire kernel.

Any logging system, with or without an external notification
mechanism, will be painful.  pr_<foo> is at least a small
start.  I'd like to see a notification mechanism, perhaps ala
netlink/ethtool to extend pr_<foo> or another call.  A lot of
these printk/pr_<level> uses really could generate notifications.

> What I'd really like to
> see is a system that allows for semi-structured logging --- where
> structured data such as the block device involved, whether it's at a
> device driver driver, block layer, cfq or proportional I/O layer, or
> file system layer, was consistently named, and squirted out a high
> efficiency interface such as netlink or an ftrace ring buffer.

Yay, we agree.

cheers, Joe

