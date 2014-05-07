From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH -v2 2/3] mke2fs: print extra information about existing
 ext2/3/4 file systemsGjj
Date: Wed, 7 May 2014 10:54:26 -0400
Message-ID: <20140507145426.GD28814@thunk.org>
References: <1399338133-21373-1-git-send-email-tytso@mit.edu>
 <1399338133-21373-2-git-send-email-tytso@mit.edu>
 <alpine.LFD.2.00.1405061528470.2255@localhost.localdomain>
 <20140507024621.GB6461@thunk.org>
 <alpine.LFD.2.00.1405071014350.2128@localhost.localdomain>
 <20140507123913.GA28814@thunk.org>
 <alpine.LFD.2.00.1405071534070.2128@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54490 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932949AbaEGOy2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 May 2014 10:54:28 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1405071534070.2128@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 07, 2014 at 03:43:09PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> so the whole thing should look like:
>=20
>  +      if (sb->s_mtime) {
>  +              tm =3D sb->s_mtime;
>  +              if (sb->s_last_mounted[0]) {
>  +                      memset(buf, 0, sizeof(buf));
>  +                      strncpy(buf, sb->s_last_mounted,
>  +                              sizeof(sb->s_last_mounted));
>  +                      printf(_("\tlast mounted on %s on %s"), buf,
>  +                             ctime(&tm));
>  +              } else
>  +                      printf(_("\tlast mounted on %s"), ctime(&tm))=
;
>  +      } else if (sb->s_mkfs_time) {
>  +              tm =3D sb->s_mkfs_time;
>  +              printf(_("\tcreated on %s"), ctime(&tm));
>  +      } else if (sb->s_wtime) {
>  +              tm =3D sb->s_wtime;
>  +              printf(_("\tlast modified on %s"), ctime(&tm));
>  +      }

Sorry, that's in fact what I have.

> Also I wonder whether we need to use 'tm' variable, can't we use the
> sb->s_*time directly ? But that's nitpicking.

That's because sb->s_mkfs_time is a __u32, and time_t isn't
necessarily be a 32-bit type (and in fact isn't on x86_64, x32,
apropos of current discussion happening on ksummit-discuss.)  Yes,
that means the ext4 superblock has a 2038 problem, but that's a
separate issue that we should fix one of these days....

	 	    	  	 	       - Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
