From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 07/11] ext4: serialize unlocked dio reads with truncate
Date: Sat, 29 Sep 2012 00:49:04 -0400
Message-ID: <20120929044904.GA2583@thunk.org>
References: <1348847051-6746-1-git-send-email-dmonakhov@openvz.org>
 <1348847051-6746-8-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz, lczerner@redhat.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52935 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895Ab2I2EtO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 29 Sep 2012 00:49:14 -0400
Content-Disposition: inline
In-Reply-To: <1348847051-6746-8-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 28, 2012 at 07:44:07PM +0400, Dmitry Monakhov wrote:
>  	if (attr->ia_valid & ATTR_SIZE) {
> -		if (attr->ia_size != i_size_read(inode))
> +		if (attr->ia_size != inode->i_size) {

Why this change?   Why are you not using i_size_read() here?

    	 	       	       	   - Ted
