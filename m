From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix incorrect lock ordering for ext4_ext_migrate
Date: Mon, 8 Apr 2013 13:01:59 -0400
Message-ID: <20130408170159.GA4598@thunk.org>
References: <1364801462-13120-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60333 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934420Ab3DHRCE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Apr 2013 13:02:04 -0400
Content-Disposition: inline
In-Reply-To: <1364801462-13120-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 01, 2013 at 11:31:02AM +0400, Dmitry Monakhov wrote:
> existing locking ordering: journal-> i_data_sem, but
> ext4_ext_migrate() grab locks in opposite order which may result
> in deacklock.

Applied, but....  s/ext4_ext_migrate/ext4_ind_migrate/g in the commit
description.

						- Ted
