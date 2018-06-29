From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 0/1] iomap: Direct I/O for inline data
Date: Fri, 29 Jun 2018 10:43:13 +0200
Message-ID: <20180629084313.GA16042@lst.de>
References: <20180627003906.15571-1-agruenba@redhat.com>
	<CAHc6FU7gJUcaKRr6He8Te0wcMYMQjriwbz58pC-ie1m-WJOw0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cluster-devel <cluster-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
To: Andreas Gruenbacher <agruenba@redhat.com>
Return-path: <cluster-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAHc6FU7gJUcaKRr6He8Te0wcMYMQjriwbz58pC-ie1m-WJOw0g@mail.gmail.com>
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

> A possible fix is to change the alignment check in iomap_dio_actor as follows:
> 
> -       if ((pos | length | align) & ((1 << blkbits) - 1))
> +       if ((pos | align) & ((1 << blkbits) - 1))
> +               return -EINVAL;
> +       if (length & ((1 << blkbits) - 1) &&
> +           pos + length != iomap->offset + iomap->length)
>                 return -EINVAL;
> 
> Moving the alignment check from iomap_dio_actor to iomap_dio_rw isn't
> that easy because iomap->bdev isn't known there.

Just make the check conditional on iomap->type != IOMAP_INLINE
as alignment checks on inline data don't make much sense.
