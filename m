From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 10/12] container quota: bill container inodes alloc/free
 on ext4.
Date: Thu, 31 May 2012 17:14:50 +0400
Message-ID: <4FC76ECA.3070301@parallels.com>
References: <1338389946-13711-1-git-send-email-jeff.liu@oracle.com> <1338389946-13711-11-git-send-email-jeff.liu@oracle.com> <4FC736AD.2070404@parallels.com> <4FC76B0D.6020804@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<jack-AlSwsSmVLrQ@public.gmane.org>, <daniel.lezcano-GANU6spQydw@public.gmane.org>, Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>,
	<bpm-sJ/iWh9BUns@public.gmane.org>, <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	<christopher.jones-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>,
	<tinguely-sJ/iWh9BUns@public.gmane.org>, <tm-d1IQDZat3X0@public.gmane.org>, <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: <jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FC76B0D.6020804-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On 05/31/2012 04:58 PM, Jeff Liu wrote:
>> >  This should be inside dquot_free_inode().
> Yeah, Ted also mentioned this before, all name space dquot bill routine
> could be placed to dquot_xxx() for VFS quota user.
>
> However, AFAICS, they still have to be exported to other file systems
> which have their own quota management module, like XFS.
>
> Thanks,
> -Jeff
>
Do you have a personal need to have it working with xfs, or is the use 
you are pursuing achievable with the other filesystems?

Unless you have a reason yourself to use xfs, I'd say don't bother with 
it too much at the moment. get it working for the standard interface first.
