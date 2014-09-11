From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 27/25] tune2fs: always check disable_uninit_bg() return
 code
Date: Thu, 11 Sep 2014 18:07:02 -0400
Message-ID: <20140911220702.GC17990@thunk.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
 <20140911194333.GS10351@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: TR Reardon <thomas_reardon@hotmail.com>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52168 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbaIKWHE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Sep 2014 18:07:04 -0400
Content-Disposition: inline
In-Reply-To: <20140911194333.GS10351@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 11, 2014 at 12:43:33PM -0700, Darrick J. Wong wrote:
> Enhance disable_uninit_bg() to return error codes -- if something goes
> wrong, we want to flag the FS as needing a fsck and exit.  Mr. Reardon
> discovered that tune2fs -O ^metadata_csum on a FS with a corrupt
> bitmap would leave the FS in a weird state.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reported-by: TR Reardon <thomas_reardon@hotmail.com>

Thanks, applied.

						- Ted
