From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [opensuse-factory] /sbin/fstrim: /home: FITRIM ioctl failed:
 Operation not supported
Date: Wed, 23 Feb 2011 11:28:32 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1102231119580.2934@dhcp-27-109.brq.redhat.com>
References: <4D644245.9000809@opensuse.org> <AANLkTi=sMAam8sa-QUxZKzeCev2JWqhc+HnhwC33wgUy@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="571140353-2032693338-1298456914=:2934"
Cc: =?ISO-8859-15?Q?Cristian_Rodr=EDguez?= <crrodriguez@opensuse.org>,
	opensuse-factory <opensuse-factory@opensuse.org>,
	ext4 <linux-ext4@vger.kernel.org>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017Ab1BWK2j (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Feb 2011 05:28:39 -0500
In-Reply-To: <AANLkTi=sMAam8sa-QUxZKzeCev2JWqhc+HnhwC33wgUy@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--571140353-2032693338-1298456914=:2934
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Tue, 22 Feb 2011, Greg Freemyer wrote:

> On Tue, Feb 22, 2011 at 6:09 PM, Cristian Rodríguez
> <crrodriguez@opensuse.org> wrote:
> >  Hi:
> >
> >  I get the error message in $Subject if I try to use /sbin/fstrim on all
> >  my filesystems BUT /boot which is the only one which is not encrypted.
> >
> >  How am I supposed to "trim" dm-crypt/LUKS volumes on an SSD device ?
> >
> > Thanks.

No NO NO! Big no to trimming encrypted filesystems! When you are
discarding blocks, the subsequent read from those blocks are usually "well
defined" and hence you are giving away useful information for attacker
trying to decrypt your filesystem. And I do not think dm-crypt guys will
ever allow this. wiper.sh might work, however you can as well give up on
using encrypted filesystem.

Now, there might be some way around this to allow trimming encrypted
volumes without serious security issue, but this is rather question for
dm-crypt guys.

Thanks!
-Lukas


> 
> First, trim is a nicety, not a 100% requirement.  The FITRIM ioctl was
> just introduced in 2.6.37 and it does NOT work in all environments.
> ie. I don't think LVM / mdraid are supported either.  But they may
> just silently drop the trim commands in the block stack.
> 
> The main solution prior to 2.6.37 was wiper.sh from the hdparm
> package.  But it to had known limitations similar to those above.
> 
> As to your real question
> I suspect that is a question you need to take to lkml or one of its
> sub-mailing lists.
> 
>           linux-fsdevel@vger.kernel.org,
>           linux-ext4@vger.kernel.org
> 
> I monitor the ext4 one and have not seen any discussion related to
> trimming dm-crypt/LUKS protected volumes that I recall.
> 
> I also wonder if wiper.sh from hdparm would work with your
> filesystems.  Trouble is a failure may cause major data loss.  I have
> no idea of the odds, I'm just very nervous about unintentionally
> trimming the wrong sectors.
> 
> Mark Lord is the maintainer of hdparm.  I've found him to be pretty
> responsive to questions about wiper.sh, so if you can't tell from the
> release notes, etc. I'd send him a email.
> 
> Greg
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
--571140353-2032693338-1298456914=:2934--
