From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2 v2] ext4: Do not convert to indirect with bigalloc
 enabled
Date: Wed, 10 Apr 2013 23:58:50 -0400
Message-ID: <20130411035850.GB18878@thunk.org>
References: <1365506687-9216-1-git-send-email-lczerner@redhat.com>
 <1365506687-9216-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, gnehzuil.liu@gmail.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33374 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759688Ab3DKD6x (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Apr 2013 23:58:53 -0400
Content-Disposition: inline
In-Reply-To: <1365506687-9216-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 09, 2013 at 01:24:47PM +0200, Lukas Czerner wrote:
> With bigalloc feature enabled we do not support indirect addressing at all
> so we have to prevent extent addressing to indirect addressing
> conversion in this case. The problem has been introduced with the commit
> "ext4: support simple conversion of extent-mapped inodes to use i_blocks"
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, this version is now in the ext4 patch queue.

	     	     	       	   - Ted
