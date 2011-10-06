From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfstest: fsstress add EXT2_IOC_{SET,GET}FLAGS
 operations
Date: Thu, 6 Oct 2011 15:52:06 -0400
Message-ID: <20111006195205.GI13434@infradead.org>
References: <1316357699-22692-1-git-send-email-dmonakhov@openvz.org>
 <1316357699-22692-2-git-send-email-dmonakhov@openvz.org>
 <1317820840.2226.12.camel@doink>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60975
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759168Ab1JFTwH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Oct 2011 15:52:07 -0400
Content-Disposition: inline
In-Reply-To: <1317820840.2226.12.camel@doink>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 05, 2011 at 08:20:40AM -0500, Alex Elder wrote:
> I have a question below.  I think this is probably
> a good addition, though it should be made so it
> works for more than EXTx.

I actually works on more than extN, but at this point it requires
the ext2 headers to compiled, which isn't too nice.

