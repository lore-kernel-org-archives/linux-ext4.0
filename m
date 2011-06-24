From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] jbd2: Fix oops in jbd2_journal_remove_journal_head()
Date: Fri, 24 Jun 2011 10:25:03 -0400
Message-ID: <20110624142503.GD3064@thunk.org>
References: <1307974167-9594-1-git-send-email-jack@suse.cz>
 <20110624141602.GC26380@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44912 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921Ab1FXOZH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Jun 2011 10:25:07 -0400
Content-Disposition: inline
In-Reply-To: <20110624141602.GC26380@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 24, 2011 at 04:16:02PM +0200, Jan Kara wrote:
>   Ted, have you picked up updated version of this patch?

Yes, and it's upstream already; commit de1b794130.

					- Ted
