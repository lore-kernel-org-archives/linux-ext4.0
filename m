From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate
 super_operation
Date: Sun, 21 Nov 2010 14:20:00 -0600
Message-ID: <1290370800.3017.6.camel@mulgrave.site>
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com>
	 <20101118130630.GJ6178@parisc-linux.org>
	 <20101118134804.GN5618@dhcp231-156.rdu.redhat.com>
	 <20101118141957.GK6178@parisc-linux.org>
	 <20101118142918.GA18510@infradead.org>
	 <1290100750.3041.72.camel@mulgrave.site> <4CE59C9E.6050902@teksavvy.com>
	 <1290177488-sup-6540@think> <4CE68F80.7000607@teksavvy.com>
	 <36056.1290366424@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Mark Lord <kernel@teksavvy.com>,
	Chris Mason <chris.mason@oracle.com>,
	Christoph Hellwig <hch@infradead.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Josef Bacik <josef@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>, tytso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	sandeen <sandeen@redhat.com>
To: Valdis.Kletnieks@vt.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:47241 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419Ab0KUUUH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Nov 2010 15:20:07 -0500
In-Reply-To: <36056.1290366424@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 2010-11-21 at 14:07 -0500, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 19 Nov 2010 09:53:52 EST, Mark Lord said:
> > On 10-11-19 09:40 AM, Chris Mason wrote:
> > >
> > > We've been told that online and constant trimming is the default in
> > > windows7.   The ssds are most likely to just start ignoring the trims
> > > they can't service efficiently.
> > 
> > Win7 collects multiple TRIM ranges over time and batches them as single TRIMs
> > (as reported to me by an SSD vendor who traced it with a SATA analyzer,
> >   and who also apparently has "inside info").
> 
> What should happen if we have (for instance) a "collect 64 trims at a time" policy,
> and the system crashes at trim number 47? (Probably not an issue if you're
> doing non-deterministic trim, but is an exposure if you're relying on deterministic
> trim for security reasons)

I think it's about the third time in the thread this has been said but
just in case anyone else missed it: TRIM != SECURE ERASE.
TRIM/UNMAP/WRITE_SAME are used to provide optional information about
which blocks the filesystem doesn't care about.  They have no bearing on
information security which is preserved by separate mechanisms.

James


