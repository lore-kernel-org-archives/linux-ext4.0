From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] JBD: release checkpoint journal heads through
 try_to_release_page when the memory is exhausted
Date: Mon, 20 Oct 2008 16:02:49 -0700
Message-ID: <20081020160249.ff41f762.akpm@linux-foundation.org>
References: <20081017.223716.147444348.00960188@stratos.soft.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, sct@redhat.com
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36518 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753957AbYJTXDG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Oct 2008 19:03:06 -0400
In-Reply-To: <20081017.223716.147444348.00960188@stratos.soft.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 17 Oct 2008 22:37:16 +0900 (JST)
Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com> wrote:

> Hi.
> 
> I found the situation where OOM-Killer happens easily.
> I will inform you of it. 
> I tried to fix this problem to make OOM-Killer not happen easily as much as 
> possible.
> As a result, I made a reference patch to fix it. 
> 
> Any comments are welcome.
> (The comments for making much simpler or epoch-making approach are 
> very welcome.)
> 
> ------------------------------------------------------------------------------
> 
> If the following is satisfied, OOM-Killer happens easily.
> (1) A quarter of a summation of each total log size of all filesystems which 
>    use jbd exceeds the memory size of Normal Zone.
> (2) We commit a huge number of data which include many metadata to each 
>    filesystem and then we stop committing data to them. 
>     For example, a process creates many files whose size are huge and 
>    which have a huge number of indirect blocks. Then all processes stop I/O 
>    to all filesystems which use jbd.
> (3) After (2), we request to get a big size memory.
> (NOTE: A oom-killer can happen easily on a system whose architecture is x86. 
> Because a x86 system can have only a small Normal Zone of less than 1GB.)
> 
> The reason is that jbd does not positively release journal heads(jh-s)
>   even if there are many jh-s which can be released.
> 
> Releasing jh-s is only executed at the following timing:
> - if free log space becomes a quarter of the total log size 
>   (log_do_checkpoint())
> - if a transaction begins to commit (journal_cleanup_checkpoint_list() 
>  which is called by journal_commit_transaction())
> (NOTE: A jh-s which corresponds to buffer heads (bh-s) which is a direct block 
>       can be released at journal_try_to_free_buffers() which is called 
>       by try_to_release_page())   
> 
> Therefore,  if we let filesystems do above (2), jh-s remains because 
> new transaction isn't generated. 
> However, when the system memory is exhausted, try_to_release_page() can be 
> called, but it cannot release bh-s which are metadata (indirect blocks 
> and so on).  
> Because the mapping to the page is owned by a block device not a filesystem 
> (ext3).
> 
> If the mapping is owned by a block device, try_to_release_page() calls 
> try_to_free_buffers(). It can release generic bh, but cannot release the bh 
> which is referring by the jh. Because the reference counter of the bh is 
> larger than 0.
> Therefore it is necessary to release the jh before the bh is released.
> 
> To achieve it, I added a new member function into buffer head structure.
> The function releases the bh which correspond to a page whose mapping
> is block device. And the release target of the bh has private data 
> (journal head).
> The function resembles journal_try_to_free_buffers().
> Then I changed try_to_release_page(), which calls try_to_free_buffers()
> after the new function.
> 
> As a result, I think it becomes difficult for oom-killer to happen 
> than before because try_to_free_buffers() via try_to_release_page() 
> which is called when the system memory is exhausted can release bh-s. 
> 

OK.

> ---
>  fs/buffer.c                 |   23 ++++++++++++++++++++++-
>  fs/jbd/journal.c            |    7 +++++++
>  fs/jbd/transaction.c        |   39 +++++++++++++++++++++++++++++++++++++++
>  include/linux/buffer_head.h |    7 +++++++
>  include/linux/jbd.h         |    1 +
>  5 files changed, 76 insertions(+), 1 deletion(-) 

The patch is fairly complex, and increasing the buffer_head size can be
rather costly.  An alternative might be to implement a shrinker
callback function for the journal_head slab cache.  Did you consider
this?

