From: "Akinobu Mita" <akinobu.mita@gmail.com>
Subject: Re: [PATCH] ext4: annotate unhandled kmem_cache_alloc() error
Date: Wed, 24 Dec 2008 07:37:48 +0900
Message-ID: <961aa3350812231437x4debaf9byf230a63582561010@mail.gmail.com>
References: <20081223104016.GC7217@localhost.localdomain>
	 <20081223142915.GA23303@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	"Theodore Tso" <tytso@mit.edu>, adilger@sun.com,
	linux-ext4@vger.kernel.org
To: "Josef Bacik" <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:36258 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbYLWWhu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Dec 2008 17:37:50 -0500
In-Reply-To: <20081223142915.GA23303@unused.rdu.redhat.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> BUG_ON is good for devel things, but for stable stuff it's better to let
> somebody know an error occured rather than panic'ing the box.  The proper
> solution would be to do
>
> if (!new_entry)
>        return -ENOMEM;
>
> or if there is some out: label set ret to -ENOMEM and goto out, whatever is
> appropriate in the context.  Thanks,

I don't understand the code around here well.
But I think it is not that simple.

The "new_entry" is needed to free blocks. If it just returns error,
it leaks something.
