From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH v1 00/30] Ext4 snapshots
Date: Mon, 13 Jun 2011 16:26:16 +0300
Message-ID: <BANLkTin0Wg9LMjRtHQhyu8rBwU7dQLNW-w@mail.gmail.com>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
	<BANLkTi=T1OtyRSWNTA6xhkTy5uaHWqA_XA@mail.gmail.com>
	<alpine.LFD.2.00.1106081716200.6609@dhcp-27-109.brq.redhat.com>
	<BANLkTikUXdvMQROYEdxnyfcPuB0e9ozMOg@mail.gmail.com>
	<BANLkTinU9Hegr3iA5it2vNjE_RYbB+8+RQ@mail.gmail.com>
	<BANLkTik9Mnq5yqK795pxyr8SK-3EOzzNhA@mail.gmail.com>
	<alpine.LFD.2.00.1106090834270.4138@dhcp-27-109.brq.redhat.com>
	<BANLkTi=fugrRE0P5m8nMPrH_kZqPZB7ajA@mail.gmail.com>
	<alpine.LFD.2.00.1106091012030.4138@dhcp-27-109.brq.redhat.com>
	<BANLkTin0RKZbDmB1movombH9o4HDpTnvFw@mail.gmail.com>
	<alpine.LFD.2.00.1106091443370.4138@dhcp-27-109.brq.redhat.com>
	<BANLkTinEJ6235sPNz_f92nfN0ac4qSnHtw@mail.gmail.com>
	<alpine.LFD.2.00.1106101044350.4502@dhcp-27-109.brq.redhat.com>
	<BANLkTikdmT5vjXJHnRTT-=z8zFVAx+Y6_w@mail.gmail.com>
	<alpine.LFD.2.00.1106131204330.4328@dhcp-27-109.brq.redhat.com>
	<BANLkTinQpXfY=WXmm6BMUErQBF8nNL1fSg@mail.gmail.com>
	<alpine.LFD.2.00.1106131502160.4328@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, sandeen@redhat.com, snitzer@redhat.com,
	lvm-devel@redhat.com, thornber@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34260 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab1FMN0R (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Jun 2011 09:26:17 -0400
Received: by wwa36 with SMTP id 36so4825755wwa.1
        for <linux-ext4@vger.kernel.org>; Mon, 13 Jun 2011 06:26:16 -0700 (PDT)
In-Reply-To: <alpine.LFD.2.00.1106131502160.4328@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 13, 2011 at 4:11 PM, Lukas Czerner <lczerner@redhat.com> wrote:
> On Mon, 13 Jun 2011, Amir G. wrote:
>

-snip-
>> >>
>> >> Did you come to understand the drawbacks of multisnap (physical fragmentation)?
>> >
>> > Yes I did, but the fragmentation is problem for any thinly provisioned
>> > storage. I also understand that your snapshot files has also proble with
>> > fragmentation.
>> >
>>
>> It's true. ext4 snapshots generates fragmented *files*, but it does not fragment
>> the filesystem metadata. And only on specific workloads of in-place writes,
>> like large db or virtual image.
>>
>> One difference is that ext4 snapshots can do effective auto defrag by using
>> the inode context, which is not available for multisnap.
>
> No it is not, but from top of my head .. we can use time locality to
> pack frequently accessed blocks together. Definitely there is a place
> for improvements.
>
>> The other big difference is that ext4 snapshots gives precedence to main
>> fs performance, while multisnap hasn't even the notion of a main fs.
>> All thinp and snapshot targets are writable and get equal treatment.
>
> I am sorry, what do you mean by that ? Is it that when you mount the
> snapshot, the reads will actually have lower importance ?
>

with ext4, snapshots reads may cause extra seeks, but main fs will
stay optimized for reads.
with thinp and multisnap, there is no optimization for read from one
specific target, but I admit that can change in the future when auto defrag
heuristics are applies to multisnap.

Amir.
