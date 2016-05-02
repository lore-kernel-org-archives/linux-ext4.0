From: Waiman Long <waiman.long@hpe.com>
Subject: Re: [PATCH v5 0/2] ext4: Improve parallel I/O performance on NVDIMM
Date: Mon, 2 May 2016 13:45:08 -0400
Message-ID: <57279224.7030702@hpe.com>
References: <1461947276-25988-1-git-send-email-Waiman.Long@hpe.com> <57238DFC.6010108@hpe.com> <20160501172854.GA19601@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@linux.intel.com>,
	<linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Scott J Norton <scott.norton@hpe.com>,
	Douglas Hatch <doug.hatch@hpe.com>,
	Toshimitsu Kani <toshi.kani@hpe.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bl2on0135.outbound.protection.outlook.com ([65.55.169.135]:58712
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753818AbcEBRpU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 May 2016 13:45:20 -0400
In-Reply-To: <20160501172854.GA19601@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/01/2016 01:28 PM, Christoph Hellwig wrote:
> On Fri, Apr 29, 2016 at 12:38:20PM -0400, Waiman Long wrote:
>>  From my testing, it looked like that parallel overwrites to the same file in
>> an ext4 filesystem on DAX can happen in parallel even if their range
>> overlaps. It was mainly because the code will drop the i_mutex before the
>> write. That means the overlapped blocks can get garbage. I think this is a
>> problem, but I am not expert in the ext4 filesystem to say for sure. I would
>> like to know your thought on that.
> That's another issue with dax I/O pretending to be direct I/O..  Because
> it isn't we'll need to synchronize it like buffered I/O and not like
> direct I/O in all file systems.

 From what I saw in the code, I think filemap_write_and_wait_range()
should have prevented concurrent overwrites from stepping on each
other for non-DAX I/O.  However it is essentially a no-op for DAX
I/O and so the protection is gone.

I am planning to send out a patch to disable mutex dropping for DAX
overwrite. There is still an issue on the read side. If journal is
disabled and the dioread_nolock mount option is used, read will done
without locking. Again, the filemap_write_and_wait_range() check on
the read side will not protect against write.

Cheers,
Longman

