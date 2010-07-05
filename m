From: tytso@mit.edu
Subject: Re: [PATCH] e2fsprogs: Add missed ext2fs_close
Date: Mon, 5 Jul 2010 15:10:34 -0400
Message-ID: <20100705191034.GH25518@thunk.org>
References: <87wrtgbw5b.fsf@dmon-lap.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:37519 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759Ab0GETKi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Jul 2010 15:10:38 -0400
Content-Disposition: inline
In-Reply-To: <87wrtgbw5b.fsf@dmon-lap.sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 30, 2010 at 03:24:48PM +0400, Dmitry Monakhov wrote:
> Today i've accidentally overwrote first GB of 400Gb ext4 filesystem with
> zeroes :) . So journal, group descriptors, rootdir and etc was destroyed.
> Surprisingly i've able to recover some of my data after long fsck
> process. I've met only one trivial bug in initialization stage.
> See patch attached.

Thanks for catching this.  I've applied the fix to my source tree.

       	   	    	   		    - Ted
