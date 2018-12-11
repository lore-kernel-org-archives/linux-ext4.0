Return-Path: <SRS0=J55O=OU=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:39504 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726136AbeLKVys (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 11 Dec 2018 16:54:48 -0500
Date: Wed, 12 Dec 2018 08:54:44 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>, Kanchan Joshi <joshi.k@samsung.com>,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.com,
        viro@zeniv.linux.org.uk, darrick.wong@oracle.com,
        jrdr.linux@gmail.com, ebiggers@google.com,
        jooyoung.hwang@samsung.com, chur.lee@samsung.com,
        prakash.v@samsung.com
Subject: Re: [PATCH 2/2] fs/ext4,jbd2: Add support for passing write-hint
 with journal.
Message-ID: <20181211215444.GA29416@dastard>
References: <1544446204-5291-1-git-send-email-joshi.k@samsung.com>
 <CGME20181210125256epcas1p1e4142cfefb9b21dfb8dad927fbd49143@epcas1p1.samsung.com>
 <1544446204-5291-3-git-send-email-joshi.k@samsung.com>
 <20181210141226.GM29289@quack2.suse.cz>
 <9f693dd1-3c29-cdb4-90cd-83a27e21df4a@kernel.dk>
 <20181210154121.GO29289@quack2.suse.cz>
 <11da6cc1-0276-7842-a036-671241edf6fd@kernel.dk>
 <20181211040714.GF2398@dastard>
 <7b9369de-0539-e862-4778-b35bdc59aaf2@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b9369de-0539-e862-4778-b35bdc59aaf2@kernel.dk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 10, 2018 at 10:07:48PM -0700, Jens Axboe wrote:
> On 12/10/18 9:07 PM, Dave Chinner wrote:
> > On Mon, Dec 10, 2018 at 08:44:32AM -0700, Jens Axboe wrote:
> >> On 12/10/18 8:41 AM, Jan Kara wrote:
> >>> On Mon 10-12-18 08:17:18, Jens Axboe wrote:
> >>>> On 12/10/18 7:12 AM, Jan Kara wrote:
> >>>>> On Mon 10-12-18 18:20:04, Kanchan Joshi wrote:
> >>>>>> This patch introduces "j_writehint" in JBD2 journal,
> >>>>>> which is set based by Ext4 depending on "journal_writehint"
> >>>>>> mount option (inspired from "journal_ioprio").
> >>>>>
> >>>>> Thanks for the patch! It would be good to provide the explanation you have
> >>>>> in the cover letter in this patch as well so that it gets recorded in git
> >>>>> logs.
> >>>>>
> >>>>> Also I don't like the fact that users have to set the hint via a mount
> >>>>> option for this to be enabled. OTOH the WRITE_FILE_<foo> hints defined in
> >>>>> fs.h are generally supposed to be used by userspace so it's difficult to
> >>>>> pick anything if we don't know what the userspace is going to do. I'd argue
> >>>>> it's even difficult for the sysadmin to pick any good value even if he
> >>>>> actually knows that he might benefit from setting some. Jens, is there
> >>>>> some reasonable way for fs to automatically pick some stream value for its
> >>>>> journal?
> >>>>
> >>>> I think we have two options here:
> >>>>
> >>>> 1) It's _probably_ safe to assume that journal data is short lived. While
> >>>>    hints are all relative to the specific use case, the size of the journal
> >>>>    compared to the rest of the drive is most likely very small. Hence a
> >>>>    default of WRITE_LIFE_SHORT is probably a good idea.
> >>>
> >>> That's what I was thinking as well. But there are some exceptions like
> >>> heavy DB load where there's very little of metadata modified (and thus
> >>> almost no journal IO) compared to the DB data. So journal blocks may have
> >>> actually longer life time than data blocks. OTOH if there's little journal
> >>> IO there's no big benefit in specifying a stream for it so WRITE_LIFE_SHORT
> >>> is probably a good default anyway.
> >>
> >> Right, that's my probably, it would definitely not work for all cases. But
> >> it only really fails if two uses of the same life time ends up being vastly
> >> different. It doesn't matter if LIFE_SHORT ends up being the longest life
> >> time of them all.
> >>
> >>>> 2) We add a specific internal life time hint for fs journals.
> >>>>
> >>>> #2 makes the most sense to me, but requires a bit more work...
> >>>
> >>> Yeah, #2 would look more natural to me but I guess it needs some mapping to
> >>> what the drive offers, doesn't it?
> >>
> >> We only used 4 streams, drives generally offer a lot more. So we can expand
> >> it quite easily.
> > 
> > Can we get the number of stream supported from the drive? If we can
> > get at this at mount time, we can use high numbers down for internal
> > filesystem stuff, and low numbers up for user data (as already
> > defined by the fcntl interface).
> > 
> > If the hardware doesn't support streams or doesn't support any more
> > than the userspace interface covers, then it is probably best not to
> > use hints at all for metadata...
> 
> Yes, we query these values. For instance, if we can't get the current
> number of streams we support (4), then we don't use them. We currently
> don't export this anywhere for the kernel to see, but that could be
> rectified. In terms of values, the NVMe stream space is 16-bits, so
> we could allocate from 65535 and down. There are no restrictions on
> ordering, so it'd be perfectly fine to use your suggestion of top down
> for the kernel.

That sounds perfect - right now I can't see a need for more than 4
streams for XFS filesystem metadata (log, directory blocks, inodes,
and internal btree blocks) as all the file data extent tree blocks
whould inherit the data lifetime hint as the two of them are closely
related....

> In terms of hardware support, we assign a number of streams per
> namespace, and there's a fixed number of concurrently open streams per
> drive. We can add reservations, for instance 8, for each namespace.
> That'll give you the 4 user streams, and 4 for the kernel, 65535..65532.

*nod*

That also allows us to extend the "kernel reserved" space in future
if we need to.

How do we find out if the device has the required number of streams
to enable us to use this? Or can we just always set the hint on
filesytem metadata IO and the devices will ignore it if they don't
support it? The latter would be ideal from a filesystem POV - zero
conf and just does the right thing when the hardware supports it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
