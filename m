From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Copy i_flags to ext3 inode flags on write (version 2)
Date: Fri, 20 Apr 2007 00:53:37 -0700
Message-ID: <20070420005337.91beacfe.akpm@linux-foundation.org>
References: <20070417103855.GB11815@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46029 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992421AbXDTHyP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Apr 2007 03:54:15 -0400
In-Reply-To: <20070417103855.GB11815@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 17 Apr 2007 12:38:55 +0200 Jan Kara <jack@suse.cz> wrote:

>   attached is a second version of a patch that stores inode flags such as
> S_IMMUTABLE, S_APPEND, etc. from i_flags to EXT3_I(inode)->i_flags when
> inode is written to disk. The same thing is done on GETFLAGS ioctl.
>   Quota code changes these flags on quota files (to make it harder for
> sysadmin to screw himself) and these changes were not correctly
> propagated into the filesystem (especially, lsattr did not show them and
> users were wondering...). Andrew, could you please put the patch into your
> queue? Thanks.

umm, OK.

What about ext2 and all the zillions of others?
