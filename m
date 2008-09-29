From: "Takashi Sato" <t-sato@yk.jp.nec.com>
Subject: Re: [PATCH 3/3] Add timeout feature
Date: Mon, 29 Sep 2008 20:11:41 +0900
Message-ID: <CB0D828755EF47B78DA10F72C80BC436@nsl.ad.nec.co.jp>
References: <20080908205337t-sato@mail.jp.nec.com>
	<20080908171119.GB22521@infradead.org>
	<48DBFD42.6030307@redhat.com>
	<D0B0D91F884647D6808626CDFF81E532@nsl.ad.nec.co.jp>
	<48DCC043.1020207@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="ISO-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: axboe@kernel.dk, mtk.manpages@googlemail.com, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com, dm-devel@redhat.com, viro@ZenIV.linux.org.uk,
	linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>
To: "Ric Wheeler" <rwheeler@redhat.com>,
	"Christoph Hellwig" <hch@infradead.org>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <48DCC043.1020207@redhat.com>
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

Hi Ric and Christoph,

Ric Wheeler wrote:
>>>> And as with all previous posting I still fundamentally disagree about
>>>> the need of this functionality.  We don't need a timeout for freezing.
>>>
>>> I agree with Christoph here, I think that the timeout is unneeded.
>>
>> I think that your concern is that the freezer cannot recognize the occurrence
>> of a timeout and it continues the backup process and the backup data is
>> corrupted finally.
>> If the freezer can recognize it by the unfreeze ioctl's errono, will your concern
>> be solved?
>> If so, I will implement it.
>>
>> Cheers, Takashi
>>
> I think that is certainly part a big part of my concern.
>
> Also note that the timeout seems to be quite low relative to say the standard timeout for a SCSI 
> device (30 seconds worst case).
>
> In general, I am quite supportive of the patch series and think that this is a great addition.

Thank you for your comments.
Christoph, do you have any comments about this solution?

If it's OK, I will change the freeze patch so that the unfreeze ioctl sets
ETIMEDOUT to errno when the timeout occurs.

Cheers, Takashi
