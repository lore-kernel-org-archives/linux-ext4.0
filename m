From: Dave Chinner <david@fromorbit.com>
Subject: Re: HUGE slowdown when doing dpkg with ext4 over nbd
Date: Sat, 10 Dec 2016 08:31:21 +1100
Message-ID: <20161209213121.GP4326@dastard>
References: <1621417488.8583313.1481030030711.JavaMail.zimbra@online.net>
 <78AEFE7B-685B-4B4E-A15E-E3F6D99DD343@dilger.ca>
 <1339224178.8897979.1481104368542.JavaMail.zimbra@online.net>
 <AB04C067-920D-483D-9653-FDCD3AB1B42B@dilger.ca>
 <53212988-1445-45A4-B56F-0F240013B64C@dilger.ca>
 <8760mv4mhi.fsf@turtle.gmx.de>
 <20161209012521.GM4326@dastard>
 <7A0D8B8E-7D71-4281-A7F5-65836412DBDE@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Renaud Mariana <rmariana@online.net>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        debian-dpkg@lists.debian.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:31454 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751214AbcLIVcu (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Dec 2016 16:32:50 -0500
Content-Disposition: inline
In-Reply-To: <7A0D8B8E-7D71-4281-A7F5-65836412DBDE@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 09, 2016 at 01:28:05PM -0700, Andreas Dilger wrote:
> On Dec 8, 2016, at 6:25 PM, Dave Chinner <david@fromorbit.com> wrote:
> > 
> > On Wed, Dec 07, 2016 at 07:34:17PM +0100, Sven Joachim wrote:
> >> On 2016-12-07 11:16 -0700, Andreas Dilger wrote:
> >> 
> >>> Add debian-dpkg mailing list to CC.
> >>> 
> >>> On Dec 7, 2016, at 10:58 AM, Andreas Dilger <adilger@dilger.ca> wrote:
> >>>> 
> >>>> On Dec 7, 2016, at 2:52 AM, Renaud Mariana <rmariana@online.net> wrote:
> >>>>> 
> >>>>> Here are my answers, hope it will help solve this issue, thanks.
> >>>>> 
> >>>>> Recap:
> >>>>> dpkg kibana on ext4 over a nbd device takes 10 minutes
> >>>>> with xfs it's only 30s.
> >>>>> with ext4 no extends only 30s.
> >>>>> 
> >>>>> 
> >>>>> kernels :
> >>>>> 4.5.7 has this issue as older kernel like 4.4.34
> >>>>> The issue is also when nbd client & server run on same host
> >>>>> 
> >>>>> 
> >>>>> How small are the files?
> >>>>> here is the histogram of file sizes : http://pasteboard.co/6HC3nKyk2.png
> >>>>> We can see 5000 files around 512 Bytes.
> >>>> 
> >>>> Definitely there is no value to use fallocate for 512-byte files, or any
> >>>> of the files that can be written in a single write() syscall.  I'd expect
> >>>> any reasonable tool to be using a write buffer of at least 2-4MB these
> >>>> days to get good performance, so writes below the buffer size shouldn't
> >>>> use fallocate() at all.
> >> 
> >> It should be noted that the latest dpkg (1.18.15) only uses fallocate
> >> for files which are at least 16 KiB in size[1], so it would be nice if
> >> Renaud could recheck with that version, or cherry-pick the patch into
> >> whatever version he uses.
> > 
> > The fallocate() call should be removed completely. Applications
> > should not be attempting to control file allocation like this as it
> > defeats all the optimisations that filesystems use to optimise IO
> > patterns and minimise filesystem fragmentation (e.g. delayed
> > allocation).
> > 
> > There is /rarely/ a need for applications to use fallocate() to
> > manage fragmentation - especailly as excessive use of fallocate()
> > actively harms performance and accelerates filesystem aging.
> > 
> > Unless an application has a specific, repeatable performance problem
> > due to file fragmentation, it should not be using fallocate() to
> > allocate file space.
> 
> I'm not sure I'd go so far as to say that fallocate() should be removed
> completely.  Isn't that the best (only) way for an application to tell
> the filesystem that it is about to write a file of X size

That's most definitely not what preallocation is for. Filesystems
optimise the "growing file via sequential writes at EOF" case just
fine - using fallocate for this sort of thing is simply defeats all
the writeback optimisations and improvements we've developed over
the past 20 years for this /very common/ workload...

> and try to
> find a suitable amount of free space for it?

fallocate() does give a guarantee than a subsequent write won't
ENOSPC, but "suitable" is very dependent on context. This contenxt
is something
applications don't have - they have no idea what allocation
optimisations are required to provide fast, efficient IO, and have
no idea that different filesystems will require /different
optimisations/. 

e.g. btrfs will probably also suffer horribly under fallocate usage
like what dpkg is doing, and I can tell you for certain it will make
a mess of XFS filesystems, too....

> Otherwise, if the file
> is large and/or written slowly and/or the system has memory pressure
> the filesystem (even with delalloc) can't make a good decision about
> allocation.

None of which are the case for dpkg. Nor is it the case for /most
applications/. And fallocate actually makes memory pressure
problems worse, because it defeats writeback optimisations to
maximise dirty page cleaning rates...

Preallocation is *not a general purpose tool*. It's for applications
that have performance problems caused by known, repeatable
fragmentation or file layout issue.

> However, fallocate() won't really help if the file size
> is small (e.g. a few MB) since that can easily fit into RAM and will
> be written to disk in a single chunk.

In my experience, the list of "where fallocate is harmful" is quite
a bit larger than the list of "where fallocate is beneficial". This
is just one example of where it's harmful. 

-Dave.
-- 
Dave Chinner
david@fromorbit.com
