From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 01/29] ext4: Make ext4_bio_write_page() use
 BH_Async_Write flags instead page pointers from ext4_io_end
Date: Thu, 11 Apr 2013 23:50:34 -0400
Message-ID: <20130412035034.GC4865@thunk.org>
References: <1365456754-29373-1-git-send-email-jack@suse.cz>
 <1365456754-29373-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33711 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367Ab3DLDuj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Apr 2013 23:50:39 -0400
Content-Disposition: inline
In-Reply-To: <1365456754-29373-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks, I've applied this to the ext4 dev branch for testing.

	     	     	     	      - Ted
