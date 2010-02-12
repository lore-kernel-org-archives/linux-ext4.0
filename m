From: Enrik Berkhan <Enrik.Berkhan@ge.com>
Subject: possible ext4 related deadlock
Date: Fri, 12 Feb 2010 13:49:34 +0100
Message-ID: <4B754E5E.603@ge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from exprod5og105.obsmtp.com ([64.18.0.180]:44059 "EHLO
	exprod5og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab0BLMyp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Feb 2010 07:54:45 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

currently we're experiencing some process hangs that seem to be 
ext4-related. (Kernel 2.6.28.10-Blackfin, i.e. with Analog Devices
patches including some memory management changes for NOMMU.)

The situation is as follows:

We have two threads writing to an ext4-filesystem. After several hours 
and accross about 20 systems there happens one hang where
(reconstructed from Alt-SysRq-W output):

1. pdflush waits in start_this_handle
2. kjournald2 waits in jdb2_journal_commit_transaction
3. thread 1 waits in start_this_handle
4. thread 2 waits in
   ext4_da_write_begin
     (start_this_handle succeeded)
     grab_cache_page_write_begin
       __alloc_pages_internal
         try_to_free_pages
           do_try_to_free_pages
             congestion_wait

Actually, thread 2 shouldn't be completely blocked, because 
congestion_wait has a timeout if I understand the code correctly. 
Unfortunately, I pressed Alt-SysRq-W only once when having a chance to 
reproduce the problem on a test system with console access.

When the system is in this state, some external event like telnet login 
or killing a monitoring process in an older telnet sessin by pressing 
Ctrl-C makes it continue to work normally. I suspect that this triggers 
some memory freeing which allows thread 2 in the example above to get 
some pages and continue running.

I had a look at all the recent ext4/jbd2 changes since about 2.6.28 but 
couldn't identify anything that would solve this problem. But maybe I 
just couldn't identify the right thing.

What I have noticed is that the order of start_this_handle and 
grab_cache_page_write_begin has changed between ext3 and ext4:


ext3_write_begin:
   ...
   page = grab_cache_page_write_begin(mapping, index, flags);
   if (!page)
     return -ENOMEM;
   *pagep = page;

   handle = ext3_journal_start(inode, needed_blocks);
   ...


ext4_{da_}_write_begin:
   ...
   handle = ext4_journal_start(inode, needed_blocks);
   if (IS_ERR(handle)) {
     ret = PTR_ERR(handle);
     goto out;
   }

   /* We cannot recurse into the filesystem as the transaction is already
    * started */
   flags |= AOP_FLAG_NOFS;

   page = grab_cache_page_write_begin(mapping, index, flags);
   ...


As I understand the change of the order requires the AOP_FLAG_NOFS in 
the ext4 code.

Might this be the reason for the deadlock? Would it be worth trying to 
change the order back or is there a very good reason for the change 
between ext3 and ext4?

Or am I looking in a completely wrong place?

Any help would be appreciated.

Enrik
