From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC] Defragmentation interface
Date: Sat, 4 Nov 2006 03:22:16 +0800
Message-ID: <20061103192216.GA5252@schatzie.adilger.int>
References: <20061102143929.GA8607@atrey.karlin.mff.cuni.cz> <20061102225953.GF8394166@melbourne.sgi.com> <20061103143030.GB17306@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Chinner <dgc@sgi.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:21485 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S1753484AbWKCTWt
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Nov 2006 14:22:49 -0500
To: Jan Kara <jack@suse.cz>
Content-Disposition: inline
In-Reply-To: <20061103143030.GB17306@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Nov 03, 2006  15:30 +0100, Jan Kara wrote:
> > - stripe unit and stripe width need to be exposed so defrag too
> >   can make correct placement decisions.
>   fs-specific thing...

I think this is not just XFS-specific.  It is very desirable to align
large IO to the RAID stripe so that if you write stripe_width bytes
you don't do 2 expensive read-modify-write steps, but rather a single
write operation.  Also RAID controllers have (large) internal cache
"lines" and having aligned reads can help noticably, and also if array
is doing RAID parity checking to avoid overhead of doing this for two
stripes instead of one.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
