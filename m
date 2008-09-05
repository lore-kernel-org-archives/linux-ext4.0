From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] debugfs : Fix memory leaks in do_ncheck()
Date: Fri, 5 Sep 2008 08:37:41 -0400
Message-ID: <20080905123741.GF9129@mit.edu>
References: <ea11fea30809022253x6b8a493bkf7c92032c1cf479c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:43571 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752818AbYIEOgl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Sep 2008 10:36:41 -0400
Content-Disposition: inline
In-Reply-To: <ea11fea30809022253x6b8a493bkf7c92032c1cf479c@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 03, 2008 at 11:23:53AM +0530, Manish Katiyar wrote:
> Below patch fixes memory leaks in do_ncheck(). Also use this
> opportunity to fix the progname printed as "ncheck" instead of
> "do_ncheck" since all other messages
> in this file do so.

Applied, thanks.

					- Ted
