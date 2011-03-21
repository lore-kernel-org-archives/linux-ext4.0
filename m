From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [RFC 4/5] MMC: Adjust unaligned write accesses.
Date: Tue, 22 Mar 2011 00:45:34 +0100
Message-ID: <8E9828F3-7533-4DC7-B2D1-EDFBF11BFCFD@whamcloud.com>
References: <201103211527.45726.arnd@arndb.de>
Mime-Version: 1.0 (iPhone Mail 8F190)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Andrei Warkentin <andreiw@motorola.com>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62925 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab1CVHEt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Mar 2011 03:04:49 -0400
Received: by wya21 with SMTP id 21so6432066wya.19
        for <linux-ext4@vger.kernel.org>; Tue, 22 Mar 2011 00:04:48 -0700 (PDT)
In-Reply-To: <201103211527.45726.arnd@arndb.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I was just looking at the test data. I wonder of this slowness might also be due to sync on ext4 using a barrier, and not on ext2/3?

Cheers, Andreas

On 2011-03-21, at 3:27 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> Hi ext4 developers,
> 
> Andrei has been experimenting with optimizations in the mmc layer for
> specific eMMC media. The test results so far show not much success, but
> I was rather surprised that ext4 performs worse than ext3 on this
> drive and test case.
> 
> I would have expected that with support for delayed allocation and
> trim, it should be better.
> 
>   Arnd
> 
> ----------  Forwarded Message  ----------
> 
> Subject: Re: [RFC 4/5] MMC: Adjust unaligned write accesses.
> Date: Saturday 19 March 2011
> From: Andrei Warkentin <andreiw@motorola.com>
> To: Arnd Bergmann <arnd@arndb.de>
> CC: linux-mmc@vger.kernel.org
> 
> Hi Arnd, all...
> 
> On Mon, Mar 14, 2011 at 2:40 AM, Andrei Warkentin <andreiw@motorola.com> wrote:
> 
>>>> 
>>>> Revalidating the data now, along with some more tests, to get a better
>>>> picture. It seems the more data I get, the less it makes sense :(.
>>> 
>>> I was already fearing that the change would only benefit low-level
>>> benchmarks. It certainly helps writing small chunks to the buffer
>>> that is meant for FAT32 directories, but at some point, the card
>>> will have to write back the entire logical erase block, so you
>>> might not be able to gain much in real-world workloads.
>>> 
>> 
> 
> Attaching is some data I have collected  on the MMC32G part. I tried
> to make the collection process as controlled as possible, as well as
> use more-or-less a "real life" usage case that involves running a user
> application, so it's not just a purely synthetic test at block level.
> 
> Attached file (I hope you don't mind PDFs) contains data collected for
> two possible optimizations. The second page of the document tests the
> vendor suggested optimization that is basically -
> if (request_blocks < 24) {
>    /* given request offset, calculate sectors remaining on 8K page
> containing offset */
>    sectors = 16 - (request_offset % 16);
>    if (request_blocks > sectors) {
>       request_blocks = sectors;
>    }
> }
> ...I'll call this optimization A.
> 
> ...the first page of the document tests the optimization that floated
> up on the list when I first sent a patch with the vendor suggestions.
> That optimization being - align all unaligned accesses (either all
> completely, or under a certain size threshold) on flash page size.
> I'll call this optimization B.
> 
> To test, a collect time info for 2000 small inserts into a table with
> sqlite into 20 separate tables. So that's 20 x 2000 sqlite inserts per
> test. The test is executed for ext2, ext3 and ext4 with a 4k block
> size. Every test begins with a flash discard and format operation on
> the partition where the tables are created and accessed, to ensure
> similar acceses to flash on every test. All other partitions are RO,
> and no processes other than those needed by the tests run. All power
> management is disabled. The results are thus repeatable, consistent
> and stable across reboots and power-on time...
> 
> Each test consists of:
> 1) Unmount partition
> 2) Flash erase
> 3) Format with fs
> 4) Mount
> 5) Sync
> 6) echo 3 > /proc/sys/vm/drop_caches
> 7) run 20 x 2000 inserts as described above
> 8) unmount
> 
> For optimization B testing, the alignment size and alignment access
> size threshold (same parameters as in my RFC patch) are exposed
> through debugfs. To get B test data, the flow was
> 
> 1) Set alignment to none (no optimization)
> 2) Sql test on ext2
> 3) Sql test on ext3
> 4) Sql test on ext4
> 
> 6) Set alignment to 8k, no threshold
> 7) Sql test on ext2
> 8) Sql test on ext3
> 9) Sql test on ext4
> 
> 10) Set alignment to 8k, < 8k only
> 11) Sql test on ext2
> 12) Sql test on ext3
> 13) Sql test on ext4
> 
> ...all the way up to 32K threshold.
> 
> For optimization A testing, the optimization was turned off/on with a
> debugfs attribute, and the data collected with this flow:
> 
> 1) Turn off optimization
> 2) Sql test on ext2
> 3) Sql test on ext3
> 4) Sql test on ext4
> 5) Turn on optimization
> 6) Sql test on ext2
> 7) Sql test on ext3
> 8) Sql test on ext4
> 
> My interpretation of the results: Any kind of alignment-on-flash page
> optimization produced data that in all cases was either
> indistinguishable from control, or was worse. Do you agree with my
> interpretation?
> 
> So I guess that hexes the align optimization, at least until I can get
> data for MMC16G with the same controlled setup. Sorry about that. I'll
> work on the "reliability optimization" now, which I guess are pretty
> generic for cards with similar buffer schemes. It relies on reliable
> writes, so exposing that will be first for review here...
> 
> Even though I'm rescinding the adjust/align patch, is there any chance
> for pulling in my quirks changes?
> 
> Thanks,
> A
> 
> -------------------------------------------------------
> <flash data MMC32G.pdf>

