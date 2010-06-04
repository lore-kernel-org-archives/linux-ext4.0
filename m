From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 4/4] jffs2: update ctime when changing the file's
 permission by setfacl
Date: Fri, 04 Jun 2010 16:14:02 +0100
Message-ID: <1275664442.17903.91.camel@macbook.infradead.org>
References: <1275664075-4703-1-git-send-email-jack@suse.cz>
	 <1275664075-4703-5-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53526 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132Ab0FDPOW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Jun 2010 11:14:22 -0400
In-Reply-To: <1275664075-4703-5-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2010-06-04 at 17:07 +0200, Jan Kara wrote:
> jffs2 didn't update the ctime of the file when its permission was changed.

Thanks. I have a couple more JFFS2 bug fixes that Al pointed out a day
or two ago, which I want to submit for 2.6.35; I'll merge this through
my tree with those if that's OK.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

