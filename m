From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: fix build errors on bigendian hosts
Date: Tue, 8 Apr 2014 14:34:05 -0400
Message-ID: <20140408183405.GH31558@thunk.org>
References: <1395915444-2225-1-git-send-email-guaneryu@gmail.com>
 <20140408113625.GB23533@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Eryu Guan <guaneryu@gmail.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51754 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756894AbaDHSeQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Apr 2014 14:34:16 -0400
Content-Disposition: inline
In-Reply-To: <20140408113625.GB23533@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 08, 2014 at 07:36:25PM +0800, Zheng Liu wrote:
> On Thu, Mar 27, 2014 at 06:17:24PM +0800, Eryu Guan wrote:
> > Fix the following build errors on bigendian hosts.

Thanks, applied.

					- Ted
