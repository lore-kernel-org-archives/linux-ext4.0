From: Joseph Qi <joseph.qi@huawei.com>
Subject: Re: [BUG] infinite loop when unmounting ext3/4
Date: Thu, 16 Jul 2015 14:18:16 +0800
Message-ID: <55A74CA8.9070902@huawei.com>
References: <20150715143031.GB18016@dhcp-13-216.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>
To: Eryu Guan <guaneryu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:25706 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbbGPGSa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Jul 2015 02:18:30 -0400
In-Reply-To: <20150715143031.GB18016@dhcp-13-216.nay.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I got the problem.
I am not sure why old code uses "result <= 0" even if
it won't return negative value. Could we use "result == 0" instead of
"result <= 0"?

On 2015/7/15 22:30, Eryu Guan wrote:
> Hi all,
> 
> I found an infinite loop when unmounting a known bad ext3 image (using
> ext4 driver) with 4.2-rc1 kernel.
> 
> The fs image can be found here
> https://bugzilla.kernel.org/show_bug.cgi?id=10882#c1
> 
> Reproduce steps:
>   mount -o loop ext3.img /mnt/ext3
>   rm -rf /mnt/ext3/{dev,proc,sys}
>   umount /mnt/ext3	# never return
> 
> And this issue was introduced by
> 6f6a6fd jbd2: fix ocfs2 corrupt when updating journal superblock fails
> 
> It's looping in
> fs/jbd2/journal.c:jbd2_journal_destroy()
> ...
> 1693         while (journal->j_checkpoint_transactions != NULL) {                                                                             
> 1694                 spin_unlock(&journal->j_list_lock);                                                                                      
> 1695                 mutex_lock(&journal->j_checkpoint_mutex);                                                                                
> 1696                 jbd2_log_do_checkpoint(journal);                                                                                         
> 1697                 mutex_unlock(&journal->j_checkpoint_mutex);                                                                              
> 1698                 spin_lock(&journal->j_list_lock);                                                                                        
> 1699         }
> ...
> 
> Because jbd2_cleanup_journal_tail() is returning -EIO on aborted journal
> now instead of 1, and jbd2_log_do_checkpoint() won't cleanup
> journal->j_checkpoint_transactions in this while loop.
> 
> A quick hack would be
> 
> diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
> index 4227dc4..1b2ea47 100644
> --- a/fs/jbd2/checkpoint.c
> +++ b/fs/jbd2/checkpoint.c
> @@ -220,11 +220,13 @@ int jbd2_log_do_checkpoint(journal_t *journal)
>          * don't need checkpointing, just eliminate them from the
>          * journal straight away.
>          */
> -       result = jbd2_cleanup_journal_tail(journal);
> -       trace_jbd2_checkpoint(journal, result);
> -       jbd_debug(1, "cleanup_journal_tail returned %d\n", result);
> -       if (result <= 0)
> -               return result;
> +       if (!is_journal_aborted(journal)) {
> +               result = jbd2_cleanup_journal_tail(journal);
> +               trace_jbd2_checkpoint(journal, result);
> +               jbd_debug(1, "cleanup_journal_tail returned %d\n", result);
> +               if (result <= 0)
> +                       return result;
> +       }
>  
>         /*
>          * OK, we need to start writing disk blocks.  Take one transaction
> 
> to restore the old behavior (continue on aborted journal). Maybe someone
> has a better fix.
> 
> Thanks,
> Eryu
> 
> .
> 


