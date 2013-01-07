From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix configuration dependencies for ext4 ACLs and
 security labels
Date: Sun, 6 Jan 2013 23:07:49 -0500
Message-ID: <20130107040749.GA4956@thunk.org>
References: <1357444389-4895-1-git-send-email-val@vaaconsulting.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, David Brown <davidb@codeaurora.org>,
	Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
	Tao Ma <boyu.mt@taobao.com>
To: Valerie Aurora <val@vaaconsulting.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42088 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413Ab3AGEH7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 6 Jan 2013 23:07:59 -0500
Content-Disposition: inline
In-Reply-To: <1357444389-4895-1-git-send-email-val@vaaconsulting.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 05, 2013 at 07:53:09PM -0800, Valerie Aurora wrote:
> Commit "ext4: Remove CONFIG_EXT4_FS_XATTR" removed the configuration
> dependencies for ext4 xattrs from the ext4 ACLs and security labels
> configuration options, but did not replace them with a dependency on
> ext4 itself.  Add back the dependency on ext4 so the options only show
> up if ext4 is enabled.
> 
> Signed-off-by: Valerie Aurora <val@vaaconsulting.com>

Thanks Val, for catching this!  I've queued this on the ext4 tree.

       	    		 	     	    	 - Ted
