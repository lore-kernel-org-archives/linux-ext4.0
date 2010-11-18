From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate super_operation
Date: Thu, 18 Nov 2010 18:05:57 +0000
Message-ID: <20101118180557.GU22787@shareable.org>
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com> <20101118130630.GJ6178@parisc-linux.org> <20101118134804.GN5618@dhcp231-156.rdu.redhat.com> <20101118141957.GK6178@parisc-linux.org> <20101118142918.GA18510@infradead.org> <1290100750.3041.72.camel@mulgrave.site> <x494obe4kd5.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: James Bottomley <James.Bottomley@suse.de>,
	Christoph Hellwig <hch@infradead.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Josef Bacik <josef@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, sandeen@redhat.com
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:59508 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab0KRSua (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Nov 2010 13:50:30 -0500
Content-Disposition: inline
In-Reply-To: <x494obe4kd5.fsf@segfault.boston.devel.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jeff Moyer wrote:
> James Bottomley <James.Bottomley@suse.de> writes:
> 
> > Not stepping into the debate: I'm happy to see punch go to the mapping
> > data and FITRIM pick it up later.
> >
> > However, I think it's time to question whether we actually still want to
> > allow online discard at all.  Most of the benchmarks show it to be a net
> 
> Define online discard, please.
> 
> > lose to almost everything (either SSD or Thinly Provisioned arrays), so
> > it's become an "enable this to degrade performance" option with no
> > upside.
> 
> Some SSDs very much require TRIMming to perform well as they age.  If
> you're suggesting that we move from doing discards in journal commits to
> a batched discard, like the one Lukas implemented, then I think that's
> fine.  If we need to reintroduce the finer-grained discards due to some
> hardware changes in the future, we can always do that.

"Growable" virtual disks benefit from it too, if it frees up a lot of space.

Windows has some ability to trim unused space in NTFS on virtual disks
for this reason; I'm not sure if it's an online or offline procedure.

Online trim may be slow, but offline would be awfully inconvenient
when an fs is big and needed for a live system, or when it's your root fs.

-- Jamie
