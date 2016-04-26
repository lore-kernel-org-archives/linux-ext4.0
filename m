From: Waiman Long <waiman.long@hpe.com>
Subject: Re: [PATCH v3 1/2] ext4: Pass in DIO_SKIP_DIO_COUNT flag if inode_dio_begin()
 called
Date: Tue, 26 Apr 2016 12:32:17 -0400
Message-ID: <571F9811.20305@hpe.com>
References: <1460484775-33359-1-git-send-email-Waiman.Long@hpe.com> <1460484775-33359-2-git-send-email-Waiman.Long@hpe.com> <20160420205801.GA24609@infradead.org> <571918BC.2060007@hpe.com> <20160425114802.GA15856@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160425114802.GA15856@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 04/25/2016 07:48 AM, Christoph Hellwig wrote:
> On Thu, Apr 21, 2016 at 02:15:24PM -0400, Waiman Long wrote:
>> On 04/20/2016 04:58 PM, Christoph Hellwig wrote:
>>> FYI, none of the Dax code even needs to ever touch the dio_count,
>>> as dax I/O can't be asynchronous, and we thus don't need it to protect
>>> against truncate.  I'd suggest to remove it and then end_io callback
>> >from the DAX code entirely as a start and then move from there.
>>
>> Yes, it seems like we may not need to change the dio_count in dax_do_io()
>> after all. BTW, what do mean by using end_io callback as a start?
> I mean to remove both the i_dio_count manipulation, and the unessecary
> end_io callback from dax_do_io.

Thanks for the clarification.

Since DAX I/O is always synchronous, the locking done by the caller or 
in the dax_do_Io() for read should be enough to prevent truncation from 
happening at the same time. So we don't need to use i_dio_count for that 
purpose.

However, I have not understood enough of the block IO layer to determine 
if the end_io callback is really redundant. I am not confident enough to 
touch the end_io callback.

Cheers,
Longman
