From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC 4/5] MMC: Adjust unaligned write accesses.
Date: Mon, 21 Mar 2011 15:21:34 +0100
Message-ID: <201103211521.34322.arnd@arndb.de>
References: <1299718449-15172-1-git-send-email-andreiw@motorola.com> <AANLkTimV-no9Wk4wbS4gQGdSgq-2L=ims6SXDFrdEZAe@mail.gmail.com> <AANLkTinEQEwa2SqEwTnbe3kcYuDoM-ZbzWE7X+V3B+zV@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: linux-mmc@vger.kernel.org, linux-ext4@vger.kernel.org
To: Andrei Warkentin <andreiw@motorola.com>
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <AANLkTinEQEwa2SqEwTnbe3kcYuDoM-ZbzWE7X+V3B+zV@mail.gmail.com>
Sender: linux-mmc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Saturday 19 March 2011, Andrei Warkentin wrote:
> On Mon, Mar 14, 2011 at 2:40 AM, Andrei Warkentin <andreiw@motorola.com> wrote:
> 
> >>>
> >>> Revalidating the data now, along with some more tests, to get a better
> >>> picture. It seems the more data I get, the less it makes sense :(.
> >>
> >> I was already fearing that the change would only benefit low-level
> >> benchmarks. It certainly helps writing small chunks to the buffer
> >> that is meant for FAT32 directories, but at some point, the card
> >> will have to write back the entire logical erase block, so you
> >> might not be able to gain much in real-world workloads.
> >>
> >
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
>      /* given request offset, calculate sectors remaining on 8K page
> containing offset */
>      sectors = 16 - (request_offset % 16);
>      if (request_blocks > sectors) {
>         request_blocks = sectors;
>      }
> }
> ...I'll call this optimization A.
> 
> ...the first page of the document tests the optimization that floated
> up on the list when I first sent a patch with the vendor suggestions.
> That optimization being - align all unaligned accesses (either all
> completely, or under a certain size threshold) on flash page size.
> I'll call this optimization B.

I'm not sure if I really understand the difference between the two.
Do you mean optimization A makes sure that you don't have partial
pages at the start of a request, while optimization B also splits
small requests on page boundary if the first page in it is aligned?

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

Just to make sure: Did you properly align the partition start on an
erase block boundary of 4MB?

I would have loved to see results with nilfs2 and btrfs as well, but
I can understand that these were less relevant to you, especially
since you don't really want to compare the file systems as much as
your own changes.

One very surprising result to me is how much worse the ext4 numbers
are compared to ext2/ext3. I would have guessed that they should
be much better, given that the ext4 developers are specifically
trying to optimize for this case. I've taken the ext4 mailing
list on Cc here and will forward your test results there as
well.

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

I suppse when the result is total runtime in seconds, that larger numbers
are always worse, so I agree.

One potential flaw in the measurement might be that running the test
a second time means that the card is already in a state that requires
garbage collection and therefore slower. Running the test in the opposite
order (optimized first, then unoptimized) might theoretically lead
to other results. It's not clear from your description whether your
test method has taken this into account (I would assume yes).

> So I guess that hexes the align optimization, at least until I can get
> data for MMC16G with the same controlled setup. Sorry about that. I'll
> work on the "reliability optimization" now, which I guess are pretty
> generic for cards with similar buffer schemes. It relies on reliable
> writes, so exposing that will be first for review here...
> 
> Even though I'm rescinding the adjust/align patch, is there any chance
> for pulling in my quirks changes?

The quirks patch still looks fine to me, I'd just recommend that we
don't apply it before we have a need for it, i.e. at least a single
card specific quirk.

	Arnd
