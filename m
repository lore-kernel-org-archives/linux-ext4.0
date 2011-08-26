From: Tao Ma <tm@tao.ma>
Subject: Re: [URGENT PATCH] ext4: fix potential deadlock in ext4_evict_inode()
Date: Fri, 26 Aug 2011 22:53:03 +0800
Message-ID: <4E57B34F.6010508@tao.ma>
References: <E1QwnAu-00087H-8X@tytso-glaptop.cam.corp.google.com> <20110826073507.GZ3162@dastard> <20110826084403.GA3162@dastard> <20110826085057.GA13311@infradead.org> <4E57630B.7000202@tao.ma> <20110826091718.GA3179@infradead.org> <22BEE903-4141-4D2A-932B-259DF50F14E1@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <david@fromorbit.com>,
	Jiaying Zhang <jiayingz@google.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:42728 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751368Ab1HZOxZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Aug 2011 10:53:25 -0400
In-Reply-To: <22BEE903-4141-4D2A-932B-259DF50F14E1@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/26/2011 07:35 PM, Theodore Tso wrote:
>=20
> On Aug 26, 2011, at 5:17 AM, Christoph Hellwig wrote:
>=20
>> The thing I have queued up for 3.2 makes it very simple:  we do not
>> track I/O ends any more at all, outside of the workqueue.
>>
>> For buffered I/O we only mark the page uptodate when all unwritten
>> extent conversion and size updates have finished.  All data integrit=
y
>> callers and inode eviction wait for the pages to be update so we are
>> covered.
>>
>> For direct I/O we only call inode_dio_done and aio_complete once all
>> unwritten extent size updates are done.  Inodes can't be evicted unt=
il
>> we drop a reference to the inode, which can't happen until the
>> sync or async dio is done and we drop the inode reference the VFS
>> holds for it.  Sync and fsync are only guaranteed to pick up I/O
>> that has returned to userspace, so we are covered for that as well.
>=20
> Long term, I definitely want to make ext4 do something similar.=20
> What we have now is just way too fragile=85
yeah, actually I have done some basic tests about letting
ext4_free_io_end to clear the page writeback flag for us after the
unwritten extent conversion, and it does have several problems with bot=
h
ext4 and jbd2. I will try to write up some solution for review.

Thanks
Tao
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
