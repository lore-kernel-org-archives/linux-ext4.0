From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: don't BUG when truncating encrypted inodes on the
 orphan list
Date: Mon, 13 Feb 2017 10:27:04 -0500
Message-ID: <20170213152704.rgh5oannnvsqleoh@thunk.org>
References: <20170211031942.11783-1-tytso@mit.edu>
 <CAOMGZ=FGDTY2p0r4G30=nGvCKVMG6n-JZfcREsys6Xa1Oiz9bg@mail.gmail.com>
 <20170213003137.u6xqaswur7gka325@thunk.org>
 <CAOMGZ=GrnLVSX5xEzn5m4ASsiBhpWv8U8SL0im-xNway9pNktw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34404 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751504AbdBMP1I (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 13 Feb 2017 10:27:08 -0500
Content-Disposition: inline
In-Reply-To: <CAOMGZ=GrnLVSX5xEzn5m4ASsiBhpWv8U8SL0im-xNway9pNktw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 13, 2017 at 03:58:46AM +0100, Vegard Nossum wrote:
> Those reports all include the hotlinks actually. The one for this problem was:
> 
> http://139.162.151.198/f/ext4/5bdefda69f39b2f2c56d9b67d5b7d9e2cc8dfd5f/
> 
> If you go to the stack trace then any line containing a kernel address
> that can be addr2lined appears in green and clicking it should expand
> a link to git.kernel.org. It does probably need javascript to work.

Nice!  I hadn't noticed that.  I was running with javascript disabled
(unless the site was on a white list) for a while, so that could be why.

> I'll get around to rerunning all the testcases soon on a recent kernel.

Thanks!

					- Ted
