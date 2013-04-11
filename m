From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2 v2] ext4: move ext4_ind_migrate() into migrate.c
Date: Wed, 10 Apr 2013 23:58:26 -0400
Message-ID: <20130411035826.GA18878@thunk.org>
References: <1365506687-9216-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, gnehzuil.liu@gmail.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33370 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759688Ab3DKD6a (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Apr 2013 23:58:30 -0400
Content-Disposition: inline
In-Reply-To: <1365506687-9216-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 09, 2013 at 01:24:46PM +0200, Lukas Czerner wrote:
> Move ext4_ind_migrate() into migrate.c file since it makes much more
> sense and ext4_ext_migrate() is there as well.
> 
> Also fix tiny style problem - add spaces around "=" in "i=0".
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

I had to regenerate this patch since ext4_ind_migrate has been changed
by other patches in the ext4 patch queue, but it's applied now.

   	 	    	     	   - Ted
