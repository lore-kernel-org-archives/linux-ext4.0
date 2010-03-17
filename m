From: "Jayson R. King" <dev@jaysonking.com>
Subject: Re: [PATCH 2.6.27.y 00/11] *** SUBJECT HERE ***
Date: Tue, 16 Mar 2010 22:10:44 -0500
Message-ID: <4BA04834.6040502@jaysonking.com>
References: <1268699165-17461-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: stable@kernel.org, "Jayson R. King" <dev@jaysonking.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bosmailout07.eigbox.net ([66.96.190.7]:58001 "EHLO
	bosmailout07.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab0CQDtF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Mar 2010 23:49:05 -0400
Received: from bosmailscan04.eigbox.net ([10.20.15.4])
	by bosmailout07.eigbox.net with esmtp (Exim)
	id 1NrjlK-00016Q-Jk
	for linux-ext4@vger.kernel.org; Tue, 16 Mar 2010 23:17:38 -0400
In-Reply-To: <1268699165-17461-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 03/15/2010 07:25 PM, Theodore Ts'o wrote:
> These are the patches backported by Jayson R. King.  I've eyeballed
> them, and run them through a xfsqa test run, and they look good to me.
> 
> Greg, please apply them to the 2.6.27 kernel.
> 
>       	     	   					- Ted
> 
> Aneesh Kumar K.V (10):
>   ext4: invalidate pages if delalloc block allocation fails.
>   ext4: Make sure all the block allocation paths reserve blocks
>   ext4: Add percpu dirty block accounting.
>   ext4: Retry block reservation
>   ext4: Retry block allocation if we have free blocks left
>   ext4: Use tag dirty lookup during mpage_da_submit_io
>   vfs: Remove the range_cont writeback mode.
>   vfs: Add no_nrwrite_index_update writeback control flag
>   ext4: Fix file fragmentation during large file write.
>   ext4: Implement range_cyclic in ext4_da_writepages instead of
>     write_cache_pages
> 
> Mingming Cao (1):
>   percpu counter: clean up percpu_counter_sum_and_set()
> 
>  fs/ext4/balloc.c               |   88 +++++++++---
>  fs/ext4/ext4.h                 |   13 ++
>  fs/ext4/ext4_sb.h              |    1 +
>  fs/ext4/inode.c                |  314 ++++++++++++++++++++++++++++------------
>  fs/ext4/mballoc.c              |   39 +++--
>  fs/ext4/super.c                |    8 +-
>  include/linux/percpu_counter.h |   12 +-
>  include/linux/writeback.h      |   10 +-
>  lib/percpu_counter.c           |    8 +-
>  mm/page-writeback.c            |   16 +-
>  10 files changed, 360 insertions(+), 149 deletions(-)

Thanks for looking at this.

Jayson
