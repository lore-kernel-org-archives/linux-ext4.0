From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/4] ext4: online defrag is not supported for journaled
 files
Date: Wed, 26 Sep 2012 12:30:47 -0400
Message-ID: <20120926163047.GB18983@thunk.org>
References: <1348489434-22778-1-git-send-email-dmonakhov@openvz.org>
 <1348489434-22778-3-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, a-fujita@rs.jp.nec.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52515 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757196Ab2IZQaw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Sep 2012 12:30:52 -0400
Content-Disposition: inline
In-Reply-To: <1348489434-22778-3-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 24, 2012 at 04:23:52PM +0400, Dmitry Monakhov wrote:
> Proper block swap for inodes with full journaling enabled is
> truly non obvious task. In order to be on a safe side let's
> explicitly disable it for now.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Applied, thanks!!

					- Ted
