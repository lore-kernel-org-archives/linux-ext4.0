From: "Kalpak Shah" <kalpak.shah@gmail.com>
Subject: Re: [PATCH 2/2] Large EAs
Date: Wed, 26 Nov 2008 11:30:32 +0530
Message-ID: <460220570811252200t5d9e4aaax95f73843b8f3e482@mail.gmail.com>
References: <1226954173.3972.70.camel@localhost>
	 <20081126044138.GD1410@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Kalpak Shah" <Kalpak.Shah@sun.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	"Mingming Cao" <cmm@us.ibm.com>, "Andreas Dilger" <adilger@sun.com>
To: "Theodore Tso" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:10158 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbYKZGAd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Nov 2008 01:00:33 -0500
Received: by wf-out-1314.google.com with SMTP id 27so328407wfd.4
        for <linux-ext4@vger.kernel.org>; Tue, 25 Nov 2008 22:00:32 -0800 (PST)
In-Reply-To: <20081126044138.GD1410@mit.edu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 26, 2008 at 10:11 AM, Theodore Tso <tytso@mit.edu> wrote:
> Sorry for not reviewing this patch earlier, but looking at the disk
> format, I wonder if it's really necessary to allocate an inode for
> each EA.  Given that we have a fixed inode table, if the user creates
> a large number of 2k EA's (on a 4k filesystem) or 512 byte EA's (on a
> 1k) filesystem, this could easily burn a huge number of inodes,
> causing users to run out.
>
> We don't actually *need* to use an inode;

One of the reasons we need to use an inode is that orphan EA inodes
can be linked into lost+found. If we just use an extent tree, I am not
sure how e2fsck can find out orphan EAs.

> what if we make use
> e_value_block and e_hash to be a 64-bit block number, and use
> e_value_offs (if 0) to indicate whether the 64-bit block number
> contains data, or (if 1) contains the root of an extent tree.  This
> adds a bit of complexity to the hash calculation if we want to support
> sharing the EA block that contains pointers to Large EA's, but from
> what I can tell the proposed patch doesn't support this anyway (and it
> seems highly unlikely that multiple files with large EA's could be
> able to be shared anyway).

We shouldn't worry about sharing EA blocks once we have large EAs as
it will be too inefficient getting all the EA values (from EA inodes
or extent trees) and calculating a hash of all the data and when an EA
block cannot be shared we will need to create copies of all EA
inodes......

> The upsides of this patch (not needing to use inodes) seems to be
> worth the downsides (slightly more complexity, and not being able to
> share EA blocks).
>
> What do folks think?
>
>                                                - Ted

Thanks,
Kalpak
