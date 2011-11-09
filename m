From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] ext4: expand commit callback
Date: Wed, 9 Nov 2011 05:17:07 -0500
Message-ID: <20111109101707.GA3639@infradead.org>
References: <4EBA4CC1.5020605@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@MIT.EDU>,
	Andreas Dilger <adilger@whamcloud.com>,
	linux-ext4@vger.kernel.org
To: Bobi Jam <bobijam@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:59167
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751265Ab1KIKRJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Nov 2011 05:17:09 -0500
Content-Disposition: inline
In-Reply-To: <4EBA4CC1.5020605@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 09, 2011 at 05:49:53PM +0800, Bobi Jam wrote:
> Hi,
> 
> This patch has been rebased on v3.2-rc1-91.
> 
> The per-commit callback was used by mballoc code to manage free
> space bitmaps after deleted blocks have been released. This patch
> expand it to contain multiple different callbacks.

It fails to explain why you do it, both in text and by sending it
together with a patch that actually makes use of it.

