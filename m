From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/5] libext2fs: avoid 32-bit overflow in
 ext2fs_initialize with a 512M cluster size
Date: Tue, 15 Jan 2013 14:10:30 -0500
Message-ID: <20130115191030.GC17719@thunk.org>
References: <20130114211014.GA22642@thunk.org>
 <1358210232-30578-1-git-send-email-tytso@mit.edu>
 <1358210232-30578-5-git-send-email-tytso@mit.edu>
 <20130115153331.GE19209@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43547 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280Ab3AOTKb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jan 2013 14:10:31 -0500
Content-Disposition: inline
In-Reply-To: <20130115153331.GE19209@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 15, 2013 at 11:33:31PM +0800, Zheng Liu wrote:
> 
> FWIW, I wonder why we need to add such complex logical to handle a
> corner case.  I guess no one wants to use a 512MB cluster.  So changing
> max cluster size from 512MB to 256MB is very simple and straightfoward.

I agree that it seems very unlikely that there would be much interest
in using a 512MB cluster.  However, we would still need to do the
check in the case of a 16k block size (on an PowerPC or Itanium
system) at a 256MB or 128MB cluster.  So part of this check would be
needed anyway.

						- Ted
