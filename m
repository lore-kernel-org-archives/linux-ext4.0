From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH 0/1] iomap: Direct I/O for inline data
Date: Fri, 29 Jun 2018 13:01:48 +0200
Message-ID: <CAHc6FU5yrGCZ+aVxeo9tBxmmQRKs02r2MwE_JMQxQpaZ61PU-w@mail.gmail.com>
References: <20180627003906.15571-1-agruenba@redhat.com>
	<CAHc6FU7gJUcaKRr6He8Te0wcMYMQjriwbz58pC-ie1m-WJOw0g@mail.gmail.com>
	<20180629084313.GA16042@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: cluster-devel <cluster-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Christoph Hellwig <hch@lst.de>
Return-path: <cluster-devel-bounces@redhat.com>
In-Reply-To: <20180629084313.GA16042@lst.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/cluster-devel>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=subscribe>
Sender: cluster-devel-bounces@redhat.com
Errors-To: cluster-devel-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

On 29 June 2018 at 10:43, Christoph Hellwig <hch@lst.de> wrote:
>> A possible fix is to change the alignment check in iomap_dio_actor as follows:
>>
>> -       if ((pos | length | align) & ((1 << blkbits) - 1))
>> +       if ((pos | align) & ((1 << blkbits) - 1))
>> +               return -EINVAL;
>> +       if (length & ((1 << blkbits) - 1) &&
>> +           pos + length != iomap->offset + iomap->length)
>>                 return -EINVAL;
>>
>> Moving the alignment check from iomap_dio_actor to iomap_dio_rw isn't
>> that easy because iomap->bdev isn't known there.
>
> Just make the check conditional on iomap->type != IOMAP_INLINE
> as alignment checks on inline data don't make much sense.

Yeah, probably.

Thanks,
Andreas
