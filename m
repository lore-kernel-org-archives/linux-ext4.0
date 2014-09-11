From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 22/25] tests: test recovery from an external journal
Date: Thu, 11 Sep 2014 17:04:51 -0400
Message-ID: <20140911210451.GN8366@thunk.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
 <20140908231401.25904.74802.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52039 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754838AbaIKVEw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Sep 2014 17:04:52 -0400
Content-Disposition: inline
In-Reply-To: <20140908231401.25904.74802.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 08, 2014 at 04:14:01PM -0700, Darrick J. Wong wrote:
> Add a couple of tests to verify that writing to and recovering from
> an external journal work properly.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
