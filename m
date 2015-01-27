From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 10/54] tune2fs: abort when trying to enable/disable
 metadata_csum on mounted fs
Date: Tue, 27 Jan 2015 11:26:44 -0500
Message-ID: <20150127162644.GJ2453@thunk.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
 <20150127073638.13308.31584.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35380 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753841AbbA0Q0r (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Jan 2015 11:26:47 -0500
Content-Disposition: inline
In-Reply-To: <20150127073638.13308.31584.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 26, 2015 at 11:36:38PM -0800, Darrick J. Wong wrote:
> Earlier, I tried to make tune2fs abort if the user tried to enable or
> disable metadata_csum on a mounted FS, but forgot the exit() call.
> Supply it now.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
