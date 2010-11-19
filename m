From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate
 super_operation
Date: Fri, 19 Nov 2010 11:38:28 -0500
Message-ID: <20101119163828.GA8023@infradead.org>
References: <1290100750.3041.72.camel@mulgrave.site>
 <x494obe4kd5.fsf@segfault.boston.devel.redhat.com>
 <1290102098.3041.77.camel@mulgrave.site>
 <AANLkTim=SkqBehcCvEME7YVHk3S0dLdmBS8ooRF+-BuW@mail.gmail.com>
 <4CE59E57.2090009@teksavvy.com>
 <yq1r5eiw5os.fsf@sermon.lab.mkp.net>
 <4CE5C616.7070706@teksavvy.com>
 <AANLkTikgEeUL2NVLLdoT3RX0r=v0Pzfp9-==F39DVRgN@mail.gmail.com>
 <20101119115516.GA1152@infradead.org>
 <AANLkTimQZKLtKpKRUJ-KyCyo29F_Mnws8J54G3CeMkyc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Mark Lord <kernel@teksavvy.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	James Bottomley <James.Bottomley@suse.de>,
	Jeff Moyer <jmoyer@redhat.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Josef Bacik <josef@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, sandeen@redhat.com
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49521 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab0KSQiq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Nov 2010 11:38:46 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTimQZKLtKpKRUJ-KyCyo29F_Mnws8J54G3CeMkyc@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 19, 2010 at 08:20:58AM -0800, Greg Freemyer wrote:
> The kernel team has been coding around some Utopian SSD TRIM
> implementation for at least 2 years with the basic assumption that
> SSDs can handle thousands of trims per second.  Just mix em in with
> the rest of the i/o.  No problem.  Intel swore to us its the right
> thing to do.

Thanks Greg, good that you told us what we've been doing.  I would have
forgot myself if you didn't remember me.

> I'm still waiting to see the first benchmark report from anywhere
> (SSD, Thin Provisioned SCSI) that the online approach used by mount -o
> discard is a win performance wise.  Linux has a history of designing
> for reality, but for some reason when it comes to SSDs reality seems
> not to be a big concern.

Both Lukas and I have done extensive benchmarks on various SSDs and
thinkly provisioned raids.  Unfortunately most of the hardware is only
available under NDA so we can't publish it.

For the XFS side which I've looked it I can summarize that we do have
arrays that do the online discard without measureable performance
penalty on various workloads, and we have devices (both SSDs and arrays)
where the overhead is incredibly huge.  I can also say that doing the
walk of the freespace btrees similar to the offline discard, but every
30 seconds or at a similarly high interval is a sure way to completely
kill performance.

Or in short we haven't fund the holy grail yet.

