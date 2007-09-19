From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] Ext4: Uninitialized Block Groups
Date: Wed, 19 Sep 2007 00:30:58 -0600
Message-ID: <20070919063058.GG32520@schatzie.adilger.int>
References: <46F06C7B.20308@linux.vnet.ibm.com> <20070918200321.d7da53e2.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Avantika Mathur <mathur@linux.vnet.ibm.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	cmm@us.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:41146 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbXISGac (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Sep 2007 02:30:32 -0400
Content-Disposition: inline
In-Reply-To: <20070918200321.d7da53e2.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sep 18, 2007  20:03 -0700, Andrew Morton wrote:
> On Tue, 18 Sep 2007 17:25:31 -0700 Avantika Mathur <mathur@linux.vnet.ibm.com> wrote:
> 
> > +#if !defined(CONFIG_CRC16)
> > +/** CRC table for the CRC-16. The poly is 0x8005 (x16 + x15 + x2 + 1) */
> > +__u16 const crc16_table[256] = {
> > +	0x0000, 0xC0C1, 0xC181, 0x0140, 0xC301, 0x03C0, 0x0280, 0xC241,
> 
> That's rather sad.  A plain old "depends on" would be better.

My bad.  We wrote this patch and it had to run on older kernels that might
not even have lib/crc16.c (it was added around 2.6.15 or so, so e.g. RHEL4
doesn't have it).  I forgot to remove it from the upstream submission,
and since it didn't cause problems nobody else complained...

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
