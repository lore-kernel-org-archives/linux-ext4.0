From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH 3/3] Add timeout feature
Date: Fri, 26 Sep 2008 06:58:11 -0400
Message-ID: <48DCC043.1020207@redhat.com>
References: <20080908205337t-sato@mail.jp.nec.com> <20080908171119.GB22521@infradead.org> <48DBFD42.6030307@redhat.com> <D0B0D91F884647D6808626CDFF81E532@nsl.ad.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oleg Nesterov <oleg@tv-sign.ru>, linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com, viro@ZenIV.linux.org.uk,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com, axboe@kernel.dk,
	mtk.manpages@googlemail.com, linux-kernel@vger.kernel.org
To: Takashi Sato <t-sato@yk.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:34197 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbYIZK62 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Sep 2008 06:58:28 -0400
In-Reply-To: <D0B0D91F884647D6808626CDFF81E532@nsl.ad.nec.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Takashi Sato wrote:
> Hi,
>
> Ric Wheeler wrote:
>> Christoph Hellwig wrote:
>>> On Mon, Sep 08, 2008 at 08:53:37PM +0900, Takashi Sato wrote:
>>>
>>>> The timeout feature is added to "freeze ioctl" to solve a deadlock
>>>> when the freezer accesses a frozen filesystem. And new ioctl
>>>> to reset the timeout period is added to extend the timeout period.
>>>> For example, the freezer resets the timeout period to 10 seconds 
>>>> every 5
>>>> seconds.  In this approach, even if the freezer causes a deadlock by
>>>> accessing the frozen filesystem, it will be solved by the timeout
>>>> in 10 seconds and the freezer will be able to recognize that
>>>> at the next reset of timeout period.
>>>>
>>>
>>> And as with all previous posting I still fundamentally disagree about
>>> the need of this functionality.  We don't need a timeout for freezing.
>>
>> I agree with Christoph here, I think that the timeout is unneeded.
>
> I think that your concern is that the freezer cannot recognize the 
> occurrence
> of a timeout and it continues the backup process and the backup data is
> corrupted finally.
> If the freezer can recognize it by the unfreeze ioctl's errono, will 
> your concern
> be solved?
> If so, I will implement it.
>
> Cheers, Takashi
>
I think that is certainly part a big part of my concern.

Also note that the timeout seems to be quite low relative to say the 
standard timeout for a SCSI device (30 seconds worst case).

In general, I am quite supportive of the patch series and think that 
this is a great addition.

Thanks!

Ric


