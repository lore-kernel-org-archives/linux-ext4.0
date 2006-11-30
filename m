From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC][PATCH 4/4] BIG_BG: block group descriptor modifications
Date: Thu, 30 Nov 2006 14:49:49 -0500
Message-ID: <20061130194949.GC10999@thunk.org>
References: <1164386918.17961.79.camel@ckrm> <20061125092346.GA4241@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Valerie Clement <Valerie.Clement@bull.net>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:43191 "EHLO thunker.thunk.org")
	by vger.kernel.org with ESMTP id S1031278AbWK3Ttv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Nov 2006 14:49:51 -0500
To: Andreas Dilger <adilger@clusterfs.com>
Content-Disposition: inline
In-Reply-To: <20061125092346.GA4241@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Nov 25, 2006 at 02:23:46AM -0700, Andreas Dilger wrote:
> Also note that the on-disk layout of this struct in e2fsprogs is a bit
> incorrect - it has the above 3 __u16, but then immediately __u32 bg_reserved
> so those fields are padded incorrectly.  I think it isn't a fatal problem,
> just something to be aware of and fix.

Thanks for pointing this out; I've fixed this in Mercurial repository
for e2fsprogs.

						- Ted
