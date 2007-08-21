From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC] mballoc patches
Date: Tue, 21 Aug 2007 16:00:43 -0500
Message-ID: <46CB527B.5090300@redhat.com>
References: <1187000545401-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <46C08902.7020709@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625AbXHUVHQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Aug 2007 17:07:16 -0400
In-Reply-To: <46C08902.7020709@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Aneesh Kumar K.V wrote:
> 
> 
> I am attaching below the PATCH 2/4 in .gz format. The uncompressed one
> got dropped by the list.
> 
> -aneesh

hmm makes it hard to comment in-line though :)  So basing this on the
patch currently in the git repo.

+/*
+ * default stripe size = 1MB
+ */
+#define MB_DEFAULT_STRIPE              256

Units?  Doesn't seem to matter anyway as it's never referenced.

+       /* tunables */
+       unsigned long s_mb_factor;
+       unsigned long s_stripe;
+       unsigned long s_mb_small_req;
+       unsigned long s_mb_large_req;
+       unsigned long s_mb_max_to_scan;
+       unsigned long s_mb_min_to_scan;

could we get some comments here as to what these are, and what units?

Same is true many places... for example

+static int mb_find_extent(struct ext4_buddy *e3b, int order, int block,
+                               int needed, struct ext4_free_extent *ex)

how many "what" are needed?

And perhaps an addition of the new mount options to
Documentation/fs/ext4.txt would be good.

+#define EXT4_MB_BITMAP(e3b)    ((e3b)->bd_bitmap)
+#define EXT4_MB_BUDDY(e3b)     ((e3b)->bd_buddy)

For the sake of consistency should these (and others) be e4b?

Also there are a *lot* of BUGs and BUG_ONs added in this patch... are
none of these recoverable?

Thanks,

-Eric
