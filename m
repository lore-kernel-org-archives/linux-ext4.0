From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v2] ext4: remove the entry from es tree when bigalloc is
 enabled
Date: Tue, 30 Jul 2013 07:44:25 +0800
Message-ID: <20130729234425.GB3648@gmail.com>
References: <1374795726-28859-1-git-send-email-wenqing.lz@taobao.com>
 <20130729162151.GH11816@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:42214 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab3G2Xou (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Jul 2013 19:44:50 -0400
Received: by mail-pd0-f177.google.com with SMTP id u11so6034282pdi.22
        for <linux-ext4@vger.kernel.org>; Mon, 29 Jul 2013 16:44:50 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130729162151.GH11816@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 29, 2013 at 12:21:51PM -0400, Theodore Ts'o wrote:
> On Fri, Jul 26, 2013 at 07:42:06AM +0800, Zheng Liu wrote:
> > From: Jan Kara <jack@suse.cz>
> > 
> > Now in ext4_da_page_release_reservation() we remove the entry from es
> > tree if to_release != 0.  But there are two issues.  One is that it is
> > wrong when blocksize != pagesize,
> 
> The commit description says that this is wrong, but I don't see
> anything in the patch which addresses this.  And could you state what
> the impact is of this wrongness?

Sorry for my bad description.  As Jan said, this patch doesn't address
any issue.  It just makes the code clearly.  After applied this patch,
I still get the warning messages from ext4_da_release_space running
xfstests #74 when blocksize = 1k.

Thanks,
                                                - Zheng
