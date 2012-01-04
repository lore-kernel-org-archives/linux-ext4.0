From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH V6 RESEND 08/15] ext4: add a function which sets up a
 flex groups each time
Date: Tue, 3 Jan 2012 21:46:20 -0500
Message-ID: <20120104024620.GI30502@thunk.org>
References: <1325242812-27005-1-git-send-email-xiaoqiangnk@gmail.com>
 <1325242812-27005-9-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36860 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755442Ab2ADDth (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Jan 2012 22:49:37 -0500
Content-Disposition: inline
In-Reply-To: <1325242812-27005-9-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 30, 2011 at 07:00:05PM +0800, Yongqiang Yang wrote:
> From: Yongqiang Yang <xiaoqiangnk@gmail.com>
> 
> This patch adds a function named ext4_setup_new_descs() which sets up
> a flex groups each time.

Similarly, ext4_setup_new_desc() and ext4_setup_new_descs() should be
folded together.

						- Ted
