From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 1/3] Implement generic freeze feature
Date: Mon, 28 Apr 2008 09:03:58 -0400
Message-ID: <20080428130358.GB2798@infradead.org>
References: <20080428193123t-sato@mail.jp.nec.com> <20080428103719.GA16030@infradead.org> <2E042A67F72447F6AAA0CC0605DBFA84@nsl.ad.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
To: Takashi Sato <t-sato@yk.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47654 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934182AbYD1ND7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Apr 2008 09:03:59 -0400
Content-Disposition: inline
In-Reply-To: <2E042A67F72447F6AAA0CC0605DBFA84@nsl.ad.nec.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 28, 2008 at 09:59:55PM +0900, Takashi Sato wrote:
>> I think the protection against double freezes would be better done by
>> using a trylock on bd_mount_sem.
>
> bd_mount_sem can protect against only freezes and cannot protect against
> unfreezes.  If multiple unfreezes run in parallel,  the multiple up() for
> bd_mount_sem might occur incorrectly.

Indeed.  The bit flag would fix that because unfreeze could then check
for the bit beeing set first.  So that's probably the easiest way to go.

