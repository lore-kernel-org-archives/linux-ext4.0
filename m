From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC 4/5] MMC: Adjust unaligned write accesses.
Date: Mon, 21 Mar 2011 19:03:09 +0100
Message-ID: <C0A67981-AF1A-40FF-91BA-93ECF6F72B58@dilger.ca>
References: <1299718449-15172-1-git-send-email-andreiw@motorola.com> <AANLkTimV-no9Wk4wbS4gQGdSgq-2L=ims6SXDFrdEZAe@mail.gmail.com> <AANLkTinEQEwa2SqEwTnbe3kcYuDoM-ZbzWE7X+V3B+zV@mail.gmail.com> <201103211521.34322.arnd@arndb.de> <AANLkTik0DkQa7NrGbpSVVAkhQ4O9+kenPSr2dP=+Ej94@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Arnd Bergmann <arnd@arndb.de>, linux-mmc@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Andrei Warkentin <andreiw@motorola.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:16805 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab1CUSDQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Mar 2011 14:03:16 -0400
In-Reply-To: <AANLkTik0DkQa7NrGbpSVVAkhQ4O9+kenPSr2dP=+Ej94@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-03-21, at 3:41 PM, Andrei Warkentin wrote:
> On Mon, Mar 21, 2011 at 9:21 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>>> Attached file (I hope you don't mind PDFs) contains data collected for
>>> two possible optimizations. The second page of the document tests the
>>> vendor suggested optimization that is basically -
>>> if (request_blocks < 24) {
>>>    /* given request offset, calculate sectors remaining on 8K page
>>> containing offset */
>>>    sectors = 16 - (request_offset % 16);
>>>    if (request_blocks > sectors) {
>>>       request_blocks = sectors;
>>>    }
>>> }
>>> ...I'll call this optimization A.
>>> 
>>> ...the first page of the document tests the optimization that floated
>>> up on the list when I first sent a patch with the vendor suggestions.
>>> That optimization being - align all unaligned accesses (either all
>>> completely, or under a certain size threshold) on flash page size.
>>> I'll call this optimization B.
>> 
>> I'm not sure if I really understand the difference between the two.
>> Do you mean optimization A makes sure that you don't have partial
>> pages at the start of a request, while optimization B also splits
>> small requests on page boundary if the first page in it is aligned?
> 
> The vendor optimization always splits accesses under 12k, even if they
> are aligned. There are (still) some outstanding questions
> on how that's supposed to work (to improve anything), but that's the algorithm.
> 
> "our" optimization, suggested on this list, was to align accesses onto
> flash page size, thus splitting each request into (small) unaligned
> and aligned portions.

Note that mballoc was specifically designed to handle allocation requests that are aligned on RAID stripe boundaries, so it should be able to handle this for MMC as well.  What is needed is to tell the filesystem what the underlying alignment is.  That can be done at format time with mke2fs or afterward with tune2fs by using the "-E stripe_width" option.

>>> To test, a collect time info for 2000 small inserts into a table with
>>> sqlite into 20 separate tables. So that's 20 x 2000 sqlite inserts per
>>> test. The test is executed for ext2, ext3 and ext4 with a 4k block
>>> size. Every test begins with a flash discard and format operation on
>>> the partition where the tables are created and accessed, to ensure
>>> similar acceses to flash on every test. All other partitions are RO,
>>> and no processes other than those needed by the tests run. All power
>>> management is disabled. The results are thus repeatable, consistent
>>> and stable across reboots and power-on time...
>>> 
>>> Each test consists of:
>>> 1) Unmount partition
>>> 2) Flash erase
>>> 3) Format with fs
>>> 4) Mount
>>> 5) Sync
>>> 6) echo 3 > /proc/sys/vm/drop_caches
>>> 7) run 20 x 2000 inserts as described above
>>> 8) unmount
>> 
>> Just to make sure: Did you properly align the partition start on an
>> erase block boundary of 4MB?
>> 
> 
> Yes, absolutely.
> 
>> I would have loved to see results with nilfs2 and btrfs as well, but
>> I can understand that these were less relevant to you, especially
>> since you don't really want to compare the file systems as much as
>> your own changes.
>> 
> 
> In the context of looking at this anyway, I will try and get
> comparison data for sqlite on different fs (and different fs tunables)
> on flash.
> 
>> One very surprising result to me is how much worse the ext4 numbers
>> are compared to ext2/ext3. I would have guessed that they should
>> be much better, given that the ext4 developers are specifically
>> trying to optimize for this case. I've taken the ext4 mailing
>> list on Cc here and will forward your test results there as
>> well.
> 
> I was surprised too.
> 
>> One potential flaw in the measurement might be that running the test
>> a second time means that the card is already in a state that requires
>> garbage collection and therefore slower. Running the test in the opposite
>> order (optimized first, then unoptimized) might theoretically lead
>> to other results. It's not clear from your description whether your
>> test method has taken this into account (I would assume yes).
>> 
> 
> I've done tests across reboots that showed consistent results.
> Additionally, repeating a test after another showed same results. At
> least on this flash medium, block erase (used erase utility from
> flashbench, modified to erase everything if no argument provided)
> prior to formatting with fs prior to every test seemed to make results
> consistent.
> 
>>> So I guess that hexes the align optimization, at least until I can get
>>> data for MMC16G with the same controlled setup. Sorry about that. I'll
>>> work on the "reliability optimization" now, which I guess are pretty
>>> generic for cards with similar buffer schemes. It relies on reliable
>>> writes, so exposing that will be first for review here...
>>> 
>>> Even though I'm rescinding the adjust/align patch, is there any chance
>>> for pulling in my quirks changes?
>> 
>> The quirks patch still looks fine to me, I'd just recommend that we
>> don't apply it before we have a need for it, i.e. at least a single
>> card specific quirk.
>> 
> 
> Ok. Sounds good. Back to reliable writes it is, so I can roll up the
> second quirk...
> 
> A
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





