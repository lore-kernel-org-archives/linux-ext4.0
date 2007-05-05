From: Theodore Tso <tytso@mit.edu>
Subject: Re: PATCH: use CFLAGS when linking always
Date: Sat, 5 May 2007 15:26:48 -0400
Message-ID: <20070505192647.GC21049@thunk.org>
References: <200705050920.56558.dennis@ausil.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dennis Gilmore <dennis@ausil.us>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:39785 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933185AbXEET0u (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 5 May 2007 15:26:50 -0400
Content-Disposition: inline
In-Reply-To: <200705050920.56558.dennis@ausil.us>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, May 05, 2007 at 09:20:47AM -0500, Dennis Gilmore wrote:
> for multilib archs default CFLAGS may be inappropriate  and reslut in binaries 
> unable to be linked.  since e2fsprogs uses gcc for linking I noticed this 
> while building for sparc64.  patch has been tested and applied in Aurora 
> SPARC Linux. 

What options do you need, and why don't you just specify them via:

configure --with-ldopts="--foo-ld-flag"

					- Ted
