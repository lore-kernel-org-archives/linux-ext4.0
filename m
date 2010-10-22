From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: [PATCH] e2fsck: Discard free data and inode blocks.
Date: Fri, 22 Oct 2010 13:14:12 -0400
Message-ID: <4CC1C664.90109@gmail.com>
References: <1287670556-23460-1-git-send-email-lczerner@redhat.com>	<6388FD2D-50A8-42B9-A955-3824451ACBF4@dilger.ca>	<alpine.LFD.2.00.1010221059490.3007@dhcp-lab-213.englab.brq.redhat.com>	<4CC175E6.5000700@gmail.com>	<alpine.LFD.2.00.1010221335080.3390@dhcp-lab-213.englab.brq.redhat.com>	<4CC19BC2.9010503@gmail.com>	<alpine.LFD.2.00.1010221620490.3390@dhcp-lab-213.englab.brq.redhat.com>	<4CC1A3AA.6040004@gmail.com> <4CC1AFD2.2020803@redhat.com>	<4CC1B094.3090403@gmail.com> <yq18w1qp3bl.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, tytso@mit.edu
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54249 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545Ab0JVROT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Oct 2010 13:14:19 -0400
Received: by yxn35 with SMTP id 35so830280yxn.19
        for <linux-ext4@vger.kernel.org>; Fri, 22 Oct 2010 10:14:18 -0700 (PDT)
In-Reply-To: <yq18w1qp3bl.fsf@sermon.lab.mkp.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  On 10/22/2010 01:03 PM, Martin K. Petersen wrote:
>>>>>> "Ric" == Ric Wheeler<ricwheeler@gmail.com>  writes:
>>> so we're not depending on it zeroing blocks, we're just depending on
>>> it advertising correctly whether or not it -does- zero.
> If the relevant bits are set (ATA: DRAT and RZAT, SCSI: TPRZ) we'll set
> the bdev's discard_zeroes_data flag.
>
> [root@test ~]# lsscsi | grep SSD | awk '{ print $7 }'
> /dev/sde
> [root@test ~]# grep . /sys/block/sde/queue/discard_zeroes_data
> 1
>
> The relevant ioctl is BLKDISCARDZEROES.
>
>
> Ric>  I think that ATA devices have historically not done this correctly,
>
> I'm only aware of one drive that advertised RZAT and got it wrong. I
> believe a firmware update fixed it.
>
> Generally we assume that if the firmware writers go through the effort
> of reporting things correctly then they have also implemented the
> feature. We have quite a few sanity checks in place in libata so we
> won't trigger if the firmware guys just put all ones in a word, for
> instance. There are several things that need to line up for us to
> actually set the discard flags.
>
>
> PS. http://oss.oracle.com/~mkp/docs/linux-advanced-storage.pdf
>

Hi Martin,

I think that the T13 people are still reworking (or have just finished?) the 
spec. For example,

http://www.t13.org/documents/UploadedDocuments/docs2010/e09158r2-Trim_Clarifications.pdf

has more detail on how to interpret those bits.  I certainly cannot claim to 
have followed all of this recently, but do recall that early on the ATA devices 
specifically had various behaviors that caused concern.

Ric

