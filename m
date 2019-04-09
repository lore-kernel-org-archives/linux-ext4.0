Return-Path: <SRS0=i6rR=SL=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 886ABC10F0E
	for <linux-ext4@archiver.kernel.org>; Tue,  9 Apr 2019 16:06:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 629512084C
	for <linux-ext4@archiver.kernel.org>; Tue,  9 Apr 2019 16:06:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbfDIQGc (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 9 Apr 2019 12:06:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:58176 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726558AbfDIQGb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 9 Apr 2019 12:06:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 32DB2B08C;
        Tue,  9 Apr 2019 16:06:29 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 768941E429B; Tue,  9 Apr 2019 18:06:28 +0200 (CEST)
Date:   Tue, 9 Apr 2019 18:06:28 +0200
From:   Jan Kara <jack@suse.cz>
To:     "zhangxiaoxu (A)" <zhangxiaoxu5@huawei.com>
Cc:     Jan Kara <jack@suse.cz>, viro@zeniv.linux.org.uk, tytso@mit.edu,
        adilger.kernel@dilger.ca, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        yi.zhang@huawei.com
Subject: Re: [PATCH] fs/buffer.c: Fix data corruption when buffer write with
 IO error
Message-ID: <20190409160628.GE1426@quack2.suse.cz>
References: <1554534793-31444-1-git-send-email-zhangxiaoxu5@huawei.com>
 <20190408111108.GB18662@quack2.suse.cz>
 <cdc7faed-20a0-4024-9405-ab74d7d18ab8@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cdc7faed-20a0-4024-9405-ab74d7d18ab8@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue 09-04-19 21:11:22, zhangxiaoxu (A) wrote:
> 
> 
> On 4/8/2019 7:11 PM, Jan Kara wrote:
> > On Sat 06-04-19 15:13:13, ZhangXiaoxu wrote:
> > > When the buffer write failed, 'end_buffer_write_sync' and
> > > 'end_buffer_async_write' will clear the uptodate flag. But the
> > > data in the buffer maybe newer than disk. In some case, this
> > > will lead data corruption.
> > > 
> > > For example: ext4 flush metadata to disk failed, it will clear
> > > the uptodate flag. when a new coming call want the buffer, it will
> > > read it from the disk(because the buffer no uptodate flag). But
> > > the journal not checkpoint now, it will read old data from disk.
> > > If read successfully, ext4 will write the old data to the new
> > > journal, the data will corruption.
> > > 
> > > So, don't clear the uptodate flag when write the buffer failed.
> > > 
> > > Signed-off-by: ZhangXiaoxu<zhangxiaoxu5@huawei.com>
> > Thanks for the patch. But what are the chances that after the write has
> > failed the read will succeed? Also there were places that were using
> > buffer_uptodate() to detect IO errors. Did you check all those got
> > converted to using buffer_write_io_error() instead?
> > 
> > 								Honza
> > 
> I encountered this situation when using iscsi target as the ext4 volume,
> if the network down a while when ext4 write metadata to disk, and maybe
> read will success after the network recovered.

OK, but then you are running in errors=continue mode, aren't you? Because
otherwise the filesystem would get remounted read-only or panic the system
on the first metadata IO error.

> In my testcase, just create and delete files, when disconnect the network,
> the dir entry maybe corruption. I add some logs when read entry buffer from
> disk, the buffer stats maybe buffer_write_io_error() and !buffer_uptodate().
> In this case, the ext4 will corruption high probability. Because the buffer
> is read from disk, and some newer information just on journal. In this case,
> we should not read buffer from the disk.

Well, this never worked reliably (e.g. the buffer may get evicted due to
memory pressure after IO error) and never was promised to work. Once you
hit the first metadata error, all bets are off, you have to unmount the
filesystem and run fsck. Sure the damage would be likely smaller if we kept
the buffer uptodate in your case but it isn't guaranteed the filesystem
will not get corrupted. But as I said, changing this is not just a matter
of deleting those two clear_buffer_uptodate() calls...

> I don't know any other filesystem how to use the uptodate flag. But I think
> uptodate means the buffer is valid and newer than disk, am I right?

Yes, uptodate means the buffer is valid and newer than disk. However after
IO error, it isn't clear what the actual disk state is. But generally I'm
not opposed to the change you suggest, just it means you have to first go
and check all filesystems using buffer heads and verify that none of them
uses buffer_uptodate() check to detect buffer write failure.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
