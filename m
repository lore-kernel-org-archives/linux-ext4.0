From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC][PATCH 0/3] Extent base online defrag
Date: Thu, 09 Nov 2006 07:46:32 -0500
Message-ID: <45532328.70302@garzik.org>
References: <20061109200950sho@rifu.tnes.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: sho@tnes.nec.co.jp
In-Reply-To: <20061109200950sho@rifu.tnes.nec.co.jp>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

sho@tnes.nec.co.jp wrote:
> Hi,
> 
>> I am considering the online defrag function for ext4 and thinking
>> that your following patch set for multi-block allocation is useful
>> to search contiguous free blocks for the defragmentation.
>>
>> "[RFC] extents,mballoc,delalloc for 2.6.16.8"
>> http://marc.theaimsgroup.com/?l=linux-ext4&m=114669168616780&w=2
>>
>> I will send the patch of simple defrag implementation for ext4 later.
> 
> I have written the patches of ioctl for extent base online defragment
> and the command which call it.
> These patches are at the experimental stage so they need many
> improvements.  But they work well so far as basic defragmenter,
> which means they are worth enough to examine my trial.
> 
> - Specify the target area in a file using the following structure:
>   struct ext3_ext_defrag_data {
> 	  loff_t start_offset; /* start offset to defrag in bytes */
> 	  loff_t defrag_size;  /* size of defrag in bytes */
>   }
>   It uses loff_t so that the size of the structure is identical on
>   both 32 bits and 64 bits architecture.
>   Block allocation, including searching for the free contiguous
>   blocks, is implemented in kernel.

NAK the ioctl approach.

People who like ioctls are just holdovers from non-Linux OS's.

	Jeff



