From: Theodore Tso <tytso@mit.edu>
Subject: Re: Group descriptor 0 checksum is invalid
Date: Sun, 15 Nov 2009 22:11:01 -0500
Message-ID: <20091116031101.GP4323@mit.edu>
References: <alpine.DEB.2.01.0911141349050.27639@bogon.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59858 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873AbZKPDLB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 Nov 2009 22:11:01 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.0911141349050.27639@bogon.housecafe.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Nov 14, 2009 at 02:00:15PM -0800, Christian Kujau wrote:
> Hi,
> 
> when trying to convert an ext3 filesystem to ext4, I'm getting these 
> "Group descriptor 0 checksum is invalid" messages. I've seen them before 
> and the net is full of them, but I still wonder if they're expected to 
> show up at all during the filesystem's first fsck. See below for the 
> script log.

Yes, it's expected.  We may try to make tune2fs better about fixing up
the checksums when enabling uninit_bg at some point in the future, but
for now, it's one of the reasons why tune2fs requests that you run
e2fsck on the file system.

					- Ted
