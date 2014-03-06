From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] mke2fs: disable resize_inode feature if 64bit feature
 is enabled
Date: Thu, 6 Mar 2014 15:03:30 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1403061458340.2249@localhost.localdomain>
References: <1372928710-10461-1-git-send-email-guaneryu@gmail.com> <20130705012128.GA11793@gmail.com> <20130707154140.GA11993@thunk.org> <alpine.LFD.2.00.1403031640020.2258@localhost.localdomain> <20140304151925.GC23106@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1940693645-1394114612=:2249"
Cc: Eryu Guan <guaneryu@gmail.com>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbaCFODi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Mar 2014 09:03:38 -0500
In-Reply-To: <20140304151925.GC23106@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1940693645-1394114612=:2249
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Tue, 4 Mar 2014, Theodore Ts'o wrote:

> Date: Tue, 4 Mar 2014 10:19:25 -0500
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Eryu Guan <guaneryu@gmail.com>, linux-ext4@vger.kernel.org
> Subject: Re: [PATCH] mke2fs: disable resize_inode feature if 64bit feature is
>     enabled
> 
> On Mon, Mar 03, 2014 at 04:40:21PM +0100, Lukáš Czerner wrote:
> > 
> > are you going to take this in ?
> > 
> > > It's better to use the resize_inode for file systems that are smaller
> > > than 16TB, even if the 64-bit flag is enabled, since using the meta_bg
> > > style resizing spreads out the block group descriptors, which
> > > increases the time to mount the file system.  Using the resize_inode
> > > will defer the need to go to the meta_bg-style resizing until we cross
> > > the 16TB boundary.
> 
> See my comments above.
> 
> If we create a file system which is say, 1T but with the 64-bit flag,
> we do want the resize_inode feature to be used until we cross over the
> 32-bit boundary, because keeping block group descriptors contiguous
> speeds up the mount time.
> 
> If I were to accept this patch, and/or Red Hat were to ship with it, I
> will predict that you will get angry customer support calls about file
> system mount times getting slow after doing a resize.
> 
> At some point what we may want to lazily load the block group
> descriptors at mount time, to mitigate the slow mount time issue when
> using meta_bg.  We have a lot of assumptions in the code that the
> block group descriptors are always available, though.
> 
>       	    		    	   	      - Ted

Hi Ted,

I am sorry, but am I missing something ? This patch seems to do
exactly that.

	if ((fs_blocks_count > MAX_32_NUM) &&
+	    (fs_param.s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT))
+		fs_param.s_feature_compat &= ~EXT2_FEATURE_COMPAT_RESIZE_INODE;

The answer from you on that patch is commenting on a guestion from
Zheng Liu who is asking whether we could skip the MAX_32_NUM check.

So the patch seems to be ok for me.

Thanks!
-Lukas
--8323328-1940693645-1394114612=:2249--
