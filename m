From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH][2/15] e2fsprogs-config-before-cmdline.patch
Date: Mon, 6 Oct 2008 16:49:26 -0400
Message-ID: <20081006204926.GA8139@mit.edu>
References: <1223289068.4007.84.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Kalpak Shah <Kalpak.Shah@Sun.COM>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:37372 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754096AbYJFUt3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Oct 2008 16:49:29 -0400
Content-Disposition: inline
In-Reply-To: <1223289068.4007.84.camel@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 06, 2008 at 04:01:08PM +0530, Kalpak Shah wrote:
> The patch changes the order that the config file and command line are
> parsed so that command line has precedence.  It also adds a check to
> make sure only one -E option is passed on the command line as -E option
> parsing is not cumulative.

Hmm.  I wonder if we would be better off making -E option parsing
cumulative, especially if we are going to add a way of specifying some
extended options via the config file.  Comments?

							- Ted
