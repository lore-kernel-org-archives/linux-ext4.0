From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 7/8] xfstests: add new stress test
Date: Mon, 24 Oct 2011 05:08:13 -0400
Message-ID: <20111024090813.GB31887@infradead.org>
References: <1319020189-13584-1-git-send-email-dmonakhov@openvz.org>
 <1319020189-13584-8-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, jack@suse.cz, hch@infradead.org,
	aelder@sgi.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60480
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752398Ab1JXJIO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Oct 2011 05:08:14 -0400
Content-Disposition: inline
In-Reply-To: <1319020189-13584-8-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 19, 2011 at 02:29:48PM +0400, Dmitry Monakhov wrote:
> During stress testing we want to cover as much code paths as possible
> fsstress is very good for this purpose. But it has expandable nature
> (disk usage almost continually grow). So once it goes in no ENOSPC
> condition it will be where till the end. But by running 'dd' writers
> in parallel we can regularly trigger ENOSPC but only for a limited
> periods of time because each time it opens file with O_TRUNC.

Looks good, but please use a more useful subject line, e.g.

xfstests: add a new test that runs fsstress under ENOSPC conditions.
