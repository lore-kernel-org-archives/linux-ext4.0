From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH 1/2] Add discard/nodiscard mount option for ext3
Date: Mon, 12 Jul 2010 12:03:42 -0400
Message-ID: <4C3B3CDE.9060505@redhat.com>
References: <1278508727-29135-1-git-send-email-lczerner@redhat.com> <1278508727-29135-2-git-send-email-lczerner@redhat.com> <20100712151921.GA19433@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	jmoyer@redhat.com, eshishki@redhat.com, sandeen@redhat.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6928 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752997Ab0GLQAb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Jul 2010 12:00:31 -0400
In-Reply-To: <20100712151921.GA19433@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/12/2010 11:19 AM, Jan Kara wrote:
>> Those mount option has the same meaning as in ext4 file system. It
>> provide a way to enable/disable file system's trim support. The trim
>> support is off by default, thus nodiscard option is not actually
>> necessary.
>    I kind of miss why ext3 should have a 'discard' mount option. When
> user calls DISCARD ioctl on the filesystem, then he probably wants
> discard to be performed.
>
> 								Honza
>

Sorry I misunderstood your original question.

One reason that you might want to have a "discard" option is to allow a system 
admin to mount without barriers to protect flaky hardware (we have had some 
mixed results for example). As you say, the user probably wants to have the 
ioctl do the discard and should be reasonable for doing it only on solid devices,

Regards,

Ric
