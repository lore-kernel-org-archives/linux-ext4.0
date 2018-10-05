Return-Path: <SRS0=0MVU=MR=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34974 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726737AbeJFGu5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 6 Oct 2018 02:50:57 -0400
Date: Fri, 5 Oct 2018 19:49:52 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-ext4@vger.kernel.org, linux-doc@vger.kernel.org,
        corbet@lwn.net
Subject: Re: [PATCH 2/2] docs: promote the ext4 data structures book to top
 level
Message-ID: <20181005234952.GC2548@thunk.org>
References: <153870117116.30837.1220267868954289184.stgit@magnolia>
 <153870118415.30837.3990077919915459798.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153870118415.30837.3990077919915459798.stgit@magnolia>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 04, 2018 at 05:59:44PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the ext4 data structures book to Documentation/filesystems/ext4/
> since the administrative information moved elsewhere.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied and pushed out to the ext4.git tree.

Randy, Jon: the original patch didn't make it past vger.kernel.org
because it was too large (it was moving a lot of files around).  It
looked fine to me, but if you want to take a look it should be on the
dev branch of the ext4.git tree.

					- Ted
