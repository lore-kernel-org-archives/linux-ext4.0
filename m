From: Theodore Tso <tytso@mit.edu>
Subject: Re: issue of ext3_file_write function & remote shares
Date: Fri, 13 Feb 2009 09:03:07 -0500
Message-ID: <20090213140307.GC10683@mini-me.lan>
References: <1234529184.3927.3.camel@Q0405CPU53.qualexsystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Kavita Kulkarni <Kavita_Kulkarni@qualexsystems.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:60340 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761567AbZBMQ3P (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Feb 2009 11:29:15 -0500
Content-Disposition: inline
In-Reply-To: <1234529184.3927.3.camel@Q0405CPU53.qualexsystems.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 13, 2009 at 06:16:24PM +0530, Kavita Kulkarni wrote:
> The "ext3_file_write" function in the file
> "/usr/src/linux-source/fs/ext3/file.c" is called whenever a file is
> accessed/modified.

That's where you're wrong.  Files can also be modified via mmap(), and
file modifications that take place after files are memory mapped and
then modified via their memory mappings do not go through
ext3_file_write.

					- Ted
