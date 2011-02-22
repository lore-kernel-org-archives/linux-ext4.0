From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [opensuse-factory] /sbin/fstrim: /home: FITRIM ioctl failed:
 Operation not supported
Date: Tue, 22 Feb 2011 18:34:37 -0500
Message-ID: <AANLkTi=sMAam8sa-QUxZKzeCev2JWqhc+HnhwC33wgUy@mail.gmail.com>
References: <4D644245.9000809@opensuse.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: opensuse-factory <opensuse-factory@opensuse.org>,
	ext4 <linux-ext4@vger.kernel.org>
To: =?ISO-8859-1?Q?Cristian_Rodr=EDguez?= <crrodriguez@opensuse.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57090 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab1BVXe6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Feb 2011 18:34:58 -0500
Received: by iyb26 with SMTP id 26so2349121iyb.19
        for <linux-ext4@vger.kernel.org>; Tue, 22 Feb 2011 15:34:57 -0800 (PST)
In-Reply-To: <4D644245.9000809@opensuse.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 22, 2011 at 6:09 PM, Cristian Rodr=EDguez
<crrodriguez@opensuse.org> wrote:
> =A0Hi:
>
> =A0I get the error message in $Subject if I try to use /sbin/fstrim o=
n all
> =A0my filesystems BUT /boot which is the only one which is not encryp=
ted.
>
> =A0How am I supposed to "trim" dm-crypt/LUKS volumes on an SSD device=
 ?
>
> Thanks.

=46irst, trim is a nicety, not a 100% requirement.  The FITRIM ioctl wa=
s
just introduced in 2.6.37 and it does NOT work in all environments.
ie. I don't think LVM / mdraid are supported either.  But they may
just silently drop the trim commands in the block stack.

The main solution prior to 2.6.37 was wiper.sh from the hdparm
package.  But it to had known limitations similar to those above.

As to your real question
I suspect that is a question you need to take to lkml or one of its
sub-mailing lists.

          linux-fsdevel@vger.kernel.org,
          linux-ext4@vger.kernel.org

I monitor the ext4 one and have not seen any discussion related to
trimming dm-crypt/LUKS protected volumes that I recall.

I also wonder if wiper.sh from hdparm would work with your
filesystems.  Trouble is a failure may cause major data loss.  I have
no idea of the odds, I'm just very nervous about unintentionally
trimming the wrong sectors.

Mark Lord is the maintainer of hdparm.  I've found him to be pretty
responsive to questions about wiper.sh, so if you can't tell from the
release notes, etc. I'd send him a email.

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
