From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH V6 RESEND 07/15] ext4: add a function which adds
 several group descriptors
Date: Tue, 3 Jan 2012 21:44:52 -0500
Message-ID: <20120104024452.GH30502@thunk.org>
References: <1325242812-27005-1-git-send-email-xiaoqiangnk@gmail.com>
 <1325242812-27005-8-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36842 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755334Ab2ADDtd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Jan 2012 22:49:33 -0500
Content-Disposition: inline
In-Reply-To: <1325242812-27005-8-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 30, 2011 at 07:00:04PM +0800, Yongqiang Yang wrote:
> From: Yongqiang Yang <xiaoqiangnk@gmail.com>
> 
> This patch adds a functon named ext4_add_new_descs() which adds
> several group descriptors each time.

This is why it's less desirable to add functions one at a time.  I had
to look through all of the patches to determine that
ext4_add_new_desc() is _only_ being called by ext4_add_new_descs().
And since ext4_add_new_descs() adds so little new value, it's better
to combine these two functions together into single function.

I'll add a new patch which folds these two functions together.

   	   	     	       		     	    - Ted

