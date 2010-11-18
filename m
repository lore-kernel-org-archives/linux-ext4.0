From: Mark Lord <kernel@teksavvy.com>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate super_operation
Date: Thu, 18 Nov 2010 16:42:14 -0500
Message-ID: <4CE59DB6.9090304@teksavvy.com>
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com> <20101118130630.GJ6178@parisc-linux.org> <20101118134804.GN5618@dhcp231-156.rdu.redhat.com> <20101118141957.GK6178@parisc-linux.org> <20101118142918.GA18510@infradead.org> <1290100750.3041.72.camel@mulgrave.site> <x494obe4kd5.fsf@segfault.boston.devel.redhat.com> <1290102098.3041.77.camel@mulgrave.site> <AANLkTim=SkqBehcCvEME7YVHk3S0dLdmBS8ooRF+-BuW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: James Bottomley <James.Bottomley@suse.de>,
	Jeff Moyer <jmoyer@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Josef Bacik <josef@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, sandeen@redhat.com
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <AANLkTim=SkqBehcCvEME7YVHk3S0dLdmBS8ooRF+-BuW@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 10-11-18 03:04 PM, Greg Freemyer wrote:
>
> I'm a fan of wiper.sh, but afaik it still cannot address a
> multi-spindle LVM setup, Nor a MDraid setup.  etc.
>
> That's because it bypasses the block stack and talks directly to the
> devices.  Thus it doesn't get the benefit of all the logical to
> physical sector remapping handled via the block stack.
>
> Mark, please correct me if I'm wrong.

I'm a big fan of FITRIM, especially as it should work on MD devices
as well, which are problematic for wiper.sh today.   I originally proposed
FITRIM (without the name, though) back when first implementing wiper.sh,
and I really believe we should extend FITRIM to btrfs and xfs.

hdparm is picking up support for FITRIM in the next release,
and wiper.sh will use it when it can in place of raw TRIMs.

This remains my own preferred method for TRIM:  offline, that is.  :)

Cheers
