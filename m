From: Glauber Costa <glommer@parallels.com>
Subject: Re: container disk quota
Date: Sun, 3 Jun 2012 13:48:18 +0400
Message-ID: <4FCB32E2.6050404@parallels.com>
References: <1338389946-13711-1-git-send-email-jeff.liu@oracle.com> <20120601155457.GA30909@quack.suse.cz>	<20120601160421.GA17402@amd1> <4FC9ABBB.3050303@oracle.com> <01FED15D-15A3-4542-B95B-1166F0A309E6@parallels.com> <4FC9B183.10605@oracle.com> <8660DDAA-D7A7-4C03-8CBB-9DB7E94C80CB@parallels.com> <4FCAE6CB.8060208@oracle.com> <81DE9C10-649B-4D13-86B0-200944AE8767@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "jeff.liu@oracle.com" <jeff.liu@oracle.com>,
	Jan Kara <jack@suse.cz>, "tytso@mit.edu" <tytso@mit.edu>,
	"tinguely@sgi.com" <tinguely@sgi.com>,
	"containers@lists.linux-foundation.org"
	<containers@lists.linux-foundation.org>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"hch@infradead.org" <hch@infradead.org>,
	"bpm@sgi.com" <bpm@sgi.com>,
	"christopher.jones@oracle.com" <christopher.jones@oracle.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
	"tm@tao.ma" <tm@tao.ma>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"chris.mason@oracle.com" <chris.mason@oracle.com>
To: Kirill Korotaev <dev@parallels.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.parallels.com ([64.131.90.16]:48816 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624Ab2FCJup (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 3 Jun 2012 05:50:45 -0400
In-Reply-To: <81DE9C10-649B-4D13-86B0-200944AE8767@parallels.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/03/2012 09:47 AM, Kirill Korotaev wrote:
>
> On Jun 3, 2012, at 08:23 , Jeff Liu wrote:
>
>> Hi Kirill,
>>
>> On 06/02/2012 11:21 PM, Kirill Korotaev wrote:
>>
>>>>>>>
>>>>>>> Not having looked closely at the original patchset, let me ask - is this
>>>>>>> feature going to be a freebie with Eric's usernamespace patches?
>>>>>>
>>>>>> It we can reach a consensus to bind quota on mount namespace for
>>>>>> container or other things maybe.
>>>>>
>>>>> 1. OpenVZ doesn't use mount namespaces and still has quotas per container.
>>>>
>>>> AFAICS, OpenVZ has self-released quota tools to supply this feature.
>>>
>>> but standard quota tools work inside container w/o any modifications.
>>> This is very important for us, cause we run unmodified distros inside.
>>
>> Yes, am agree.
>> I can work out a new patches regarding quota tools based on mount namespace w/o any modification.
>
> Jeff, why do you need fs namespace for quotas? OpenVZ works w/o it.
> It sounds as too strict use case limitation. Or do I understand your patchset description wrong?
>

OpenVZ has its own kernel, with its very own isolation capabilities.
So in upstream, something has to be used instead.


