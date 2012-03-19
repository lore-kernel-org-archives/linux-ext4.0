From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: what happened with dccaf33fa37 "ext4: flush any pending end_io
 requests before DIO" for 3.0?
Date: Mon, 19 Mar 2012 21:21:51 +0400
Message-ID: <4F676B2F.8040209@msgid.tls.msk.ru>
References: <4ED6942F.7070006@msgid.tls.msk.ru> <4F4CBDA1.1080302@msgid.tls.msk.ru> <4F6459F2.8010403@msgid.tls.msk.ru> <20120319164256.GB10561@quack.suse.cz> <CAFgt=MCXRzLx+s1mthr1oD=Pj=HQ5kxnOdbtX8Q9=wSeZ41u2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000905030600020105090507"
Cc: Theodore Tso <tytso@google.com>, gregkh@linuxfoundation.org,
	stable@kernel.org, linux-ext4@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>
To: Jiaying Zhang <jiayingz@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from isrv.corpit.ru ([86.62.121.231]:38910 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162030Ab2CSRVx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Mar 2012 13:21:53 -0400
In-Reply-To: <CAFgt=MCXRzLx+s1mthr1oD=Pj=HQ5kxnOdbtX8Q9=wSeZ41u2w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000905030600020105090507
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

19.03.2012 21:10, Jiaying Zhang wrote:
> On Mon, Mar 19, 2012 at 9:42 AM, Jan Kara<jack@suse.cz>  wrote:
>> On Sat 17-03-12 13:31:30, Michael Tokarev wrote:
>>> Ping?
>>>
>>> Maybe just a one-line reply isn't THAT difficult?
> Sorry for the slow response. I am not sure what happened to this patch.
> Ted, do you know what we need to do to get this patch to the
> stable release?

For reference, attached is the version I use locally since last August.

...
>>>>> There was one more ext4 commit at that time, which made its way into
>>>>> stable but this one did not.
>>>>>
>>>>> I wonder if the reason for that was the fact that it needed a small
>>>>> "backport" for 3.0, since in 3.1+ the code has been moved into another
>>>>> file, and the context is slightly different.  In that case, attached
>>>>> is the "backport" which we use with 3.0.x since that time.

Thanks,

/mjt

--------------000905030600020105090507
Content-Type: text/x-diff;
 name="ext4-flush-any-pending-end_io-requests-before-DIO-reads-w-dioread_nolock-dccaf33fa3.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="ext4-flush-any-pending-end_io-requests-before-DIO-reads-w-di";
 filename*1="oread_nolock-dccaf33fa3.diff"

(backported to 3.0 by mjt)

upstream_commit dccaf33fa37a1bc5d651baeb3bfeb6becb86597b
Author: Jiaying Zhang <jiayingz@google.com>
Date:   Fri Aug 19 19:13:32 2011 -0400

    ext4: flush any pending end_io requests before DIO reads w/dioread_nolock

    There is a race between ext4 buffer write and direct_IO read with
    dioread_nolock mount option enabled. The problem is that we clear
    PageWriteback flag during end_io time but will do
    uninitialized-to-initialized extent conversion later with dioread_nolock.
    If an O_direct read request comes in during this period, ext4 will return
    zero instead of the recently written data.

    This patch checks whether there are any pending uninitialized-to-initialized
    extent conversion requests before doing O_direct read to close the race.
    Note that this is just a bandaid fix. The fundamental issue is that we
    clear PageWriteback flag before we really complete an IO, which is
    problem-prone. To fix the fundamental issue, we may need to implement an
    extent tree cache that we can use to look up pending to-be-converted extents.

    Signed-off-by: Jiaying Zhang <jiayingz@google.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
    Signed-off-by: Michael Tokarev <mjt@tls.msk.ru>
    Cc: stable@kernel.org

diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index b8602cd..0962642 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3507,12 +3507,17 @@ ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
 	}
 
 retry:
-	if (rw == READ && ext4_should_dioread_nolock(inode))
+	if (rw == READ && ext4_should_dioread_nolock(inode)) {
+		if (unlikely(!list_empty(&ei->i_completed_io_list))) {
+			mutex_lock(&inode->i_mutex);
+			ext4_flush_completed_IO(inode);
+			mutex_unlock(&inode->i_mutex);
+		}
 		ret = __blockdev_direct_IO(rw, iocb, inode,
 				 inode->i_sb->s_bdev, iov,
 				 offset, nr_segs,
 				 ext4_get_block, NULL, NULL, 0);
-	else {
+	} else {
 		ret = blockdev_direct_IO(rw, iocb, inode,
				 inode->i_sb->s_bdev, iov,
 				 offset, nr_segs,
 

--------------000905030600020105090507--
