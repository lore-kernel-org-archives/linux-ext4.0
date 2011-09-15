From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] e2fsprogs: add 64bit-online-resize support
Date: Thu, 15 Sep 2011 11:16:32 -0400
Message-ID: <20110915151632.GI15782@thunk.org>
References: <1314692003-12395-1-git-send-email-xiaoqiangnk@gmail.com>
 <20110914155619.GD3429@dhcp-172-31-195-159.cam.corp.google.com>
 <CAOQ4uxjkt4NFEPtekWeu=Xag0nScQ6MJ4U748MpUm6XZE3F+Rg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>, adilger@dilger.ca,
	linux-ext4@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54869 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756403Ab1IOPQi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Sep 2011 11:16:38 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjkt4NFEPtekWeu=Xag0nScQ6MJ4U748MpUm6XZE3F+Rg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 15, 2011 at 05:36:14PM +0300, Amir Goldstein wrote:
> 
> Are you planning to pull the kernel 64bit-resize patches for 3.2
> merge window?

It depends on how much time I have.  My main priority is to get
another snapshot release of e2fsprogs out.  I have some $WORK projects
I need to focus on as well, and I've also been assisting with the
kernel.org security penetration cleanup, so my time has been pretty
badly slammed as of late.

I included the the userspace support for the new resize ioctl since
it's pretty simple, and very unlikely to change.

					- Ted
