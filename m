From: tytso@mit.edu
Subject: Re: [RFC] do you want jbd2 interface of ext3?
Date: Tue, 16 Feb 2010 09:31:33 -0500
Message-ID: <20100216143133.GU5337@thunk.org>
References: <20100216164123.b10b00e5.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org, adilger@sun.com, jack@suse.cz,
	linux-ext4@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:58880 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756922Ab0BPObq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Feb 2010 09:31:46 -0500
Content-Disposition: inline
In-Reply-To: <20100216164123.b10b00e5.toshi.okajima@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 16, 2010 at 04:41:23PM +0900, Toshiyuki Okajima wrote:
> 
> jbd2 has new features from jbd. For example, it includes the
> integrity improvement features. The body of ext3 is already enough
> quality. If ext3 changes the journaling interface from jbd into
> jbd2, ext3 filesystem with jbd2 interface may get better integrity
> than with the jbd interface.  (jbd2 is aggressively being developed
> now, so I think we are glad if we can get the effect of the
> development of jbd2 for ext3.)
> 
> And ext3 is as de facto standard filesystem, so jbd2 component will
> be used by more people than now if ext3 has the jbd2 interface. If
> many people used the jbd2 interface of ext3, the jbd2 component
> would get more chances to improve the quality and performance and so
> on.

Jbd2 is development attention because it is part of ext4.  And you
don't get to use the data integrity features of jbd2 without
backporting required changes from ext4 to ext3.  At which point, why
not have people use ext4?

Ext4 is format compatible with ext3, and with the proper kernel
configuration options, starting with 2.6.33, it's possible to
seemlessly allow people who use "mount -t ext3 /dev/sda1 /u1" to have
/dev/sda1 mounted using the ext4 file system driver.  So we even have
a way that we can seemlessly upgrade existing userspace setups to
using ext4 without having to make any system configuration changes
(except installing a new kernel, of course).

The whole point of creating the ext3/ext4 fork was to not disturb ext3
users while ext4 was under development.  This was done by effectively
putting ext3 into a bug-fix-only development mode.  Changing ext3 so
it could use jbd2 would seem to violate the stability process that we
have made to the ext3 users; if people want new features and
performance improvements, they can use ext4.

Best regards,

					- Ted
