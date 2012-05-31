From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: container disk quota
Date: Thu, 31 May 2012 13:19:07 +0400
Message-ID: <4FC7378B.2030707@parallels.com>
References: <1338389946-13711-1-git-send-email-jeff.liu@oracle.com> <4FC731C1.5000903@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <jack-AlSwsSmVLrQ@public.gmane.org>, <tytso-3s7WtUTddSA@public.gmane.org>,
	<containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>,
	<hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, <bpm-sJ/iWh9BUns@public.gmane.org>, <christopher.jones-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
	<linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<tm-d1IQDZat3X0@public.gmane.org>, <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, <tinguely-sJ/iWh9BUns@public.gmane.org>
To: <jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FC731C1.5000903-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On 05/31/2012 12:54 PM, Glauber Costa wrote:
> On 05/30/2012 06:58 PM, jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org wrote:
>> Hello All,
>>
>> According to glauber's comments regarding container disk quota, it
>> should be binded to mount
>> namespace rather than cgroup.
>>
>> Per my try out, it works just fine by combining with userland quota
>> utilitly in this way.
> that's great.
>
> I'll take a look at the patches.

Despite my criticism, I do believe those are a lot better than the 
previous version. It seems to me to be the right direction, but some 
more transparency is lacking.

I believe you should be able to do it without a lot less changes to the 
tools - if any.
