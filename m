From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 01/13][e2fsprogs] Add initial checksum support.
Date: Mon, 15 Oct 2007 16:53:44 -0400
Message-ID: <20071015205344.GA18006@thunk.org>
References: <20071011191559.4599.69332.stgit@gara> <20071011191605.4599.34407.stgit@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:40101 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbXJOUy1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Oct 2007 16:54:27 -0400
Content-Disposition: inline
In-Reply-To: <20071011191605.4599.34407.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Oct 11, 2007 at 02:16:05PM -0500, Jose R. Santos wrote:
> @@ -66,7 +66,9 @@ OBJS= $(DEBUGFS_LIB_OBJS) $(RESIZE_LIB_OBJS) $(E2IMAGE_LIB_OBJS) \
>  	unix_io.o \
>  	unlink.o \
>  	valid_blk.o \
> -	version.o
> +	version.o \
> +	crc16.o \
> +	csum.o

Please keep the order of files in $(OBJS) and $(SRCS) in alphabetical
order.  There are two reasons for this; first of all, it makes it
easier to find files.  Secondly, it makes it less likely for there to
be merge collisions between two patches.  Thanks!!

						- Ted
