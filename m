From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC] [PATCH] Documentation/filesystems/ext4.txt
Date: Wed, 11 Oct 2006 11:03:35 -0600
Message-ID: <20061011170335.GO22010@schatzie.adilger.int>
References: <1160072610.8508.12.camel@kleikamp.austin.ibm.com> <20061005173933.f54555fb.akpm@osdl.org> <20061009232927.77b667c2.akpm@osdl.org> <20061010075402.GA23992@in.ibm.com> <20061010011434.e8e2f76b.akpm@osdl.org> <1160510555.28923.15.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@osdl.org>, suparna@in.ibm.com,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:1684 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S1161023AbWJKRDi
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Oct 2006 13:03:38 -0400
To: Dave Kleikamp <shaggy@austin.ibm.com>
Content-Disposition: inline
In-Reply-To: <1160510555.28923.15.camel@kleikamp.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 10, 2006  15:02 -0500, Dave Kleikamp wrote:
> +  - It's still mke2fs -j /dev/hda1

I would suggest "mke2fs -j -O dir_index -I 256 /dev/XXX" to be more
representative of what will be used in the future.

> +programs:	http://e2fsprogs.sourceforge.net/
> +		http://ext2resize.sourceforge.net

You should likely remove ext2resize from this list, it hasn't got any
support for extent-mapped files.


Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

