From: Mark Lord <kernel@teksavvy.com>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate super_operation
Date: Thu, 18 Nov 2010 16:37:34 -0500
Message-ID: <4CE59C9E.6050902@teksavvy.com>
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com>	 <20101118130630.GJ6178@parisc-linux.org>	 <20101118134804.GN5618@dhcp231-156.rdu.redhat.com>	 <20101118141957.GK6178@parisc-linux.org>	 <20101118142918.GA18510@infradead.org> <1290100750.3041.72.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch@infradead.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Josef Bacik <josef@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, sandeen@redhat.com
To: James Bottomley <James.Bottomley@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1290100750.3041.72.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 10-11-18 12:19 PM, James Bottomley wrote:
>
> Not stepping into the debate: I'm happy to see punch go to the mapping
> data and FITRIM pick it up later.
>
> However, I think it's time to question whether we actually still want to
> allow online discard at all.  Most of the benchmarks show it to be a net
> lose to almost everything (either SSD or Thinly Provisioned arrays), so
> it's become an "enable this to degrade performance" option with no
> upside.

I also suspect that online TRIM exerts significant premature wear on the SSDs.
TRIM operations most likely trigger immediate copy/erase operations internal
to most SSDs, often regardless of the amount of data being trimmed.

Performing a 256KB erase because of a 1024-byte TRIM, over and over, is going
to harm the expected lifetime of an SSD.  Sure, some SSDs may do things differently
internally, but I don't see it working that way in much of the current crop of SSDs.

Currently, I patch my kernels to remove the automatic online TRIMs.
Is there a knob somewhere for this in the later kernels?

Cheers
