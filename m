From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: Fix ERR_PTR dereference in jbd2__journal_start
Date: Sat, 2 Mar 2013 17:10:18 -0500
Message-ID: <20130302221017.GB22941@thunk.org>
References: <87obfcs1x6.fsf@openvz.org>
 <20130222180325.GB21264@thunk.org>
 <87mwuqmzoe.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <gnehzuil.liu@gmail.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50951 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156Ab3CBWKX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 Mar 2013 17:10:23 -0500
Content-Disposition: inline
In-Reply-To: <87mwuqmzoe.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 27, 2013 at 03:18:57AM +0400, Dmitry Monakhov wrote:
> From 65344ff34ebbe6dc45c193c3d88e7a74668edfd5 Mon Sep 17 00:00:00 2001
> From: Dmitry Monakhov <dmonakhov@openvz.org>
> Date: Wed, 27 Feb 2013 02:59:37 +0400
> Subject: [PATCH] jbd2: Fix ERR_PTR dereference in jbd2__journal_start
> 
> If start_this_handle() failed handle will be initialized
> to ERR_PTR() and can not be dereferenced.

Applied, thanks.

					- Ted
