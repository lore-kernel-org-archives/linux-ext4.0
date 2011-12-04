From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/8] xfstests: use command line option for setting extra
 space
Date: Sun, 4 Dec 2011 16:16:30 -0500
Message-ID: <20111204211630.GB13000@infradead.org>
References: <1321875088-30801-1-git-send-email-david@fromorbit.com>
 <1321875088-30801-6-git-send-email-david@fromorbit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:57058
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754521Ab1LDVQc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 4 Dec 2011 16:16:32 -0500
Content-Disposition: inline
In-Reply-To: <1321875088-30801-6-git-send-email-david@fromorbit.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 21, 2011 at 10:31:25PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Allow the extra free space to leave in large scratch filesystems to
> be specified by a command line option rather than just via an
> environment variable.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

This probably should be documented in the help text.

