From: tytso@mit.edu
Subject: Re: [PATCH] ext4: Fix buffer head ref leaks after calls to
 ext4_get_inode_loc()
Date: Sat, 3 Apr 2010 17:44:56 -0400
Message-ID: <20100403214456.GB18524@thunk.org>
References: <6601abe91003220846x46a2a8d5u2769c0563910c7d3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33566 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860Ab0DCVo6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 3 Apr 2010 17:44:58 -0400
Content-Disposition: inline
In-Reply-To: <6601abe91003220846x46a2a8d5u2769c0563910c7d3@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 22, 2010 at 08:46:42AM -0700, Curt Wohlgemuth wrote:
> Fix buffer head reference leaks in ext4_write_inode() and
> ext4_xattr_fiemap().
> 
> Signed-off-by: Curt Wohlgemuth <curtw@google.com>

Added to ext4 patch queue

					- Ted
