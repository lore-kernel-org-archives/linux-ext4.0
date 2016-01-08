From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: A blocksize problem about dax and ext4
Date: Fri, 08 Jan 2016 12:22:40 -0500
Message-ID: <x49k2nk0yvz.fsf@segfault.boston.devel.redhat.com>
References: <CAM=YXF-aXxp19=uFDExUswpEfKXNN6LJScxAB-7-u-AgRiXJ2g@mail.gmail.com>
	<CAPcyv4gYHuSWuugnELSO6B1rye+b89io3zJVUXwRt0wE1ZfPrA@mail.gmail.com>
	<94D0CD8314A33A4D9D801C0FE68B40295BEC985F@G9W0745.americas.hpqcorp.net>
	<20151224000021.GU19802@dastard>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "Elliott\, Robert \(Persistent Memory\)" <elliott@hpe.com>,
	Ted Tso <tytso@mit.edu>,
	"linux-nvdimm\@lists.01.org" <linux-nvdimm@ml01.01.org>,
	"linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"xfs\@oss.sgi.com" <xfs@oss.sgi.com>,
	"adilger.kernel\@dilger.ca" <adilger.kernel@dilger.ca>,
	Cholerae Hu <choleraehyq@gmail.com>,
	"linux-ext4\@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151224000021.GU19802@dastard> (Dave Chinner's message of "Thu,
	24 Dec 2015 11:00:21 +1100")
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Dave Chinner <david@fromorbit.com> writes:

>> 1. ext4 fails to mount the filesystem, while xfs just disables DAX.
>> It seems like they should they be the same.

I agree, it would be nice if they were the same.

> I don't really care what is done to ext4 here, but I'm not changing
> XFS behaviour. I'm expecting mixed dax/non-dax fileystems to be a
> thing, with DAX turned on by an inode flag on disk. Indeed, I see
> the mount option going away permanently for XFS, and DAX being
> controlled completely from on-disk flags. E.g. ext4 encrypted files
> need to turn off DAX, while clear text files can be accessed using
> DAX. This should happen completely transparently to the user....

The one thing we definitely need is a common way for an application to
open a file in dax mode.  So, whatever ends up being the interface for
xfs in the future sure as heck better work for ext4.

I'm also not super keen on just getting rid of the dax mount option.  I
understand why you'd want to do that, but I think it should stay, with
documentation on when you simply won't get dax mappings.

Please think about the poor programmers and system administrators that
have to use these interfaces.

Thanks,
Jeff
