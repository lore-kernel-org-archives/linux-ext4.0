From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 04/22] ext4: Only call out to crc32c if necessary
Date: Mon, 5 Dec 2011 11:38:59 -0800
Message-ID: <20111205193859.GC7137@tux1.beaverton.ibm.com>
References: <20111128232615.19194.80081.stgit@elm3c44.beaverton.ibm.com> <20111128232642.19194.80905.stgit@elm3c44.beaverton.ibm.com> <20111205155226.GA32031@thunk.org>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:57520 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755113Ab1LETja (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Dec 2011 14:39:30 -0500
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 5 Dec 2011 12:39:30 -0700
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pB5JdJ2g094968
	for <linux-ext4@vger.kernel.org>; Mon, 5 Dec 2011 12:39:19 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pB5Jd2aO009822
	for <linux-ext4@vger.kernel.org>; Mon, 5 Dec 2011 12:39:06 -0700
Content-Disposition: inline
In-Reply-To: <20111205155226.GA32031@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 05, 2011 at 10:52:26AM -0500, Ted Ts'o wrote:
> On Mon, Nov 28, 2011 at 03:26:43PM -0800, Darrick J. Wong wrote:
> > +	/* Load the checksum driver */
> > +	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
> > +				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
> > +		sbi->s_chksum_driver = crypto_alloc_shash("crc32c", 0, 0);
> > +		if (IS_ERR(sbi->s_chksum_driver)) {
> > +			ret = PTR_ERR(sbi->s_chksum_driver);
> > +			sbi->s_chksum_driver = NULL;
> > +			goto failed_mount;
> > +		}
> > +	}
> 
> Unless the crypto engine printk's a message if the crc32c algorithm is
> not available (perhaps even if it does), it's probably going to be a
> good idea to issue an ext4_msg() saying that we're failing because we
> couldn't load the crc32c crypto module.  Otherwise the user will get a
> mysterious failure (including a message from mount to check 'dmesg |
> tail'), and then when they look at the kernel messages, they won't see
> what might have gone wrong, and then they'll send a complaint to
> ext3-users or linux-ext4....

Ok.

--D

