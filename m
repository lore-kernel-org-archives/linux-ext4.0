From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: noacl
Date: Thu, 04 Jun 2015 11:05:21 -0500
Message-ID: <55707741.7050700@redhat.com>
References: <CANxXLRbJcK0=nOuWPVm2kaoWmByEuWn0bjNfpmdBFmY04J65+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Tobias Koeck <tobias.koeck@gmail.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40266 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbbFDQFX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Jun 2015 12:05:23 -0400
In-Reply-To: <CANxXLRbJcK0=nOuWPVm2kaoWmByEuWn0bjNfpmdBFmY04J65+g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/4/15 10:50 AM, Tobias Koeck wrote:
> Hi there,
> 
> is there a reason you want to remove the noacl option?

I'll answer your question with a question ;)

Is there a reason you want to keep the noacl option?

It (and nouser_xattr) were deprecated because extN were the only
filesystems which allowed this sort of configuration as a mount
option, and it seemed to serve no obvious purpose.

-Eric

