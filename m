From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3 2/6] ext4: track extent status tree shrinker delay
 statictics
Date: Thu, 4 Sep 2014 11:49:25 -0400
Message-ID: <20140904154925.GF4047@thunk.org>
References: <1407382553-24256-1-git-send-email-wenqing.lz@taobao.com>
 <1407382553-24256-3-git-send-email-wenqing.lz@taobao.com>
 <20140827132607.GA22211@quack.suse.cz>
 <20140904121048.GA13193@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Zheng Liu <wenqing.lz@taobao.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37951 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913AbaIDPtb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Sep 2014 11:49:31 -0400
Content-Disposition: inline
In-Reply-To: <20140904121048.GA13193@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 04, 2014 at 08:10:48PM +0800, Zheng Liu wrote:
> >   When reading through this again, I realized that we probably don't want
> > this file in /proc/fs/ext4 but rather in /sys/kernel/debug/ext4 because
> > it's really a debugging interface and we don't want any tools to start
> > using it.
> 
> Fair enough.  I will fix it in next version.

I was actually OK with leaving it in /proc, since we have a number of
other debugging files in /proc/fs/ext4/<dev> already, and I'm not sure
spreading ext4's foot print so that we have some files in /proc, some
in /sys, and some in debugfs is worth decreasing the possibility that
some tool would start depending on the contents of that file --- I
can't really imagine why non-fs developers would ever care about such
statistics.

I probably *would* be in favor of creating a new config option which
disables /proc/fs/ext4/<dev>/mballoc_groups and
/proc/fs/ext4/<dev>/es_shrinker_info, to help with the people who care
shrinking the total footprint of the Linux kernel for embedded
application (kernel tinification), though.

						- Ted
