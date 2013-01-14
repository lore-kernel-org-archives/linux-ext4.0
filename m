From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/2] Ext3: return ENOMEM rather than EIO if sb_getblk
 fails
Date: Sun, 13 Jan 2013 19:59:22 -0800
Message-ID: <20130114035922.GA3809@kroah.com>
References: <1294915634-3413-1-git-send-email-wangshilong1991@gmail.com>
 <20130113044342.GA11738@kroah.com>
 <20130114034538.GB29329@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Wang shilong <wangshilong1991@gmail.com>, jack@suse.cz,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Wang Shilong <wangsl-fnst@cn.fujitsu.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35285 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736Ab3AND6d (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 13 Jan 2013 22:58:33 -0500
Received: by mail-pa0-f42.google.com with SMTP id rl6so1995295pac.15
        for <linux-ext4@vger.kernel.org>; Sun, 13 Jan 2013 19:58:33 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20130114034538.GB29329@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 13, 2013 at 10:45:38PM -0500, Theodore Ts'o wrote:
> On Sat, Jan 12, 2013 at 08:43:42PM -0800, Greg KH wrote:
> > On Thu, Jan 13, 2011 at 06:47:14PM +0800, Wang shilong wrote:
> > > From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> > > 
> > > It will be better to have ENOMEM return rather than EIO,because
> > > the only reason that sb_getblk fails is allocation fails.
> > > 
> > 
> > <formletter>
> > 
> > This is not the correct way to submit patches for inclusion in the
> > stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
> > for how to do this properly.
> > 
> > </formletter>
> 
> Did Wang Shilong bcc stable@vger.kernel.org?

Yes he did, which triggered my semi-automatic-bot response.

