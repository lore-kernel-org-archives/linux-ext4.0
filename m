From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Unregister features interface on module unload
Date: Thu, 3 Feb 2011 00:53:05 -0500
Message-ID: <20110203055305.GM4258@thunk.org>
References: <1295276437-27966-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58474 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396Ab1BCFxK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Feb 2011 00:53:10 -0500
Content-Disposition: inline
In-Reply-To: <1295276437-27966-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 17, 2011 at 04:00:37PM +0100, Lukas Czerner wrote:
> Ext4 features interface was not properly unregistered which led to
> problems while unloading/reloading ext4 module. This commit fixes that by
> adding proper kobject unregistration code into ext4_exit_fs() as well as
> fail-path of ext4_init_fs()
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Reported-by: Eric Sandeen <sandeen@redhat.com>

Added to the ext4 patch queue, thanks.

				- Ted
