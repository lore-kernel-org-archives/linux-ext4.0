From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
Subject: Re: [PATCH 6/6] tests: avoid spurious parallel failure due to temporary
 disk full
Date: Mon, 04 Apr 2011 10:34:16 +0100
Message-ID: <4D999098.5040502@draigBrady.com>
References: <1301894021-29180-1-git-send-email-jim@meyering.net>	<1301894021-29180-7-git-send-email-jim@meyering.net>	<4D997AAB.3070807@draigBrady.com> <87mxk69yfd.fsf@rho.meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: coreutils@gnu.org, linux-ext4@vger.kernel.org
To: Jim Meyering <jim@meyering.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail1.slb.deg.dub.stisp.net ([84.203.253.98]:16410 "HELO
	mail1.slb.deg.dub.stisp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753731Ab1DDJfJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Apr 2011 05:35:09 -0400
In-Reply-To: <87mxk69yfd.fsf@rho.meyering.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/04/11 10:08, Jim Meyering wrote:
> P=E1draig Brady wrote:
>> On 04/04/11 06:13, Jim Meyering wrote:
>>> From: Jim Meyering <meyering@redhat.com>
>>>
>>> Running the new fiemap-empty test uses 600MB of disk space via
>>> fallocate, and in so doing caused failure in unrelated tests that
>>> were running in parallel on a small file system.  Rather than
>>> simply running fallocate (which allocates the space, inducing
>>> disk full when it fails), skip the test if there is less than
>>> 800MB of free space, as computed via stat and awk.
>=20
> Thanks for looking.
>=20
>> Oops sorry.
>> Maybe worth noting is that stat works at a lower level,
>=20
> Not sure what you mean?  Both use statfs.

Oops right. df uses f_bavail, so perhaps it might
be better to use %a rather than %f with `stat`?

This fallocate() behavior is annoying anyway,
as I'm not sure when it's useful, except for
filling up a file system.
It seems like a this would be useful.

#define FALLOC_FL_FULL_SIZE     0x03 /* allocate all or nothing */

cheers,
P=E1draig.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
