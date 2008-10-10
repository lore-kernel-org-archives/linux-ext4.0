From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH updated] ext4: Fix file fragmentation during large file
	write.
Date: Fri, 10 Oct 2008 23:42:53 +0530
Message-ID: <20081010181253.GA20796@skywalker>
References: <1223661776-20098-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	chris.mason@oracle.com, akpm@linux-foundation.org,
	hch@infradead.org, steve@chygwyn.com, npiggin@suse.de,
	mpatocka@redhat.com, linux
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:59497 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757007AbYJJSNi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Oct 2008 14:13:38 -0400
Content-Disposition: inline
In-Reply-To: <1223661776-20098-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 10, 2008 at 11:32:56PM +0530, Aneesh Kumar K.V wrote:
> The range_cyclic writeback mode use the address_space
> writeback_index as the start index for writeback. With
> delayed allocation we were updating writeback_index
> wrongly resulting in highly fragmented file. Number of
> extents reduced from 4000 to 27 for a 3GB file with
> the below patch.
> 
> The patch also removes the range_cont writeback mode
> added for ext4 delayed allocation. Instead we add
> two new flags in writeback_control which control
> the behaviour of write_cache_pages.
> 

Need the below update. Will send the updated patch to ext4 list.

[2.6.27-rc9-1-working@linux-review-ext]$ git diff
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index a85930c..4f359f4 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -960,7 +960,7 @@ int write_cache_pages(struct address_space *mapping,
                goto retry;
        }
        if (!wbc->no_index_update &&
-               (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))) {
+               (wbc->range_cyclic || (range_whole && nr_to_write > 0))) {
                mapping->writeback_index = index;
        }
        if (!wbc->no_nrwrite_update)
