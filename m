From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH v2.1 00/50] e2fsprogs: Add metadata checksumming
Date: Mon, 28 Nov 2011 23:52:28 -0800
Message-ID: <20111129075228.GA23175@tux1.beaverton.ibm.com>
References: <20111129002755.17953.19556.stgit@elm3c44.beaverton.ibm.com> <484E5140-D0E7-4BE2-BF59-F88406D95E8C@dilger.ca>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:55854 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288Ab1K2Hwe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Nov 2011 02:52:34 -0500
Received: from /spool/local
	by e5.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Tue, 29 Nov 2011 02:52:33 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pAT7qU3F241744
	for <linux-ext4@vger.kernel.org>; Tue, 29 Nov 2011 02:52:30 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pAT7qTqQ027540
	for <linux-ext4@vger.kernel.org>; Tue, 29 Nov 2011 02:52:30 -0500
Content-Disposition: inline
In-Reply-To: <484E5140-D0E7-4BE2-BF59-F88406D95E8C@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 28, 2011 at 10:17:35PM -0700, Andreas Dilger wrote:
> On 2011-11-28, at 5:27 PM, Darrick J. Wong wrote:
> > This patchset adds support in e2fsprogs for attaching crc32c checksums to most of the ext4 metadata objects.  A full design document is on the
> > ext4 wiki[1].  Please see the cover letter for the kernel patches for a
> > more thorough summary of this work.
> > 
> > [1] https://ext4.wiki.kernel.org/index.php/Ext4_Metadata_Checksums
> 
> This URL has changed:
> 
> https://ext4.wiki.kernel.org/articles/e/x/t/Ext4_Metadata_Checksums_4d24.html
> 
> It would also be useful to include in this wiki page the tests you
> did for the checksum speed of different algorithms at different chunk
> sizes, since checksums of 512MB of data are few and far between
> (especially since this is not computing the checksum of file data).

Oh, the wiki's back up... though I guess I can't log in either.  I'll dig up
the results and shove it in the google docs spreadsheet for now, I guess.

--D
> 
> Cheers, Andreas
> 
> 
> 
> 
> 

