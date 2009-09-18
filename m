From: jehan procaccia <jehan.procaccia@it-sudparis.eu>
Subject: Re: howto downgrade ext4 to ext3
Date: Fri, 18 Sep 2009 23:21:08 +0200
Message-ID: <4AB3F9C4.1010702@it-sudparis.eu>
References: <4AB39EC5.6070107@it-sudparis.eu> <20090918175851.GH26991@mit.edu> <4AB3D060.2020101@redhat.com> <20090918193456.GA27303@mit.edu>
Reply-To: jehan.procaccia@it-sudparis.eu
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp4.int-evry.fr ([157.159.10.71]:32992 "EHLO
	smtp4.int-evry.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbZIRVVM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Sep 2009 17:21:12 -0400
In-Reply-To: <20090918193456.GA27303@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso a =E9crit :
> On Fri, Sep 18, 2009 at 01:24:32PM -0500, Eric Sandeen wrote:
>  =20
>> Delalloc should be mostly ok in that kernel, but quota doesn't handl=
e =20
>> it.  So dropping quota -or- dropping delalloc should suffice.
>>
>> OTOH, the -o nodelalloc paths have not gotten a lot of test coverage=
, so =20
>> caveats apply.
>>    =20
>
> I haven't dont a -o delalloc test in a while, but at one point,
> probably about 2-3 months ago, I did do a regression test run using
> the xfsqa test suite with -o delalloc.  Of course, just because
> mainline -o delalloc has been tested doesn't say that much about RHEL
> 5.4's -o delalloc --- there's a reason why it was labelled a
> Technology Preview on RHEL 5.4.  :-)
>
> 						 - Ted
>  =20
I would love to test that option (-o nodelalloc) instead of move back t=
o=20
ext3.
however I don't understand what it is ... Am I taking risk in term of=20
integrity of data if I set it ?, or just losing performances ?
anyway, I'am not sure it is available, when I search it in "man mount",=
=20
I can't find it, is it an undocumennted option ?
=2E..
well it appears to be available as I set it on a test partition with=20
success apparently
$ mount
/dev/mapper/VolGroup03S2IA-LogVolS2ia01 on /disk00 type ext4dev=20
(rw,_netdev,acl,usrquota,grpquota,nodelalloc)

but now, how can I check that there's no more pb on that specific=20
partition( /disk00)?
 when kernel complains this way for example:
Sep 16 18:06:45 gizeh kernel: mpage_da_map_blocks block allocation=20
failed for inode 39419 at logical offset 0 with max blocks 2 with error=
=20
-122
Sep 16 18:06:45 gizeh kernel: This should not happen.!! Data will be lo=
st
I've no indication from which partition that inode is. there's so many=20
error message like this that is won't be easy to tell that none  comes=20
from /disk00 .

thanks for your help .
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
