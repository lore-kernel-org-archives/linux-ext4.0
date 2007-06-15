From: Theodore Tso <tytso@mit.edu>
Subject: Re: Couple of queries related to htree directory
Date: Fri, 15 Jun 2007 12:32:48 -0400
Message-ID: <20070615163248.GE14911@thunk.org>
References: <ffa0f8300706140622j104ad6d7ra3abb2c8779dece@mail.gmail.com> <20070614184630.GB14911@thunk.org> <ffa0f8300706150400u39c31a13l2805f4d8217eb4cf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tejas Sumant <tejas.sumant@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:57963 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757904AbXFOQcz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Jun 2007 12:32:55 -0400
Content-Disposition: inline
In-Reply-To: <ffa0f8300706150400u39c31a13l2805f4d8217eb4cf@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jun 15, 2007 at 04:30:02PM +0530, Tejas Sumant wrote:
> Hi Theodore,
> 
> My file system has dir_index feature.
> When I created new directory larger than blocksize and run htree
> command of debugfs on it, I received message that the directory is not
> in htree format.

Can you run the debugfs stat command on the directory and send me the
output?

Thanks,

						- Ted
