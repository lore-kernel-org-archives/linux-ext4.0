From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] debugfs : Fix usage of logdump command to make
	consistent with man page.
Date: Wed, 1 Oct 2008 19:56:24 -0400
Message-ID: <20081001235624.GO10080@mit.edu>
References: <ea11fea30809120139w352d97a7ha355e79658190ba1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:54172 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750760AbYJAX40 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Oct 2008 19:56:26 -0400
Content-Disposition: inline
In-Reply-To: <ea11fea30809120139w352d97a7ha355e79658190ba1@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 12, 2008 at 02:09:19PM +0530, Manish Katiyar wrote:
> Below path adds the missing 's' option in the usage of logdump. Also
> trivially replace "inode" with "filespec" to make consistent with man
> page.

Thanks, applied.

						- Ted
