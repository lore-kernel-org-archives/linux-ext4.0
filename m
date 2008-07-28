From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 12/17] vfs: pagecache usage optimization for
	pagesize!=blocksize
Date: Mon, 28 Jul 2008 19:00:32 -0400
Message-ID: <20080728230031.GA22218@infradead.org>
References: <200807282246.m6SMkaHT032267@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: torvalds@linux-foundation.org, hifumi.hisashi@oss.ntt.co.jp,
	hch@infradead.org, jack@ucw.cz, linux-ext4@vger.kernel.org,
	nickpiggin@yahoo.com.au
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33548 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbYG1XAf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jul 2008 19:00:35 -0400
Content-Disposition: inline
In-Reply-To: <200807282246.m6SMkaHT032267@imap1.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 28, 2008 at 03:46:36PM -0700, akpm@linux-foundation.org wrote:
> From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
> 
> When we read some part of a file through pagecache, if there is a
> pagecache of corresponding index but this page is not uptodate, read IO is
> issued and this page will be uptodate.

I was under the impression we wanted to do this in a nicer way than 
the hacky method?

