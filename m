From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: remove a duplicate call in ext4_init_new_dir()
Date: Fri, 22 Aug 2014 19:55:40 -0400
Message-ID: <20140822235540.GS11085@thunk.org>
References: <1407856709-18612-1-git-send-email-wangshilong1991@gmail.com>
 <B0F97F2C-631A-4D01-97EC-E6687D4E674D@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Wang Shilong <wangshilong1991@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45463 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308AbaHVXzo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Aug 2014 19:55:44 -0400
Content-Disposition: inline
In-Reply-To: <B0F97F2C-631A-4D01-97EC-E6687D4E674D@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 20, 2014 at 01:21:55AM +0800, Wang Shilong wrote:
> Any comments on this cleanup patch?

Looks good.  This got sent just before the merge window opened, and
this week has been the Kernel Summit / LinuxCon North America.  So I
haven't started accepting patches to the ext4 git tree just yet.  Now
that the event is open, we'll start with regression fixes and high
priority bug fixes that need to go to Linus before 3.17 is released,
and then cleanup and patch fixups.

Cheers,

						- Ted
