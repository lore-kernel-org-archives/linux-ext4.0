From: Theodore Tso <tytso@mit.edu>
Subject: Re: [E2FSPROGS, PATCH] Fix "make docs" rule in Makefile for doc
	folder.
Date: Sun, 13 Apr 2008 17:21:26 -0400
Message-ID: <20080413212126.GA18156@mit.edu>
References: <ea11fea30804101255g4d4c772eh2016563954802713@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:57727 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752767AbYDNLgz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Apr 2008 07:36:55 -0400
Content-Disposition: inline
In-Reply-To: <ea11fea30804101255g4d4c772eh2016563954802713@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 11, 2008 at 01:25:47AM +0530, Manish Katiyar wrote:
> On systems which don't have makeinfo installed by default, "make" or
> "make docs" fails with the following error
> /home/mkatiyar/e2fs-git> make docs
> make[1]: Entering directory `/home/mkatiyar/e2fs-git/doc'
>         MAKEINFO libext2fs.info
> make[1]: makeinfo: Command not found
> make[1]: [libext2fs.info] Error 127 (ignored)
> 
> This patch makes it to bail out with proper error message when
> makeinfo is not present.

Can you send me a Signed-off-by for your patch, per the
SUBMITTING-PATCHES file in the e2fsprogs sources?

Many thanks,

	      	  	    	   	 - Ted
