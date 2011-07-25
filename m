From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] jbd: change the field "b_cow_tid" of struct journal_head
 from type unsigned to tid_t
Date: Mon, 25 Jul 2011 09:44:42 -0400
Message-ID: <20110725134442.GA9826@infradead.org>
References: <4E2D6961.9000909@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Wang Sheng-Hui <shhuiw@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:42263
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751178Ab1GYNpK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Jul 2011 09:45:10 -0400
Content-Disposition: inline
In-Reply-To: <4E2D6961.9000909@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 25, 2011 at 09:02:25PM +0800, Wang Sheng-Hui wrote:
> The patch is against 3.0
> 
> In the definition of struct journal_head, the comment for
> the field "unsigned b_cow_tid" says the field tracks the
> last transaction id in which this buffer has been cowed.

The correct fix is to simply remove the field, as it's entirely unused.

