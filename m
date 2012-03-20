From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
Date: Mon, 19 Mar 2012 18:33:22 -0700
Message-ID: <1332207202.7847.23.camel@joe2Laptop>
References: <20120319153133.GA2502@thunk.org>
	 <CAJL_dMtC9fnOsY=4uDVJD=-h5u-qW=xjaf64gtDcgnKX2brhPw@mail.gmail.com>
	 <20120319161425.GB2502@thunk.org>
	 <20120319.141402.934377752041508724.davem@davemloft.net>
	 <20120319183126.GA6031@thunk.org> <1332182773.3908.11.camel@joe2Laptop>
	 <20120320010401.GA14363@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>, anca.emanuel@gmail.com,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:59440 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753607Ab2CTBdX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Mar 2012 21:33:23 -0400
In-Reply-To: <20120320010401.GA14363@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2012-03-19 at 21:04 -0400, Ted Ts'o wrote:
> On Mon, Mar 19, 2012 at 11:46:13AM -0700, Joe Perches wrote:
> > On Mon, 2012-03-19 at 14:31 -0400, Ted Ts'o wrote:
> > > On Mon, Mar 19, 2012 at 02:14:02PM -0400, David Miller wrote:
> > > I've *already* gone far beyond the pr_fmt standardization, with the
> > > ext4_msg() and ext4_error() system
> > 
> > Please note the defects that were recently corrected there
> > which occurred because of a lack of standardization both
> > in prefix and termination style.
> 
> For debugging printk's that are #ifdef'ed for anyone other than ext4
> developers and can't be enabled via CONFIG_*.  Yawn.

Really?  Huh.  Are these messages debugging only?
Not really.

$ grep "ext4_msg.*EXT4-fs: " fs/ext4/*.c
fs/ext4/mballoc.c:			ext4_msg(sb, KERN_ERR, "EXT4-fs: can't allocate mem "
fs/ext4/mballoc.c:		ext4_msg(sb, KERN_ERR, "EXT4-fs: can't allocate buddy mem");
fs/ext4/mballoc.c:	ext4_msg(ac->ac_sb, KERN_ERR, "EXT4-fs: Can't allocate:"
fs/ext4/mballoc.c:	ext4_msg(ac->ac_sb, KERN_ERR, "EXT4-fs: status %d flags %d",
fs/ext4/mballoc.c:	ext4_msg(ac->ac_sb, KERN_ERR, "EXT4-fs: orig %lu/%lu/%lu@%lu, "
fs/ext4/mballoc.c:	ext4_msg(ac->ac_sb, KERN_ERR, "EXT4-fs: %lu scanned, %d found",
fs/ext4/mballoc.c:	ext4_msg(ac->ac_sb, KERN_ERR, "EXT4-fs: groups: ");

They _were_ doubly prefixed.

from ext4#dev

commit 2504a4a9c0c096e11bcc24691b85bf6d942df9fe
Author: Joe Perches <joe@perches.com>
Date:   Mon Mar 19 00:12:00 2012 -0400

    ext4: remove redundant "EXT4-fs: " from uses of ext4_msg
    
    ext4_msg adds "EXT4-fs: " to the messsage output.
    Remove the redundant bits from uses.
    
    Signed-off-by: Joe Perches <joe@perches.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

> > Any logging system, with or without an external notification
> > mechanism, will be painful.  pr_<foo> is at least a small
> > start.  I'd like to see a notification mechanism, perhaps ala
> > netlink/ethtool to extend pr_<foo> or another call.  A lot of
> > these printk/pr_<level> uses really could generate notifications.
> 
> Yes, but we can't do structured notifications with the current
> pr_<foo>.  So why change literally tens of thousands of callsites when
> in order to really realize the full promise of structured
> notifications, we'll have to change them *again*?

So that they are consistent and extensible and can use
something like pr_<level>_notify, just like pr_<level>_once
and pr_<level>_ratelimited, or some other similar form.

