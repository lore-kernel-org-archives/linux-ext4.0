From: tytso@mit.edu
Subject: Re: [PATCH] ext4: use __ext4_get_inode_loc() from
 ext4_write_inode()
Date: Sat, 3 Apr 2010 17:28:47 -0400
Message-ID: <20100403212847.GA18524@thunk.org>
References: <6601abe91003261501i1a12a953n9c2367ed4b0dd3b2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:52631 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756023Ab0DCV2x (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 3 Apr 2010 17:28:53 -0400
Content-Disposition: inline
In-Reply-To: <6601abe91003261501i1a12a953n9c2367ed4b0dd3b2@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 26, 2010 at 03:01:26PM -0700, Curt Wohlgemuth wrote:
> Fix for no-journal ext4_write_inode() code path: ensure in_mem is 0 on call
> to __ext4_get_inode_loc()
> 
> Signed-off-by: Curt Wohlgemuth <curtw@google.com>

Applied to the ext4 patch queue.

					- Ted
