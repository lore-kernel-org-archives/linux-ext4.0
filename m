From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2image: add -a switch to include all data
Date: Tue, 15 Jan 2013 23:02:30 -0500
Message-ID: <20130116040230.GB6052@thunk.org>
References: <1358281883-18199-1-git-send-email-psusi@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43702 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756664Ab3APECd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jan 2013 23:02:33 -0500
Content-Disposition: inline
In-Reply-To: <1358281883-18199-1-git-send-email-psusi@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 15, 2013 at 03:31:23PM -0500, Phillip Susi wrote:
> Normally the raw and QCOW2 images only contain fs metadata.
> Add a new switch ( -a ) to include all data.  This makes it
> possible to use e2image to clone a whole filesystem.
> 
> Signed-off-by: Phillip Susi <psusi@ubuntu.com>

Thanks, applied.

					- Ted
