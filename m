From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/5] ext4: let ext4 journal deletion of data blocks
Date: Fri, 30 Dec 2011 10:05:57 -0500
Message-ID: <20111230150557.GC29547@thunk.org>
References: <1321344474-14707-1-git-send-email-xiaoqiangnk@gmail.com>
 <1321344474-14707-2-git-send-email-xiaoqiangnk@gmail.com>
 <20111228172324.GB12370@thunk.org>
 <CAGBYx2YbJZog0oNvyrvcyyEZ9sDQGaHZGgJyr4DxaZnX9L5fNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58776 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391Ab1L3PF7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Dec 2011 10:05:59 -0500
Content-Disposition: inline
In-Reply-To: <CAGBYx2YbJZog0oNvyrvcyyEZ9sDQGaHZGgJyr4DxaZnX9L5fNw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 30, 2011 at 10:59:48PM +0800, Yongqiang Yang wrote:
> Hi Ted,
> 
> The 2nd and 3rd patch aim to let ext4_free_blocks work with journal
> mode.  Consider that journal mode of a file is changed from ordered
> mode to journal mode and several data blocks are deleted, then bh
> passed in is NULL and sb_find_get_block returns NULL, but we need
> ext4_forget to handle the data blocks to record them in revoke table.

Ah, I see.  This wasn't obvious from the commit description.  Could
you combine patches #2 and #3, and add the above detail in the commit
description?

Many thanks!!

					- Ted
