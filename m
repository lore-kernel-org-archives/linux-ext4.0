From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 fix for interaction between i_size, fallocate, and delalloc
 after a crash
Date: Thu, 30 Nov 2017 09:22:19 -0500
Message-ID: <20171130142219.qeh3a7hleyvxkmkf@thunk.org>
References: <20171127161137.4ghjcxfklpurk2eo@thunk.org>
 <CAFk8rvbxaQ72rvOg6NXDQYG1rXtuZsdzJ5SrbR=C6ftAU0YyPA@mail.gmail.com>
 <20171128204525.ijpis74t75f4bbsc@thunk.org>
 <CAFk8rvZQopSupfc3nakAR+1ORbHSZF+ypzhZA12w=g=MNstHrA@mail.gmail.com>
 <20171129061307.f6hekryi3bppo26y@thunk.org>
 <CAOQ4uxiU3gu5+CRTSKig8r-Bpk=W0-J5N+MBL7s6XSrNUMrAKA@mail.gmail.com>
 <CAFk8rvY9_-GxghCA43G9JoVqw-8NTG7-oRxEcV_cudcgDcy=rQ@mail.gmail.com>
 <20171130004816.pdzfqjluchtvfq6u@thunk.org>
 <CAFk8rvakptuN_rP5CRfLNNLEwntkvvcbdjn55O_E-RQyLUB=MQ@mail.gmail.com>
 <20171130044649.xfgwhd2wzdc5mwql@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Amir Goldstein <amir73il@gmail.com>,
        Vijay Chidambaram <vvijay03@gmail.com>,
        Ext4 <linux-ext4@vger.kernel.org>
To: Ashlie Martinez <ashmrtn@utexas.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47102 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751125AbdK3OWX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 30 Nov 2017 09:22:23 -0500
Content-Disposition: inline
In-Reply-To: <20171130044649.xfgwhd2wzdc5mwql@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 29, 2017 at 11:46:49PM -0500, Theodore Ts'o wrote:
> 
> Can you send the block I/O trace that was observed when you did the
> following, a complete output of dumpe2fs on the file system, and a
> debugfs stat output on the test file?

Oh, and the block I/O trace after CrashMonkey reordered the I/O
operations after the last CACHE FLUSH / barrier operation?  I'm
***really*** curious what I/O operations happened *after* the last
barrier operation if you had waited 120 secounds before triggering the
crash.

						- Ted
