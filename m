From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/8] xfstests: add --largefs check option
Date: Sun, 4 Dec 2011 16:14:54 -0500
Message-ID: <20111204211454.GA13000@infradead.org>
References: <1321875088-30801-1-git-send-email-david@fromorbit.com>
 <1321875088-30801-2-git-send-email-david@fromorbit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:57033
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754521Ab1LDVO6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 4 Dec 2011 16:14:58 -0500
Content-Disposition: inline
In-Reply-To: <1321875088-30801-2-git-send-email-david@fromorbit.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 21, 2011 at 10:31:21PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Make it easier to check large filesystems quickly by adding a
> --large-fs option to check to turn on shortcuts for large scratch
> device filesystem testing.
> 
> Also, reject invalid command line options with a usage message.

Looks good, except that the help text for it doesn't look overly useful.
I don't think we "optimise" for large filesystems, we simply fill most
of it, which is what the documentation should mention.

