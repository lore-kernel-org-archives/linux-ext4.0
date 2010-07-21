From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 0/2] mbcache fixes
Date: Thu, 22 Jul 2010 00:22:46 +0100
Message-ID: <20100721232245.GB903@ZenIV.linux.org.uk>
References: <4C46D1C5.90200@gmail.com>
 <4C46FD67.8070808@redhat.com>
 <20100721202637.4CC213C539AA@imap.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, hch@infradead.org,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-janitors <kernel-janitors@vger.kernel.org>,
	Wang Sheng-Hui <crosslonelyover@gmail.com>
To: Andreas Gruenbacher <agruen@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:48304 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292Ab0GUXWy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Jul 2010 19:22:54 -0400
Content-Disposition: inline
In-Reply-To: <20100721202637.4CC213C539AA@imap.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 21, 2010 at 07:57:20PM +0200, Andreas Gruenbacher wrote:
> Al,
> 
> here is an mbcache cleanup and then a fixed version of Shenghui's minor
> shrinker function fix.  The patches have survived functional testing
> here.
> 
> This seems slightly too much for kernel-janitors, so could you please
> take the patches?

Done.
