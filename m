From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Fwd: Need help with Data Recovery on Ext4 partitions that became
 corrupted on running OS
Date: Wed, 25 Sep 2013 19:59:50 -0500
Message-ID: <52438706.3090706@redhat.com>
References: <CAOWv6b1Jq0MAtELB_brhg_G3S2svEW8EaW9A8ciddTUdqDWFdQ@mail.gmail.com> <CAOWv6b1m8A2S3sjDsJxOrRVztch6iq4zH9eFq5DKFMqtWWWpEw@mail.gmail.com> <CAOWv6b3+rzK4a6Oc29R2gNTv-mX+9QvnsuE0O3dCL8F8-PfjTQ@mail.gmail.com> <20130925161259.GA5404@quack.suse.cz> <CAOWv6b3xh34_86QWy7O24U-voQ2JXw5JFDThgoiXD27WOMCZxQ@mail.gmail.com> <20130925212834.GA10542@quack.suse.cz> <CAOWv6b3OPaSMRvE8cG5_6Qkq-gUGheX7hccmLtO=z7wkekq8ZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: InvTraySts <invtrasys@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13538 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591Ab3IZA7y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Sep 2013 20:59:54 -0400
In-Reply-To: <CAOWv6b3OPaSMRvE8cG5_6Qkq-gUGheX7hccmLtO=z7wkekq8ZA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9/25/13 7:08 PM, InvTraySts wrote:
> (Going to merge these two back, because both of you are actually
> helping me, but with the two conversations being segregated like this
> it makes it hard to correlate with you both)
> The partprobe did work with getting the partition table reread.
> After that, the tune2fs sorta worked.
> root@server:~# tune2fs -f -O ^has_journal /dev/sdf1
> tune2fs 1.42.5 (29-Jul-2012)
> root@server:~# mount /dev/sdf1 /media/tmp
> root@server:~# ls -l /media/tmp/
> total 0
> 
> When I try and use the debugfs /dev/sdf1
> 
> root@server:~# debugfs /dev/sdf1
> debugfs 1.42.5 (29-Jul-2012)
> debugfs:  ls
> EXT2 directory corrupted
> debugfs:  ls /
> /: EXT2 directory corrupted

At this point you could try e2fsck on the _copy_, to see what it
can do.

Seems like something quite bad may have happened to your storage,
though, and e2fsck may not be magical for you.

-Eric

