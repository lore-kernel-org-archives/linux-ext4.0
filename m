From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
Date: Mon, 19 Mar 2012 18:59:01 -0700
Message-ID: <1332208741.7847.46.camel@joe2Laptop>
References: <20120319153133.GA2502@thunk.org>
	 <CAJL_dMtC9fnOsY=4uDVJD=-h5u-qW=xjaf64gtDcgnKX2brhPw@mail.gmail.com>
	 <20120319161425.GB2502@thunk.org>
	 <20120319.141402.934377752041508724.davem@davemloft.net>
	 <20120319183126.GA6031@thunk.org> <1332182773.3908.11.camel@joe2Laptop>
	 <20120320010401.GA14363@thunk.org> <1332207202.7847.23.camel@joe2Laptop>
	 <20120320014707.GD14363@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>, anca.emanuel@gmail.com,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:42143 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756745Ab2CTB7C (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Mar 2012 21:59:02 -0400
In-Reply-To: <20120320014707.GD14363@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2012-03-19 at 21:47 -0400, Ted Ts'o wrote:
> On Mon, Mar 19, 2012 at 06:33:22PM -0700, Joe Perches wrote:
> > They _were_ doubly prefixed.
> > from ext4#dev
> > commit 2504a4a9c0c096e11bcc24691b85bf6d942df9fe
> > Author: Joe Perches <joe@perches.com>
> > Date:   Mon Mar 19 00:12:00 2012 -0400
> >     ext4: remove redundant "EXT4-fs: " from uses of ext4_msg
> >     ext4_msg adds "EXT4-fs: " to the messsage output.
> Yes, and I accepted that patch.  I was referring to your complaints of
> printk's such as this:
> #ifdef EXT4FS_DEBUG
> 			WARN_ON(ret <= 0);
> 			printk(KERN_ERR "%s: ext4_ext_map_blocks "
> 				    "returned error inode#%lu, block=%u, "
> 				    "max_blocks=%u", __func__,
> 				    inode->i_ino, map.m_lblk, max_blocks);
> #endif

and I was not.  Doubly prefixed was as I said, doubly prefixed.
ext4_msg wasn't a consistently used interface.

> Changing to pr_err() is pointless, because it doesn't do anything
> functional.  You *have* to have an interface like ext4_msg(sb, ...) if
> you're going to send a semi-structured notification, or include
> relevant information about which ext4 file system was responsible for
> issuing the warning.

Umm, ext4_msg does call printk.

> If you're going to change huge numbers of lines of code, you might as
> well do it in a way that significantly improves things.  The change to
> pr_foo() is just syntactic sugar, and that's a whitespace-level change
> in my book.  Adding a struct super * or or a struct block device *,
> which gets passed to the notification functions?  That's ***far***
> more interesting.

It's hard to say that's true.
Look at the the trace_<foo> mechanisms.
Very useful stuff but once set, there's
been a strong desire to set the output
as an unchangeable ABI.

So I think defining the output correctly
_first_ is the most important element of
any notification mechanism.  TLV use in
the output generally isn't human parsable
and there's value in that readability.


