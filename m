From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [RFC] ext4: block reservation allocation
Date: Sun, 11 Mar 2012 13:32:34 -0400
Message-ID: <4F5CE1B2.80501@ubuntu.com>
References: <20120227090901.GA13953@gmail.com> <4F58E0AF.3010207@ubuntu.com> <CAGpXXZ+z-HVECg+EAe4-d20BkjhX7bjxaHOs2_KBbgQaJwpCHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:17605 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310Ab2CKRcg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 11 Mar 2012 13:32:36 -0400
In-Reply-To: <CAGpXXZ+z-HVECg+EAe4-d20BkjhX7bjxaHOs2_KBbgQaJwpCHQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/10/2012 07:26 PM, Greg Freemyer wrote:
>> I thought this could be done with the new defrag api.  I thought it had a
>> way to allocate a new donor file in a specific location so you could then
>> migrate the target file to those specific donor blocks.
>>
>>
> I'm not aware of that ability in the defrag api.
> 
> There are ohsm patches to do things along those lines, but they haven't
> been updated since 2.6.30 days as far as I know.

It seems this ability would be vital to e4defrag.  Without it, it would end up being no better than filesystem agnostic defragmenters like shake.  I'm almost certain there was some discussion in this direction a few years ago when e4defrag started being talked about, was it really not implemented?


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPXOGuAAoJEJrBOlT6nu75n5kIANngR3o+ZQ6vij+jJ7nj1/S1
nTmWUA70328xZD/Ht2G/ue3oTqOnQmxDIFOhM8AuUoZ0fHondSRXRFpPsXyUU7LO
uc/ZranjqGCAH7IP3FzduqvOcQSJS8Vo4CI9bjrH0fnB7uV+vYbB0mVkVh7X2AHi
T/1h0KIbtna8T7n1ISb3xqvKDY1zUM5qR9a7qo5fHkZpgLBDQNDxu1Q1qMEiytet
HPksKZcPPvkA8oOuHvika1zj2FiidWWcmPsv20P80BtTaRUBmAHbc3s3Wox3THWh
SP0tI0260LiMEyVVSpdsx76NoV9lFpu0ezNOtFHjFL99lnCV2K/fsHpTaICDBiA=
=E6n5
-----END PGP SIGNATURE-----
