From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] ext4: hold page lock when checking mapping in
 ext4_page_mkwrite
Date: Mon, 18 Jul 2011 22:13:28 -0400
Message-ID: <20110719021328.GA11918@infradead.org>
References: <1311004772-14675-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60933
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751235Ab1GSCNa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Jul 2011 22:13:30 -0400
Content-Disposition: inline
In-Reply-To: <1311004772-14675-1-git-send-email-josef@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 18, 2011 at 11:59:32AM -0400, Josef Bacik wrote:
> Pages can be evicted from cache outside of truncate, for example when
> invalidating pages after writing with O_DIRECT.  The only proper way to check
> page->mapping is under the page lock, so fix ext4_page_mkwrite to do this.
> Thanks,

Josef, please check the ext4_page_mkwrite implementation in the vfs
tree, which is just a wrapper around the generic code and thus shouldn't
have this problem any more.
