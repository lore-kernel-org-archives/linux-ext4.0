From: Jan Kara <jack@suse.cz>
Subject: Re: possible ext4 related deadlock
Date: Thu, 18 Feb 2010 02:55:36 +0100
Message-ID: <20100218015536.GB8897@atrey.karlin.mff.cuni.cz>
References: <4B754E5E.603@ge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Enrik Berkhan <Enrik.Berkhan@ge.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ksp.mff.cuni.cz ([195.113.26.206]:35059 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753797Ab0BRBzh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Feb 2010 20:55:37 -0500
Content-Disposition: inline
In-Reply-To: <4B754E5E.603@ge.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

> currently we're experiencing some process hangs that seem to be  
> ext4-related. (Kernel 2.6.28.10-Blackfin, i.e. with Analog Devices
> patches including some memory management changes for NOMMU.)
>
> The situation is as follows:
>
> We have two threads writing to an ext4-filesystem. After several hours  
> and accross about 20 systems there happens one hang where
> (reconstructed from Alt-SysRq-W output):
>
> 1. pdflush waits in start_this_handle
> 2. kjournald2 waits in jdb2_journal_commit_transaction
> 3. thread 1 waits in start_this_handle
> 4. thread 2 waits in
>   ext4_da_write_begin
>     (start_this_handle succeeded)
>     grab_cache_page_write_begin
>       __alloc_pages_internal
>         try_to_free_pages
>           do_try_to_free_pages
>             congestion_wait
>
> Actually, thread 2 shouldn't be completely blocked, because  
> congestion_wait has a timeout if I understand the code correctly.  
> Unfortunately, I pressed Alt-SysRq-W only once when having a chance to  
> reproduce the problem on a test system with console access.
  Yes, thread 2 should eventually proceed, finish (or fail) the write and thus
all other processes should continue. If it does not, it's really strange. I've
checked the code but don't see where we could possibly loop - at worst, we
should spend like 1.5s waiting, then we conclude there's no free page for us
and we bail out with ENOMEM. If this does not happen it would be good to
find out whether we get stuck somewhere else or what...

> When the system is in this state, some external event like telnet login  
> or killing a monitoring process in an older telnet sessin by pressing  
> Ctrl-C makes it continue to work normally. I suspect that this triggers  
> some memory freeing which allows thread 2 in the example above to get  
> some pages and continue running.
>
> I had a look at all the recent ext4/jbd2 changes since about 2.6.28 but  
> couldn't identify anything that would solve this problem. But maybe I  
> just couldn't identify the right thing.
>
> What I have noticed is that the order of start_this_handle and  
> grab_cache_page_write_begin has changed between ext3 and ext4:
>
>
> ext3_write_begin:
>   ...
>   page = grab_cache_page_write_begin(mapping, index, flags);
>   if (!page)
>     return -ENOMEM;
>   *pagep = page;
>
>   handle = ext3_journal_start(inode, needed_blocks);
>   ...
>
>
> ext4_{da_}_write_begin:
>   ...
>   handle = ext4_journal_start(inode, needed_blocks);
>   if (IS_ERR(handle)) {
>     ret = PTR_ERR(handle);
>     goto out;
>   }
>
>   /* We cannot recurse into the filesystem as the transaction is already
>    * started */
>   flags |= AOP_FLAG_NOFS;
>
>   page = grab_cache_page_write_begin(mapping, index, flags);
>   ...
>
>
> As I understand the change of the order requires the AOP_FLAG_NOFS in  
> the ext4 code.
  Yes.

> Might this be the reason for the deadlock? Would it be worth trying to  
> change the order back or is there a very good reason for the change  
> between ext3 and ext4?
  It isn't a good idea to change the ordering in ext4 back to the one
in ext3. The main reason is that also other places in ext4 code rely
on start_handle -> lock_page ordering and thus you'd create real deadlocks
if you've changed just ext4_{da_}write_begin.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
