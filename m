From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 0/6 v3] dax: Page invalidation fixes
Date: Mon, 12 Dec 2016 12:51:33 -0500
Message-ID: <20161212175133.GB8688@cmpxchg.org>
References: <20161212164708.23244-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        linux-mm@kvack.org, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gum.cmpxchg.org ([85.214.110.215]:52280 "EHLO gum.cmpxchg.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753724AbcLLRvh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 12 Dec 2016 12:51:37 -0500
Content-Disposition: inline
In-Reply-To: <20161212164708.23244-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 12, 2016 at 05:47:02PM +0100, Jan Kara wrote:
> Hello,
> 
> this is the third revision of my fixes of races when invalidating hole pages in
> DAX mappings. See changelogs for details. The series is based on my patches to
> write-protect DAX PTEs which are currently carried in mm tree. This is a hard
> dependency because we really need to closely track dirtiness (and cleanness!)
> of radix tree entries in DAX mappings in order to avoid discarding valid dirty
> bits leading to missed cache flushes on fsync(2).
> 
> The tests have passed xfstests for xfs and ext4 in DAX and non-DAX mode.
> 
> Johannes, are you OK with patch 2/6 in its current form? I'd like to push these
> patches to some tree once DAX write-protection patches are merged.  I'm hoping
> to get at least first three patches merged for 4.10-rc2... Thanks!

LGTM, thanks Jan
