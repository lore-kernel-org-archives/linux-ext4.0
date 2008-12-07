From: Theodore Tso <tytso@mit.edu>
Subject: Re: [ext4] Documentation patch
Date: Sun, 7 Dec 2008 13:39:16 -0500
Message-ID: <20081207183916.GB15998@mit.edu>
References: <8763m3u9kv.fsf@basilikum.skogtun.org> <20081201165700.GA26680@infradead.org> <493425DC.1010008@redhat.com> <20081201205828.GA20069@mit.edu> <20081206222534.GJ1323@mit.edu> <493B0BAD.10004@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Harald Arnesen <skogtun.harald@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:41282 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752342AbYLGUby (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Dec 2008 15:31:54 -0500
Content-Disposition: inline
In-Reply-To: <493B0BAD.10004@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Good points.  OK, how about this?
     	      
  - When comparing performance with other filesystems, it's always
    important to try multiple workloads; very often a subtle change in a
    workload parameter can completely change the ranking of which
    filesystems do well compared to others.  When comparing versus ext3,
    note that ext4 enables write barriers by default, while ext3 does
    not enable write barriers by default.  So it is useful to use
    explicitly specify whether barriers are enabled or not when via the
    '-o barriers=[0|1]' mount option for both ext3 and ext4 filesystems
    for a fair comparison.  When tuning ext3 for best benchmark numbers,
    it is often worthwhile to try changing the data journaling mode; '-o
    data=writeback,nobh' can be faster for some workloads.  (Note
    however that running mounting with data=writeback can potentially
    leave stale data exposed in recently written files in case of an
    unclean shutdown, which could be a security exposure in some
    situations.)  Configuring the filesystem with a large journal can
    also be helpful for metadata-intensive workloads.

							- Ted
