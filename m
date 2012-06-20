From: "Luca Porzio (lporzio)" <lporzio@micron.com>
Subject: RE: [PATCH 2/3] ext4: Context support
Date: Wed, 20 Jun 2012 15:09:49 +0000
Message-ID: <26E7A31274623843B0E8CF86148BFE32779D94DD@NTXAVZMBX04.azit.micron.com>
References: <1339411562-17100-1-git-send-email-saugata.das@stericsson.com>
 <201206161741.23900.arnd.bergmann@linaro.org>
 <20120618174214.GA1506@thunk.org>
 <201206191517.26687.arnd.bergmann@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Alex Lemberg <Alex.Lemberg@sandisk.com>,
	HYOJIN JEONG <syr.jeong@samsung.com>,
	Saugata Das <saugata.das@linaro.org>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	Saugata Das <saugata.das@stericsson.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"patches@linaro.org" <patches@linaro.org>,
	"venkat@linaro.org" <venkat@linaro.org>
To: Arnd Bergmann <arnd.bergmann@linaro.org>,
	"Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <201206191517.26687.arnd.bergmann@linaro.org>
Content-Language: en-US
Sender: linux-mmc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

Some feedbacks inlined below.

Moreover some generic comments of mine hereafter.
First of all I agree with a previous comment from Arnd that a FS aware of virtual page / erase block is much better than using contexts especially if this requires low effort by re-using similar concepts as in the scsi stripe example.

My opinion on contexts is:
- A wrong context (context used not in the expected way) can cause much impact on performances than not using it at all
- Fewer contexts are better: eMMC have limited resources. You can expect performance benefit when opening few (3~4) contexts but opening many contexts can be critical.

You can imagine an eMMC like an Observer who tries to dispatch contents based on what "he perceives" as the traffic flow (how much sequential is this data? How much randomic? How much likely is it to be rewritten? etc). ContextIDs are the attempt to move part of the burden from the internal observer to an external observer called FileSystem. 
Given the story above, to give their best I strongly agree that having an open discussion on how to best dispatch the burden between internal and external observer is key to the success of this feature.

Cheers,
   Luca

> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd.bergmann@linaro.org]
> Sent: Tuesday, June 19, 2012 5:17 PM
> To: Ted Ts'o
> Cc: Alex Lemberg; HYOJIN JEONG; Saugata Das; Artem Bityutskiy; Saugata Das;
> linux-ext4@vger.kernel.org; linux-fsdevel@vger.kernel.org; linux-
> mmc@vger.kernel.org; patches@linaro.org; venkat@linaro.org; Luca Porzio
> (lporzio)
> Subject: Re: [PATCH 2/3] ext4: Context support
> 
> On Monday 18 June 2012, Ted Ts'o wrote:
> > On Sat, Jun 16, 2012 at 05:41:23PM +0000, Arnd Bergmann wrote:
> > >
> > > * We cannot read from write-only large-unit context, so we have to
> > >   do one of these:
> > >    a) ensure we never drop any pages from page-cache between writing
> > >       them to the large context and closing that context
> > >    b) if we need to read some data that we have just written to the
> > >       large-unit context, close that context and open a new rw-context
> > >       without the large-unit flag set (or write in the default context)
> >
> > If we ever a read on the inode in question, we close the large-unit
> > context.  That's the simplest thing to do, since we then don't need to
> > track which blocks had been written from the inode.  And in general,
> > if you have a random read/write workload, large-unit contexts probably
> > won't help you.  We mainly would need this when the workload is doing
> > large sequential writes, which is *easy* to optimize for.
> 
> right.
> 

I agree. Also you can open the large unit context in read/write mode so that you don't need to close the context if you just want to read while writing.

Again I would suggest not to use context unless absolutely sure that the context will be used in the right way.
With the latter, I am not worried about the closing cost but more on the performance impact.

> > > * All writes to the large-unit context have to be done in superpage
> > >   size, which means something between 8 and 32 kb typically, so more
> > >   than the underlying fs block size
> >

I would expect even larger numbers than 32KB.

> > Right, so we only enable the large-unit context when we are in
> > ext4_da_writepages() and we can do the first write in a way that meets
> > the requirements (i.e., the write starts aligned on the erase block,
> > and is a multiple of the superpage size).  The moment we need to do a
> > read (see above) or a write which doesn't meet the large-unit
> > restrictions, we close the large-unit context.
> >
> > (This is why I asked the question about whether there are performance
> > penalties for opening and closing contexts.  If it requires flushing
> > the NCQ queues, ala the trim request, then we might need to be more
> > careful.)
> 
> I believe it should only require flushing that one context, although
> a specific hardware implementation might be worse than that. Maybe
> Luca or Alex can comment on this.
> 

That's an interesting question. 
The short answer is that unless we define a use case, it is hard for me to give you meaningful numbers.

> > > * We can only start the large unit at the start of an erase block. If
> > >   we unmount the drive and later continue writing, it has to continue
> > >   without the large-unit flag at first until we hit an erase block
> > >   boundary.
> >
> > My assumption was that when you umount the drive, the file system
> > would close all of the contexts.
> 
> Yes, makes sense. This is probably required to ensure that the data
> has made to the drive, at least for the large contexts, but it is
> definitely required for housekeeping of contexts if we manage them
> from the block layer.
> 

One comment here, large unit contexts (according to spec) are not bounded to erase blocks. They can span one or more blocks, actually they are not related to block size at all (just virtual page size of the device which can be read from the EXT_CSD configuration registers for eMMC).

> 	Arnd
