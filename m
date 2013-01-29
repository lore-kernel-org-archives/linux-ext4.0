From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/4] ext4: release buffer when checksum failed
Date: Mon, 28 Jan 2013 21:25:57 -0500
Message-ID: <20130129022557.GF7003@thunk.org>
References: <1358496074-6228-1-git-send-email-yan@linux.vnet.ibm.com>
 <20130118212838.GO6426@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Guo Chao <yan@linux.vnet.ibm.com>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45962 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645Ab3A2C0C (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2013 21:26:02 -0500
Content-Disposition: inline
In-Reply-To: <20130118212838.GO6426@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 18, 2013 at 01:28:38PM -0800, Darrick J. Wong wrote:
> On Fri, Jan 18, 2013 at 04:01:11PM +0800, Guo Chao wrote:
> > Commit b0336e8d (ext4: calculate and verify checksums of directory leaf
> > blocks) and commit dbe89444 (ext4: Calculate and verify checksums for
> > htree nodes) forget to release buffer when checksum failed, at some places.
> > 
> > Cc: D. J. Wong <darrick.wong@oracle.com>
> > Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
> 
> I think this looks ok...
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
