From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: limit group search loop for non-extent files
Date: Sun, 5 May 2013 23:08:41 -0400
Message-ID: <20130506030841.GB4974@thunk.org>
References: <5184230E.6020500@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Lachlan McIlroy <lmcilroy@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46518 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999Ab3EFDIo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 May 2013 23:08:44 -0400
Content-Disposition: inline
In-Reply-To: <5184230E.6020500@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 03, 2013 at 03:50:22PM -0500, Eric Sandeen wrote:
> From: Lachlan McIlroy <lmcilroy@redhat.com>

Note: if it's from Lachlan, it needs his Signed-off-by.  Lachlan, can
you send an Ack saying it's OK for me to add a:

Signed-off-by: Lachlan McIlroy <lmcilroy@redhat.com>

to the commit description?

Thanks,

						- Ted
