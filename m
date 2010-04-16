From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: quota reservation fixes for -stable?
Date: Fri, 16 Apr 2010 15:37:35 -0500
Message-ID: <4BC8CA8F.1030708@redhat.com>
References: <4BB36BEC.2000207@redhat.com> <20100401082334.GD3322@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932408Ab0DPUhk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Apr 2010 16:37:40 -0400
In-Reply-To: <20100401082334.GD3322@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/01/2010 03:23 AM, Jan Kara wrote:

>   Ah, I'm testing quotas on non-root fs so I was wondering how come people
> hit the warning so often. Now I understand :) For root filesystem on ext4
> we don't have a chance to not see this warning. That being said the warning
> is pretty useless for ordinary users so I guess we should just hide it
> behind #ifdef __DQUOT_PARANOIA and use it for debugging purposes only.
>   If noone objects soon, I'll do the change.
> 
> 								Honza

Hm, I see this in your tree now, but isn't __DQUOT_PARANOIA defined by
default anyway?

fs/quota/dquot.c:

1da177e4	(Linus Torvalds	2005-04-16 15:20:36 -0700	83)#define
__DQUOT_PARANOIA

-Eric
