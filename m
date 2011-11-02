From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 2/2 V2] ext4: remove the resize mount option
Date: Wed, 02 Nov 2011 12:50:11 -0500
Message-ID: <4EB182D3.5000300@redhat.com>
References: <4EB17085.9060107@redhat.com> <4EB1717B.1000202@redhat.com> <4EB171AA.2040006@redhat.com> <10B11A15-3B01-485E-9818-0ED5578170E2@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755796Ab1KBRuO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Nov 2011 13:50:14 -0400
In-Reply-To: <10B11A15-3B01-485E-9818-0ED5578170E2@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/2/11 12:41 PM, Andreas Dilger wrote:
> On 2011-11-02, at 10:36 AM, Eric Sandeen wrote:
>> The resize mount option seems to be of limited value,
>> especially in the age of online resize2fs.  Nuke it.
> 
> I agree that it is useless today.  That said, with the new online
> resize support that Yongqiang Yang is working on, it would again
> be possible to just do "remount -o resize={any larger size}" and
> it would work without the need for an ioctl or special user tool.
> 
> That might be useful in initrd/appliance kind of environments that
> put a premium on userspace tools.  I don't run such an environment,
> but I've read many times about distro installs that want to do an
> image install to the disk and then resize it.  Maybe in the age of
> DVDs and 4GB memory sticks this isn't needed anymore?
> 
> I'm not dead set on keeping it, just pointing out that it might
> again become useful in the same release that this patch lands in.
> 
> Cheers, Andreas

Hm.  Well, just because it -can- be done ... should it be done?
We could do all sorts of things via mount options if we really
wanted to.  mount -o tune2fs=^journal, you name it.

I don't have a super-strong preference either way, but we do
have a tool for this already, so duplicating it in a mount option
seems odd to me.

Thanks,
-Eric

