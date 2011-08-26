From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [URGENT PATCH] ext4: fix potential deadlock in ext4_evict_inode()
Date: Fri, 26 Aug 2011 07:35:24 -0400
Message-ID: <22BEE903-4141-4D2A-932B-259DF50F14E1@mit.edu>
References: <E1QwnAu-00087H-8X@tytso-glaptop.cam.corp.google.com> <20110826073507.GZ3162@dastard> <20110826084403.GA3162@dastard> <20110826085057.GA13311@infradead.org> <4E57630B.7000202@tao.ma> <20110826091718.GA3179@infradead.org>
Mime-Version: 1.0 (Apple Message framework v1244.3)
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Tao Ma <tm@tao.ma>, Dave Chinner <david@fromorbit.com>,
	Jiaying Zhang <jiayingz@google.com>, linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:62509 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750897Ab1HZLfa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Aug 2011 07:35:30 -0400
In-Reply-To: <20110826091718.GA3179@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Aug 26, 2011, at 5:17 AM, Christoph Hellwig wrote:

> The thing I have queued up for 3.2 makes it very simple:  we do not
> track I/O ends any more at all, outside of the workqueue.
>=20
> For buffered I/O we only mark the page uptodate when all unwritten
> extent conversion and size updates have finished.  All data integrity
> callers and inode eviction wait for the pages to be update so we are
> covered.
>=20
> For direct I/O we only call inode_dio_done and aio_complete once all
> unwritten extent size updates are done.  Inodes can't be evicted unti=
l
> we drop a reference to the inode, which can't happen until the
> sync or async dio is done and we drop the inode reference the VFS
> holds for it.  Sync and fsync are only guaranteed to pick up I/O
> that has returned to userspace, so we are covered for that as well.

Long term, I definitely want to make ext4 do something similar.=20
What we have now is just way too fragile=85

-- Ted

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
