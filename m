From: Jan Kara <jack@ucw.cz>
Subject: Re: [RFC] Defragmentation interface
Date: Fri, 3 Nov 2006 20:38:00 +0100
Message-ID: <20061103193800.GD17306@atrey.karlin.mff.cuni.cz>
References: <20061102143929.GA8607@atrey.karlin.mff.cuni.cz> <20061102225953.GF8394166@melbourne.sgi.com> <20061103143030.GB17306@atrey.karlin.mff.cuni.cz> <20061103192216.GA5252@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Chinner <dgc@sgi.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:1453 "EHLO
	atrey.karlin.mff.cuni.cz") by vger.kernel.org with ESMTP
	id S1753472AbWKCTiB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Nov 2006 14:38:01 -0500
To: Andreas Dilger <adilger@clusterfs.com>
Content-Disposition: inline
In-Reply-To: <20061103192216.GA5252@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> On Nov 03, 2006  15:30 +0100, Jan Kara wrote:
> > > - stripe unit and stripe width need to be exposed so defrag too
> > >   can make correct placement decisions.
> >   fs-specific thing...
> 
> I think this is not just XFS-specific.  It is very desirable to align
> large IO to the RAID stripe so that if you write stripe_width bytes
> you don't do 2 expensive read-modify-write steps, but rather a single
> write operation.  Also RAID controllers have (large) internal cache
> "lines" and having aligned reads can help noticably, and also if array
> is doing RAID parity checking to avoid overhead of doing this for two
> stripes instead of one.
  I see, thanks for information. On the other hand this is rather an
underlying block device feature than a fs thing, isn't it? So does it
make sence to pass this information via fs interface?

								Honza
