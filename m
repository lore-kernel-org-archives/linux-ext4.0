From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate super_operation
Date: Fri, 19 Nov 2010 08:20:58 -0800
Message-ID: <AANLkTimQZKLtKpKRUJ-KyCyo29F_Mnws8J54G3CeMkyc@mail.gmail.com>
References: <20101118141957.GK6178@parisc-linux.org> <20101118142918.GA18510@infradead.org>
 <1290100750.3041.72.camel@mulgrave.site> <x494obe4kd5.fsf@segfault.boston.devel.redhat.com>
 <1290102098.3041.77.camel@mulgrave.site> <AANLkTim=SkqBehcCvEME7YVHk3S0dLdmBS8ooRF+-BuW@mail.gmail.com>
 <4CE59E57.2090009@teksavvy.com> <yq1r5eiw5os.fsf@sermon.lab.mkp.net>
 <4CE5C616.7070706@teksavvy.com> <AANLkTikgEeUL2NVLLdoT3RX0r=v0Pzfp9-==F39DVRgN@mail.gmail.com>
 <20101119115516.GA1152@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Mark Lord <kernel@teksavvy.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	James Bottomley <James.Bottomley@suse.de>,
	Jeff Moyer <jmoyer@redhat.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Josef Bacik <josef@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, sandeen@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101119115516.GA1152@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Nov 19, 2010 at 3:55 AM, Christoph Hellwig <hch@infradead.org> =
wrote:
> On Thu, Nov 18, 2010 at 05:16:36PM -0800, Greg Freemyer wrote:
>> I agree with Mark. =A0When you say "make coalescing work" it sounds =
like
>> major overkill.
>>
>> FITRIM should be able to lock a group of non-contiguous free ranges,
>> send them down to the block layer as a single pre-coalesced set, and
>> the block layer just needs to pass it on in a synchronous way. =A0Th=
en
>> when that group of ranges is discarded, FITRIM releases the locks.
>
> Given that you know the Linux I/O stack and hardware so well may I
> volunteer you to implement it? =A0Including remapping the multiple ra=
nges
> in device mapper, and dealing with the incompatible range formats for
> TRIM vs UNMAP. =A0If your implementation is clean enough I'm pretty
> sure no one will object to merge it.
>
>> Every TRIM causes a cache flush anyway on the SSD, so the synchronou=
s
>> aspect of the process should not be a problem. =A0(Maybe SCSI with t=
hin
>> provisioning would see a performance hit?)
>
> What's your evidence?

The kernel team has been coding around some Utopian SSD TRIM
implementation for at least 2 years with the basic assumption that
SSDs can handle thousands of trims per second.  Just mix em in with
the rest of the i/o.  No problem.  Intel swore to us its the right
thing to do.

I'm still waiting to see the first benchmark report from anywhere
(SSD, Thin Provisioned SCSI) that the online approach used by mount -o
discard is a win performance wise.  Linux has a history of designing
for reality, but for some reason when it comes to SSDs reality seems
not to be a big concern.

Greg
