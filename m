From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH]:ext4 these lines are too long while reading
Date: Fri, 9 Sep 2016 09:47:31 -0400
Message-ID: <20160909134731.qw3pmidbprxjrtpg@thunk.org>
References: <57D281D1.6020208@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: norton <norton.zhu@huawei.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:32906 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751092AbcIINsL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 9 Sep 2016 09:48:11 -0400
Content-Disposition: inline
In-Reply-To: <57D281D1.6020208@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 09, 2016 at 05:33:05PM +0800, norton wrote:
> Hi, all
> 
> I'm a freshman in ext4 file system and I'm reading its source code now.
> This patch did nothing but make it looks better.(
> some lines are too long in vim :( ).

We don't take line-remapping patches.  It used to be the case that
checkpatch would complain if lines were too long, and then it started
complaining if the lines were wrapped.  I don't like checkpatch,
because it causes unnecessary patch churn.  :-(

May I suggest instead that you take a look at reconfiguring vim?

http://stackoverflow.com/questions/467739/how-do-you-get-vim-to-display-wrapped-lines-without-inserting-newlines

					- Ted
