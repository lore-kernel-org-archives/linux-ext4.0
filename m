From: Tao Ma <tm@tao.ma>
Subject: Re: ext4 data=writeback performs worse than data=ordered now
Date: Wed, 14 Dec 2011 22:52:00 +0800
Message-ID: <4EE8B810.8040405@tao.ma>
References: <20111214133400.GA18565@localhost> <20111214143014.GB18080@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Ted Ts'o <tytso@mit.edu>, Wu Fengguang <fengguang.wu@intel.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, Li Shaohua <shaohua.li@intel.com>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20111214143014.GB18080@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Ted/Fengguang,
On 12/14/2011 10:30 PM, Ted Ts'o wrote:
> On Wed, Dec 14, 2011 at 09:34:00PM +0800, Wu Fengguang wrote:
>> Hi,
>>
>> Shaohua recently found that ext4 writeback mode could perform worse
>> than ordered mode in some cases. It may not be a big problem, however
>> we'd like to share some information on our findings.
>>
>> I tested both 3.2 and 3.1 kernels on normal SATA disks and USB key.
>> The interesting thing is, data=writeback used to run a bit faster
>> than data=ordered, however situation get inverted presumably by the
>> IO-less dirty throttling.
> 
> Interesting.  What sort of workloads are you using to do these
> measurements?  How many writer threads; I assume you are doing
> sequential writes which are extending one or more files, etc?
> 
> I suspect it's due to the throttling meaning that each thread is
> getting to send less data to the disk, and so there is more seeking
> going on with data=writeback, where as with data=ordered, at each
> journal commit we are forcing all of the dirty pages out to disk, one
> inode at a time, and this is resulting in a more efficient writeback
> compared to when the writeback code is getting to make its own choices
> about how much each inode gets to write out at at time.
> 
> It would be interesting to see what would happen if in
> ext4_da_writepages(), we completely ignore how many pages are
> requested to be written back by the writeback code, and just simply
> write back all of the dirty pages, and see if that brings the
> performance back.
I guess fengguang's test is a buffer write dd test. Here we have found
some performance regression from 18 because of the delayed allocation.
In case of delayed allocation, we will create the extent tree during
writepages which would delay the write because ext4_da_write_begin would
down_read the i_data_sem to map the block while writepages would
down_write it so we have seen some severe delay in ext4_da_write_begin
(around 3s). And instead of increasing the page numbers of every
writepages, some tests shows that the decrease makes the performance
increase. I will dive into it soon to see what's going on there.

So Fengguang, would you please keep the page number in
ext4_da_writepages passed by writeback(instead of the bumping) and check
the result?

Thanks
Tao
