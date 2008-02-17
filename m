From: "Akinobu Mita" <akinobu.mita@gmail.com>
Subject: Re: [PATCH 1/3] ext2: improve ext2_readdir() return value
Date: Mon, 18 Feb 2008 01:30:54 +0900
Message-ID: <961aa3350802170830r6c1e314cx1871e00db0e9b690@mail.gmail.com>
References: <20080217055612.GA3390@APFDCB5C> <20080217120926.GE8905@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	"Andrew Morton" <akpm@linux-foundation.org>
To: "Theodore Tso" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.247]:63751 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbYBQQa5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Feb 2008 11:30:57 -0500
Received: by an-out-0708.google.com with SMTP id d31so308573and.103
        for <linux-ext4@vger.kernel.org>; Sun, 17 Feb 2008 08:30:54 -0800 (PST)
In-Reply-To: <20080217120926.GE8905@mit.edu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2008/2/17, Theodore Tso <tytso@mit.edu>:
> On Sun, Feb 17, 2008 at 02:56:13PM +0900, Akinobu Mita wrote:
> > This patch improves ext2_readdir() return value for ext2_get_page() failure
> > by using the actual result of ext2_get_page().
>
> > -                     return -EIO;
> > +                     return PTR_ERR(page);
>
> The patch is harmless, and maybe even a good thing from an abstract
> point of view, but you realize that EIO is the only thing that
> ext2_get_page() can return, right?

There are some cases that ext2_get_page() returns -ENOMEM logically.
(--> read_mapping_page --> read_cache_page --> read_cache_page_async -->
     __read_cache_page --> page_cache_alloc_cold, or add_to_page_cache_lru)
But this is not likely to happen in reality.
