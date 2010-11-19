From: Mark Lord <kernel@teksavvy.com>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate super_operation
Date: Thu, 18 Nov 2010 22:42:23 -0500
Message-ID: <4CE5F21F.7010806@teksavvy.com>
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com>	<20101118130630.GJ6178@parisc-linux.org>	<20101118134804.GN5618@dhcp231-156.rdu.redhat.com>	<20101118141957.GK6178@parisc-linux.org>	<20101118142918.GA18510@infradead.org>	<1290100750.3041.72.camel@mulgrave.site>	<x494obe4kd5.fsf@segfault.boston.devel.redhat.com>	<1290102098.3041.77.camel@mulgrave.site>	<AANLkTim=SkqBehcCvEME7YVHk3S0dLdmBS8ooRF+-BuW@mail.gmail.com>	<4CE59E57.2090009@teksavvy.com> <yq1r5eiw5os.fsf@sermon.lab.mkp.net>	<4CE5C616.7070706@teksavvy.com> <yq1eiaiw0a7.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
	James Bottomley <James.Bottomley@suse.de>,
	Jeff Moyer <jmoyer@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Josef Bacik <josef@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, sandeen@redhat.com
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1eiaiw0a7.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 10-11-18 08:49 PM, Martin K. Petersen wrote:
> So assuming we walk the filesystem to reclaim space on ATA SSDs on a
> weekly basis (since that's the only sane approach):
>
>         What is the performance impact of not coalescing discontiguous
>         block ranges when cron scrubs your /home at 4am Sunday morning?

In the case of FITRIM, you're right: the performance impact
probably doesn't matter much for a 4am cronjob.

But a lot of people currently (at least) prefer to run it manually,
and they don't want it to take forever.

Though that's still not the primary worry:  each TRIM seems to trigger
a flash erase cycle (or cycles) on the most common SSDs on the market,
including anything Indilinx-based and as far as I can tell also for
anything SandForce based.  That's probably 70% of the SSDs out there today.

And I'm very concerned about premature wear -- MLC is only for 10000 cycles (avg).

Also, the current one-range-at-a-time interface is just not correct
for the majority of devices out there:  they are SATA, not some obscure
enterprise-only one-range-at-a-time thing.  We need an implementation
that reflects real-life for uses other than data centres.

If nobody else does it, I'll probably implement it correctly this winter.
But it would really be better for a real filesystem/DM person to do it.

Thanks for hanging in there this far, though!

Cheers
