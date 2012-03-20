From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
Date: Mon, 19 Mar 2012 21:47:07 -0400
Message-ID: <20120320014707.GD14363@thunk.org>
References: <20120319153133.GA2502@thunk.org>
 <CAJL_dMtC9fnOsY=4uDVJD=-h5u-qW=xjaf64gtDcgnKX2brhPw@mail.gmail.com>
 <20120319161425.GB2502@thunk.org>
 <20120319.141402.934377752041508724.davem@davemloft.net>
 <20120319183126.GA6031@thunk.org>
 <1332182773.3908.11.camel@joe2Laptop>
 <20120320010401.GA14363@thunk.org>
 <1332207202.7847.23.camel@joe2Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, anca.emanuel@gmail.com,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56566 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616Ab2CTBrN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Mar 2012 21:47:13 -0400
Content-Disposition: inline
In-Reply-To: <1332207202.7847.23.camel@joe2Laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 19, 2012 at 06:33:22PM -0700, Joe Perches wrote:
> They _were_ doubly prefixed.
> 
> from ext4#dev
> 
> commit 2504a4a9c0c096e11bcc24691b85bf6d942df9fe
> Author: Joe Perches <joe@perches.com>
> Date:   Mon Mar 19 00:12:00 2012 -0400
> 
>     ext4: remove redundant "EXT4-fs: " from uses of ext4_msg
>     
>     ext4_msg adds "EXT4-fs: " to the messsage output.
>     Remove the redundant bits from uses.
>     
>     Signed-off-by: Joe Perches <joe@perches.com>
>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Yes, and I accepted that patch.  I was referring to your complaints of
printk's such as this:

#ifdef EXT4FS_DEBUG
			WARN_ON(ret <= 0);
			printk(KERN_ERR "%s: ext4_ext_map_blocks "
				    "returned error inode#%lu, block=%u, "
				    "max_blocks=%u", __func__,
				    inode->i_ino, map.m_lblk, max_blocks);
#endif

... and in that case, even if I was going to fix it, I wouldn't be
fixing it via pr_err().  I'd be fixing using ext4_msg().  Why?
Because then the message would include the block device and not just
the EXT4-fs prefix.

> > Yes, but we can't do structured notifications with the current
> > pr_<foo>.  So why change literally tens of thousands of callsites when
> > in order to really realize the full promise of structured
> > notifications, we'll have to change them *again*?
> 
> So that they are consistent and extensible and can use
> something like pr_<level>_notify, just like pr_<level>_once
> and pr_<level>_ratelimited, or some other similar form.

Changing to pr_err() is pointless, because it doesn't do anything
functional.  You *have* to have an interface like ext4_msg(sb, ...) if
you're going to send a semi-structured notification, or include
relevant information about which ext4 file system was responsible for
issuing the warning.

If you're going to change huge numbers of lines of code, you might as
well do it in a way that significantly improves things.  The change to
pr_foo() is just syntactic sugar, and that's a whitespace-level change
in my book.  Adding a struct super * or or a struct block device *,
which gets passed to the notification functions?  That's ***far***
more interesting.

      	   	       	   	       	   	   - Ted
