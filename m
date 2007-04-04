From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Ext4 benchmarks
Date: Wed, 4 Apr 2007 13:21:59 -0600
Message-ID: <20070404192159.GS5967@schatzie.adilger.int>
References: <45FFFBAA.6080404@bull.net> <4613DB20.1040605@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Mingming Cao <cmm@us.ibm.com>,
	"AVANTIKA R. MATHUR" <mathur@linux.vnet.ibm.com>
To: Cordenner jean noel <jean-noel.cordenner@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:39734 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330AbXDDTWG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Apr 2007 15:22:06 -0400
Content-Disposition: inline
In-Reply-To: <4613DB20.1040605@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Apr 04, 2007  19:06 +0200, Cordenner jean noel wrote:
> here is the first results of the round:
> http://www.bullopensource.org/ext4/20070404/

Jean Noel,
thank you for the test results.  It is always nice to see that ext4 is
doing so well compared to ext3 and XFS.

Ming Ming,
it should be possible to just include the mballoc+delalloc patches that
Jean Noel used into the upstream ext4 patch series.  When Alex or Christoph
get a chance to do the VFS delalloc rewrite we can move to that new patch,
but until then it seems pointless to not include this functionality which
improves the performance so much.

Also, if we include those patches the mballoc and delalloc features (along
with extents) should be enabled by default if INCOMPAT_EXTENTS is in the
superblock unless:
- "noextents", "nomballoc", or "nodelalloc" mount options are given
- delalloc needs to be disabled if blocksize != PAGE_SIZE

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
