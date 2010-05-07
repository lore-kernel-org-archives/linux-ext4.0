From: Bernd Schubert <bschubert@ddn.com>
Subject: Re: status of MMP?
Date: Fri, 7 May 2010 17:14:51 +0200
Message-ID: <4BE42E6B.90405@ddn.com>
References: <201005052330.49491.bs_lists@aakef.fastmail.fm> <87zl0b21ki.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Bernd Schubert <bs_lists@aakef.fastmail.fm>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Andreas Dilger <andreas.dilger@oracle.com>
To: Andi Kleen <andi@halobates.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.datadirectnet.com ([74.62.46.229]:35081 "EHLO
	mail.datadirectnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343Ab0EGPUM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 May 2010 11:20:12 -0400
In-Reply-To: <87zl0b21ki.fsf@basil.nowhere.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 05/07/2010 05:06 PM, Andi Kleen wrote:
> Bernd Schubert <bs_lists@aakef.fastmail.fm> writes:
> 
>>
>> Lustres ldiskfs already has MMP support for several years and I would like to 
>> know what is the blocker for ext4? Updating the MMP patches for ext4-git 
>> should be fairly simple.
> 
> AFAIK simply nobody has done the work and submitted it.
> 
> Simply adding it would break LVM snapshots though, so there's a 
> compatibility issue.

Well, firstly, you are not forced to enable MMP. And then, I don't
understand what should be the issue with MMP. We use snapshots + ldiskfs
+ MMP all the time.


I have a basic understanding how the MMP code works, but not as thorough
as the Orcacle Lustre team. Andreas, would you mind if I post updated
patches here?

Cheers,
Bernd
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkvkLmsACgkQqh74FqyuOzT0bwCfQQRWqaUcTM0xQ1dgyAv483t1
2fQAniCT6AWBdqJiKWQmpUMdYvEKKubW
=U2NE
-----END PGP SIGNATURE-----
