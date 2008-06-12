From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: Re: [PATCH 1/5] jbd: strictly check for write errors on data	buffers
Date: Thu, 12 Jun 2008 22:19:37 +0900
Message-ID: <48512269.70504@hitachi.com>
References: <20080604111911.c1fe09c6.akpm@linux-foundation.org>
    <20080604212202.GA8727@mit.edu>
    <20080604145848.e3da6f20.akpm@linux-foundation.org>
    <20080604225155.GB8727@mit.edu> <20080605093536.GE27370@duck.suse.cz>
    <4847CF07.1020904@hitachi.com> <20080605142948.GA25477@mit.edu>
    <20080605092006.ba7dceef.akpm@linux-foundation.org>
    <20080605184941.GX2961@webber.adilger.int> <484D0155.4040701@hitachi.com>
    <20080611123556.GA8121@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Theodore Tso <tytso@mit.edu>, sct@redhat.com,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jbacik@redhat.com, cmm@us.ibm.com, yumiko.sugita.yf@hitachi.com,
	satoshi.oshima.fk@hitachi.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail7.hitachi.co.jp ([133.145.228.42]:44365 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759827AbYFLNTy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jun 2008 09:19:54 -0400
In-Reply-To: <20080611123556.GA8121@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Jan Kara wrote:

> On Mon 09-06-08 19:09:25, Hidehiro Kawai wrote:

>>Index: linux-2.6.26-rc4/fs/jbd/commit.c
>>===================================================================
>>--- linux-2.6.26-rc4.orig/fs/jbd/commit.c
>>+++ linux-2.6.26-rc4/fs/jbd/commit.c
>>@@ -432,8 +432,11 @@ void journal_commit_transaction(journal_
>> 			wait_on_buffer(bh);
>> 			spin_lock(&journal->j_list_lock);
>> 		}
>>-		if (unlikely(!buffer_uptodate(bh)))
>>+		if (unlikely(!buffer_uptodate(bh))) {
>>+			set_bit(AS_EIO, &bh->b_page->mapping->flags);
>>+			SetPageError(bh->b_page);
>> 			err = -EIO;
>>+		}
> 
>   Actually, you should be more careful here because if the data buffer has
> been truncated in the currently running transaction, it can happen that
> b_page->mapping is NULL. It is a question how to safely access
> page->mapping - probably you'll need page lock for that...

Thank you for pointing out this problem.  I confirmed that
b_page->mapping can be NULL.  I'm making sure that the locking page
approach works out well.

Thanks,
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center

