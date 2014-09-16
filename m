From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] jbd2: free bh when descriptor block checksum fails
Date: Tue, 16 Sep 2014 14:43:58 -0400
Message-ID: <20140916184358.GK6205@thunk.org>
References: <20140914173252.31996.86784.stgit@birch.djwong.org>
 <20140914173305.31996.71172.stgit@birch.djwong.org>
 <5415E8E7.7010001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60329 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754576AbaIPSoB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Sep 2014 14:44:01 -0400
Content-Disposition: inline
In-Reply-To: <5415E8E7.7010001@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 14, 2014 at 02:13:43PM -0500, Eric Sandeen wrote:
> On 9/14/14 12:33 PM, Darrick J. Wong wrote:
> > Free the buffer head if the journal descriptor block fails checksum
> > verification.
> > 
> > This is the jbd2 port of the e2fsprogs patch "e2fsck: free bh on csum
> > verify error in do_one_pass".
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied.

					- Ted
