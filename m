From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH -v2] ext4: Dynamically allocate the jbd2_inode in
 ext4_inode_info as necessary
Date: Fri, 7 Jan 2011 17:40:18 -0500
Message-ID: <20110107224018.GR21922@thunk.org>
References: <20110106221404.GB2857@thunk.org>
 <1294367763-16275-1-git-send-email-tytso@mit.edu>
 <AANLkTikNqeX-e0uLwxG39TW0=qmr21jFs_-rJ1QOxOm2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59346 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355Ab1AGWkW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Jan 2011 17:40:22 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTikNqeX-e0uLwxG39TW0=qmr21jFs_-rJ1QOxOm2@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 07, 2011 at 10:46:29PM +0200, Amir Goldstein wrote:
> 
> actually, I though, jbd2_free_inode would be better off outside the spinlock,

Oops, yes, I agree.  Fixed.

					- Ted
