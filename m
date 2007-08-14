From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Change output format of filefrag
Date: Tue, 14 Aug 2007 06:43:39 -0700
Message-ID: <20070814134339.GD5484@schatzie.adilger.int>
References: <1187097165.3907.9.camel@garfield>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: TheodoreTso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:44172 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136AbXHNNnf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Aug 2007 09:43:35 -0400
Content-Disposition: inline
In-Reply-To: <1187097165.3907.9.camel@garfield>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Aug 14, 2007  18:42 +0530, Kalpak Shah wrote:
> I think an output format similar to that of xfs may be better. This is
> easier for parsing as well. Like this:
> 
> $ filefrag -e {filename}
> 
> ext:    logical:   phys start..end kB:  kB :lun: flags
>   0:   [0..151]: 288444888..288445039: 152 : 0 :
>   1: [152..199]: XXXXXXXX..YYYYYYYYYY:  47 : 0 : hole
>   2: [200..299]: MMMMMMMM..NNNNNNNNNN: 100 : 0 : unwritten, unknown
> 
> Please suggest if this is ok.

Yes, but please include the filename in the output as the first line,
filename:
ext:    logical: ...


Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
