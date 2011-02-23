From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: mark objects for local use as static
Date: Wed, 23 Feb 2011 12:24:24 -0500
Message-ID: <20110223172424.GL2924@thunk.org>
References: <1297798998-19306-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58796 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492Ab1BWRY2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Feb 2011 12:24:28 -0500
Content-Disposition: inline
In-Reply-To: <1297798998-19306-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 15, 2011 at 08:43:18PM +0100, Lukas Czerner wrote:
> Certain object in ext4 code are supposed to be used only locally, but
> are not defined as static. Fix it by adding static into definition.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, added to the ext4 patch queue with the one-line summary:

ext4: mark file-local functions and variables as static

      	   	      		    	      - Ted

