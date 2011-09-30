From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: Fix various errors result from
 crc32c/metadata checksum integration
Date: Fri, 30 Sep 2011 17:12:29 -0400
Message-ID: <20110930211229.GG12440@thunk.org>
References: <20110930193843.GS12086@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47456 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755275Ab1I3VMd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Sep 2011 17:12:33 -0400
Content-Disposition: inline
In-Reply-To: <20110930193843.GS12086@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 30, 2011 at 12:38:43PM -0700, Darrick J. Wong wrote:
> Fix several minor errors in structure definitions, the byteswap code, and
> Makefiles that result from merging the crc32c and initial parts of the metadata
> checksumming patchset.
> 
> (This fix is required by the metadata checksumming patchset)
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

Oops, thanks for catching these.  I've applied this patch to the next
branch of e2fsprogs.

						- Ted
