From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: 64bit + resize2fs... this is Not Good.
Date: Wed, 14 Nov 2012 16:04:50 -0500
Message-ID: <20121114210450.GC23511@thunk.org>
References: <20121114054347.GA20380@thunk.org>
 <20121114072021.28351.qmail@science.horizon.com>
 <20121114203942.GA23511@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:32897 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505Ab2KNVEx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Nov 2012 16:04:53 -0500
Content-Disposition: inline
In-Reply-To: <20121114203942.GA23511@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 14, 2012 at 03:39:42PM -0500, Theodore Ts'o wrote:
> The reason why you lost so badly when you did an off-line resize was
> because you explicitly changed the resize limit default, via the -E
> resize=NNN option.  (Can you explain to me your thinking about why you
> specified this, just out of curiosity?)  Normally the default is 1000
> times the size of the original file system, or for a file system
> larger than 1.6TB, enough so that the file system can be resized to
> the maximum amount that can be supported via the resize_inode scheme,
> which is 16TB.

Correction: for any file system larger than 16GB....

	    	    	 	       - Ted
