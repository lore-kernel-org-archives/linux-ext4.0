From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix an incorrect comment about i_mutex
Date: Tue, 25 Dec 2012 13:30:32 -0500
Message-ID: <20121225183032.GB5318@thunk.org>
References: <1323a2735a9106cf0fa1a6ffee938ce432aa085d.1356117764.git.luto@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40281 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754058Ab2LYSai (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Dec 2012 13:30:38 -0500
Content-Disposition: inline
In-Reply-To: <1323a2735a9106cf0fa1a6ffee938ce432aa085d.1356117764.git.luto@amacapital.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 21, 2012 at 11:24:58AM -0800, Andy Lutomirski wrote:
> i_mutex is not held when ->sync_file is called.
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>

Thanks, applied.

						- Ted
