From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC PATCH 1/3][e2fsprogs] Add 64-bit IO manager operations to
	struct_io_manager.
Date: Mon, 10 Mar 2008 10:40:42 -0400
Message-ID: <20080310144042.GE26651@mit.edu>
References: <20080303164113.5557.68102.stgit@gara> <20080303164118.5557.20139.stgit@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:42145 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750991AbYCJOky (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Mar 2008 10:40:54 -0400
Content-Disposition: inline
In-Reply-To: <20080303164118.5557.20139.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 03, 2008 at 10:41:18AM -0600, Jose R. Santos wrote:
> From: Jose R. Santos <jrs@us.ibm.com>
> 
> Add 64-bit IO manager operations to struct_io_manager.
> 
> In order to provide 64-bit block support for IO managers an maintain
> ABI compatibility with the old API, some new functions need to be
> added to struct_io_manger.  Luckily, strcut_io_manager has some
> reserved space that we can use to add these new functions.

Looks good, and I won't NACK this patch just because of this.
However, be aware that:

> -	int		reserved[14];
> +	errcode_t (*read_blk64)(io_channel channel, unsigned long long block,
> +					int count, void *data);
> +	errcode_t (*write_blk64)(io_channel channel, unsigned long long block,
> +					int count, const void *data);
> +	int		reserved[12];
>  };

... this doesn't really work on x86_64 platforms since int's are 4
bytes and pointers are 8 bytes.

*Fortunately* it doesn't really matter here since the reserved block
is mainly to make sure that there are sufficient zero-filled bytes
after the structure so that there is little or no risk that if new
code which looks for a new function pointer like read_blk64 tries to
access that area after the structure, it will find zero's.  

As it turns out we don't ever expect the user to allocate io manager
structures, and in fact the primary place (and probably the only
place) where io_managers are defined is in libext2fs --- although if a
user were to define their own io_manager in their program, we would be
relying on the reserved fields to provide enough zero-filled slack
space to avoid problems.

In structures where it you really do need to maintain structure sizes,
it is very important to have a separate reserved_int[16] and
reserved_ptr[16] array --- or better yet, make the structure private
and not visible to the external callers, using accessor functions as
necessary, and use a callee (as opposed to caller) allocation
convention, which removes the need for the caller (i.e., calling
application) to know the size of the structure.

This is all not relevant to the patch at hand, though (although I will
probably not decrease the size of the reserved array to provide slack
for future expansions), but is the sort of thing that should go into a
wiki for e2fsprogs coding/style conventions one of these days.  :-)

     	 	   			    	   - Ted
