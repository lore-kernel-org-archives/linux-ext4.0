From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] ext4: Context support
Date: Mon, 18 Jun 2012 13:42:14 -0400
Message-ID: <20120618174214.GA1506@thunk.org>
References: <1339411562-17100-1-git-send-email-saugata.das@stericsson.com>
 <201206160726.07851.arnd.bergmann@linaro.org>
 <20120616134923.GA12140@thunk.org>
 <201206161741.23900.arnd.bergmann@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Lemberg <Alex.Lemberg@sandisk.com>,
	HYOJIN JEONG <syr.jeong@samsung.com>,
	Saugata Das <saugata.das@linaro.org>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	Saugata Das <saugata.das@stericsson.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mmc@vger.kernel.org, patches@linaro.org, venkat@linaro.org,
	"Luca Porzio (lporzio)" <lporzio@micron.com>
To: Arnd Bergmann <arnd.bergmann@linaro.org>
Return-path: <linux-mmc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201206161741.23900.arnd.bergmann@linaro.org>
Sender: linux-mmc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Jun 16, 2012 at 05:41:23PM +0000, Arnd Bergmann wrote:
> 
> * We cannot read from write-only large-unit context, so we have to
>   do one of these:
>    a) ensure we never drop any pages from page-cache between writing
>       them to the large context and closing that context
>    b) if we need to read some data that we have just written to the
>       large-unit context, close that context and open a new rw-context
>       without the large-unit flag set (or write in the default context)

If we ever a read on the inode in question, we close the large-unit
context.  That's the simplest thing to do, since we then don't need to
track which blocks had been written from the inode.  And in general,
if you have a random read/write workload, large-unit contexts probably
won't help you.  We mainly would need this when the workload is doing
large sequential writes, which is *easy* to optimize for.

> * All writes to the large-unit context have to be done in superpage
>   size, which means something between 8 and 32 kb typically, so more
>   than the underlying fs block size

Right, so we only enable the large-unit context when we are in
ext4_da_writepages() and we can do the first write in a way that meets
the requirements (i.e., the write starts aligned on the erase block,
and is a multiple of the superpage size).  The moment we need to do a
read (see above) or a write which doesn't meet the large-unit
restrictions, we close the large-unit context.

(This is why I asked the question about whether there are performance
penalties for opening and closing contexts.  If it requires flushing
the NCQ queues, ala the trim request, then we might need to be more
careful.)

> * We can only start the large unit at the start of an erase block. If
>   we unmount the drive and later continue writing, it has to continue
>   without the large-unit flag at first until we hit an erase block
>   boundary.

My assumption was that when you umount the drive, the file system
would close all of the contexts.

> * If we run out of contexts in the block device, we might have to
>   close a large-unit context before getting to the end of it.

Yep.

> My impression was always that the high-end storage folks try to make
> everything behave nicely whatever the access patterns are, and they
> can do it because an SSD controllers has vast amounts of cache (megabytes,
> not kilobytes) and processing power (e.g. 1Ghz ARMv5 instead of 50 Mhz
> 8051) to handle it, and they also make use of tagged command queuing to
> let the device have multiple outstanding requests.

Well, the high-end stoarge folks still would need to know if a set of
blocks being written are related.  The large-unit contexts might not
matter as much, but knowing that a set of writes *are* related is
something that would help them.

					- Ted
