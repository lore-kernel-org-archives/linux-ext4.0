From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Use s_csum_seed instead of i_csum_seed for xattr
 block csum.
Date: Sun, 2 Sep 2012 23:39:05 -0400
Message-ID: <20120903033905.GC5066@thunk.org>
References: <1340547236-2838-1-git-send-email-tm@tao.ma>
 <5044208B.2080008@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, "Darrick J. Wong" <djwong@us.ibm.com>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48512 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755853Ab2ICDjM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 2 Sep 2012 23:39:12 -0400
Content-Disposition: inline
In-Reply-To: <5044208B.2080008@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 03, 2012 at 11:14:19AM +0800, Tao Ma wrote:
> Hi Ted,
> 	As the corresponding kernel change has been merged, can this patch be
> merged to the e2fsporgs also?

Hi Tao,

I folded your change into the metadata checksum patches before I
applied them to the next branch (and which is now included in the
master branch).  So if you use the master/next branch, it should be
fully in sync with the kernel implementation of metadata checksum.
This was along with a number of other cleanups that I did to collapse
related patches before they got fully applied into e2fsprogs.

I have run xfstests with metadata checksum enabled in the kernel with
the development branch of e2fsprogs, and it passes, so I'm fairly
confident they are in sync.

One of the questions that we should consider in the near future is
when to cut a e2fsprogs 1.43 release.  Things which we might want to
consider adding before we cut 1.43 include the changes to fully
support online resize for 64-bit file systems, and possibly the inline
data patches, if we are confident in the e2fsprogs changes and that
the format of inline data is ready to be cast into concrete.

Regards,

						- Ted
