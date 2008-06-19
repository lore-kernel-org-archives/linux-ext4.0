From: Andreas Dilger <adilger@sun.com>
Subject: Re: Performance of ext4
Date: Thu, 19 Jun 2008 00:58:44 -0600
Message-ID: <20080619065844.GQ3726@webber.adilger.int>
References: <Pine.LNX.4.64.0806121154090.27806@diagnostix.dwd.de>
 <20080612131928.GB18229@mit.edu>
 <Pine.LNX.4.64.0806121333480.27806@diagnostix.dwd.de>
 <20080612180605.GD22481@skywalker>
 <Pine.LNX.4.64.0806121940020.2974@diagnostix.dwd.de>
 <Pine.LNX.4.64.0806130753100.7097@diagnostix.dwd.de>
 <20080616175408.GF3279@atrey.karlin.mff.cuni.cz>
 <20080616181353.GA20686@skywalker>
 <Pine.LNX.4.64.0806171001200.6307@diagnostix.dwd.de>
 <Pine.LNX.4.64.0806180546370.20901@diagnostix.dwd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
	Solofo.Ramangalahy@bull.net, Nick Dokos <nicholas.dokos@hp.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:48282 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbYFSG6t (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Jun 2008 02:58:49 -0400
In-reply-to: <Pine.LNX.4.64.0806180546370.20901@diagnostix.dwd.de>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 18, 2008  05:58 +0000, Holger Kiehl wrote:
>      1.03       ------Sequential Output------ --Sequential Input- --Random-
>                 -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
> ext4               K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
>                16G 52133  98 221378 95 106873 32 55707  99 297065 42  1546   4
>                16G 52042  98 220931 93 107715 32 55939  98 298810 42  1543   3
>                16G 52975  98 220976 93 108060 31 56426  98 298906 42  1452   4
>
>ext4(patchqueue)16G 59727  98 252733 52 110177 25 55821  98 296739 42  1553   5
>>               16G 61047  99 239242 48 111664 25 55706  98 297151 42  1545   4
>>               16G 60503  99 241532 47 109655 25 55671  98 297648 42  1552   3
>
> I forgot to mention that for bonnie ext4-patch-queue reduces CPU-load
> a lot. For block writting it is nearly halved.

That was the main reason for developing mballoc.  With this patch it
would be able to drive almost 500MB/s write, 600MB/s read on the above
system instead of being CPU limited at 250/300MB/s.


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

