From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate
 super_operation
Date: Fri, 19 Nov 2010 19:06:16 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1011191853210.3238@dhcp-lab-213.englab.brq.redhat.com>
References: <1290100750.3041.72.camel@mulgrave.site> <x494obe4kd5.fsf@segfault.boston.devel.redhat.com> <1290102098.3041.77.camel@mulgrave.site> <AANLkTim=SkqBehcCvEME7YVHk3S0dLdmBS8ooRF+-BuW@mail.gmail.com> <4CE59E57.2090009@teksavvy.com>
 <yq1r5eiw5os.fsf@sermon.lab.mkp.net> <4CE5C616.7070706@teksavvy.com> <AANLkTikgEeUL2NVLLdoT3RX0r=v0Pzfp9-==F39DVRgN@mail.gmail.com> <20101119115516.GA1152@infradead.org> <AANLkTimQZKLtKpKRUJ-KyCyo29F_Mnws8J54G3CeMkyc@mail.gmail.com>
 <20101119163828.GA8023@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
	Mark Lord <kernel@teksavvy.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	James Bottomley <James.Bottomley@suse.de>,
	Jeff Moyer <jmoyer@redhat.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Josef Bacik <josef@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, sandeen@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755247Ab0KSSGj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Nov 2010 13:06:39 -0500
In-Reply-To: <20101119163828.GA8023@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 19 Nov 2010, Christoph Hellwig wrote:

> On Fri, Nov 19, 2010 at 08:20:58AM -0800, Greg Freemyer wrote:
> > The kernel team has been coding around some Utopian SSD TRIM
> > implementation for at least 2 years with the basic assumption that
> > SSDs can handle thousands of trims per second.  Just mix em in with
> > the rest of the i/o.  No problem.  Intel swore to us its the right
> > thing to do.
> 
> Thanks Greg, good that you told us what we've been doing.  I would have
> forgot myself if you didn't remember me.
> 
> > I'm still waiting to see the first benchmark report from anywhere
> > (SSD, Thin Provisioned SCSI) that the online approach used by mount -o
> > discard is a win performance wise.  Linux has a history of designing
> > for reality, but for some reason when it comes to SSDs reality seems
> > not to be a big concern.
> 
> Both Lukas and I have done extensive benchmarks on various SSDs and
> thinkly provisioned raids.  Unfortunately most of the hardware is only
> available under NDA so we can't publish it.
> 
> For the XFS side which I've looked it I can summarize that we do have
> arrays that do the online discard without measureable performance
> penalty on various workloads, and we have devices (both SSDs and arrays)
> where the overhead is incredibly huge.  I can also say that doing the
> walk of the freespace btrees similar to the offline discard, but every
> 30 seconds or at a similarly high interval is a sure way to completely
> kill performance.
> 
> Or in short we haven't fund the holy grail yet.
> 

Indeed we have not. But speaking of benchmarks I have just finished
quick run (well, not so quick:)) of my discard-kit for btrfs filesystem
and here are results. Note that tool used for this benchmark is
postmark, hence it might not be the realest use-case, but it provides
nice comparison between ext4 (below) and btrfs online discard
implementation (FITRIM is NOT involved).


(Sadly the table is too wide so you have to...well, you guys can manage
it somehow, right?).

BTRFS
-----

                                   |          BUFFERING ENABLED         |       BUFFERING DISABLED           |
--------------------------------------------------------------------------------------------------------------
Type                               |NODISCARD    DISCARD      DIFF      |NODISCARD    DISCARD      DIFF      |
==============================================================================================================
Total_duration                     |230.90       336.20       45.60%    |232.00       335.00       44.40%    |
Duration_of_transactions           |159.60       266.10       66.73%    |158.90       264.60       66.52%    |
Transactions/s                     |313.32       188.01       -39.99%   |314.70       189.07       -39.92%   |
Files_created/s                    |323.84       222.48       -31.30%   |322.28       223.28       -30.72%   |
Creation_alone/s                   |778.08       796.37       2.35%     |756.66       787.68       4.10%     |
Creation_mixed_with_transaction/s  |155.16       93.11        -39.99%   |155.84       93.63        -39.92%   |
Read/s                             |156.50       93.91        -39.99%   |157.18       94.44        -39.92%   |
Append/s                           |156.82       94.10        -39.99%   |157.50       94.63        -39.92%   |
Deleted/s                          |323.84       222.48       -31.30%   |322.28       223.28       -30.72%   |
Deletion_alone/s                   |770.64       788.75       2.35%     |749.42       780.15       4.10%     |
Deletion_mixed_with_transaction/s  |158.16       94.90        -40.00%   |158.85       95.44        -39.92%   |
Read_B/s                           |11925050.90  8192800.35   -31.30%   |11867797.20  8221997.40   -30.72%   |
Write_B/s                          |37318466.00  25638695.00  -31.30%   |37139294.00  25730064.60  -30.72%   |
==============================================================================================================

EXT4
----
                                   |          BUFFERING ENABLED         |       BUFFERING DISABLED           |
--------------------------------------------------------------------------------------------------------------
Type                               |NODISCARD    DISCARD      DIFF      |NODISCARD    DISCARD      DIFF      |
==============================================================================================================
Total_duration                     |306.10       512.70       67.49%    |301.60       516.10       71.12%    |
Duration_of_transactions           |243.50       449.80       84.72%    |239.00       453.90       89.92%    |
Transactions/s                     |205.43       111.19       -45.87%   |209.32       110.17       -47.37%   |
Files_created/s                    |244.30       145.85       -40.30%   |247.97       144.87       -41.58%   |
Creation_alone/s                   |834.88       830.60       -0.51%    |830.60       833.42       0.34%     |
Creation_mixed_with_transaction/s  |101.73       55.06        -45.88%   |103.66       54.55        -47.38%   |
Read/s                             |102.61       55.54        -45.87%   |104.55       55.03        -47.36%   |
Append/s                           |102.82       55.65        -45.88%   |104.76       55.14        -47.37%   |
Deleted/s                          |244.30       145.85       -40.30%   |247.97       144.87       -41.58%   |
Deletion_alone/s                   |826.90       822.66       -0.51%    |822.66       825.46       0.34%     |
Deletion_mixed_with_transaction/s  |103.70       56.13        -45.87%   |105.66       55.61        -47.37%   |
Read_B/s                           |8996110.60   5370694.40   -40.30%   |9131349.20   5334560.40   -41.58%   |
Write_B/s                          |28152588.40  16807146.60  -40.30%   |28575806.40  16694068.00  -41.58%   |
==============================================================================================================


(Buffering means that C library function like fopen, fread, fwrite are
used instead of open, read, write. I have used the word buffering in the
same way as it is used in the postmark test)

So, you can see that Btrfs handles online discard quite better than ext4
(cca 20% difference), but it is still pretty massive performance loss on
not-so-good-but-I-have-seen-worse SSD. So, I would say that you guys
(Josef?) should at least consider the possibility of using FITRIM as well.

Thanks!

-Lukas
