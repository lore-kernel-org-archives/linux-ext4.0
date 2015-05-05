From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 20/35] debugfs: optionally create undo file
Date: Tue, 5 May 2015 10:43:19 -0400
Message-ID: <20150505144319.GG9260@thunk.org>
References: <20150402023359.25243.79782.stgit@birch.djwong.org>
 <20150402023611.25243.74612.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45919 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993228AbbEEOnU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 May 2015 10:43:20 -0400
Content-Disposition: inline
In-Reply-To: <20150402023611.25243.74612.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 01, 2015 at 07:36:11PM -0700, Darrick J. Wong wrote:
> Provide the user with an option to create an undo file so that they
> can roll back a failed debugfs expedition.
> 
> v2: Support reopening undo files.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
