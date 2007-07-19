From: Mark Fasheh <mark.fasheh@oracle.com>
Subject: Re: [PATCH 1/5][TAKE8] manpage for fallocate
Date: Wed, 18 Jul 2007 22:31:56 -0700
Message-ID: <20070719053156.GF32734@ca-server1.us.oracle.com>
References: <20070713184125.GA12156@amitarora.in.ibm.com> <20070713184625.GB12156@amitarora.in.ibm.com> <20070719034155.GE32734@ca-server1.us.oracle.com> <20070719051052.GE12413810@sgi.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com, tytso@mit.edu,
	cmm@us.ibm.com, suparna@in.ibm.com, adilger@clusterfs.com,
	michael.kerrisk@gmx.net
To: David Chinner <dgc@sgi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:30911 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbXGSFhp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Jul 2007 01:37:45 -0400
Content-Disposition: inline
In-Reply-To: <20070719051052.GE12413810@sgi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jul 19, 2007 at 03:10:52PM +1000, David Chinner wrote:
> % git-log 84e1e99f112dead8f9ba036c02d24a9f5ce7f544 |head -10
> commit 84e1e99f112dead8f9ba036c02d24a9f5ce7f544
> Author: David Chinner <dgc@sgi.com>
> Date:   Mon Jun 18 16:50:27 2007 +1000
> 
>     [XFS] Prevent ENOSPC from aborting transactions that need to succeed
> 
>     During delayed allocation extent conversion or unwritten extent
>     conversion, we need to reserve some blocks for transactions reservations.
>     We need to reserve these blocks in case a btree split occurs and we need
>     to allocate some blocks.
> 
> ------
> 
> IOWs, XFS didn't provide this guarantee until about a month ago....

Ok, once again XFS is ahead of the curve ;)

Comment rescinded then...
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
