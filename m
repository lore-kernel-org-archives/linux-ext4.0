From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH -v2 2/3] mke2fs: print extra information about existing
 ext2/3/4 file systemsGjj
Date: Wed, 7 May 2014 15:43:09 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1405071534070.2128@localhost.localdomain>
References: <1399338133-21373-1-git-send-email-tytso@mit.edu> <1399338133-21373-2-git-send-email-tytso@mit.edu> <alpine.LFD.2.00.1405061528470.2255@localhost.localdomain> <20140507024621.GB6461@thunk.org> <alpine.LFD.2.00.1405071014350.2128@localhost.localdomain>
 <20140507123913.GA28814@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1996339212-1399469881=:2128"
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58888 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933037AbaEGNnO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 May 2014 09:43:14 -0400
In-Reply-To: <20140507123913.GA28814@thunk.org>
Content-ID: <alpine.LFD.2.00.1405071538410.2128@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1996339212-1399469881=:2128
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LFD.2.00.1405071538411.2128@localhost.localdomain>

On Wed, 7 May 2014, Theodore Ts'o wrote:

> Date: Wed, 7 May 2014 08:39:13 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Luká¨ Czerner <lczerner@redhat.com>
> Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
> Subject: Re: [PATCH -v2 2/3] mke2fs: print extra information about existing
>     ext2/3/4 file systemsG
> 
> On Wed, May 07, 2014 at 10:15:56AM +0200, Luká¨ Czerner wrote:
> > > Yes, that's a cut and paste typo, thanks for spotting it.  It should
> > > have been:
> > > 
> > > 	} else if (sb->s_mkfs_time) {
> > > 		tm = sb->s_mkfs_time;
> > > 		printf(_("\tcreated on %s"), ctime(&tm));
> > > 	} else if (sb->s_mtime) {  <========
> > 
> > But you're already checking for sb->s_mtime in the first condition,
> > am I missing something ?
> 
> The basic idea is to give one bit of context, and whatever would be
> the most useful.  In order of preference, it's:
> 
> 1)  Last mount directory (if available) and last mount time
> 2)  Time file system was created
> 3)  Time file system was written
> 
> #2 or #3 is only needed if the file system was never mounted.
> 
> #3 is only needed for those file systems that (a) were never mounted,
> (b) was modified/filled via e2tools or debugfs.  (Or Windows FS SDK
> based hacks, etc.)
> 
> 					- Ted
> 

I understand that, but here is what is in your patch:


 +      if (sb->s_mtime) {
 +              tm = sb->s_mtime;
 +              if (sb->s_last_mounted[0]) {
 +                      memset(buf, 0, sizeof(buf));
 +                      strncpy(buf, sb->s_last_mounted,
 +                              sizeof(sb->s_last_mounted));
 +                      printf(_("\tlast mounted on %s on %s"), buf,
 +                             ctime(&tm));
 +              } else
 +                      printf(_("\tlast mounted on %s"), ctime(&tm));
 +      } else if (sb->s_mkfs_time) {
 +              tm = sb->s_mkfs_time;
 +              printf(_("\tcreated on %s"), ctime(&tm));
 +      } else if (sb->s_mkfs_time) {
 +              tm = sb->s_mtime;
 +              printf(_("\tlast modified on %s"), ctime(&tm));
 +      }

Now you're saying that the last condition should really be

	} else if (sb->s_mtime) {  <========

But that does not make sense because it's the same as the first
condition, so it would either never get there, or never be true.

So it really should be

	} else if (sb->s_wtime) {


so the whole thing should look like:

 +      if (sb->s_mtime) {
 +              tm = sb->s_mtime;
 +              if (sb->s_last_mounted[0]) {
 +                      memset(buf, 0, sizeof(buf));
 +                      strncpy(buf, sb->s_last_mounted,
 +                              sizeof(sb->s_last_mounted));
 +                      printf(_("\tlast mounted on %s on %s"), buf,
 +                             ctime(&tm));
 +              } else
 +                      printf(_("\tlast mounted on %s"), ctime(&tm));
 +      } else if (sb->s_mkfs_time) {
 +              tm = sb->s_mkfs_time;
 +              printf(_("\tcreated on %s"), ctime(&tm));
 +      } else if (sb->s_wtime) {
 +              tm = sb->s_wtime;
 +              printf(_("\tlast modified on %s"), ctime(&tm));
 +      }

Also I wonder whether we need to use 'tm' variable, can't we use the
sb->s_*time directly ? But that's nitpicking.

Thanks!
-Lukas
--8323328-1996339212-1399469881=:2128--
