From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/6] ext4: cache extent hole in extent status tree for
 ext4_da_map_blocks()
Date: Tue, 25 Nov 2014 11:58:03 -0500
Message-ID: <20141125165803.GA11648@thunk.org>
References: <1415961957-21621-1-git-send-email-jack@suse.cz>
 <1415961957-21621-2-git-send-email-jack@suse.cz>
 <20141123054335.GA4102@thunk.org>
 <20141124093434.GC1888@quack.suse.cz>
 <20141125145714.GA3228@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <gnehzuil.liu@gmail.com>,
	Zheng Liu <wenqing.lz@taobao.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50856 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbaKYQ6I (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Nov 2014 11:58:08 -0500
Content-Disposition: inline
In-Reply-To: <20141125145714.GA3228@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 25, 2014 at 03:57:14PM +0100, Jan Kara wrote:
>   So it really wasn't my bug but a problem in ext4_da_map_blocks() which
> was made much more visible by this patch. Anyway, I've fixed it and
> resubmitted the series.

Many thanks!  I'm running the your updated series through my tests
right now.

Cheers,

					- Ted
