From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/3] Make block_page_mkwrite() handle frozen fs (V2)
Date: Fri, 20 May 2011 13:59:53 -0400
Message-ID: <20110520175953.GE29282@thunk.org>
References: <1305731882-8334-1-git-send-email-jack@suse.cz>
 <20110518180022.GM18929@tux1.beaverton.ibm.com>
 <20110519105708.GD8417@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56907 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049Ab1ETSAA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 May 2011 14:00:00 -0400
Content-Disposition: inline
In-Reply-To: <20110519105708.GD8417@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 19, 2011 at 12:57:08PM +0200, Jan Kara wrote:
>   Since Ted has merged your stable pages patches touching ext4, I'll rebase
> my ext4 patch on top of that. Regarding block_page_mkwrite() I will add
> that one-liner to the series (because the ext4_page_mkwrite() now depends
> on that).

Hi Jan,

Does your 3/3 ext4 patch have dependencies on your 1/3 and 2/3
VFS-layer patches?

Thanks,

					- Ted
