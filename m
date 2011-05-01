From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Don't set PageUptodate in ext4_end_bio()
Date: Sun, 1 May 2011 17:56:42 -0400
Message-ID: <20110501215642.GB2819@thunk.org>
References: <1303494718-13444-1-git-send-email-curtw@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jim@meyering.net, cmm@us.ibm.com
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:32917 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783Ab1EAV4q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 1 May 2011 17:56:46 -0400
Content-Disposition: inline
In-Reply-To: <1303494718-13444-1-git-send-email-curtw@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 22, 2011 at 10:51:58AM -0700, Curt Wohlgemuth wrote:
> In the bio completion routine, we should not be setting
> PageUptodate at all -- it's set at sys_write() time, and is
> unaffected by success/failure of the write to disk.
> 
> This can cause a page corruption bug when
> 
>       block size < page size
> 
> if we have only written a single block -- we might end up
> setting the entire PageUptodate, which will cause subsequent
> reads to get bad data.
> 
> Signed-off-by: Curt Wohlgemuth <curtw@google.com>
> Reported-by: Jim Meyering <jim@meyering.net>
> Reported-by: Hugh Dickins <hughd@google.com>
> Cc: Mingming Cao <cmm@us.ibm.com>

Thanks, I've added this to the ext4 tree.

					- Ted
