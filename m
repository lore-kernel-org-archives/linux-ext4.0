From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] resize2fs : Fix potential memory corruption in
	ext2fs_progress_init()G
Date: Wed, 1 Oct 2008 19:50:48 -0400
Message-ID: <20081001235048.GN10080@mit.edu>
References: <ea11fea30809140732i38680994na7d686835e2949cd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:34345 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751174AbYJAXuu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Oct 2008 19:50:50 -0400
Content-Disposition: inline
In-Reply-To: <ea11fea30809140732i38680994na7d686835e2949cd@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 14, 2008 at 08:02:12PM +0530, Manish Katiyar wrote:
> Since "prog" is not initialized with 0 , below check in
> ext2fs_progress_init() is wrong and may lead to corruptions.

Thanks, applied. (Sorry for the delay; I've been really busy the past
two weeks.)

					- Ted
