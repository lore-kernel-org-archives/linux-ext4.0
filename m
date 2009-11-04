From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/4 v2] Direct IO return value fix for holes/fallocate
Date: Tue, 3 Nov 2009 21:09:15 -0500
Message-ID: <20091104020915.GF6510@mit.edu>
References: <1255050796.4931.190.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Curt Wohlgemuth <curtw@google.com>
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:37998 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753844AbZKDCJQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Nov 2009 21:09:16 -0500
Content-Disposition: inline
In-Reply-To: <1255050796.4931.190.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 08, 2009 at 06:13:16PM -0700, Mingming wrote:
> ext4: Direct IO return value fix for holes/fallocate
> 
> When direct IO complete, ext4 will convert unwritten extents to written,
> for
> writes over preallocated space, or holes.
> 
> ext4_direct_IO should returns the number of bytes read/write on success.
> However there is a bug that cause ext4_direct_IO returns the number of
> bytes converted to written extents, which is 0 on success. This bug
> causes
> direct IO falls back to buffered IO even on sucessful rewrites or
> preallocated space. 
> 
> Signed-off-by: Mingming Cao <cmm@us.ibm.com>

I fixed up some white space issues, and rewrote the patch descriptions
as follows:

ext4: fix ext4_ext_direct_IO()'s return value after converting uninit extents

After a direct I/O request covering an uninitalized extent (i.e.,
created using the fallocate system call) or a hole in a file, ext4
will convert the uninitialized extent so it is marked as initialized
by calling ext4_convert_unwritten_extents().  This function returns
zero on success.

This return value was getting returned by ext4_direct_IO(); however
the file system's direct_IO function is supposed to return the number
of bytes read or written on a success.  By returning zero, it confused
the direct I/O code into falling back to buffered I/O unnecessarily.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Added to the patch queue.

						- Ted
