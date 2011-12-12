From: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 1/2] ext4: avoid hangs in
 ext4_da_should_update_i_disksize()
Date: Mon, 12 Dec 2011 17:57:59 +0100
Message-ID: <20111212165758.GF16411@redhat.com>
References: <1323656828-24465-1-git-send-email-aarcange@redhat.com>
 <1323656828-24465-2-git-send-email-aarcange@redhat.com>
 <CAGBYx2Y3WUc1m0BvTyrDcEyh0TTeLriWGA3YjgKcGoW=s8PYnw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710Ab1LLQ6Z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Dec 2011 11:58:25 -0500
Content-Disposition: inline
In-Reply-To: <CAGBYx2Y3WUc1m0BvTyrDcEyh0TTeLriWGA3YjgKcGoW=s8PYnw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 12, 2011 at 11:28:21AM +0800, Yongqiang Yang wrote:
> Hi Andrea,
> 
> I can not figure out why ext4 hangs.  Could you explain more on hanging?

Well I tried to explain it in the changeset comment.

If "copied" is zero, end/offset/idx becomes -1, and this loops:

	for (i = 0; i < idx; i++)

definitely a bug and checking ext4 git I don't see anything fixing it.
