From: Mike Mestnik <cheako@visi.com>
Subject: Re: How to use mkfs.ext4 "stride=" on RAID correctly?
Date: Fri, 15 Jan 2010 20:59:38 -0600
Message-ID: <fa7b26051001151859h188159c5x8e82c46b55c8b389@mail.gmail.com>
References: <fa7b26051001131612h482845dalf3446e5fce5f3639@mail.gmail.com>
	 <fa7b26051001131613jc61e20fu5e4d0ccee86d6b16@mail.gmail.com>
	 <fa7b26051001131658ya96c3b0ieb6010c6fba389c4@mail.gmail.com>
	 <4B50AB23.8050300@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, "Martin K. Petersen" <mkp@mkp.net>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f209.google.com ([209.85.219.209]:59224 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758210Ab0APC7j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Jan 2010 21:59:39 -0500
Received: by ewy1 with SMTP id 1so852371ewy.28
        for <linux-ext4@vger.kernel.org>; Fri, 15 Jan 2010 18:59:38 -0800 (PST)
In-Reply-To: <4B50AB23.8050300@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 15, 2010 at 11:51 AM, Ric Wheeler <rwheeler@redhat.com> wro=
te:
> On 01/13/2010 07:58 PM, Mike Mestnik wrote:
>>
>> On Wed, Jan 13, 2010 at 6:13 PM, Mike Mestnik<cheako@visi.com> =A0wr=
ote:
>>
>>>
>>> What should this value be? =A0From what I gather it should be the l=
ength
>>> of data stored on a single disk for each RAID level block. =A0If th=
at's
>>> the case how is it that two given data blocks are calculated to be =
on
>>> separate drives? =A0It seams to me that the stripe-width is also
>>> essential in this regard, but the man page does not reflect this.
>>>
>>> For example let's say that stride=3D1, then which of the following
>>> blocks are not on the same drive as 1: 8 9 10?
>>> The answer is dependent on the number data disks, like so.
>>> Where x =3D n - 1 or n depending on the RAID type.
>>> if x =3D 2 then 9
>>> if x =3D 3 then 8 and 10
>>> if x =3D 5 then 8 and 9
>>>
>>>
>>
>> Wait!!
>> I got this all wrong, one would need all of x, n, and stride to
>> successfully determine the disk used for a given stride.
>>
>> Seams to me mkfs is missing some parameters. =A0What about [-g
>> blocks-per-group]...
>>
>> http://tldp.org/HOWTO/Software-RAID-0.4x-HOWTO-8.html
>>
>>
>
> Hi Mike,
>
> Recent changes upstream export alignment and optimal IO size for you =
(at
> least for software RAID/dm devices) and for some external arrays if t=
he
> vendor exports the information in a standard way.
>
Would this include eSATA DAS units?
Example: LaCie 4big Quadra

I can't discover or alter the IO size on this device and have not
received an answer from LaCie support.  They did say something to the
effect of "We don't have this information in our documentation, so it
must be I.P. that I can't disclose."

> Martin was the lead on that & work has been ongoing to add support up=
 the
> tool chain.
>
> Hopefully, this will get easier to do so we all don't have to work ou=
t the
> numbers each time we build on RAID :-)
>
> Ric
>
>>> There is no way to make this calculation with out knowing x, furthe=
r
>>> more calculating x based of of both stride and stripe-width is roun=
d
>>> about... =A0Why not simply ask for x, the number of data disks and =
have
>>> stripe-width be the value that is calculated, as stride might not g=
o
>>> into stripe-width evenly leaving you with a headache.
>>>
>>> Did I locate a bug?
>>>
>>> Is there a better forum for this discussion?
>>>
>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
