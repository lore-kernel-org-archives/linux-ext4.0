From: Theodore Tso <tytso@mit.edu>
Subject: Re: possible (ext4 related?) memory leak in kernel 2.6.26
Date: Tue, 7 Oct 2008 18:12:56 -0400
Message-ID: <20081007221256.GF15929@mit.edu>
References: <20080930211854.GZ10831@mit.edu> <20080930222358.1FF30EAC415@quatramaran.ens.fr> <20081003003548.GA18138@mit.edu> <20081005091526.GA678@goelette.ens.fr> <20081005122752.GB27335@mit.edu> <20081005161214.GA2985@goelette.ens.fr> <20081006025006.GA9289@mit.edu> <48EA2F20.7020309@redhat.com> <20081006175502.GA12937@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Quentin Godfroy <godfroy@clipper.ens.fr>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Quentin Godfroy <godfroy@clipper.ens.fr>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:37087 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754618AbYJGWNI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Oct 2008 18:13:08 -0400
Content-Disposition: inline
In-Reply-To: <20081006175502.GA12937@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 06, 2008 at 01:55:02PM -0400, Theodore Tso wrote:
> Here are updates to the two patches I sent you.  The first fixes some
> printk labels and requires that the debugging dump ioctl be triggered
> by root; the second fixes the think-o that Eric pointed out earlier
> this morning.

Hey Quentin, just wanted to check in and find out if the patches seem
to be working for you.  They seem to solve the problem on my side; I
can no longer reproduce the problem.  Is it working for you?

Thanks, regards,

       	      		    	      	    - Ted
