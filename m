From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3] ext4: Rewrite ext4_page_mkwrite() to use generic
 helpers
Date: Thu, 23 Jun 2011 07:51:44 -0400
Message-ID: <20110623115144.GA13776@infradead.org>
References: <1308767062-27695-1-git-send-email-jack@suse.cz>
 <20110623103937.GB5171@infradead.org>
 <20110623110918.GB4229@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:38078
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759238Ab1FWLvr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Jun 2011 07:51:47 -0400
Content-Disposition: inline
In-Reply-To: <20110623110918.GB4229@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 23, 2011 at 01:09:18PM +0200, Jan Kara wrote:
> > more readable, even if there is a tiny amount of code duplication.
>   The trouble is that ext4 falls backs to standard allocation instead of
> delayed allocation when we run low on free space. So complete separation
> of these two cases is not possible. Also inode data journal flag can be
> set on the fly so we have to check it even in delalloc mkwrite
> implementation.

Yikes!  Ok, in that case there's no benefit in doing the split.

