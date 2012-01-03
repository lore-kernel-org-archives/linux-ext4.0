From: Ted Ts'o <tytso@mit.edu>
Subject: Re: e4defrag modifies folder's mtime.
Date: Tue, 3 Jan 2012 15:34:43 -0500
Message-ID: <20120103203443.GC30502@thunk.org>
References: <4F00BE34.1080006@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Thomas Lindroth <thomas.lindroth@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36850 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755362Ab2ADDtd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Jan 2012 22:49:33 -0500
Content-Disposition: inline
In-Reply-To: <4F00BE34.1080006@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 01, 2012 at 09:12:36PM +0100, Thomas Lindroth wrote:
> I ran e4defrag from e2fsprogs-1.42 on a file system and a lot of
> folders had their mtime updated as a result. This confuses both my
> backup program and myself. I guess the folder timestamps change
> because the temporary donor file is created in the same directory as
> the original file. XFS's defrag program put the donor files in a
> temporary folder in the root of the file system. Maybe e4defrag
> could do the same.

Yes, that could be done if the user running the program (which does
not have to be root) has write access to the root directory of the
file system.  There will certainly be cases where this will not be
true, however.

					- Ted
