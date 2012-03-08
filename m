From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH, RFC] Don't do page stablization if !CONFIG_BLKDEV_INTEGRITY
Date: Wed, 7 Mar 2012 19:21:47 -0800
Message-ID: <4F5825CB.9000100@panasas.com>
References: <E1S5QTU-0005Cc-Kl@tytso-glaptop.cam.corp.google.com> <4F57F523.3020703@redhat.com> <20120308000510.GJ15164@tux1.beaverton.ibm.com> <20120308021853.GK15164@tux1.beaverton.ibm.com> <4F5820BE.2090501@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
	<linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>
To: <djwong@us.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4F5820BE.2090501@panasas.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 03/07/2012 07:00 PM, Boaz Harrosh wrote:
> On 03/07/2012 06:18 PM, Darrick J. Wong wrote:
>> On Wed, Mar 07, 2012 at 04:05:10PM -0800, Darrick J. Wong wrote:
<snip>
>> diff --git a/block/blk-integrity.c b/block/blk-integrity.c
>> index da2a818..f2d51f9 100644
>> --- a/block/blk-integrity.c
>> +++ b/block/blk-integrity.c
>> @@ -420,6 +420,10 @@ int blk_integrity_register(struct gendisk *disk, struct blk_integrity *template)
>>  	} else
>>  		bi->name = bi_unsupported_name;
>>  
>> +#ifdef CONFIG_BLK_DEV_INTEGRITY
> 
> Ooof I feel like a mute.
> 
> No also iscsi data digest needs stable pages. Please remove any reference to
> CONFIG_BLK_DEV_INTEGRITY. It needs to be supported for other
> transport needs. 
> Just make the default off. (Which it is)
> 
> I'll check to see how to add this for iscsi, when data digest is on
> 
> Thanks
> Boaz
> 
>> +	disk->queue->backing_dev_info.state |= (1 << BDI_stable_writes);

Actually I will have an hard time accessing the BDI from the iscsi LLD
Can you please put this flag as part of the topology parameters exported
from a request_queue. And inspect it from there.

It should be a block device property. not a BDI one.

Thanks
Boaz

>> +#endif
>> +
>>  	return 0;
>>  }
>>  EXPORT_SYMBOL(blk_integrity_register);
<snip>

