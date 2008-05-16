From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: Re: [PATCH 2/4] jbd: ordered data integrity fix (rebased)
Date: Fri, 16 May 2008 19:25:44 +0900
Message-ID: <482D6128.6060200@hitachi.com>
References: <482A6E00.6080303@hitachi.com> <482A6F2B.3020605@hitachi.com>
    <20080514131007.GD24363@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>, sct@redhat.com,
	adilger@clusterfs.com, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Josef Bacik <jbacik@redhat.com>,
	Mingming Cao <cmm@us.ibm.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>,
	sugita <yumiko.sugita.yf@hitachi.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail7.hitachi.co.jp ([133.145.228.42]:41303 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941AbYEPKZ4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 May 2008 06:25:56 -0400
In-Reply-To: <20080514131007.GD24363@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Thanks for your comment.

Jan Kara wrote:

> On Wed 14-05-08 13:48:43, Hidehiro Kawai wrote:
> 
>>Subject: [PATCH 2/4] jbd: ordered data integrity fix
>>
>>In ordered mode, if a buffer being dirtied exists in the committing
>>transaction, we write the buffer to the disk, move it from the
>>committing transaction to the running transaction, then dirty it.
>>But we don't have to remove the buffer from the committing
>>transaction when the buffer couldn't be written out, otherwise it
>>breaks the ordered mode rule.
> 
>   Hmm, could you elaborate a bit more what exactly is broken and how does
> this help to fix it? Because even if we find EIO happened on data buffer,
> we currently don't do anything else than just remove the buffer from the
> transaction and abort the journal. And even if we later managed to write
> the data buffer from other process before the journal is aborted, ordered
> mode guarantees are satisfied - we only guarantee that too old data cannot
> be seen, newer can be seen easily... Thanks.

In the case where I stated the above, error checking is postponed to
the next (currently running) transaction because the buffer is removed
from the committing transaction before checked for an error.  This can
happen repeatedly, then the error won't be detected "for a long time".
However, finally the error is detected by, for example,
journal_commit_transaction(), we can abort the journal.  So this
problem is not so serious than the other patches which I sent.

Thanks,

-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center

