From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate
 super_operation
Date: Fri, 19 Nov 2010 09:06:39 -0500
Message-ID: <20101119140639.GA25488@infradead.org>
References: <1290100750.3041.72.camel@mulgrave.site>
 <x494obe4kd5.fsf@segfault.boston.devel.redhat.com>
 <1290102098.3041.77.camel@mulgrave.site>
 <AANLkTim=SkqBehcCvEME7YVHk3S0dLdmBS8ooRF+-BuW@mail.gmail.com>
 <4CE59E57.2090009@teksavvy.com>
 <yq1r5eiw5os.fsf@sermon.lab.mkp.net>
 <4CE5C616.7070706@teksavvy.com>
 <AANLkTikgEeUL2NVLLdoT3RX0r=v0Pzfp9-==F39DVRgN@mail.gmail.com>
 <20101119115516.GA1152@infradead.org>
 <4CE6831E.4020606@teksavvy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	James Bottomley <James.Bottomley@suse.de>,
	Jeff Moyer <jmoyer@redhat.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Josef Bacik <josef@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, sandeen@redhat.com
To: Mark Lord <kernel@teksavvy.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4CE6831E.4020606@teksavvy.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Nov 19, 2010 at 09:01:02AM -0500, Mark Lord wrote:
> That is my intent already, thanks.  Just needs time, perhaps this winter.

This wasn't addressed at you, but a snide remark at Greg, who is just
contantly bickering without actually beeing any help.

> I think a reasonable approach would be to modify the existing interfaces
> so that the LLD can report a "max discard ranges per command" back up
> the stack.
> 
> This way, libata could report a max of say, 64 ranges per "discard" (trim),
> and DM/RAID could simply (for now) report a max of one range per discard.

That's certainly the easy way out.  You'll need a good way to actually
transport the ranges as we can't simply sote them in bi_sector/bi_size
and adapt the whole block layer to deal with the two types of different
discards.  Not saying it's impossible, but when I tried it before it
wasn't pretty.

