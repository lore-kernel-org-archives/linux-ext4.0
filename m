From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
Date: Mon, 19 Mar 2012 11:31:34 -0400
Message-ID: <20120319153133.GA2502@thunk.org>
References: <20120319040950.GG31682@thunk.org>
 <20120319.001430.1735750114727679638.davem@davemloft.net>
 <20120319043420.GL31682@thunk.org>
 <20120319.011211.89954160788757412.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: joe@perches.com, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57857 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309Ab2CSPbg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Mar 2012 11:31:36 -0400
Content-Disposition: inline
In-Reply-To: <20120319.011211.89954160788757412.davem@davemloft.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 19, 2012 at 01:12:11AM -0400, David Miller wrote:
> 
> It also allows you to modify pr_fmt at the top of the file or
> elsewhere and have it influence the output, as just one example
> of how it's better.
> 
> As a maintainer you can only take one of two positions:
> 
> 1) Accept all properly written patches that convert code over to use
>    the new and recommended way of doing things, such as pr_info() et
>    al.

Recommended by *who*?!?  Who dictated that this is the best way to go?

And in the past we've always allowed for local variations of style;
it's never been a strict style nazism.  Linus has always given
maintainers latitude and has frowned on patch churn for churn's sake.

For goodness sake we still have get_fs() and set_fs() in the kernel
code even though we haven't used the actual fs segment register in
over a decade.

And we're arguing over "there must be only one true logging
interface?!?".  This isn't Highlander.

						- Ted
