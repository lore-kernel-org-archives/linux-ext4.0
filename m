From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: Test results for ext4
Date: Fri, 30 May 2008 18:21:16 +0200
Message-ID: <4840297C.7030809@bull.net>
References: <48402253.8040407@bull.net> <484024EF.7080304@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:40981 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbYE3QVi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 May 2008 12:21:38 -0400
In-Reply-To: <484024EF.7080304@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> Valerie Clement wrote:
>> Hi all,
>>
>> Since a couple of weeks, I did batches of tests to have some perform=
ance
>> numbers for the new ext4 features like uninit_groups, flex_bg or
>> journal_checksum on a 5TB filesystem.
>> I tried to test allmost all combinations of mkfs and mount options, =
but
>> I put only a subset of them in the result tables, the most significa=
nt
>> for me.
>>
>> I had started to do these tests on a kernel 2.6.26-rc1, but I'd got =
several
>> hangs and crashes occuring randomly outside ext4, sometimes in the s=
lab
>> code or in the scsi driver eg., and which were not reproductible.
>> Since 2.6.26-rc2, no crash or hang occur with ext4 on my system.
>>
>> The first results and the test description are available here:
>> http://www.bullopensource.org/ext4/20080530/ffsb-write-2.6.26-rc2.ht=
ml
>> http://www.bullopensource.org/ext4/20080530/ffsb-readwrite-2.6.26-rc=
2.html
>=20
> To be fair in your comparisons with xfs, you should probably either t=
urn
> barriers off for xfs, or on for ext[34], just FWIW.
>=20

Oops, I did the test on a device mapper /dev/md0. I forgot to change it=
 in
the test description. I will do it.

When mounting the xfs filesystem, I've got the following message:
  Filesystem "md0": Disabling barriers, not supported by the underlying=
 device

It means barriers are not supported by my device, isn' it?

   Val=E9rie


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
