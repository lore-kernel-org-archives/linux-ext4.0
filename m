From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext4 - error with root drive mount
Date: Wed, 4 Feb 2009 01:24:00 -0500
Message-ID: <20090204062400.GZ14762@mit.edu>
References: <20090203191531.0dfe27a1@amd64linuxmsi.rentzhouse.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jimmy Rentz <jedynamic@bellsouth.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44394 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbZBDGYE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Feb 2009 01:24:04 -0500
Content-Disposition: inline
In-Reply-To: <20090203191531.0dfe27a1@amd64linuxmsi.rentzhouse.lan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 03, 2009 at 07:15:31PM -0500, Jimmy Rentz wrote:
> 	I am unable to mount my ext4 root drive. 
> 
> 	I get this error:
> 	EXT4-fs: ext4_check_descriptors: Block bitmap for group 2688
> 	not in group (block 4205711663)!<3>EXT4-fs: group descriptors
> 	corrupted!
> 
> 	I had a similar error some time ago, but I thought it was power
> 	related.  I fixed the problem by running a fcsk.  

You'll need to fix it using fsck again.  I assume the back up
superblocks will have the correct value.

It would be interesting to see if there are any other errors picked up
by e2fsck.

> 	Any tips to debug this?

Can you reliably replicate this problem?  I've not seen any similar
reports of problems like this.

						- Ted
