From: Jan Kara <jack@suse.cz>
Subject: Re: kernel oops in jbd2_journal_get_descriptor_buffer
Date: Thu, 11 Oct 2012 17:28:28 +0200
Message-ID: <20121011152828.GA8001@quack.suse.cz>
References: <50768765.8040406@ti.com>
 <20121011095932.GA16624@quack.suse.cz>
 <5076E449.5000004@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
To: Clement Gallin-Douathe <c-gallin-douathe@ti.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34431 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932303Ab2JKP2b (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Oct 2012 11:28:31 -0400
Content-Disposition: inline
In-Reply-To: <5076E449.5000004@ti.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 11-10-12 17:22:49, Clement Gallin-Douathe wrote:
> Jan,
> 
> Thanks for your answer.
> I have checked and I have no tricks with mapping flags (mount ext4
> options : rw,nosuid,nodev,noatime,errors=continue,data=ordered)
> I have added high mem verification on grow_dev_page function just
> after the page creation with find_or_create_page function.
> PageHighMem() is not null.
> So you think, it's a good idea to look into mm/page_alloc.c and
> verify gfp flags?
  Yep. Check what gfp flags are passed to find_or_create_page() and if
there if no __GFP_HIGH set, drill down into find_or_create_page() and
further to mm/page_alloc.c to find out where we get the page from.

								Honza
> On 10/11/2012 11:59 AM, Jan Kara wrote:
> >!__GFP_HIGH in particular. So does the device ext4 is mounted on play
> >some tricks with mapping fl
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
