From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] [RESEND] ext3: set i_extra_isize of 11th inode
Date: Thu, 26 Aug 2010 14:29:31 +0200
Message-ID: <20100826122931.GJ3294@quack.suse.cz>
References: <20100825090551.DEB3.61FB500B@jp.fujitsu.com>
 <20100825230442.GH2738@quack.suse.cz>
 <20100826092636.C31C.61FB500B@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Andreas Dilger <adilger.kernel@dilger.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49942 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309Ab0HZMaQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Aug 2010 08:30:16 -0400
Content-Disposition: inline
In-Reply-To: <20100826092636.C31C.61FB500B@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 26-08-10 09:26:37, Masayoshi MIZUMA wrote:
> On Thu, 26 Aug 2010 01:04:42 +0200
> Jan Kara <jack@suse.cz> wrote:
> 
> >   So I'd rather choose a safer approach for ext3 - see attached patch - it
> > fixes the problem for me.  For ext4 your patch is definitely a way to go,
> > so please port it to ext4 and send it to Ted Tso. Thanks.
> This problem doesn't happen at ext4. Because, the i_extra_isize of 11th
> inode is set to the suitable value by ext4_iget().
  Ah, you are right. Sorry for confusion.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
