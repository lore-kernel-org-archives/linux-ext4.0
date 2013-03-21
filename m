From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix journal callback list traversal
Date: Thu, 21 Mar 2013 12:16:53 -0400
Message-ID: <20130321161653.GB21877@thunk.org>
References: <1363880952-28758-1-git-send-email-dmonakhov@openvz.org>
 <874ng4ybpv.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, bobijam@whamcloud.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54876 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933678Ab3CUQQ5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Mar 2013 12:16:57 -0400
Content-Disposition: inline
In-Reply-To: <874ng4ybpv.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 21, 2013 at 08:11:24PM +0400, Dmitry Monakhov wrote:
> OOps. Sorry. I've sent wrong patch. Please ignore it. I'll send correct
> version in a minute.

Yeah, I just noticed that it doesn't compile.  Also, it looks like the
patch you sent wasn't actually checking the return value of
ext4_journal_callback_try_del()?

						- Ted
