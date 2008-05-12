From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC PATCH 6/9][e2fsprogs] Add 64-bit ext_attr interface.
Date: Mon, 12 May 2008 10:47:13 -0400
Message-ID: <20080512144713.GD7029@mit.edu>
References: <20080509163928.15484.22146.stgit@gara> <20080509164005.15484.23414.stgit@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:45055 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751212AbYELOrP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 May 2008 10:47:15 -0400
Content-Disposition: inline
In-Reply-To: <20080509164005.15484.23414.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 09, 2008 at 11:40:05AM -0500, Jose R. Santos wrote:
> From: Jose R. Santos <jrs@us.ibm.com>
> 
> Add 64-bit ext_attr interface.
> 
> Add ext2fs_read_ext_attr2(), ext2fs_write_ext_attr2() and
> ext2fs_adjust_ea_refcount2() that take blk64_t as an input.

Remind me --- did we ever figure out where we are going to store the
high 32 bits of the external extended attribute block?  The low 32
bits are stored in i_file_acl, but I don't remember if we decided
where to put the high 32 bits?

							- Ted
