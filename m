From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] fix null handler of ioctls in no journal mode
Date: Mon, 13 Jul 2009 09:29:53 -0400
Message-ID: <20090713132953.GA1030@mit.edu>
References: <1247223826-24378-1-git-send-email-bergwolf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Peng Tao <bergwolf@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46185 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754942AbZGMN35 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Jul 2009 09:29:57 -0400
Content-Disposition: inline
In-Reply-To: <1247223826-24378-1-git-send-email-bergwolf@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 10, 2009 at 07:03:46PM +0800, Peng Tao wrote:
> EXT4_IOC_GROUP_ADD and EXT4_IOC_GROUP_EXTEND ioctls should not flush journal
> in no_journal mode.

Thanks, added to the ext4 patch queue, altough I did tighten up up
your patch description slightly:

ext4: fix null handler of ioctls in no journal mode

The EXT4_IOC_GROUP_ADD and EXT4_IOC_GROUP_EXTEND ioctls should not
flush the journal in no_journal mode.  Otherwise, running resize2fs on
a mounted no_journal partition triggers the following error messages:

BUG: unable to handle kernel NULL pointer dereference at 00000014
IP: [<c039d282>] _spin_lock+0x8/0x19
*pde = 00000000 
Oops: 0002 [#1] SMP

Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

							- Ted
	       
