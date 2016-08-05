From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/1] mm/block: convert rw_page users to bio op use
Date: Fri, 5 Aug 2016 07:52:54 -0600
Message-ID: <10142950-64f9-4054-55c7-82f0758d2099@kernel.dk>
References: <1470331056-796-1-git-send-email-mchristi@redhat.com>
 <20160805075756.GA28577@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ross.zwisler@linux.intel.com, linux-ext4@vger.kernel.org,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	david@fromorbit.com, minchan@kernel.org, ngupta@vflare.org,
	vishal.l.verma@intel.com
To: Christoph Hellwig <hch@infradead.org>,
	Mike Christie <mchristi@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20160805075756.GA28577@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 08/05/2016 01:57 AM, Christoph Hellwig wrote:
>>
>> The rw_page users were not converted to use bio/req ops. As a result
>> bdev_write_page is not passing down REQ_OP_WRITE and the IOs will
>> be sent down as reads.
>
> Can we just get rid of REQ_OP_WRITE enum for the ->rw_page interface
> and pass a 'bool write'?  If not I'd prefer to avoid using op_is_write
> as much as possible - it's a confusing interface if we really want
> to do a switch on read vs write vs invalid.

That's a really good point, especially since the op_flags was dropped as 
well. I'll cook that up.

-- 
Jens Axboe

