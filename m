From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [PATCH 1/8] far: remove i_alloc_sem abuse
Date: Wed, 22 Jun 2011 01:09:29 +0900
Message-ID: <87boxrmaiu.fsf@devron.myhome.or.jp>
References: <20110620201533.847236272@bombadil.infradead.org>
	<20110620202030.577464178@bombadil.infradead.org>
	<87fwn3mb2g.fsf@devron.myhome.or.jp>
Mime-Version: 1.0
Content-Type: text/plain
Cc: viro@zeniv.linux.org.uk, tglx@linutronix.de,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <87fwn3mb2g.fsf@devron.myhome.or.jp> (OGAWA Hirofumi's message of
	"Wed, 22 Jun 2011 00:57:43 +0900")
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:

> Christoph Hellwig <hch@infradead.org> writes:
>
>> Add a new rw_semaphore to protect bmap against truncate.  Previous
>> i_alloc_sem was abused for this, but it's going away in this series.
>
> In FAT case, ->i_mutex was better. But, last time I saw, shmfs was using
> ->i_mutex to call ->bmap. So, this was chosen instead.
>
> I'm not checking current version yet though, if shmfs had change, we can
> use ->i_mutex.

It was swapfile. And unfortunately it doesn't have change.

> BTW, this patch looks good to me.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
