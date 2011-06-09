From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH v1 00/30] Ext4 snapshots
Date: Thu, 9 Jun 2011 11:51:07 +0800
Message-ID: <BANLkTik9Mnq5yqK795pxyr8SK-3EOzzNhA@mail.gmail.com>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
	<alpine.LFD.2.00.1106071735100.11385@dhcp-27-109.brq.redhat.com>
	<BANLkTikAB-RDDS8PMMrFK-OuY6PuavBixA@mail.gmail.com>
	<alpine.LFD.2.00.1106081114240.5026@dhcp-27-109.brq.redhat.com>
	<BANLkTi=T1OtyRSWNTA6xhkTy5uaHWqA_XA@mail.gmail.com>
	<alpine.LFD.2.00.1106081716200.6609@dhcp-27-109.brq.redhat.com>
	<BANLkTikUXdvMQROYEdxnyfcPuB0e9ozMOg@mail.gmail.com>
	<BANLkTinU9Hegr3iA5it2vNjE_RYbB+8+RQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, linux-kernel@vger.kernel.org, sandeen@redhat.com
To: "Amir G." <amir73il@users.sourceforge.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47075 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744Ab1FIDvI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Jun 2011 23:51:08 -0400
In-Reply-To: <BANLkTinU9Hegr3iA5it2vNjE_RYbB+8+RQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 9, 2011 at 11:18 AM, Amir G. <amir73il@users.sourceforge.ne=
t> wrote:
> On Thu, Jun 9, 2011 at 4:59 AM, Yongqiang Yang <xiaoqiangnk@gmail.com=
> wrote:
>>> But I do understand the difference. And also, when it comes to fs l=
evel
>>> snapshotting I would suspect that it would do something we can not =
do
>>> with the current solutions, for example per-file or per-directory s=
napshots,
>>> cat ext4 snapshots do that ?
>> Hi Lukas,
>>
>> I noticed that there is no answer to this question in the thread. =A0=
I
>
> I think I answered this question with No it can't ;-)
I think this can be implemented easily by chattr and adding check in
should_snapshot() or should_move_data().

And I thought Lukas are focusing on if ext4-snapshots can do this
easily.  So i said YES:-)

>
>> can give the question the answer that ext4 can snapshot per-file or
>> per-directory, and can exclude some files or directories from being
>> snapshotted.
>>
>
> So the full answer is that ext4 snapshot CAN exclude
> certain files/dirs from snapshot, but this feature is not fully imple=
mented yet
> (I have it in a dev branch)
>
>> --
>> Best Wishes
>> Yongqiang Yang
>>
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
