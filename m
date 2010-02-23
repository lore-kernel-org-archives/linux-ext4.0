From: Camille Moncelier <pix@devlife.org>
Subject: Re: [ext3] Changes to block device after an ext3 mount point has been
	remounted readonly
Date: Tue, 23 Feb 2010 09:42:39 +0100
Message-ID: <baaef4711002230042p3d6fa7fam5a80174269773d48@mail.gmail.com>
References: <baaef4711002180845n29561ccif451fae62e49e520@mail.gmail.com>
	<9F53CAF8-B6B4-40EB-89FA-CD6779D17DBE@sun.com> <baaef4711002182338g17e42a7dpa47242dd334a27c2@mail.gmail.com>
	<20100222223252.GA13882@atrey.karlin.mff.cuni.cz> <20100222230552.GB13882@atrey.karlin.mff.cuni.cz>
	<16F918FB-F45D-478E-9358-550BB39E277E@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-fsdevel@vger.kernel.org,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:54981 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab0BWInB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Feb 2010 03:43:01 -0500
In-Reply-To: <16F918FB-F45D-478E-9358-550BB39E277E@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The fact is that I've been able to reproduce the problem on LVM block
devices, and sd* block devices so it's definitely not a loop device
specific problem.

By the way, I tried several other things other than "echo s
>/proc/sysrq_trigger" I tried multiple sync followed with a one minute
"sleep",

"echo 3 >/proc/sys/vm/drop_caches" seems to lower the chances of "hash
changes" but doesn't stops them.

On Tue, Feb 23, 2010 at 12:09 AM, Andreas Dilger <adilger@sun.com> wrot=
e:
> On 2010-02-22, at 16:05, Jan Kara wrote:
>>
>> =A0Hmm, and apparently there is some subtlety in the loopback device=
 code
>> because even when I use sync(1), the first and second images sometim=
es
>> differ (although it's much rarer). But I see a commit block of the
>> transaction =A0already in the first image (the commit block is writt=
en last)
>> but the contents of the transaction is present only in the second im=
age.
>
>
> It has never been safe to run ext3 on top of a loop device, because t=
he loop
> device does not preserve ordering, and I'm not sure whether it proper=
ly
> passes barriers either.
>
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
>
>



--=20
Camille Moncelier
http://devlife.org/

If Java had true garbage collection, most programs would
delete themselves upon execution.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
