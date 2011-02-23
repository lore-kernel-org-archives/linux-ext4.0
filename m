From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [opensuse-factory] /sbin/fstrim: /home: FITRIM ioctl failed:
 Operation not supported
Date: Wed, 23 Feb 2011 21:18:51 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1102232117010.2934@dhcp-27-109.brq.redhat.com>
References: <4D644245.9000809@opensuse.org> <AANLkTi=sMAam8sa-QUxZKzeCev2JWqhc+HnhwC33wgUy@mail.gmail.com> <alpine.LFD.2.00.1102231119580.2934@dhcp-27-109.brq.redhat.com> <4D655C06.2080704@opensuse.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="571140353-1650493836-1298492334=:2934"
Cc: Lukas Czerner <lczerner@redhat.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	opensuse-factory <opensuse-factory@opensuse.org>,
	ext4 <linux-ext4@vger.kernel.org>, linux-fsdevel@vger.kernel.org
To: =?ISO-8859-15?Q?Cristian_Rodr=EDguez?= <crrodriguez@opensuse.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4D655C06.2080704@opensuse.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--571140353-1650493836-1298492334=:2934
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 23 Feb 2011, Cristian Rodríguez wrote:

> El 23/02/11 07:28, Lukas Czerner escribió:
> > On Tue, 22 Feb 2011, Greg Freemyer wrote:
> > 
> >> On Tue, Feb 22, 2011 at 6:09 PM, Cristian Rodríguez
> >> <crrodriguez@opensuse.org> wrote:
> >>>  Hi:
> >>>
> >>>  I get the error message in $Subject if I try to use /sbin/fstrim on all
> >>>  my filesystems BUT /boot which is the only one which is not encrypted.
> >>>
> >>>  How am I supposed to "trim" dm-crypt/LUKS volumes on an SSD device ?
> >>>
> >>> Thanks.
> 
> Lukas, thanks for your answer.
> 
> > No NO NO! Big no to trimming encrypted filesystems! When you are
> > discarding blocks, the subsequent read from those blocks are usually "well
> > defined" and hence you are giving away useful information for attacker
> > trying to decrypt your filesystem. 
> 
> I understand that there might be security issues, but so far, for this
> scenario the only kind of attacker from which I need to protect my
> desktop is from low-funded regular thieves that may break into my home
> office, unlikely that will get pass the volume password prompt ;-)
> 
> 
> > Now, there might be some way around this to allow trimming encrypted
> > volumes without serious security issue, but this is rather question for
> > dm-crypt guys.
> 
> Maybe making work the "discard" mount option ?
> --

This is really a question for dm-crypt/block layer guys.
Adding linux-fsdevel@vger.kernel.org into cc.

> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--571140353-1650493836-1298492334=:2934--
