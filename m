From: Theodore Tso <tytso@mit.edu>
Subject: Re: Simple inode question (ext2/3)
Date: Tue, 24 Feb 2009 16:05:15 -0500
Message-ID: <20090224210515.GA7064@mit.edu>
References: <20090224190709.GG5482@mit.edu> <alpine.DEB.2.00.0902241932530.2000@pintail.doc.ic.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Felipe Franciosi <ozzy@doc.ic.ac.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:39854 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365AbZBXVFT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Feb 2009 16:05:19 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0902241932530.2000@pintail.doc.ic.ac.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 24, 2009 at 07:32:53PM +0000, Felipe Franciosi wrote:
> Hi Ted,
> At this stage, it is just for practice. I'm building a kernel module
> that communicates with user space using a chardev and is able to
> take requests in order to read or change specific inode data. Right
> now, I'm just trying to dump the whole inode table.

Yeah, but this is a really bad idea.   Practice for *what*?

This isn't for some college class, is it?   

						- Ted
