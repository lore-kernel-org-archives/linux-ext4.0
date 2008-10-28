From: "Takashi Sato" <t-sato@yk.jp.nec.com>
Subject: Re: [PATCH 2/3] Implement generic freeze feature
Date: Tue, 28 Oct 2008 21:33:59 +0900
Message-ID: <F69DB5CD5C544C428676CFA36F31FF26@nsl.ad.nec.co.jp>
References: <20081027215855t-sato@mail.jp.nec.com>
	<20081027231533.96c42a78.akpm@linux-foundation.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: axboe@kernel.dk, mtk.manpages@googlemail.com, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>,
	dm-devel@redhat.com, viro@ZenIV.linux.org.uk,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: "Andrew Morton" <akpm@linux-foundation.org>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20081027231533.96c42a78.akpm@linux-foundation.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

Hi,

>> -void thaw_bdev(struct block_device *bdev, struct super_block *sb)
>> +int thaw_bdev(struct block_device *bdev, struct super_block *sb)
>>  {
>> + int error = 0;
>> +
>> + mutex_lock(&bdev->bd_fsfreeze_mutex);
>> + if (!bdev->bd_fsfreeze_count) {
>> + mutex_unlock(&bdev->bd_fsfreeze_mutex);
>> + return -EINVAL;
> 
> This would be a programming error, yes?

This is not a kernel programming error but a user's.
thaw_bdev() is called via the unfreeze ioctl.  If a user calls the unfreeze
ioctl for an unfrozen filesystem, this error will be returned.
So a WARN_ON isn't needed.

> If so, a WARN_ON is more appropriate than a silent runtime error.
> 
>> + }

Cheers, Takashi
