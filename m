From: Waiman Long <waiman.long@hpe.com>
Subject: Re: [PATCH v3 1/2] ext4: Pass in DIO_SKIP_DIO_COUNT flag if inode_dio_begin()
 called
Date: Thu, 14 Apr 2016 12:21:13 -0400
Message-ID: <570FC379.7000107@hpe.com>
References: <1460484775-33359-1-git-send-email-Waiman.Long@hpe.com> <1460484775-33359-2-git-send-email-Waiman.Long@hpe.com> <20160414031634.GJ10643@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	<linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
	Scott J Norton <scott.norton@hpe.com>,
	Douglas Hatch <doug.hatch@hpe.com>,
	Toshimitsu Kani <toshi.kani@hpe.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160414031634.GJ10643@dastard>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 04/13/2016 11:16 PM, Dave Chinner wrote:
> On Tue, Apr 12, 2016 at 02:12:54PM -0400, Waiman Long wrote:
>> When performing direct I/O, the current ext4 code does
>> not pass in the DIO_SKIP_DIO_COUNT flag to dax_do_io() or
>> __blockdev_direct_IO() when inode_dio_begin() has, in fact, been
>> called. This causes dax_do_io()/__blockdev_direct_IO() to invoke
>> inode_dio_begin()/inode_dio_end() internally.  This doubling of
>> inode_dio_begin()/inode_dio_end() calls are wasteful.
>>
>> This patch removes the extra internal inode_dio_begin()/inode_dio_end()
>> calls when those calls are being issued by the caller directly. For
>> really fast storage systems like NVDIMM, the removal of the extra
>> inode_dio_begin()/inode_dio_end() can give a meaningful boost to
>> I/O performance.
> Doesn't this break truncate IO serialisation?
>
> i.e. it appears to me that the ext4 use of inode_dio_begin()/
> inode_dio_end() does not cover AIO, where the IO is still in flight
> when submission returns. i.e. the inode_dio_end() call
> needs to be in IO completion, not in the submitter context. The only
> reason it doesn't break right now is that the duplicate accounting
> in the DIO code is correct w.r.t. AIO. Hence bypassing the DIO
> accounting will cause AIO writes to race with truncate.
>
> Same AIO vs truncate problem occurs with the indirect read case you
> modified to skip the direct IO layer accounting.

I don't quite understand how the duplicate accounting is correct wrt 
AIO. Both the direct and indirect paths are something like:

     inode_dio_begin()
     ...
         inode_dio_begin()
         ...
         inode_dio_end()
     ...
     inode_dio_end()

What the patch does is to eliminate the innermost inode_dio_begin/end 
pair. Unless there is a difference between a dio count of 2 vs. 1, I 
can't see how the code correctness differ with and without my patch.

Cheers,
Longman
