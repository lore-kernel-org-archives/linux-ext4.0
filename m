From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC PATCH] ext4: don't split xattr inode refcounts across
 i_ctime and i_version fields
Date: Thu, 11 Jan 2018 17:41:50 -0500
Message-ID: <20180111224150.GK19241@thunk.org>
References: <20180109144701.27387-1-jlayton@kernel.org>
 <20180109185249.GA5594@magnolia>
 <1515524731.3571.16.camel@kernel.org>
 <20180111183914.GE19241@thunk.org>
 <1515701343.3788.19.camel@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        dhowells@redhat.com
To: Jeff Layton <jlayton@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38574 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933341AbeAKWl5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 11 Jan 2018 17:41:57 -0500
Content-Disposition: inline
In-Reply-To: <1515701343.3788.19.camel@kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 11, 2018 at 03:09:03PM -0500, Jeff Layton wrote:
> 
> Wouldn't it have made more sense to just store it all in i_version field
> (like this patch makes it do)? If this breaks backward compatibility
> though, then I'm fine with just dropping the patch.

Yes, that part is there for compatibility for the deployed base
(Lustre Servers).

					- Ted
