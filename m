From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate
 super_operation
Date: Tue, 7 Dec 2010 04:27:49 -0500
Message-ID: <20101207092749.GA26100@infradead.org>
References: <20101118130630.GJ6178@parisc-linux.org>
 <20101118134804.GN5618@dhcp231-156.rdu.redhat.com>
 <20101118141957.GK6178@parisc-linux.org>
 <20101118142918.GA18510@infradead.org>
 <1290100750.3041.72.camel@mulgrave.site>
 <4CE59C9E.6050902@teksavvy.com>
 <1290177488-sup-6540@think>
 <4CE68F80.7000607@teksavvy.com>
 <20101119145748.GB27919@infradead.org>
 <4CE695FF.20601@teksavvy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Chris Mason <chris.mason@oracle.com>,
	James Bottomley <james.bottomley@suse.de>,
	Matthew Wilcox <matthew@wil.cx>,
	Josef Bacik <josef@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>, tytso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	sandeen <sandeen@redhat.com>
To: Mark Lord <kernel@teksavvy.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35939 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab0LGJ16 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Dec 2010 04:27:58 -0500
Content-Disposition: inline
In-Reply-To: <4CE695FF.20601@teksavvy.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 19, 2010 at 10:21:35AM -0500, Mark Lord wrote:
> >I really hate to rely on this third party hearsay (from all sides), and
> >have implement TRIM support in qemu now.  I'll soon install win7 and
> >will check out the TRIM patters myself.
> 
> Excellent!

I did a Windows 7 installation under qemu today, and the result is:

 - it TRIMs the whole device early during the installation
 - after that I see a constant stream of small trims during the
   installation.  It's using lots of non-contiguous ranges in a single
   TRIM command, with sizes down to 8 sectors (4k) for a single range.
 - after installation there's is some background-trimming going on
   even when doing no user interaction with the VM at all.
 - removing files leads to an instant stream of TRIMs, again vectored
   and of all sizes down to 4k.  Note that the TRIMs are a lot more
   instant than even with btrfs and -o discard, which delays most
   TRIMs until doing a sync.
