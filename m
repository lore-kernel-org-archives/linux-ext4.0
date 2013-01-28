From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RESEND][PATCH 2/2 v2] ext4: let us fully support punching hole
 feature in fallocate
Date: Sun, 27 Jan 2013 23:57:13 -0500
Message-ID: <20130128045713.GA13680@thunk.org>
References: <1358493381-20150-1-git-send-email-wenqing.lz@taobao.com>
 <1358493381-20150-2-git-send-email-wenqing.lz@taobao.com>
 <20130125033201.GD28908@thunk.org>
 <20130128050442.GA12217@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45781 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753547Ab3A1E5Q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 27 Jan 2013 23:57:16 -0500
Content-Disposition: inline
In-Reply-To: <20130128050442.GA12217@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 28, 2013 at 01:04:42PM +0800, Zheng Liu wrote:
> 
> Sorry, my apology.  I found a bug in indirect-based hole punching patch
> when I tried to create a new test case in xfstest.  A patch has been
> sent out.  Please look at it.

Ah yes, this must be the patch found at:

   http://patchwork.ozlabs.org/patch/216105/

It would it make sense for me to fold this into the punch hole patch,
yes?  (Since I haven't pushed out the patch yet, I might as well just
fold in the bugfix into the feature patch.)

     	    	   	    	    - Ted
