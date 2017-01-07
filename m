From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Mount option "noacl" will be removed by 3.5
Date: Sat, 7 Jan 2017 10:48:11 -0600
Message-ID: <6a320116-76a0-0562-3732-954002d40e45@redhat.com>
References: <fd36725d-d6d8-35a2-4f69-a3391aa4e42e@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Udo van den Heuvel <udovdh@xs4all.nl>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53760 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756192AbdAGQsN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 7 Jan 2017 11:48:13 -0500
In-Reply-To: <fd36725d-d6d8-35a2-4f69-a3391aa4e42e@xs4all.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/7/17 7:14 AM, Udo van den Heuvel wrote:
> Hello!
> 
> Why should it go?
> Found no explanation.
> What alternative is there to reduce unnecessary FS traffic?

It was a journey from not /requiring/ -o acl to use acls and
making it the default, to ultimately deprecating the noacl option.

The hope was that over the many years of the transition, anyone
who needed the old behavior would speak up.  :)

You could always compile without CONFIG_EXT4_FS_POSIX_ACL if
you're really concerned about it.  That's build time, not a
per-filesystem switch, of course.

If you have data to show that the inability to turn it off is
harmful, please share.

Thanks,
-Eric

> Kind regards,
> Udo

