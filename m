From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsck shouln't consider superblock summaries as fatal
Date: Tue, 26 Aug 2008 09:58:39 -0500
Message-ID: <48B41A1F.5060809@redhat.com>
References: <20080826104502.GH3392@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:58881 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755333AbYHZPBF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Aug 2008 11:01:05 -0400
In-Reply-To: <20080826104502.GH3392@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> Running e2fsck on a quiescent (but mounted) filesystem fails in the
> common case where the superblock inode and block count summaries are
> wrong.  The kernel doesn't update these values except at unmount time.
> If there are other errors in the filesystem then they will already
> cause e2fsck to consider the filesystem invalid, so these minor errors
> should not.

If by quiescent, if you mean ->write_super_lockfs, shouldn't that path
be indistinguishable from an unmount?  Why wouldn't write_super_lockfs
also update these counts, rather than working around it in fsck?

-Eric

> Don't consider only an error in the superblock summary as incorrect.
> The kernel does not update this field except at unmount time.  Any
> other unfixed errors will themselves mark the filesystem invalid.
> 
> Signed-off-by: Andreas Dilger <adilger@sun.com>
