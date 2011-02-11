From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [patch] ext4: off by one check in ext4_groupinfo_create_slab()
Date: Thu, 10 Feb 2011 19:00:35 -0500
Message-ID: <20110211000035.GH16597@thunk.org>
References: <20110209232412.GC4384@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sandeen@redhat.com, Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58065 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757378Ab1BKAAl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Feb 2011 19:00:41 -0500
Content-Disposition: inline
In-Reply-To: <20110209232412.GC4384@bicker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 10, 2011 at 02:24:12AM +0300, Dan Carpenter wrote:
> If cache_index == NR_GRPINFO_CACHES then we read past the end of the
> ext4_groupinfo_caches[] array a couple lines later.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Oops, thanks for pointing that out!

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

					- Ted
