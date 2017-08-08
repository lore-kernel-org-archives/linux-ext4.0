From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: How to enable CONFIG_EXT4_ENCRYPTION
Date: Tue, 8 Aug 2017 09:19:10 -0400
Message-ID: <20170808131910.c2qrejl47xlujnl6@thunk.org>
References: <20170807032502.2tiyjybtqrn6odab@linux>
 <20170807095126.hyhrrnr4vrj3ne4k@linux>
 <20170807134942.u3ep5ivfq4ublueb@thunk.org>
 <20170807193138.GA46084@gmail.com>
 <20170808012738.6rlknzovmyhjn4rg@linux>
 <20170808055013.GA593@zzz.localdomain>
 <20170808060320.sh4pe4abekxhkonh@linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Biggers <ebiggers3@gmail.com>, linux-ext4@vger.kernel.org
To: Dai Xiang <xiangx.dai@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49546 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752184AbdHHNTP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 8 Aug 2017 09:19:15 -0400
Content-Disposition: inline
In-Reply-To: <20170808060320.sh4pe4abekxhkonh@linux>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 08, 2017 at 02:03:20PM +0800, Dai Xiang wrote:
> oh, I see, i miss them, but i have a new question:
> 
> I have set CONFIG_FS_ENCRYPTION and CONFIG_EXT4_ENCRYPTION both y, but
> after build the config do not include them, and what make me confused
> is that there is no failure log about them.
> 
> Did i miss some dependence kconfigs or conflict kconfigs?

Almost certainly.  :-)

You can use "make menuconfig" to help figure out what you missed.

						- Ted
