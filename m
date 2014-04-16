From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC PATCH v2 0/4] ext4: extents status tree shrinker improvement
Date: Wed, 16 Apr 2014 11:19:38 -0400
Message-ID: <20140416151938.GA17208@thunk.org>
References: <1397647830-24444-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55162 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161737AbaDPPTo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Apr 2014 11:19:44 -0400
Content-Disposition: inline
In-Reply-To: <1397647830-24444-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Zheng,

Thanks so much for your deep and detailed work on this.

I have two immediate reactions.

1) We should first fix __ext4_es_shrink so that we interpret
nr_to_scan correctly --- it's the number of objects to scan, not the
number of objects that we need to shirnk.  That should significantly
reduce the number of scans that we do, and fixing this could
potentially influence the metrics that we measure.

2) In addition to measuring the scan time, we should also measure how
many times we end up loading extents from disk when (during the course
of a normal workload) we are under memory pressure, and RR ends up
throwing out an extent that would have been saved in LRU, and so an
additional metadata read would be required when using RR.

	   	    	       	  	   - Ted
