From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: IRON filesystem papers - development of robust and fault tolerant filesystems
Date: Fri, 22 Jun 2007 16:20:17 -0600
Message-ID: <20070622222017.GU5181@schatzie.adilger.int>
References: <1823488273.20070622102830@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: sftf <sftf-misc@mail.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:43200 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741AbXFVWUU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Jun 2007 18:20:20 -0400
Content-Disposition: inline
In-Reply-To: <1823488273.20070622102830@mail.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 22, 2007  10:28 +0600, sftf wrote:
> Hello!
> I suggest developers to consider ext4 design from the point of view of these papers:
> IRON FILE SYSTEMS -
> http://www.cs.wisc.edu/wind/Publications/vijayan-thesis06.pdf
> IMHO - very impressive paper and  developers of close future filesystems can't
> ignore these problems and solutions.
> 
> and "Failure Analysis of SGI XFS File System"
> http://www.cs.wisc.edu/~vshree/xfs.pdf  
 
Thanks, I think most of the ext4 developers have already read these papers.
They are definitely of interest, and reducing e2fsck time is a very important
area of development these days.

We have already implemented the IRON FS journal checksumming feature, and
this will go into ext4 shortly.  There is lots of work needed in order to
implement checksumming for the rest of the filesystem, so if you are
interested to work on this please let us know.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
