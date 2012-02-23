From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: backport "ext4: serialize unaligned asynchronous DIO" to 2.6.32
Date: Thu, 23 Feb 2012 09:15:19 -0600
Message-ID: <4F465807.7070703@redhat.com>
References: <4D2F7B52.1040209@redhat.com> <20110207023336.GI10402@thunk.org> <20110207155936.GA3457@thunk.org> <201202231424.23645.hahn@univention.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>,
	xen-devel@lists.xensource.com
To: Philipp Hahn <hahn@univention.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728Ab2BWPP2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Feb 2012 10:15:28 -0500
In-Reply-To: <201202231424.23645.hahn@univention.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2/23/12 7:23 AM, Philipp Hahn wrote:
> Hello Ted, hello Eric,
> 
> On Monday February 7th 2011 16:59:36 Ted Ts'o wrote:
>> commit 7520bb0f2980ef79d17dcbec2783760b37490ffc

upstream is actually e9e3bcecf44c04b9e6b505fd8e2eb9cea58fb94d but you probably knew that.

>> Author: Eric Sandeen <sandeen@redhat.com>
>> Date:   Mon Feb 7 10:57:28 2011 -0500
>>
>>     ext4: serialize unaligned asynchronous DIO
>>
>>     ext4 has a data corruption case when doing non-block-aligned
>>     asynchronous direct IO into a sparse file, as demonstrated
>>     by xfstest 240.
> 
> I hope you remember that bug, because I encountered this data corruption bug 
> on Debians 2.6.32(.51) kernel as well.

I remember it well ;)

I also backported it to RHEL6, but that "2.6.32" kernel also had a few of ext4 updates.

Still, grabbing a centos6 kernel src.rpm and looking might help you.

FWIW I also backported f46c483357c2d87606bbefb511321e3efd4baae0 and
f2d28a2ebcb525a6ec7e2152106ddb385ef52b73 as helpers.

> On the other hand RedHat seems to have back-ported that fix to RHEL5 (2.6.18)  
> and probably RHEL6 (2.6.32) as well, but I don't have a subscription, so I 
> can't verify that:
> <http://rpmfind.net/linux/RPM/centos/updates/5.7/x86_64/RPMS/kernel-devel-2.6.18-274.12.1.el5.x86_64.html>
> <https://bugzilla.redhat.com/show_bug.cgi?id=689830>

615309 is the RHEL6 bug.  Sadly it's marked private.

> The Xen-people also encountered it and asked for someone to backport it:
> <http://osdir.com/ml/xen-development/2011-07/msg00474.html>
> 
> I tried to backport it from 2.6.38~rc5 to 2.6.32.51 and thus far it seems to 
> fix the bug. But several other things were re-named and re-organized between 
> those versions, so it was not slreight forward.
> 
> Since I'm no ext4 expert, I'd like to ask you to have a look at this backport. 
> Is it sound or are there some tests I can throw at it to get it tested more 
> thoroughly?

xfstests test #240 tests it specifically:

# FS QA Test No. 240
#
# Test that non-block-aligned aio+dio into holes does not leave
# zero'd out portions of the file
#
# QEMU IO to a file-backed device with misaligned partitions
# can send this sort of IO
#
# This test need only be run in the case where the logical block size
# of the device can be smaller than the file system block size.

and running all the xfstests over your result would probably be good.

FWIW, there was a related xfs fix as well:

https://bugzilla.redhat.com/show_bug.cgi?id=669272

that one's not marked private <eyeroll>

> Does is classify for <mailto:stable@vger.kernel.org>?

probably so.

To be honest I am really pressed for time right now, and this was somewhat tricky code.  I won't be able to review it right now, anyway, but can try to get to it at some point if my schedule lightens up... :(

- -Eric

> Thanks in advance
> Philipp Hahn

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPRlgFAAoJECCuFpLhPd7gU58QAJwAzv2e9WVT2zs741Jhv0Fl
NCAJ7t7+EYECA5Qtbzm/LCojmvf2mYKVA2MmHiLIG0jxSAX6DQ+bHsjx0N3DbFCA
nabZFBwjiNfbII3ut4lHTWXfi6hZ0yqs6/qZTCnm4janwQN9ffR7+kuwTfuJGTaI
a0pelgiXQTIVQcx/togd9qezrEwVGd/7Z/sw67o1/hpc76fsELXYnZVkQ4jzXKwc
gvAgjFKSdkY0sMCq/owwiA6lgZydMeGzkXYbDlvYx7lfPp6n8ZPpupa2UKAeSF/P
4T8cweTK/XNvlr7KcXx9zHoD3ZLRTYaVvvIlaOa5n0S+v71wGV/AOV2wLNeK3s2x
jn91Zsf1sKTpvUQsh5P1UZKgOEXVgQ+gu4+15Ggk5LPOrSd8j4wjrGbrHHu4MfRv
udLZP1lE+RINflzdkL6nx6UeeI+X4LOU5McjSgs4gaKInTK9U090vpsCDijEK+mJ
ku9nfX+pBiXQgcHFA8fTe0KwnBxvA+AuY0n4w4zzj96bh9tqlYK2MH3qfVJTrMrs
pl6gZQTUbt8/UwaP8ooa0gBBG9aGVaBsRtBng9hqIb5vU+TImR8PBlL3QQZPvcZa
g+wYq3UmIl5z+A17Ify37FgbU6lsuFmleU0fRglV/ofAywMGatKNUJZn4yz+7QTv
ADMfCQ8Gnpy8Ue+LxQkO
=cYPJ
-----END PGP SIGNATURE-----
