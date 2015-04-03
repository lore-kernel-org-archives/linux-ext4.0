From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 00/22] ext4 encryption patches
Date: Thu, 2 Apr 2015 21:57:46 -0400
Message-ID: <20150403015746.GA10991@thunk.org>
References: <1428012659-12709-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jaegeuk@kernel.org, mhalcrow@google.com
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48406 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbbDCB5t (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Apr 2015 21:57:49 -0400
Content-Disposition: inline
In-Reply-To: <1428012659-12709-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 02, 2015 at 06:10:37PM -0400, Theodore Ts'o wrote:
> 
> There is a design document here.  It should hopefully be mostly up to
> date, but there are a few things that we might end up changing (for
> example, just using CTS all the time for protecting directory file
> names).
> 
> https://docs.google.com/document/d/1IsyQ9DU1gA6NUqS0jF4ni_NTvv-b0HfCkRk47Zkd7W0

Andreas pointed out this URL wasn't working due to access control
issues; my bad.  Please try this one instead.

https://docs.google.com/document/d/1ft26lUQyuSpiu6VleP70_npaWdRfXFoNnB8JYnykNTg

						- Ted
