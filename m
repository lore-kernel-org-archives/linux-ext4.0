From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH V6 RESEND 05/15] ext4: add a structure which will be
 used by 64bit-resize interface
Date: Tue, 3 Jan 2012 21:30:53 -0500
Message-ID: <20120104023053.GG30502@thunk.org>
References: <1325242812-27005-1-git-send-email-xiaoqiangnk@gmail.com>
 <1325242812-27005-6-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36846 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755343Ab2ADDtd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Jan 2012 22:49:33 -0500
Content-Disposition: inline
In-Reply-To: <1325242812-27005-6-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 30, 2011 at 07:00:02PM +0800, Yongqiang Yang wrote:
> +void free_flex_gd(struct ext4_new_flex_group_data *flex_gd)

This should be static, so we don't leak symbols that don't begin with
"ext4_" into kernel namespace.  I've checked and future users of this
function are in fs/ext4/resize.c, so there's no reason for this not to
be non-static.

(A good thing to do while doing development is to run "nm ext4.ko" and
check for exported symbols that you aren't expecting.)

Again, I'll fix this as a minor nit.

					- Ted
