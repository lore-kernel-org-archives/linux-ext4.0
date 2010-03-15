From: tytso@mit.edu
Subject: Re: New compiler warning in 2.6.34-rc1: 'start_ext.ee_block' may
 be used uninitialized
Date: Mon, 15 Mar 2010 11:41:42 -0400
Message-ID: <20100315154142.GB4484@thunk.org>
References: <4B9E475F.1010302@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Akira Fujita <a-fujita@rs.jp.nec.com>, linux-ext4@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46898 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932525Ab0COPlu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Mar 2010 11:41:50 -0400
Content-Disposition: inline
In-Reply-To: <4B9E475F.1010302@s5r6.in-berlin.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 15, 2010 at 03:42:39PM +0100, Stefan Richter wrote:
> Hi,
> 
> I saw the following scroll by during kernel compilation:
> 
> fs/ext4/move_extent.c: In function 'mext_leaf_block':
> 
> fs/ext4/move_extent.c:478: warning: 'start_ext.ee_block' may be used
> uninitialized in this function
> 
> Is it real?  It seems that the initial start_ext.ee_len = 0 guards
> against accidental use of an uninitialized start_ext.ee_block, but maybe
> I missed something.

>From my review of the code the fact that ee_len is set to zero should
make this be safe, but my preference would be to clear
start_ext.ee_block as well to prevent the warning from coming up
(since false positives clutter up warnings and might cause us to miss
a warning which isn't so benign).

Akira-san, do you agree that it is currently is safe?

	      	  	     	   - Ted
