From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 3/5] ext4: fix wrong m_len value after unwritten
 extent conversion
Date: Tue, 12 Mar 2013 22:14:20 -0400
Message-ID: <20130313021420.GB16919@thunk.org>
References: <1362579435-6333-1-git-send-email-wenqing.lz@taobao.com>
 <1362579435-6333-4-git-send-email-wenqing.lz@taobao.com>
 <20130311010718.GC10090@thunk.org>
 <20130311054707.GA3867@gmail.com>
 <20130313015741.GA16919@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53000 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755285Ab3CMCO0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Mar 2013 22:14:26 -0400
Content-Disposition: inline
In-Reply-To: <20130313015741.GA16919@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Oh, now I see my confusion.  You're talking about retval being
different from the output of map->m_len.  I was talking about retval
being often different from the *input* value of map->m_len.

I agree that the output of ext4_ext_map_blocks() and
ext4_ind_map_blocks() should be the same as map->m_len, and having a
BUG_ON there would make sense.  But we can save those changes for
after -rc3 as a cleanup....

					- Ted
