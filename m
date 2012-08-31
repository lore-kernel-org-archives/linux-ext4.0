From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 hung tasks in linux-stable 3.0.41
Date: Fri, 31 Aug 2012 13:59:03 -0400
Message-ID: <20120831175903.GB6342@thunk.org>
References: <50406B29.1090403@profihost.ag>
 <20120831092859.GB19786@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
	stable@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48166 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378Ab2HaR7K (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 31 Aug 2012 13:59:10 -0400
Content-Disposition: inline
In-Reply-To: <20120831092859.GB19786@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 31, 2012 at 11:28:59AM +0200, Jan Kara wrote:
> > 
> > Is this problem known? Or is there a fix for 3.0.X available?
>   From a quick look, processes are waiting for IO so it may be that your
> disk is just loaded... Did it start happening after some change? Or do you
> experience unexpectedly low performance?

All of the processes waiting for I/O are waiting for a directory
block.  This makes me suspicious that perhaps an interrupt or I/O
request got lost.

Is this a repeatable failure, and is the stack traces always the same?

If so, you might want to try running badblocks on the device and make
sure that hardware issues have been ruled out.

     	  	   	       	    	  - Ted
