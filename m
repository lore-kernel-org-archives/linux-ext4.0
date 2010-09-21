From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Is it deliberate that the device mapper is not passing the
 DISCARD ioctls
Date: Tue, 21 Sep 2010 15:47:16 -0400
Message-ID: <AANLkTinuaJnKe21m7Pu9ht0+swE8zZQOSO==myWc=08X@mail.gmail.com>
References: <E1OxgCu-0000XW-29@tytso-glaptop> <alpine.LFD.2.00.1009211232010.3008@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	dm-devel@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64249 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab0IUTri (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Sep 2010 15:47:38 -0400
Received: by fxm3 with SMTP id 3so1719596fxm.19
        for <linux-ext4@vger.kernel.org>; Tue, 21 Sep 2010 12:47:36 -0700 (PDT)
In-Reply-To: <alpine.LFD.2.00.1009211232010.3008@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 21, 2010 at 6:42 AM, Lukas Czerner <lczerner@redhat.com> wrote:
> On Mon, 20 Sep 2010, Theodore Ts'o wrote:
>
>> Hi there,
>>
>> I was just testing discard support in mke2fs, and I was surprised that
>> although the dm layer appears to pass discard requests through to the
>> underlying block device driver when submitted through the bio layer
>> (i.e., from kernel file systems), apparently the discard ioctls (i.e.,
>> BLKDISCARD, BLKDISCARDSEC, BLKDISCARDZEROES) are not currently wired up
>> in the dm layer.
>>
>> Is this deliberate, or an oversight?
>>
>> Thanks, regards,
>
> Hi Ted,
>
> I have tested this with 2.6.35 and it really did not work for me as
> well, but with 2.6.36-rc5 (latests kernel) it works just fine. Though,
> not sure when it was added. But according to the log it seems it was
> merged in with 8357422d4bf33bc2c35884d4016c3fc9efbbc1d2.

Makes sense, DM's discard support was added during the 2.6.36 merge window.

Mike
