From: Jelle de Jong <jelledejong@powercraft.nl>
Subject: Re: How to resize to an bigger then 16TB ext4 filesysteem on Debian
Date: Thu, 10 Apr 2014 17:07:34 +0200
Message-ID: <5346B3B6.7020806@powercraft.nl>
References: <53468055.4070700@powercraft.nl> <20140410140937.GE15925@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay02.cambriumhosting.nl ([217.19.16.174]:34657 "EHLO
	relay02.cambriumhosting.nl" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751225AbaDJPHm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Apr 2014 11:07:42 -0400
In-Reply-To: <20140410140937.GE15925@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 10/04/14 16:09, Theodore Ts'o wrote:
> On Thu, Apr 10, 2014 at 01:28:21PM +0200, Jelle de Jong wrote:
>> 
>> Hello everyone,
>> 
>> https://packages.debian.org/wheezy/e2fsprogs
>> 
>> # resize2fs /dev/lvm0-vol/storage resize2fs 1.42.5 (29-Jul-2012) 
>> resize2fs: New size too large to be expressed in 32 bits
>> 
>> (will the command work with e2fsprogs 1.42.9-3?)
>> 
>> # tune2fs -l /dev/lvm0-vol/storage 
>> http://paste.debian.net/92889/
>> 
>> Suggestions has to be stable enough for production systems.
> 
> I'm going to assume the file system was created without having the 
> 64-bit file system feature set.  (Running dumpe2fs -h 
> /dev/lvm0-vol/storage can verify this).
> 
> If that's true, and you require a production-stable way of doing
> this, there's really only one thing I can suggest:
> 
> 1)  Backup your file system completely 2)  Get the development
> version of e2fsprogs, and apply a set of in-development patches
> that haven't yet been merged 3)  Use this in-development resize2fs
> to convert to a 64-bit file system, realizing that it will have
> completely rewrite your inode tables. Cross your fingers. 4)  If it
> works, you're done.  If not, you can restore from backups.  :-)
> 
> So basically steps 2 and 3 are ways of optimizing needing to do a
> full restore of your file system.....

Thank you Ted for your quick reply.

In october 2012 I created the ext4 file system with the command:
mkfs.ext4 -m 1 /dev/lvm0-vol/storage

I assumed by using ext4 with lvm2 I would have had a solid basis for
some future storage expeditions. Apparently I made a mistake somewhere
but I don't know where yet or did I hit a bug?

# tune2fs -l /dev/lvm0-vol/storage
# dumpe2fs -h /dev/lvm0-vol/storage
http://paste.debian.net/plain/92953

Where can I see that my ext4 file system is limed to 16TB?

Your suggestion to use a development version of e2fsprogs doesn't
really suit my needs for a stable solution that is maintainable.

1. I can temporary transfer all the data to an other system and
recreate the ext4 file system, but will this be stable with version
1.42.5 and how much TB can the file-system handle?

2. I can put current the 16TB ext4 file system in production and wait
for e2fsprogs support in Debian stable or backports to arrive and
resize the to 22TB later. When do you expect this functionality to
arrive in as stable release of e2fsprogs?

Thank you for your help.

Kind regards,

Jelle de Jong
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iJwEAQECAAYFAlNGs7IACgkQ1WclBW9j5Hl5NgQAjwMLRPu3KQuBesD7BSHkUrf3
JcaFMD90vvAYmbKMbMumGhR86BA1NXVBfeEA6DnrZUrPzly1VBglCOwCJzw52GCc
TZHp3h5RD/Ce1c8/T+VD4DrVxhjIMUAyUT+/eGN008mHtrOfRppnFlcutNxZ5RZJ
oGksAsJ5i7hWmeilqcc=
=ECQP
-----END PGP SIGNATURE-----
