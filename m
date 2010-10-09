From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: Shorten the backup process?
Date: Sat, 9 Oct 2010 16:56:08 -0400
Message-ID: <AANLkTinht4bmenV1+81HLdoSHG7=DrxEhTMU3db3CFaQ@mail.gmail.com>
References: <4CB0D214.1070301@cybericom.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Chris Lee <cslee-list@cybericom.co.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53374 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757112Ab0JIU4a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 9 Oct 2010 16:56:30 -0400
Received: by iwn6 with SMTP id 6so1738914iwn.19
        for <linux-ext4@vger.kernel.org>; Sat, 09 Oct 2010 13:56:30 -0700 (PDT)
In-Reply-To: <4CB0D214.1070301@cybericom.co.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 9, 2010 at 4:35 PM, Chris Lee <cslee-list@cybericom.co.uk> =
wrote:
>
> Hi All,
> I hope this to bee food for thought as I am not able to code such a t=
hing nor am I in need of such a thing but it seemed like a good idea wh=
en it struck me, so;
> When an filesystem is snap shotted it is a function of the =A0running=
 filesystem to provide the data in that snapshot. (or is that lvms doin=
g?)
> Most users who use snapshots for backup are going to mount the snap s=
hot and then tar it up.
> Would it be a good idea to provide a virtual file through something l=
ike the sysfs that is a tar representation of the snapshot so that a ba=
ckup can just copy the tar file off as needed?
>
> Thanks for reading,
>
> Regards,
> Chris.

That seems like an overly specialized feature for the kernel.

And even if it were a good idea conceptually:

1) ext4 does not currently offer filesystem snapshot capability.  It
is handled at a lower level in the block stack.  (ie. either in the
hardware array or via device mapper).

2) Those lower levels simply are aware of blocks / sectors, not files.
 Thus they have no ability to create a "tar" file.

fyi: btrfs is a more integrated filesystem, so it is at least
technically feasible with it.

Greg


--
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
CNN/TruTV Aired Forensic Imaging Demo -
=A0=A0 http://insession.blogs.cnn.com/2010/03/23/how-computer-evidence-=
gets-retrieved/

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
