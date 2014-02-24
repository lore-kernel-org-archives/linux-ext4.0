From: Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH v5 2/10] xfs: Add support FALLOC_FL_COLLAPSE_RANGE for fallocate
Date: Mon, 24 Feb 2014 10:12:34 +0900
Message-ID: <CAKYAXd_iesKTqpAH8wPE6HVjNcXBRsor0SzRVbo3Jyr-YiTdPg@mail.gmail.com>
References: <1392741475-20063-1-git-send-email-linkinjeon@gmail.com>
	<20140223212231.GD4317@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: viro@zeniv.linux.org.uk, bpm@sgi.com, tytso@mit.edu,
	adilger.kernel@dilger.ca, jack@suse.cz, mtk.manpages@gmail.com,
	lczerner@redhat.com, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Namjae Jeon <namjae.jeon@samsung.com>,
	Ashish Sangwan <a.sangwan@samsung.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20140223212231.GD4317@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

2014-02-24 6:22 GMT+09:00, Dave Chinner <david@fromorbit.com>:
> On Wed, Feb 19, 2014 at 01:37:55AM +0900, Namjae Jeon wrote:
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> This patch implements fallocate's FALLOC_FL_COLLAPSE_RANGE for XFS.
>>
>> The semantics of this flag are following:
>> 1) It collapses the range lying between offset and length by removing any
>> data
>>    blocks which are present in this range and than updates all the
>> logical
>>    offsets of extents beyond "offset + len" to nullify the hole created
>> by
>>    removing blocks. In short, it does not leave a hole.
>> 2) It should be used exclusively. No other fallocate flag in combination.
>> 3) Offset and length supplied to fallocate should be fs block size
>> aligned
>>    in case of xfs and ext4.
>> 4) Collaspe range does not work beyond i_size.
>>
>> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
>> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> .....
>> +	while (!error && !done) {
>> +		tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
>> +		tp->t_flags |= XFS_TRANS_RESERVE;
>
Hi Dave.
> This probably shouldn't use XFS_TRANS_RESERVE. If we are at ENOSPC,
> then the operation simply fails. Yes, we've already punched the
> hole, so we shouldn't get ENOSPC here, but I don't think it's worth
> dipping into the reserve pool as it has much more important uses...
Okay.
>
> You don' tneed to resent the entire patch for this - I can remove it
> directly myself....
Thanks very much for your help!!
>
> Otherwise it looks good, so consider it
>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>
