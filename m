From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [BUG][data=journal] general protection fault is hitted when we
 run xfstests #074
Date: Mon, 11 Mar 2013 13:33:23 -0400
Message-ID: <20130311173323.GB6481@thunk.org>
References: <20130307122019.GC2800@gmail.com>
 <20130307122638.GD6723@quack.suse.cz>
 <20130308125545.GA18986@gmail.com>
 <20130311132717.GD29799@quack.suse.cz>
 <20130311140646.GA5266@gmail.com>
 <20130311163338.GM29799@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <gnehzuil.liu@gmail.com>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52577 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868Ab3CKRd1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Mar 2013 13:33:27 -0400
Content-Disposition: inline
In-Reply-To: <20130311163338.GM29799@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 11, 2013 at 05:33:38PM +0100, Jan Kara wrote:

> > 
> > Yup, but I don't think it is a very urgent bug because I need to run a
> > stress test case a lot of times to hit it, and in practice we don't
> > receive any report yet.  Certainly we need to keep it in mind.
>   Actually, it wasn't that hard. Attached patch should fix the issue.

Looks good.  Jan, Zheng, thank you very much for debugging this issue!

I've added a cc:stable@vger.kernel.org to this commit since this looks
like it would be a good one to backport.

(Let me know if there are other bugs currently on the dev branch which
you think should be backported; the general criteria is that it should
be a bug which is serious enough, as well as sufficiently low risk,
that distro kernels would want it.)

					- Ted
