From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 12/14] debugfs: implement fallocate
Date: Wed, 10 Jun 2015 20:12:44 -0400
Message-ID: <20150611001244.GG24181@thunk.org>
References: <20150514002108.10785.85860.stgit@birch.djwong.org>
 <20150514002226.10785.49150.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58961 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbbFKCmx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Jun 2015 22:42:53 -0400
Content-Disposition: inline
In-Reply-To: <20150514002226.10785.49150.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 13, 2015 at 05:22:26PM -0700, Darrick J. Wong wrote:
> Implement a fallocate function for debugfs, and add some tests to
> demonstrate that it works (more or less).
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

						- Ted
