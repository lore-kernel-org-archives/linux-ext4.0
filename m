Return-Path: <SRS0=6H3F=RA=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06EC6C43381
	for <linux-ext4@archiver.kernel.org>; Mon, 25 Feb 2019 05:10:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD6362087C
	for <linux-ext4@archiver.kernel.org>; Mon, 25 Feb 2019 05:10:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="W1T6qA0r";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="GlIhM6pH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbfBYFKR (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 25 Feb 2019 00:10:17 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:58532 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbfBYFKR (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Feb 2019 00:10:17 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 72DD260DB2; Mon, 25 Feb 2019 05:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551071415;
        bh=cTxzJoOMo7yxmvD1a7x2XpnTqx10bHqG55OWqo5jx0E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W1T6qA0rNNLka6W2RNYDAO2f5lMEXVZnyl9xbjSu5++hblRxnPXjYrZpmYsN3AgTB
         A1Lw24YIoKlLfHQXIgmYURGvk77Gc8SYDonpX15c9qmJMqrAkl4vaMMqnuMWQCaKOW
         yjioPtOHSmrD/hXbtXp7iqzr0Be5y17+3VkyZq64=
Received: from codeaurora.org (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: stummala@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6AF1560ADE;
        Mon, 25 Feb 2019 05:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551071413;
        bh=cTxzJoOMo7yxmvD1a7x2XpnTqx10bHqG55OWqo5jx0E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GlIhM6pH2onwlY7Gnm0YXfoI2p73tBblA5/WONs6yy1ZttSZzFKE6lEjSa8IVfWhg
         rYPUB1buuDpB/R+hdhi4sLi6a66bzoFmLJqWJlqqpWiykxkbUy79W+eSXOlLDjGXDN
         9u401fV6l5sr0K6ViBq2UJADKeyZVov5W876ze2k=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6AF1560ADE
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=stummala@codeaurora.org
Date:   Mon, 25 Feb 2019 10:40:07 +0530
From:   Sahitya Tummala <stummala@codeaurora.org>
To:     Jan Kara <jack@suse.cz>
Cc:     tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        stummala@codeaurora.org
Subject: Re: huge fsync latencies for a small file on ext4
Message-ID: <20190225051007.GA32651@codeaurora.org>
References: <b1ba05256affe171c2afca6c3aceeb7a@codeaurora.org>
 <20190219135302.GB27420@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190219135302.GB27420@quack2.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Feb 19, 2019 at 02:53:02PM +0100, Jan Kara wrote:
> Hi!
> 
> On Tue 19-02-19 15:50:23, stummala@codeaurora.org wrote:
> > I am observing huge fsync latencies for a small file under the below test
> > scenario -
> > 
> > process A -
> > Issue async write of 4GB using dd command (say large_file) on /data mounted
> > with ext4:
> > dd if=/dev/zero of=/data/testfile bs=1M count=4096
> > 
> > process B -
> > In parallel another process wrote a small 4KB data to another file
> > (say, small_file) and has issued fsync on this file.
> > 
> > Problem -
> > The fsync() on 4KB file, is taking upto ~30sec (worst case latency).
> > This is tested on an eMMC based device.
> > 
> > Observations -
> > This happens when the small_file and large_file both are part of the same
> > committing transaction or when the small_file is part of the running
> > transaction
> > while large_file is part of the committing transaction.
> > 
> > During the commit of a transaction which includes large_file, the jbd2
> > thread
> > does journal_finish_inode_data_buffers() by calling
> > filemap_fdatawait_keep_errors() on the file's inode address space. While
> > this is
> > happening, if the writeback thread is running in parallel for the
> > large_file, then
> > filemap_fdatawait_keep_errors() could potentially run in a loop of all the
> > pages (upto 4GB of data) and also wait for all the file's data to be written
> > to the disk in the current transaction context itself. At the time
> > of calling journal_finish_inode_data_buffers(), the file size is of only
> > 150MB.
> > and by the time filemap_fdatawait_keep_errors() returns, the file size is
> > 4GB
> > and the page index also points to 4GB file offset in
> > __filemap_fdatawait_range(), indicating that is has scanned and waited for
> > writeback
> > all the pages upto 4GB and not just 150MB.
> 
> Thanks for the detailed analysis! I'm somewhat surprised that the flusher
> is able to submit new batch of pages for writeback faster than
> __filemap_fdatawait_range() is scanning the radix tree but it is certainly
> a possibility.
> 
> > Ideally, I think the jbd2 thread should have waited for only the amount of
> > data
> > it has submitted as part of the current transaction and not to wait for the
> > on-going pages that are getting tagged for writeback in parallel in another
> > context.
> > So along these lines, I have tried to use the inode's size at the time of
> > calling
> > journal_finish_inode_data_buffers() as below -
> 
> One has to be really careful when using i_size like this. By the time the
> transaction is committing, i_size could have been reduced from the value at
> the time page writeback was issued. And that change will be journalled only
> in the following transaction. So if the system crashes in the wrong moment,
> user could see uninitialized blocks between new_size and old_size after
> journal replay. So I don't think your patch is really correct.
> 

Thanks Jan for the clarification on the patch. I agree with your comments.

From that discussion, I think the problem that it is discussing is w.r.t
journal thread waiting for on-going active transaction updates to be done
and thus causing commit latencies. And I think the proposal is to do not
hold any handle while extents are being mapped in ext4_map_blocks() but
defer it till IO is completely done.

And with the new proposal since the inode will be added to
transaction->t_inode_list only after the IO is completed, there will be
no longer the need to do journal_finish_inode_data_buffers() in the journal
context and thus this problem also will not be observed? Is my understanding
correct, please clarify.

> Ted has outlined a plan how to get rid of data=ordered limitations [1] and
> thus also this problem. It is quite some work but you're certainly welcome
> to help out :)
> 
> 								Honza
> 
> [1] https://www.spinics.net/lists/linux-ext4/msg64175.html
> 
> > 
> > diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> > index 2eb55c3..e86cf67 100644
> > --- a/fs/jbd2/commit.c
> > +++ b/fs/jbd2/commit.c
> > @@ -261,8 +261,8 @@ static int journal_finish_inode_data_buffers(journal_t
> > *journal,
> >                         continue;
> >                 jinode->i_flags |= JI_COMMIT_RUNNING;
> >                 spin_unlock(&journal->j_list_lock);
> > -               err = filemap_fdatawait_keep_errors(
> > -                               jinode->i_vfs_inode->i_mapping);
> > +               err =
> > filemap_fdatawait_range(jinode->i_vfs_inode->i_mapping,
> > +                               0,
> > i_size_read(jinode->i_vfs_inode->i_mapping->host));
> >                 if (!ret)
> >                         ret = err;
> >                 spin_lock(&journal->j_list_lock);
> > 
> > With this, the fsync latencies for small_file have reduced significantly.
> > It took upto max ~5sec (worst case latency).
> > 
> > Although this is seen in a test code, this could potentially impact the
> > phone's performance if any application or main UI thread in Android issues
> > fsync() in foreground while a large data transfer is going on in another
> > context.
> > 
> > Request you to share your thoughts and comments on this issue
> > and the fix suggested above.
> > 
> > Thanks,
> > Sahitya.
> > 
> > --
> > Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center,
> > Inc.
> > Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux
> > Foundation Collaborative Project.
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

-- 
--
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
