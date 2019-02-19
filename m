Return-Path: <SRS0=bqz9=Q2=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49394C43381
	for <linux-ext4@archiver.kernel.org>; Tue, 19 Feb 2019 13:53:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 255372147A
	for <linux-ext4@archiver.kernel.org>; Tue, 19 Feb 2019 13:53:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728298AbfBSNxF (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 19 Feb 2019 08:53:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:57732 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727601AbfBSNxF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 19 Feb 2019 08:53:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 25B7BAF2D;
        Tue, 19 Feb 2019 13:53:03 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 63FC21E1570; Tue, 19 Feb 2019 14:53:02 +0100 (CET)
Date:   Tue, 19 Feb 2019 14:53:02 +0100
From:   Jan Kara <jack@suse.cz>
To:     stummala@codeaurora.org
Cc:     tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: huge fsync latencies for a small file on ext4
Message-ID: <20190219135302.GB27420@quack2.suse.cz>
References: <b1ba05256affe171c2afca6c3aceeb7a@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1ba05256affe171c2afca6c3aceeb7a@codeaurora.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi!

On Tue 19-02-19 15:50:23, stummala@codeaurora.org wrote:
> I am observing huge fsync latencies for a small file under the below test
> scenario -
> 
> process A -
> Issue async write of 4GB using dd command (say large_file) on /data mounted
> with ext4:
> dd if=/dev/zero of=/data/testfile bs=1M count=4096
> 
> process B -
> In parallel another process wrote a small 4KB data to another file
> (say, small_file) and has issued fsync on this file.
> 
> Problem -
> The fsync() on 4KB file, is taking upto ~30sec (worst case latency).
> This is tested on an eMMC based device.
> 
> Observations -
> This happens when the small_file and large_file both are part of the same
> committing transaction or when the small_file is part of the running
> transaction
> while large_file is part of the committing transaction.
> 
> During the commit of a transaction which includes large_file, the jbd2
> thread
> does journal_finish_inode_data_buffers() by calling
> filemap_fdatawait_keep_errors() on the file's inode address space. While
> this is
> happening, if the writeback thread is running in parallel for the
> large_file, then
> filemap_fdatawait_keep_errors() could potentially run in a loop of all the
> pages (upto 4GB of data) and also wait for all the file's data to be written
> to the disk in the current transaction context itself. At the time
> of calling journal_finish_inode_data_buffers(), the file size is of only
> 150MB.
> and by the time filemap_fdatawait_keep_errors() returns, the file size is
> 4GB
> and the page index also points to 4GB file offset in
> __filemap_fdatawait_range(), indicating that is has scanned and waited for
> writeback
> all the pages upto 4GB and not just 150MB.

Thanks for the detailed analysis! I'm somewhat surprised that the flusher
is able to submit new batch of pages for writeback faster than
__filemap_fdatawait_range() is scanning the radix tree but it is certainly
a possibility.

> Ideally, I think the jbd2 thread should have waited for only the amount of
> data
> it has submitted as part of the current transaction and not to wait for the
> on-going pages that are getting tagged for writeback in parallel in another
> context.
> So along these lines, I have tried to use the inode's size at the time of
> calling
> journal_finish_inode_data_buffers() as below -

One has to be really careful when using i_size like this. By the time the
transaction is committing, i_size could have been reduced from the value at
the time page writeback was issued. And that change will be journalled only
in the following transaction. So if the system crashes in the wrong moment,
user could see uninitialized blocks between new_size and old_size after
journal replay. So I don't think your patch is really correct.

Ted has outlined a plan how to get rid of data=ordered limitations [1] and
thus also this problem. It is quite some work but you're certainly welcome
to help out :)

								Honza

[1] https://www.spinics.net/lists/linux-ext4/msg64175.html

> 
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index 2eb55c3..e86cf67 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -261,8 +261,8 @@ static int journal_finish_inode_data_buffers(journal_t
> *journal,
>                         continue;
>                 jinode->i_flags |= JI_COMMIT_RUNNING;
>                 spin_unlock(&journal->j_list_lock);
> -               err = filemap_fdatawait_keep_errors(
> -                               jinode->i_vfs_inode->i_mapping);
> +               err =
> filemap_fdatawait_range(jinode->i_vfs_inode->i_mapping,
> +                               0,
> i_size_read(jinode->i_vfs_inode->i_mapping->host));
>                 if (!ret)
>                         ret = err;
>                 spin_lock(&journal->j_list_lock);
> 
> With this, the fsync latencies for small_file have reduced significantly.
> It took upto max ~5sec (worst case latency).
> 
> Although this is seen in a test code, this could potentially impact the
> phone's performance if any application or main UI thread in Android issues
> fsync() in foreground while a large data transfer is going on in another
> context.
> 
> Request you to share your thoughts and comments on this issue
> and the fix suggested above.
> 
> Thanks,
> Sahitya.
> 
> --
> Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center,
> Inc.
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux
> Foundation Collaborative Project.
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
