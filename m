From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate
 super_operation
Date: Thu, 18 Nov 2010 11:41:38 -0600
Message-ID: <1290102098.3041.77.camel@mulgrave.site>
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com>
	 <20101118130630.GJ6178@parisc-linux.org>
	 <20101118134804.GN5618@dhcp231-156.rdu.redhat.com>
	 <20101118141957.GK6178@parisc-linux.org>
	 <20101118142918.GA18510@infradead.org>
	 <1290100750.3041.72.camel@mulgrave.site>
	 <x494obe4kd5.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch@infradead.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Josef Bacik <josef@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, sandeen@redhat.com
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <x494obe4kd5.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2010-11-18 at 12:22 -0500, Jeff Moyer wrote:
> James Bottomley <James.Bottomley@suse.de> writes:
> 
> > Not stepping into the debate: I'm happy to see punch go to the mapping
> > data and FITRIM pick it up later.
> >
> > However, I think it's time to question whether we actually still want to
> > allow online discard at all.  Most of the benchmarks show it to be a net
> 
> Define online discard, please.

Trims emitted inline at the FS operates (mount option -o discard)

> > lose to almost everything (either SSD or Thinly Provisioned arrays), so
> > it's become an "enable this to degrade performance" option with no
> > upside.
> 
> Some SSDs very much require TRIMming to perform well as they age.  If
> you're suggesting that we move from doing discards in journal commits to
> a batched discard, like the one Lukas implemented, then I think that's
> fine.  If we need to reintroduce the finer-grained discards due to some
> hardware changes in the future, we can always do that.

Right, I'm suggesting we just rely on offline methods.  Regardless of
what happens to FITRIM, we have wiper.sh now (although it does require
unmounted use for most of the less than modern fs).

James
