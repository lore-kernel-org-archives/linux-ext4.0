From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] jbd/jbd2: remove obsolete summarise_journal_usage.
Date: Sun, 8 May 2011 20:14:41 -0400
Message-ID: <20110509001441.GA4138@thunk.org>
References: <1304610859-480-1-git-send-email-tm@tao.ma>
 <20110505161454.GM5323@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tao Ma <tm@tao.ma>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56947 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754064Ab1EIAOr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 8 May 2011 20:14:47 -0400
Content-Disposition: inline
In-Reply-To: <20110505161454.GM5323@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 05, 2011 at 06:14:54PM +0200, Jan Kara wrote:
> On Thu 05-05-11 23:54:19, Tao Ma wrote:
> > From: Tao Ma <boyu.mt@taobao.com>
> > 
> > summarise_journal_usage seems to be obsolete for a long time,
> > so remove it.
>   Yes. Added to my tree. Thanks.

Hi Jan,

Did you take the whole patch (removing it for both jbd and jbd2) or
just for jbd?  I'm fine either way, I just want to know if I need to
worry about this patch.

Thanks,

							- Ted
