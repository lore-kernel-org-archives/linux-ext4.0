From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Massive corruption on RAID0
Date: Tue, 30 Jun 2009 10:33:57 -0500
Message-ID: <4A4A3065.4020202@redhat.com>
References: <298610bb0906281738u2e1ce91fnc753acc145d759bb@mail.gmail.com>	 <4A48355D.5040001@redhat.com> <298610bb0906290812t249c7e52l80e57af36bd0e80c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?UTF-8?B?S3J6eXN6dG9mIEtvc2nFhHNraQ==?= <tweenk.pl@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42652 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229AbZF3Pd7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Jun 2009 11:33:59 -0400
In-Reply-To: <298610bb0906290812t249c7e52l80e57af36bd0e80c@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Krzysztof Kosi=C5=84ski wrote:
> W dniu 29 czerwca 2009 05:30 u=C5=BCytkownik Eric Sandeen
> <sandeen@redhat.com> napisa=C5=82:
>> Is the super.bin above from before the fiddling you did (i.e. right
>> after the power loss?)
> Yes, it's before I started my recovery attempts, though mount and
> e2fsck -p were run on it during the boot process before I removed it
> from fstab.
>=20
>> The superblock is marked with errors, I wonder
>> if there were other errors reported on the filesystem prior to the p=
ower
>> loss; you might check your logs ...
> I checked and it seems there were no errors until the power failure.
> By the way, is there some way to have RAID0-like functionality with
> write barriers?

Mirrors can pass barriers, IIRC, but not stripes (IIRC...) - I don't
know if any work is being done to address this.

I wonder if there's any chance that your raid was reassembled
incorrectly....

-Eric
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
