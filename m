From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: problem(?) in ext4 or mke2fs
Date: Sun, 3 Apr 2011 14:40:43 -1000
Message-ID: <FFAB12EA-38E0-41B1-AB11-C5D6FE86104E@whamcloud.com>
References: <BANLkTi=gE-utOo479RU8qcWM99NpBrFmvQ@mail.gmail.com> <4D98BF34.6040503@redhat.com> <BANLkTikZYqbjkTrZPAPFkhMcRnmJtuAzzw@mail.gmail.com> <4D98C2E0.3010808@redhat.com>
Mime-Version: 1.0 (iPhone Mail 8F190)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Zeev Tarantov <zeev.tarantov@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47879 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab1DDAkq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 3 Apr 2011 20:40:46 -0400
Received: by pzk9 with SMTP id 9so1167219pzk.19
        for <linux-ext4@vger.kernel.org>; Sun, 03 Apr 2011 17:40:46 -0700 (PDT)
In-Reply-To: <4D98C2E0.3010808@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



Cheers, Andreas

On 2011-04-03, at 8:56 AM, Eric Sandeen <sandeen@redhat.com> wrote:

> On 4/3/11 11:52 AM, Zeev Tarantov wrote:
>> On Sun, Apr 3, 2011 at 21:40, Eric Sandeen <sandeen@redhat.com> wrote:
> 
> ...
> 
>>> What does
>>> 
>>> # blockdev --getiomin --getioopt /dev/<yourdevice>
>>> 
>>> say for your device?
>> 
>> get logical block (sector) size: 4096
>> get physical block (sector) size: 4096
>> get minimum I/O size: 4096
>> get optimal I/O size: 4096
>> get alignment offset in bytes: 0
>> get max sectors per request: 255
>> get blocksize: 4096
>> get readahead: 256
>> 
>>> The device may be reporting odd values, but mke2fs probably
>>> should be smart enough not to set block-sized stripe unit and width...
>> 
>> If the filesystem created with the default options is slow or has
>> higher cpu usage, it should be changed.
> 
> I agree.  For actual striped storage, this makes it faster, but this
> case is a problem; block-sized stripe width is never going to be good.
> What device is this, exactly?
> 
> -Eric (losing my free airport wifi in about 8 minutes, so I may have
> to continue this later...!)
> 
>>> -Eric
>> 
>> -Z.T.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
