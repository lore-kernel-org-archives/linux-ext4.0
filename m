From: Theodore Tso <tytso@mit.edu>
Subject: Re: optimising filesystem for many small files
Date: Sat, 17 Oct 2009 18:26:19 -0400
Message-ID: <20091017222619.GA10074@mit.edu>
References: <84c89ac10910162352x5cdeca37icfbf0af2f2325d7c@mail.gmail.com> <4AD9D599.3000306@redhat.com> <84c89ac10910171056i773dfb93wc2e917a086dd8ef0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, ext3-users@redhat.com,
	linux-ext4@vger.kernel.org
To: Viji V Nair <viji@fedoraproject.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:48010 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930AbZJQW0U (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 Oct 2009 18:26:20 -0400
Content-Disposition: inline
In-Reply-To: <84c89ac10910171056i773dfb93wc2e917a086dd8ef0@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 17, 2009 at 11:26:04PM +0530, Viji V Nair wrote:
> these files are not in a single directory, this is a pyramid
> structure. There are total 15 pyramids and coming down from top to
> bottom the sub directories and files  are multiplied by a factor of 4.
> 
> The IO is scattered all over!!!! and this is a single disk file system.
> 
> Since the python application is creating files, it is creating
> multiple files to multiple sub directories at a time.

What is the application trying to do, at a high level?  Sometimes it's
not possible to optimize a filesystem against a badly designed
application.  :-(

It sounds like it is generating files distributed in subdirectories in
a completely random order.  How are the files going to be read
afterwards?  In the order they were created, or some other order
different from the order in which they were read?

With a sufficiently bad access patterns, there may not be a lot you
can do, other than (a) throw hardware at the problem, or (b) fix or
redesign the application to be more intelligent (if possible).

	     		       	    		    - Ted
