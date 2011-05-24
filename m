From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] jbd2: Fix sending of data flush on journal commit
Date: Tue, 24 May 2011 12:07:52 -0400
Message-ID: <20110524160752.GB26055@thunk.org>
References: <1306186726-23430-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Edward Goggin <egoggin@vmware.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55537 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755315Ab1EXQH5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 May 2011 12:07:57 -0400
Content-Disposition: inline
In-Reply-To: <1306186726-23430-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've updated the ext4 dev branch to include your updated patches.
Thanks for working on this, and optimizing the external journal case;
I really appreciate it!!

						- Ted
