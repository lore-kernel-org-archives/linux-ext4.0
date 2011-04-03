From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: problem(?) in ext4 or mke2fs
Date: Sun, 03 Apr 2011 11:56:32 -0700
Message-ID: <4D98C2E0.3010808@redhat.com>
References: <BANLkTi=gE-utOo479RU8qcWM99NpBrFmvQ@mail.gmail.com> <4D98BF34.6040503@redhat.com> <BANLkTikZYqbjkTrZPAPFkhMcRnmJtuAzzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Zeev Tarantov <zeev.tarantov@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753096Ab1DCS4V (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 3 Apr 2011 14:56:21 -0400
In-Reply-To: <BANLkTikZYqbjkTrZPAPFkhMcRnmJtuAzzw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/3/11 11:52 AM, Zeev Tarantov wrote:
> On Sun, Apr 3, 2011 at 21:40, Eric Sandeen <sandeen@redhat.com> wrote:

...

>> What does
>>
>> # blockdev --getiomin --getioopt /dev/<yourdevice>
>>
>> say for your device?
> 
> get logical block (sector) size: 4096
> get physical block (sector) size: 4096
> get minimum I/O size: 4096
> get optimal I/O size: 4096
> get alignment offset in bytes: 0
> get max sectors per request: 255
> get blocksize: 4096
> get readahead: 256
> 
>> The device may be reporting odd values, but mke2fs probably
>> should be smart enough not to set block-sized stripe unit and width...
> 
> If the filesystem created with the default options is slow or has
> higher cpu usage, it should be changed.

I agree.  For actual striped storage, this makes it faster, but this
case is a problem; block-sized stripe width is never going to be good.
What device is this, exactly?

-Eric (losing my free airport wifi in about 8 minutes, so I may have
to continue this later...!)

>> -Eric
> 
> -Z.T.
