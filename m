From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: Fix reserved blocks calculation for mke2fs -m
 50%
Date: Thu, 20 Sep 2012 15:15:43 -0400
Message-ID: <20120920191543.GA25551@thunk.org>
References: <503F4B71.7090001@rs.jp.nec.com>
 <505A6BC2.4080803@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51793 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754051Ab2ITTPr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Sep 2012 15:15:47 -0400
Content-Disposition: inline
In-Reply-To: <505A6BC2.4080803@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 20, 2012 at 10:05:06AM +0900, Akira Fujita wrote:
> Hi Ted,
> 
> Could you check this patch?

My apologies, I forgot to send an ACK that this patch had been
accepted.  It's in the e2fsprogs repository as commit 321649c9f49:
"mke2fs: recalculate the reserved blocks when the last BG is
dropped". (I reworded the commit description slightly.)

The commit was added to the e2fsprogs repository on September 7th, and
was pushed out a few days later.

Thanks for noticing the problem and submitting the patch!

       	   	    		    	       - Ted
