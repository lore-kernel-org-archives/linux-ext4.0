From: Jan Kara <jack@suse.cz>
Subject: Re: ext4 xfstests-bld results for 3.8-rc6 on Pandaboard ES
Date: Mon, 11 Feb 2013 16:29:08 +0100
Message-ID: <20130211152908.GE5318@quack.suse.cz>
References: <20130207220536.GA16092@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36220 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756758Ab3BKP3K (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Feb 2013 10:29:10 -0500
Content-Disposition: inline
In-Reply-To: <20130207220536.GA16092@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 07-02-13 17:05:36, Eric Whitney wrote:
> Here's the lockdep report for xfstest 113 run in the dioread_nolock scenario
> as mentioned above (the taint is due to an unrelated warning from the clk
> subsystem believed to be unique to 3.8 on Pandaboards/OMAP):
  Thanks for the report!

> [ INFO: possible circular locking dependency detected ]
> 3.8.0-rc6 #1 Tainted: G        W   
> -------------------------------------------------------
> aio-stress/8597 is trying to acquire lock:
>  (&mm->mmap_sem){++++++}, at: [<c00f1928>] get_user_pages_fast+0x48/0x88
> 
> but task is already holding lock:
>  (&ei->i_data_sem){++++.+}, at: [<c01ae2a8>] ext4_direct_IO+0x3d4/0x450
>  
> which lock already depends on the new lock.
  Drat, this looks like a real deadlock possibility. I didn't realize this
when reviewing the dioread_nolock patches but i_data_sem ranks below
mmap_sem because we need to grab it in page fault path to map blocks. So we
cannot acquire it in ext4_ext_direct_IO() as it calls
__blockdev_direct_IO() which gets mmap_sem to fault in user-provided pages.
That will be tough to fix... Luckily, the deadlock isn't easy to hit in
practice as it requires mmap and DIO to happen on the same file (already
unlikely) and furthermore three processes, two of them sharing mm, to race
in the right way:

Thread 1		Thread 2	Thread 3
down_read(mmap_sem);
			mmap()
...			  down_write(mmap_sem); [blocked]
  ext4_page_mkwrite();
					ext4_ext_direct_IO()
					  down_read(i_data_sem);
					  ...
					  __blockdev_direct_IO();
					    get_user_pages_fast();
					      down_read(mmap_sem); [blocked]
    ...
    ext4_da_get_block_prep();
      down_write(i_data_sem); [blocked]


								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
