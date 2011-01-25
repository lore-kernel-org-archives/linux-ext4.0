From: tm@tao.ma
Subject: Re: speed up group trim
Date: Mon, 24 Jan 2011 18:53:21 -0700
Message-ID: <feb4ec15d3913393777662cebb65986b.squirrel@mail.tao.ma>
References: <1295577131-3778-1-git-send-email-tm@tao.ma>
    <alpine.LFD.2.00.1101211148180.3275@dhcp-lab-213.englab.brq.redhat.com>
    <CD6D9488-48B7-4964-97DF-76B985FC8FAF@dilger.ca>
    <4D3A9604.1040001@tao.ma>
    <B0539BCD-0D34-4463-8B4B-94910B6E3833@dilger.ca>
    <4D3CDEFB.4010102@tao.ma>
    <alpine.LFD.2.00.1101241417560.3090@dhcp-lab-213.englab.brq.redhat.com>
    <C2FEF4DB-531E-4541-8332-A8845396EAC7@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "Lukas Czerner" <lczerner@redhat.com>, "Tao Ma" <tm@tao.ma>,
	linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: "Andreas Dilger" <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:46923 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751680Ab1AYBxW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Jan 2011 20:53:22 -0500
In-Reply-To: <C2FEF4DB-531E-4541-8332-A8845396EAC7@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On 2011-01-24, at 06:39, Lukas Czerner wrote:
>>> I don't know either. But that is the user's choice of 'minlen' and we
>>> can't
>>> provent them from doing like that.
>>>
>>> Here is a scenario:
>>> 1. run with minlen=1mb, he got that only 1G get trimmed. but the free
>>> space is
>>> more than 3gb actually because of the fragmentation.
>>> 2. So he decide to run with minlen=512kb or even smaller len to see
>>> whether
>>> more space can be trimmed.
>>>
>>> Is it possible? I guess the answer is yes.
>>
>> Hi,
>>
>> I think that this is actually quite useful *feature*. I can imagine that
>> people might want to run FITRIM with bigger minlen (megabytes or tens of
>> megabytes) weekly, as it is much faster, especially on fragmented
>> filesystem. Then, they might want to run FITRIM with smaller minlen
>> (4kB)
>> monthly to reclaim even the smaller (or all of them) extents.
>>
>> But I like Andreas' idea, it should improve FITRIM performance
>> significantly (since we are doing mkfs trim). Minlen can be stored in
>> high bits of bb_state as number of blocks.
>
> I'd rather just add a proper field in ext4_group_info to store the length.
>  I don't think this will change the actual memory usage, since this is
> already a fairly large and odd-sized structure.
yeah, a proper field should be fine.
First, we don't store it in the disk, so we don't care for the layout
compatibility problem.
Second, we don't have much group in the volume. So a new field wouldn't
cost much for us like inodes.

Regards,
Tao

