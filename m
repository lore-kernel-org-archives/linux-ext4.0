From: "Dilger, Andreas" <andreas.dilger@intel.com>
Subject: Re: [PATCH v2 2/4] ext4: Add XIP functionality
Date: Fri, 6 Dec 2013 20:58:50 +0000
Message-ID: <CEC778F7.84365%andreas.dilger@intel.com>
References: <1386273769-12828-1-git-send-email-ross.zwisler@linux.intel.com>
 <1386273769-12828-3-git-send-email-ross.zwisler@linux.intel.com>
 <20131206031354.GS10988@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"carsteno@de.ibm.com" <carsteno@de.ibm.com>,
	"Wilcox, Matthew R" <matthew.r.wilcox@intel.com>
To: Dave Chinner <david@fromorbit.com>,
	Ross Zwisler <ross.zwisler@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:58093 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754797Ab3LFU6w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Dec 2013 15:58:52 -0500
In-Reply-To: <20131206031354.GS10988@dastard>
Content-Language: en-US
Content-ID: <93C904CA3292754E9844C239940530CD@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013/12/05 8:13 PM, "Dave Chinner" <david@fromorbit.com> wrote:

>On Thu, Dec 05, 2013 at 01:02:46PM -0700, Ross Zwisler wrote:
>> This is a port of the XIP functionality found in the current version of
>> ext2.  This patch set is intended to achieve feature parity with XIP in
>> ext2 rather than non-XIP in ext4.  In particular, it lacks support for
>> splice and AIO.  We'll be submitting patches in the future to add that
>> functionality, but we think this is a good start.
>> 
>> The motivation behind this work is that we believe that the XIP feature
>> will begin to find new uses as various persistent memory devices and
>> technologies come on to the market.  Having direct, byte-addressable
>> access to persistent memory without having an additional copy in the
>> page cache can be a win in terms of I/O latency and overall memory
>> usage.
>> 
>> This patch applies cleanly to v3.13-rc2, and was tested using brd as our
>> block driver.
>
>I think I see a significant problem here with XIP write support:
>unwritten extents.
>
>xip_file_write() has no concept of post IO completion processing -
>it assumes that all that is necessary is to memcpy() the data into
>the backing memory obtained by ->get_xip_mem(), and that's all it
>needs to do.
>
>For ext4 (and other filesystems that use unwritten extents) they
>need a callback - normally done from bio completion - to run
>transactions to convert extent status from unwritten to written, or
>run other post-IO completion operations.
>
>I don't see any hooks into ext4 to turn off preallocation (e.g.
>fallocate is explicitly hooked up for XIP) when XIP is in use, so I
>can't see how XIP can work with such filesystem requirements without
>further infrastructure being added. i.e. bypassing the need for the
>page cache does not remove the need to post-IO completion
>notification to the filesystem...

In the short term (at least until it is possible to convert the extent
after it is modified) should it be an error to try and map an unwritten
extent?  That would still allow the ext4 XIP patch to land and be safely
used for regular files while the mechanism for doing the conversion is
worked out.

>Indeed, for making filesystems like XFS be able to use XIP, we're
>going to need such facilities to be provided by the XIP
>infrastructure....
>
>Cheers,
>
>Dave.
>-- 
>Dave Chinner
>david@fromorbit.com
>


Cheers, Andreas
-- 
Andreas Dilger

Lustre Software Architect
Intel High Performance Data Division


