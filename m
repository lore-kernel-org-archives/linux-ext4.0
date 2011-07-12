From: Greg KH <greg@kroah.com>
Subject: Re: [stable] [PATCH] jbd/2[stable only]: Use WRITE_SYNC_PLUG in
 journal_commit_transaction.
Date: Tue, 12 Jul 2011 17:55:17 +0200
Message-ID: <20110712155517.GA6696@kroah.com>
References: <1310467431-23108-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Corrado Zoccolo <czoccolo@gmail.com>,
	Jeff Moyer <jmoyer@redhat.com>,
	Jens Axboe <jaxboe@fusionio.com>, stable@kernel.org,
	Vivek Goyal <vgoyal@redhat.com>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:52780 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753262Ab1GLQCA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Jul 2011 12:02:00 -0400
Content-Disposition: inline
In-Reply-To: <1310467431-23108-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 12, 2011 at 06:43:51PM +0800, Tao Ma wrote:
> This only affects .37 and .38 since Jens' new plug patches are included
> in .39 and the bug is removed as a side effect. But I think it is needed
> anyway for the stable. And RHEL6 needs this also I guess.

Both the .37 and .38-stable kernel trees are end-of-life and not having
any more releases, so there's no tree for these to be applied too,
sorry.

greg k-h
