From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: ensure f_bfree returned by ext4_statfs() is
 non-negative
Date: Tue, 24 May 2011 18:23:52 -0400
Message-ID: <20110524222352.GI26055@thunk.org>
References: <4DDB6C3B.3020306@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 <linux-ext4@vger.kernel.org>
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34601 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753156Ab1EXWXy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 May 2011 18:23:54 -0400
Content-Disposition: inline
In-Reply-To: <4DDB6C3B.3020306@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks, added to the ext4 tree.

						- Ted
