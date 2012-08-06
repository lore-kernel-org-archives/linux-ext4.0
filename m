From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Exciting :-( adventures in metadata checksumming
Date: Mon, 6 Aug 2012 18:12:07 -0400
Message-ID: <20120806221207.GA30677@thunk.org>
References: <20120806164700.GA7896@thunk.org>
 <20120806181441.26850.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43333 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757016Ab2HFWML (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Aug 2012 18:12:11 -0400
Content-Disposition: inline
In-Reply-To: <20120806181441.26850.qmail@science.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 06, 2012 at 02:14:41PM -0400, George Spelvin wrote:
> 
> (Well, some problems with multiarch and not wanting to *install* without
> a new libcomerr2:i386 to match the new libcomerr2:amd64, but that's
> something I have to figure out.)

Obvious stupid question --- you don't have a 32-bit krb5 package or
something else which depewnds on libcomerr2:i386?

I'm using Debain testing and haven't noted any issues like this...

    	  	 	     	     	       - Ted




