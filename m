From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/8] ext4: call out CRC and corruption errors with
 specific error codes
Date: Thu, 15 Oct 2015 10:47:34 -0400
Message-ID: <20151015144734.GI17329@thunk.org>
References: <20151012215416.28872.8160.stgit@birch.djwong.org>
 <20151012215452.28872.18688.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52065 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633AbbJOOrg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Oct 2015 10:47:36 -0400
Content-Disposition: inline
In-Reply-To: <20151012215452.28872.18688.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 12, 2015 at 02:54:52PM -0700, Darrick J. Wong wrote:
> Instead of overloading EIO for CRC errors and corrupt structures,
> return the same error codes that XFS returns for the same issues.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
