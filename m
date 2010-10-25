From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] ext4: update writeback_index based on last page
 scanned
Date: Mon, 25 Oct 2010 17:35:50 -0400
Message-ID: <20101025213550.GK16981@thunk.org>
References: <4CC2023A.7060607@redhat.com>
 <4CC205ED.4090007@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:54140 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674Ab0JYVfz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Oct 2010 17:35:55 -0400
Content-Disposition: inline
In-Reply-To: <4CC205ED.4090007@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 22, 2010 at 04:45:17PM -0500, Eric Sandeen wrote:
> As pointed out in a prior patch, updating the mapping's
> writeback_index based on pages written isn't quite right;
> what the writeback index is really supposed to reflect is
> the next page which should be scanned for writeback during
> periodic flush.
> 
> As in write_cache_pages(), write_cache_pages_da() does
> this scanning for us as we assemble the mpd for later
> writeout.  If we keep track of the next page after the
> current scan, we can easily update writeback_index without
> worrying about pages written vs. pages skipped, etc.
> 
> Without this, an fsync will reset writeback_index to
> 0 (its starting index) + however many pages it wrote, which
> can mess up the progress of periodic flush.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Have you done any benchmarks with and without this patch series?

Say, compilebench on a used and mildly fragmented file system?

     		       	    	       - Ted
