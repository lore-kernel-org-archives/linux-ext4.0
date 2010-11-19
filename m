From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate
 super_operation
Date: Fri, 19 Nov 2010 09:57:48 -0500
Message-ID: <20101119145748.GB27919@infradead.org>
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com>
 <20101118130630.GJ6178@parisc-linux.org>
 <20101118134804.GN5618@dhcp231-156.rdu.redhat.com>
 <20101118141957.GK6178@parisc-linux.org>
 <20101118142918.GA18510@infradead.org>
 <1290100750.3041.72.camel@mulgrave.site>
 <4CE59C9E.6050902@teksavvy.com>
 <1290177488-sup-6540@think>
 <4CE68F80.7000607@teksavvy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	James Bottomley <james.bottomley@suse.de>,
	Christoph Hellwig <hch@infradead.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Josef Bacik <josef@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>, tytso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	sandeen <sandeen@redhat.com>
To: Mark Lord <kernel@teksavvy.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50349 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507Ab0KSO6F (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Nov 2010 09:58:05 -0500
Content-Disposition: inline
In-Reply-To: <4CE68F80.7000607@teksavvy.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 19, 2010 at 09:53:52AM -0500, Mark Lord wrote:
> On 10-11-19 09:40 AM, Chris Mason wrote:
> >
> >We've been told that online and constant trimming is the default in
> >windows7.   The ssds are most likely to just start ignoring the trims
> >they can't service efficiently.
> 
> Win7 collects multiple TRIM ranges over time and batches them as single TRIMs
> (as reported to me by an SSD vendor who traced it with a SATA analyzer,
>  and who also apparently has "inside info").

I really hate to rely on this third party hearsay (from all sides), and
have implement TRIM support in qemu now.  I'll soon install win7 and
will check out the TRIM patters myself.

