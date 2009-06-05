From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: status on 'tune2fs -I 256' ?
Date: Thu, 04 Jun 2009 20:46:17 -0500
Message-ID: <4A2878E9.40802@redhat.com>
References: <7284e2210906041651g10761a2fy7eda6d308b7ccb4d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Doug Hunley <doug.hunley@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:57240 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608AbZFEBqT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Jun 2009 21:46:19 -0400
In-Reply-To: <7284e2210906041651g10761a2fy7eda6d308b7ccb4d@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Doug Hunley wrote:
> I recently converted my '/' filesytem to ext4 from ext3 using:
> tune2fs  -O extents,uninit_bg,dir_index /dev/md3
> 
> I did *not* use '-I 256' as I'd read several reports of this causing
> corruption. However, I've just checked the ext4.txt as shipped with
> 2.6.29 and it quite clearly states:
> If the filesystem was created with 128 byte inodes, it can be
>     converted to use 256 byte for greater efficiency via:
> 
>         # tune2fs -I 256 /dev/hda1
> 
> Is this now safe to do? Or should the documentation be updated to
> reflect the current corruption issue? Would I be ok to run 'tune2fs -I
> 256 /dev/md3' (followed by a forced fsck)?

AFAIK it still has dangerous corners... We should probably update the
ext4.txt, and TBH I'd rather disable the functionality in e2fsprogs
until it's safe.

(the case I ran into was when there was not actually enough space to
double the size of all the inodes - it did not know this ahead of time
and it did not fail gracefully).

-Eric
