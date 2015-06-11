From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 14/14] misc: add fuse2fs, a FUSE server for e2fsprogs
 (v4.3)
Date: Wed, 10 Jun 2015 20:13:37 -0400
Message-ID: <20150611001337.GI24181@thunk.org>
References: <20150514002108.10785.85860.stgit@birch.djwong.org>
 <20150514002240.10785.35238.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58962 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbbFKCmx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Jun 2015 22:42:53 -0400
Content-Disposition: inline
In-Reply-To: <20150514002240.10785.35238.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 13, 2015 at 05:22:40PM -0700, Darrick J. Wong wrote:
> This is the initial implementation of a FUSE server based on
> e2fsprogs.  The point of this program is to enable ext4 to run on any
> OS that FUSE supports (and doesn't already have a native driver), such
> as MacOS X, BSDs, and Windows.  The code requires FUSE API v28, which
> is available in Linux fuse and osxfuse releases that are available as
> of August 2013.

Thanks, applied.

						- Ted
						
