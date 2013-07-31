From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: e2fsprogs - possible regression between 1.42.7 and 1.42.8
Date: Tue, 30 Jul 2013 21:10:53 -0500
Message-ID: <51F8722D.9050707@redhat.com>
References: <20130729083941.GG28871@pcnci.linuxbox.cz> <51F694B6.90901@redhat.com> <51F87075.2020508@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918Ab3GaCK5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Jul 2013 22:10:57 -0400
In-Reply-To: <51F87075.2020508@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 7/30/13 9:03 PM, Eric Sandeen wrote:
> On 7/29/13 11:13 AM, Eric Sandeen wrote:
>> On 7/29/13 3:39 AM, Nikola Ciprich wrote:
>>> Hi,
> 
>>> trying to compile latest e2fsprogs and running check under RHEL6-compatible
>>> distro (centos) fails:
> 
>>> r_1024_small_bg: ext2 1024 blocksize with small block groups: failed
>>> r_ext4_small_bg: ext4 1024 blocksize with small block groups: failed
> 
>>> dunno whether this is known issue... will bisect help?
> 
>>> with regards
> 
>>> nik
> 
> 
>> Ted, these are the same ones I saw, plus one I think (working on getting
>> all the info).
> 
> Sorry this took a while.  Attached is a qcow image of a broken r_1024_small_bg
> filesystem.  Doing resize2fs -M on it twice should corrupt it, even on x86_64.

Sorry - the image as attached is not broken, but 2 current resize2fs -M's break it.

- -Eric

> (aside: the test is a bit weird, it does:
> 
> echo $RESIZE2FS $RESIZE2FS_OPTS -d 31 -M $TMPFILE $SIZE_2 >> $LOG 2>&1
> 
> but specifying -M as well as a size doesn't make much sense?)
> 
> -Eric
> 

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJR+HIsAAoJECCuFpLhPd7gT3cP/3YLhpclAhU6UHIW4cqyKhIl
STIwV3ROZmic5qQb8X6l5etc8ALCs2b5LVYjhlMlZWISkN64pXOhL0lz7coSABM9
wnZU2y3LntcyGFEg7aEs+sXe2mXqX139NkoNwKfBBPidQ/HdwpnnTdlu4FZeTyrj
aDHIUGPs2YBbp2QaBhmzl5b7xwEoHCq/XtrH7v7+SHyHEGzIYTn3w96vyXqVYTjs
csUgeMhFFw58Hq+/03UE13Ig/Et8AqSgonnaEiG3ZKXsDIxhjFxqQPGsdD2BleGd
Rb/fxnkM0RKhr7xSK3CFWnLQ8LkaUtexazxvr+7BmmgRx8jyQhQj8ASYXzmUuh/S
RtbnZ3wioxEwCRhr3FP0ZpoOZwbkDWd/UBy407ZBblxVafjLSYbsMHDM7rPrQHoz
oSo1W4c7sy85pNfCgMnQYyuqik5KVDuQNk/nqEkv6tE1YOb5zXTrpDKjEFgBKYVd
FpLRk9f0rhoxcwyfZsIY6Wx/4h4rWKnhK6jqL5unDLJitPv405KlNfY28AoFNme4
ZxwDSddausNm+8u9sZON7cuyhAb70Q8N0W6ECPX8+ie8fvXwPDRSJYPpMXqOBK06
35SPqxKlCpT7BGMAqr7+h8qemYdcTS0z7ag2im+MRS1t58AFSsuIyj+IirPWwTUM
SQRtuG3mOsWE7l93c8bc
=96jm
-----END PGP SIGNATURE-----
