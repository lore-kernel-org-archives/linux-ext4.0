From: Andrew Morton <akpm@osdl.org>
Subject: Re: Updated ext4/jbd2 patches based on 2.6.19-rc1
Date: Thu, 5 Oct 2006 23:10:56 -0700
Message-ID: <20061005231056.174ee381.akpm@osdl.org>
References: <1160072610.8508.12.camel@kleikamp.austin.ibm.com>
	<20061005213133.2c4cd82d.akpm@osdl.org>
	<20061006055829.GH22010@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Dave Kleikamp <shaggy@austin.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:58290 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932617AbWJFGLC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Oct 2006 02:11:02 -0400
To: Andreas Dilger <adilger@clusterfs.com>
In-Reply-To: <20061006055829.GH22010@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 5 Oct 2006 23:58:29 -0600
Andreas Dilger <adilger@clusterfs.com> wrote:

> but the patches have not been changed for ext4 (which should really
> default to using extents on a filesystem with the INCOMPAT_EXTENT feature
> set unless told otherwise).  That is a necessity for filesystems larger
> than 2^32 blocks, since there is no way to create old block-mapped files
> past that limit.

That's news to me.  So we only use 48-bit block numbers for extents and
not for old-style indirect blocks?

How much performance improvement do they get, btw?  CPU or IO? I'm not noticing
any difference.

Has been a while since I did any fs testing.  Boy, ext3 is beating the crap
out of ext2 for quality of file layout.
