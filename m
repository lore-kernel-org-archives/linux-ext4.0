From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: optionally run all tests under quota
Date: Tue, 9 Feb 2010 17:04:43 -0500
Message-ID: <20100209220443.GB20187@infradead.org>
References: <4B71B6E7.1000203@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs-oss <xfs@oss.sgi.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53264 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab0BIWEo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Feb 2010 17:04:44 -0500
Content-Disposition: inline
In-Reply-To: <4B71B6E7.1000203@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 09, 2010 at 01:26:31PM -0600, Eric Sandeen wrote:
> This patch might be a little heavy handed, but it seems to
> work; if you set USE_QUOTA=1 in your environment, all
> tests should be run with quota on and enabled.

I'd rather prefer a -quota option to ./check than a magic
environment variable.

