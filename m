From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 07/21] libext2fs: don't fail inline data operations if
 there's no EA
Date: Sun, 10 Aug 2014 18:31:29 -0400
Message-ID: <20140810223129.GS15431@thunk.org>
References: <20140805010457.2611.89813.stgit@birch.djwong.org>
 <20140805010543.2611.86125.stgit@birch.djwong.org>
 <20140808224640.GH11191@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53468 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173AbaHJWbc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Aug 2014 18:31:32 -0400
Content-Disposition: inline
In-Reply-To: <20140808224640.GH11191@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 08, 2014 at 03:46:40PM -0700, Darrick J. Wong wrote:
> Fix up the rest of the inline data code not to complain if there's no
> EA, since it's possible that there's no EA because we're in the
> process of creating an inline data file.  Also, don't return an error
> code when removing a nonexistent EA, because there's no reason to.
> 
> Furthermore, if we write less than 60 bytes of inline data, remove the
> EA to avoid wasting space.
> 
> v2: Fix a few more places where inline data functions would totally
> fail if the EA was missing, even though the EA's presence isn't
> required.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
