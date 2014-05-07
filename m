From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH -v2 2/3] mke2fs: print extra information about existing
 ext2/3/4 file systems
Date: Wed, 7 May 2014 10:15:56 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1405071014350.2128@localhost.localdomain>
References: <1399338133-21373-1-git-send-email-tytso@mit.edu> <1399338133-21373-2-git-send-email-tytso@mit.edu> <alpine.LFD.2.00.1405061528470.2255@localhost.localdomain> <20140507024621.GB6461@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1051330677-1399450559=:2128"
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15888 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754544AbaEGIQB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 May 2014 04:16:01 -0400
In-Reply-To: <20140507024621.GB6461@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1051330677-1399450559=:2128
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Tue, 6 May 2014, Theodore Ts'o wrote:

> Date: Tue, 6 May 2014 22:46:21 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
> Subject: Re: [PATCH -v2 2/3] mke2fs: print extra information about existing
>     ext2/3/4 file systems
> 
> On Tue, May 06, 2014 at 03:42:37PM +0200, Lukáš Czerner wrote:
> > > +	retval = ext2fs_open2(device, 0, 0, 0, 0, unix_io_manager, &fs);
> > 
> > Sorry for not noticing this earlier, but we might want to pass
> > EXT2_FLAG_64BITS.
> 
> Done.
> 
> > > +	} else if (sb->s_mkfs_time) {
> > > +		tm = sb->s_mkfs_time;
> > > +		printf(_("\tcreated on %s"), ctime(&tm));
> > > +	} else if (sb->s_mkfs_time) {
> > 
> > This does not seem right, you've already checked for s_mkfs_time and
> > if was not set if you got here. I guess, it should be something else
> > ? s_wtime perhaps ? But, can this be set when the fs was not mounted
> > (like using ext2fs library ?)
> > 
> > > +		tm = sb->s_mtime;
> > 
> > If you got here, then again this is not set.
> 
> 
> Yes, that's a cut and paste typo, thanks for spotting it.  It should
> have been:
> 
> 	} else if (sb->s_mkfs_time) {
> 		tm = sb->s_mkfs_time;
> 		printf(_("\tcreated on %s"), ctime(&tm));
> 	} else if (sb->s_mtime) {  <========

But you're already checking for sb->s_mtime in the first condition,
am I missing something ?

Thanks!
-Lukas

> 		tm = sb->s_mtime;
> 		printf(_("\tlast modified on %s"), ctime(&tm));
> 	}
> 
> 
> Cheers,
> 
> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--8323328-1051330677-1399450559=:2128--
