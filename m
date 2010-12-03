From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] mke2fs: Add discard option into mke2fs.conf
Date: Fri, 3 Dec 2010 17:29:02 -0500
Message-ID: <20101203222902.GC26906@thunk.org>
References: <1288636444-11068-1-git-send-email-lczerner@redhat.com>
 <alpine.LFD.2.00.1012020943150.2874@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com, adilger@dilger.ca
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:40030 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362Ab0LCW3I (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Dec 2010 17:29:08 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1012020943150.2874@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 02, 2010 at 09:44:22AM +0100, Lukas Czerner wrote:
> On Mon, 1 Nov 2010, Lukas Czerner wrote:
> 
> > Allow to specify discard in mke2fs.conf. Also change the way how to
> > specify default value for lazy_itable_init. It is better to have all
> > this defaulting done in the same place so do it in definition (as we do
> > with discard).
> > 
> 
> what is the status of this patch ?

Already integrated into the maint branch; sorry, forgot to send out an
ack for this patch.

					- Ted
