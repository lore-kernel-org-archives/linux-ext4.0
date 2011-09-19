From: "Mohanan, Rajmohan" <rajmohan.mohanan@intel.com>
Subject: RE: I'm getting a crash in journal_commit_transaction()
Date: Mon, 19 Sep 2011 08:26:26 -0700
Message-ID: <8EECBDCA81207E4DAF5CE05EFEA0AE754C82368E@fmsmsx501.amr.corp.intel.com>
References: <8EECBDCA81207E4DAF5CE05EFEA0AE754C823492@fmsmsx501.amr.corp.intel.com>
 <20110919125741.GA23009@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:9620 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753863Ab1ISP0a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Sep 2011 11:26:30 -0400
In-Reply-To: <20110919125741.GA23009@thunk.org>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,
    This call stack i got from lauterbach. Actually I'm not getting Kernel panic. But kernel crashed.
I'm writing a virtual uart driver which will commnunicate to the actual hardware through virtualizer.

I'm using froyo release from android which is 2.6.32 I think.

When i do scanning operation via Bluetooth android mmi gets updated ,at this time I'm getting crash every time in the same place

Regards
Rajmohan

-----Original Message-----
From: Ted Ts'o [mailto:tytso@mit.edu] 
Sent: Monday, September 19, 2011 6:28 PM
To: Mohanan, Rajmohan
Cc: linux-ext4@vger.kernel.org
Subject: Re: I'm getting a crash in journal_commit_transaction()

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
