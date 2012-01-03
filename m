From: Djalal Harouni <tixxdz@opendz.org>
Subject: Re: [PATCH] fs/ext4: add missing ext4_resize_end
Date: Tue, 3 Jan 2012 11:47:49 +0100
Message-ID: <20120103104749.GA18875@dztty>
References: <20111222150057.GA10845@dztty>
 <CAGBYx2YgN_iqcKOfAwzH_t63us+ECgxcNMEsaRz0j5aoY5tORw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from numidia.opendz.org ([98.142.220.152]:47751 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442Ab2ACKon (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jan 2012 05:44:43 -0500
Content-Disposition: inline
In-Reply-To: <CAGBYx2YgN_iqcKOfAwzH_t63us+ECgxcNMEsaRz0j5aoY5tORw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 23, 2011 at 09:14:20AM +0800, Yongqiang Yang wrote:
> Thanks.
> 
> The patch looks good.   I have to update the new resize patch too.
> 
> Yongqiang.
> 
> On Thu, Dec 22, 2011 at 11:00 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
> > Online resize ioctls 'EXT4_IOC_GROUP_EXTEND' and 'EXT4_IOC_GROUP_ADD'
> > call ext4_resize_begin() to check permissions and to set the
> > EXT4_RESIZING bit lock, they do their work and they must finish with
> > ext4_resize_end() which calls clear_bit_unlock() to unlock and to
> > avoid -EBUSY errors for the next resize operations.
> >
> > This patch adds the missing ext4_resize_end() calls on error paths.
Any news on this one ?

If we call EXT4_IOC_GROUP_EXTEND ioctl and get_user() fails with -EFAULT
then any new call will return -EBUSY, unless we unmount/mount the fs.

In rare situations this can lead to a corrupt filesystem, I've experienced
this, but I'm not sure what I did. fsck fix it.

Thanks.

-- 
tixxdz
http://opendz.org
