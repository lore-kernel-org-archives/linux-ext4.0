From: Ted Ts'o <tytso@mit.edu>
Subject: Re: I'm getting a crash in journal_commit_transaction()
Date: Mon, 19 Sep 2011 08:57:41 -0400
Message-ID: <20110919125741.GA23009@thunk.org>
References: <8EECBDCA81207E4DAF5CE05EFEA0AE754C823492@fmsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Mohanan, Rajmohan" <rajmohan.mohanan@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40647 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755853Ab1ISM5p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Sep 2011 08:57:45 -0400
Content-Disposition: inline
In-Reply-To: <8EECBDCA81207E4DAF5CE05EFEA0AE754C823492@fmsmsx501.amr.corp.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 19, 2011 at 04:31:58AM -0700, Mohanan, Rajmohan wrote:
> Hi,
> 
>  I'm getting a crash in
>  -000|journal_commit_transaction(journal = 0xC58B4600)
>  -001|kjournald(?)
>  -002|kthread(_create = 0xC5B0BD90)
>  -003|kernel_thread_exit(asm)
>   ---|end of frame
>      |
>      |
>  I  have written a tty driver for serial operation and I'm doing
>  Transferring data from my controller ... In between I gets the crash.
> 
> Could you help me to solve this issue.

What architecture is this?  That's not a normal kernel oops message...

You also haven't mentioned the kernel version number, or any thing
else vaguely useful.  Have you tried contacting your colleagues at the
Intel Open Source Technology Center?

-- Ted
