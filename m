From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ext4] Documentation patch
Date: Mon, 1 Dec 2008 11:57:00 -0500
Message-ID: <20081201165700.GA26680@infradead.org>
References: <8763m3u9kv.fsf@basilikum.skogtun.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	tytso@mit.edu
To: Harald Arnesen <skogtun.harald@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58058 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbYLAQ5B (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Dec 2008 11:57:01 -0500
Content-Disposition: inline
In-Reply-To: <8763m3u9kv.fsf@basilikum.skogtun.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 01, 2008 at 05:46:56PM +0100, Harald Arnesen wrote:
>      So when comparing with a metadata-only journalling filesystem, such
> -    as ext3, use `mount -o data=writeback'.  And you might as well use
> +    as jfs or xfs, use `mount -o data=writeback'.  And you might as well use

data=ordered comes closest to what xfs does for quite a long time..

