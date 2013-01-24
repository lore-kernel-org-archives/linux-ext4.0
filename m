From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: call WARN_ON after the debug message
Date: Thu, 24 Jan 2013 14:54:58 -0500
Message-ID: <20130124195458.GD9477@thunk.org>
References: <1359045044-31435-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45312 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755564Ab3AXTzF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Jan 2013 14:55:05 -0500
Content-Disposition: inline
In-Reply-To: <1359045044-31435-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 24, 2013 at 05:30:43PM +0100, Lukas Czerner wrote:
> In two places we call WARN_ON() before we print out the debug message,
> however the custom is to print such messages before we call WARN_ON() so
> change that.
> 
> Also use ext4_msg() instead of plain printk().
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

I was actually thinking about removing the WARN_ON entirely, or at
least suppressing it when the error begin returned from
ext4_map_blocks is EIO.  The reason for that is the warning is causing
noise for automated log scanners, and if the problem is caused by a
hardware failure, there's no real point in dumping out a stack trace.
More generally, is there any reason why we need the stack trace at
all?

Also maybe we should use ext4_warning() instead of ext4_msg()?

     	      	     	 		- Ted
