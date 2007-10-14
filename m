From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH e2fsprogs] libblkid: detect squashfs
Date: Sun, 14 Oct 2007 10:12:43 -0400
Message-ID: <20071014141242.GA6724@thunk.org>
References: <46F93F3A.7080406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:42310 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773AbXJNUag (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Oct 2007 16:30:36 -0400
Content-Disposition: inline
In-Reply-To: <46F93F3A.7080406@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Sep 25, 2007 at 12:02:50PM -0500, Eric Sandeen wrote:
> libblkid: recognize squashfs filesystems
> 
> squashfs has no uuid or labels, so all we need is the magic.
> 
> Addresses-Red-Hat-Bugzilla: #305151
>     
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied to the maint branch.

				- Ted
