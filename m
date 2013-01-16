From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 5/5] libext2fs: avoid 32-bit overflow in
 ext2fs_initialize with a 512M cluster size
Date: Wed, 16 Jan 2013 09:49:14 +0800
Message-ID: <20130116014914.GA20060@gmail.com>
References: <20130114211014.GA22642@thunk.org>
 <1358210232-30578-1-git-send-email-tytso@mit.edu>
 <1358210232-30578-5-git-send-email-tytso@mit.edu>
 <20130115153331.GE19209@gmail.com>
 <20130115191030.GC17719@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:63107 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756394Ab3APBf1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Jan 2013 20:35:27 -0500
Received: by mail-pb0-f47.google.com with SMTP id wz17so397688pbc.20
        for <linux-ext4@vger.kernel.org>; Tue, 15 Jan 2013 17:35:27 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20130115191030.GC17719@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 15, 2013 at 02:10:30PM -0500, Theodore Ts'o wrote:
> On Tue, Jan 15, 2013 at 11:33:31PM +0800, Zheng Liu wrote:
> > 
> > FWIW, I wonder why we need to add such complex logical to handle a
> > corner case.  I guess no one wants to use a 512MB cluster.  So changing
> > max cluster size from 512MB to 256MB is very simple and straightfoward.
> 
> I agree that it seems very unlikely that there would be much interest
> in using a 512MB cluster.  However, we would still need to do the
> check in the case of a 16k block size (on an PowerPC or Itanium
> system) at a 256MB or 128MB cluster.  So part of this check would be
> needed anyway.

Yeah, I see.  Thanks for the explanation.

Regards,
                                                - Zheng
