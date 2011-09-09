From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] ext4: make quota as first class supported feature
Date: Fri, 9 Sep 2011 11:40:57 -0400
Message-ID: <20110909154057.GA7738@infradead.org>
References: <1313780769-21713-1-git-send-email-adityakali@google.com>
 <0EC4FCD1-1DBB-417C-BE5D-4B39ABD67A56@dilger.ca>
 <20110829204602.GI5672@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	Aditya Kali <adityakali@google.com>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:38986
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759259Ab1IIPlD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Sep 2011 11:41:03 -0400
Content-Disposition: inline
In-Reply-To: <20110829204602.GI5672@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 29, 2011 at 10:46:02PM +0200, Jan Kara wrote:
> The only pain point is repquota(8) - that needs a new kernel interface to
> work reliably (for ocfs2 and xfs we workaround the inability to iterate
> over all quota structures from userspace by using getpwent but that's just
> ugly).

Feel free to a new quotactl case to support it, but I don't reall see
the problem of the getpwent loop.

