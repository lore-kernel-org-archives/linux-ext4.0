From: jehan procaccia <jehan.procaccia@it-sudparis.eu>
Subject: Re: ext4 and quota generate "Data will be lost" errors :-(
Date: Thu, 17 Sep 2009 17:53:05 +0200
Message-ID: <4AB25B61.6050201@it-sudparis.eu>
References: <4AB23E80.9070805@it-sudparis.eu> <4AB24A43.6090205@redhat.com>
Reply-To: jehan.procaccia@it-sudparis.eu
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp4.int-evry.fr ([157.159.10.71]:52777 "EHLO
	smtp4.int-evry.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562AbZIQPxI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Sep 2009 11:53:08 -0400
In-Reply-To: <4AB24A43.6090205@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen a =E9crit :
> jehan procaccia wrote:
>> $ rpm -q quota
>> quota-3.16-7=20
>> I upgraded redhat quota package from recompile fedora10 sources beca=
use=20
>> of this changelog:
>>
>> * Thu Oct 30 2008 Ondrej Vasik <ovasik@redhat.com <mailto:ovasik@red=
hat.com>> 1:3.16-6
>> - fix implementation of ext4 support
>>    =20
>
> and this will not affect your kernelspace issues, which were mostly
> fixed in .30 by this and other commits:
>
> commit 60e58e0f30e723464c2a7d34b71b8675566c572d
> Author: Mingming Cao <cmm@us.ibm.com>
> Date:   Thu Jan 22 18:13:05 2009 +0100
>
>     ext4: quota reservation for delayed allocation
>
>     Uses quota reservation/claim/release to handle quota properly for
> delayed
>     allocation in the three steps: 1) quotas are reserved when data
> being copied
>     to cache when block allocation is defered 2) when new blocks are
> allocated.
>     reserved quotas are converted to the real allocated quota, 2)
> over-booked
>     quotas for metadata blocks are released back.
>
>     Signed-off-by: Mingming Cao <cmm@us.ibm.com>
>     Acked-by: "Theodore Ts'o" <tytso@mit.edu>
>     Signed-off-by: Jan Kara <jack@suse.cz>
>
>  =20
Then I suppose it will be solved for me when redhat will ship a 2.6.30=20
kernel ?
is there such kernel backport to an rpm for redhat 5.4, or maybe a=20
rawhide one that I could recompile for rhel 5.4 ?
if  kernel 2.6.18-164.el5 is in real a 2.6.29 codebase, how can we=20
translate redhat rpm kernel version number  to real kernel version numb=
er ?
>> I have a discussion with redhat on this:=20
>> https://bugzilla.redhat.com/show_bug.cgi?id=3D522615
>> the reponse is to move back to ext3 until redhat support quota for e=
xt4 .
>>
>> my probleme is that I have lot of users and filesystems in this=20
>> situation now, and I wonder I couldn't expect a workaround ?
>> is this issue know in recent kernel,  will I really lose data ?=20
>> any advice greatly appreciated .
>>    =20
>
> It's a fundamental change in quota to deal with delalloc, which was n=
ot
> ready in time for RHEL5.4.  It's mostly fixed upstream, though there
> have been some recent bug reports.  If anyone on the list has other
> suggestions I'm all ears, but I think we've covered most of this in t=
he
> bug already.
>
>  =20

Yes any suggestions from this list  ? I'am all ears too ...

Am I actually really "losing" data ?

Message from syslogd@ at Thu Sep 17 15:40:11 2009 ...
> gizeh kernel: mpage_da_map_blocks block allocation failed for inode=20
> 3412191 at logical offset 0 with max blocks 1 with error -122
> Message from syslogd@ at Thu Sep 17 15:40:11 2009 ...
> gizeh kernel: This should not happen.!! Data will be lost


thanks Eric for responding on all media ;-)
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
