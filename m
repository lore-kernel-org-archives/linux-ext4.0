From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix off-by-one fsmap error on 1k block filesystems
Date: Fri, 23 Jun 2017 01:01:31 -0400
Message-ID: <20170623050131.2feyc7daq7adwtat@thunk.org>
References: <20170621182940.GB4728@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34860 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751409AbdFWFBe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 23 Jun 2017 01:01:34 -0400
Content-Disposition: inline
In-Reply-To: <20170621182940.GB4728@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 21, 2017 at 11:29:40AM -0700, Darrick J. Wong wrote:
> For 1k-block filesystems, the filesystem starts at block 1, not block 0.
> This fact is recorded in s_first_data_block, so use that to bump up the
> start_fsb before we start querying the filesystem for its space map.
> Without this, ext4/026 fails on 1k block ext4 because various functions
> (notably ext4_get_group_no_and_offset) don't know what to do with an
> fsblock that is "before" the start of the filesystem and return garbage
> results (blockgroup 2^32-1, etc.) that confuse fsmap.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
