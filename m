From: Marc MERLIN <marc@merlins.org>
Subject: Re: How can btrfs take 23sec to stat 23K files from an SSD?
Date: Tue, 31 Jul 2012 23:40:10 -0700
Message-ID: <20120801064010.GJ12695@merlins.org>
References: <20120718220446.GB3888@merlins.org> <20120722185848.GA10089@merlins.org> <201207222135.11159.Martin@lichtvoll.de> <20120722204428.GC3925@merlins.org> <20120722224145.GC12951@merlins.org> <20120723064202.GB6931@merlins.org> <20120727110835.GA6933@shiny> <20120727184238.GA6713@merlins.org> <20120801060135.GH12695@merlins.org> <5018CE66.6050609@csamuel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@fusionio.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Ted Ts'o <tytso@mit.edu>,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, axboe@kernel.dk,
	Milan Broz <mbroz@redhat.com>
To: Chris Samuel <chris@csamuel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:43834 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517Ab2HAGkO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Aug 2012 02:40:14 -0400
Content-Disposition: inline
In-Reply-To: <5018CE66.6050609@csamuel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 01, 2012 at 04:36:22PM +1000, Chris Samuel wrote:
> On 01/08/12 16:01, Marc MERLIN wrote:
> 
> > Third, A freshly made ntfs filesystem through fuse is actually FASTER!
> 
> Could it be that Samsungs FTL has optimisations in it for NTFS ?
> 
> A horrible thought, but not impossible..

Not impossible, but it's can be the main reason since it clocks still 2x
slower with ntfs than a spinning disk with encrypted btrfs.
Since SSDs should "seek" 10-100x faster than spinning disks, that can't be
the only reason.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
