From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs : Fix memory leak in ext2fs_initialize.
Date: Fri, 11 Jul 2008 14:41:49 -0400
Message-ID: <20080711184149.GB26656@mit.edu>
References: <ea11fea30807110332n459593eay3ce43cca67d5c676@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:37064 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753800AbYGKSly (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Jul 2008 14:41:54 -0400
Content-Disposition: inline
In-Reply-To: <ea11fea30807110332n459593eay3ce43cca67d5c676@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 11, 2008 at 04:02:06PM +0530, Manish Katiyar wrote:
> +	if (buf) {
> +	 ext2fs_free_mem(&buf);
> +	}

I'll fix this up and apply, but in the future, please respect the
surrounding whitespace rules of the source code.  For e2fsprogs that
means (among other things) each level is indented 8 spaces, no curly
braces are needed for single statements, and no white space at the end
of lines.

Thanks,

							- Ted
