From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] ext4: remove the entry from es tree when bigalloc is
 enabled
Date: Tue, 30 Jul 2013 18:14:36 +0200
Message-ID: <20130730161436.GC22013@quack.suse.cz>
References: <1374795726-28859-1-git-send-email-wenqing.lz@taobao.com>
 <20130729162151.GH11816@thunk.org>
 <20130729234425.GB3648@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.cz>, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45966 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948Ab3G3QOl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Jul 2013 12:14:41 -0400
Content-Disposition: inline
In-Reply-To: <20130729234425.GB3648@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 30-07-13 07:44:25, Zheng Liu wrote:
> Sorry for my bad description.  As Jan said, this patch doesn't address
> any issue.  It just makes the code clearly.  After applied this patch,
> I still get the warning messages from ext4_da_release_space running
> xfstests #74 when blocksize = 1k.
  Interesting. I never noticed those but now I see them as well. Dave Jones
also reported this problem (although he didn't mention 1KB blocksize).
I'll try to have a look into it.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
