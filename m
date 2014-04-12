From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] fs: Disallow all fallocate operation on active
 swapfile
Date: Sat, 12 Apr 2014 08:22:25 -0700
Message-ID: <20140412152225.GC18047@infradead.org>
References: <1397242665-2183-1-git-send-email-lczerner@redhat.com>
 <1397242665-2183-4-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44609 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbaDLPWZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 12 Apr 2014 11:22:25 -0400
Content-Disposition: inline
In-Reply-To: <1397242665-2183-4-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Given that the earlier patches were about races - what protects us
from swapon racing with the check outside the filesystem locks?

