From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fix debugfs output for flex_bg bitmap offsets
Date: Sun, 5 Dec 2010 22:16:58 -0500
Message-ID: <20101206031658.GH4273@thunk.org>
References: <BFE21949-F817-40EF-8A9C-8B30E0530D4A@dilger.ca>
 <A5A44A8A-41F5-4A2A-9289-CEA37F7ABC8B@dilger.ca>
 <B5F6E86E-D94A-4ECC-9B55-FCE9E219DFF1@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <andreas.dilger@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:60877 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732Ab0LFDRC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Dec 2010 22:17:02 -0500
Content-Disposition: inline
In-Reply-To: <B5F6E86E-D94A-4ECC-9B55-FCE9E219DFF1@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 26, 2010 at 05:33:27PM -0700, Andreas Dilger wrote:
> On 2010-11-25, at 12:09, Andreas Dilger wrote:
> > ...with patch this time...
> 
> Attached is an updated patch that makes the output a bit more
> verbose (to avoid line wraps) and doesn't fail the m_raid_opts test
> (which complains when "(+0)" is printed for each inode table).

Every time you write code of the form:

      if (block >= first_block + !!itable && ...)

Gcc kills a kitten.  Please, think of the kittens....

I rewrote that code as follows:  

	if ((block >= first_block) && (block <= last_block)) {
		if (itable && block == first_block)
			return;
		printf(" (+%u)", (unsigned)(block - first_block));
	} else if ...


I also changed the output to use "(bg #16 + 4)" since I think it's a
bit easier to understand than "(grp 16+4)".

Otherwise, I've added it to the e2fsprogs maint branch, thanks.

	   	      	    		  - Ted
