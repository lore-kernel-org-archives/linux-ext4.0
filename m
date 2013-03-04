From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/5] ext4: ext4_split_extent shoult take care about
 extent zeroout v3
Date: Mon, 4 Mar 2013 00:58:13 -0500
Message-ID: <20130304055813.GA18360@thunk.org>
References: <1361808463-25471-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz, wenqing.lz@taobao.com,
	Zheng Liu <gnehzuil.liu@gmail.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51152 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990Ab3CDF60 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Mar 2013 00:58:26 -0500
Content-Disposition: inline
In-Reply-To: <1361808463-25471-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dmitry,

Thanks for working on these patches.  They look good!  I've dropped
them into the ext4 tree in the dev branch, and am starting to run
tests on them.

Zheng, since some of your fix up patches look like they touch some of
the code modified by Dmitry's patches, could you rebase your patch set
on top of the dev branch (which is what we've pushed to Linus plus
Dmitry's patches)?   Thanks!!

						- Ted
