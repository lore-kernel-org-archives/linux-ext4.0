From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: an issue of ext4
Date: Thu, 6 Mar 2014 20:52:55 -0500
Message-ID: <20140307015255.GA12443@thunk.org>
References: <CF3D3A3F.283D%hongchao.zhang@intel.com>
 <20140305125105.GA11600@thunk.org>
 <CF3CDE77.96870%andreas.dilger@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Zhang, Hongchao" <hongchao.zhang@intel.com>,
	Eric Sandeen <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Dilger, Andreas" <andreas.dilger@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38183 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785AbaCGBxC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Mar 2014 20:53:02 -0500
Content-Disposition: inline
In-Reply-To: <CF3CDE77.96870%andreas.dilger@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 06, 2014 at 11:57:15PM +0000, Dilger, Andreas wrote:
> However, looking more closely at the upstream kernel, I see that this
> code was changed by Dmitry Monakhov in v2.6.34-rc7-16-g84061e0 to
> move the counters after journal init (almost the same as Hongchao's
> patch does) but then you submitted a patch v2.6.37-rc1-3-gce7e010
> to initialize the percpu counters are both before and after the
> journal is loaded.  It isn't clear from your commit comment why
> the patch to load them both before and after was needed?

I can't remembe the code path that was referencing one or more of the
percpu counters, it must have been some non-common corner case, since
we didn't notice the issue right away, but I believe that's why the
change was made.  My bad for not including more details in the commit
description....

						- Ted
