From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] code cleanup on include/linux/fs.h
Date: Thu, 17 Feb 2011 11:14:45 -0500
Message-ID: <20110217161445.GI26780@thunk.org>
References: <AANLkTinpYGiq_mn7iO4xKW01nLXWrW89bRMXjME=5pSS@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, liuqi <liuqi@thunderst.com>
To: Steven Liu <lingjiujianke@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34832 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756373Ab1BQQOu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Feb 2011 11:14:50 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTinpYGiq_mn7iO4xKW01nLXWrW89bRMXjME=5pSS@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 17, 2011 at 05:38:43PM +0800, Steven Liu wrote:
> Hi Ted,
> 
> 
>       Can this patch be fixed.
> 
>        Cleanup the unsed code on  include/linux/fs.h.
>     All filesystem using mount_bdev and mount_nodev
>     to replace get_sb_bdev and get_sb_nodev.
>     So rmmove the unused code.

Um, why are you sending this to the linux-ext4 list?

And if you really want to get rid of get_sb_bdev and get_sb_nodev, you
should send a single patch which removes it from all files in the
Linux source tree, as well as updating references to these functions
in the Documentation/filesystems/porting file.

							- Ted
