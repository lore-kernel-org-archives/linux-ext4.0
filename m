From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: regression: 4.13 cannot follow symlinks on some ext3 fs
Date: Thu, 23 Nov 2017 23:12:41 -0700
Message-ID: <C656DD8B-7521-4281-8D55-4416A3C75161@dilger.ca>
References: <20171123203330.GN2482@two.firstfloor.org>
 <20171123222317.bq2v26zm5i2jspui@thunk.org>
 <20171123233101.GP2482@two.firstfloor.org>
 <700971AC-BDE2-4993-BD56-7497AD8A0FC4@dilger.ca>
 <20171124020435.GQ2482@two.firstfloor.org>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_BA395DC1-74DB-4331-9DFB-35A22C585C97";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Theodore Ts'o <tytso@mit.edu>, Tahsin Erdogan <tahsin@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171124020435.GQ2482@two.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_BA395DC1-74DB-4331-9DFB-35A22C585C97
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 23, 2017, at 7:04 PM, Andi Kleen <andi@firstfloor.org> wrote:
>=20
>> As a workaround, you could delete and recreate the symlink with the =
new
>=20
> I revert the patch for now. Everything seems to work.
>=20
>> kernel to create a proper fast symlink.  It would be useful to scan
>> the image to see if there are other similar symlinks present:
>>=20
>>    find /myth/tmp -type l -size -60 -ls | awk '$2 !=3D 0 { print }'
>=20
> Doesn't find anything. Your recipe must be wrong.

I see that I should have used "-60c" to properly limit the listing to
short symlinks, but this doesn't appear to be the core problem.  It
looks like there is a bug in find (at least version 4.4.2 that I'm
testing with) that it doesn't print the blocks count properly.

According to find(1) the "-ls" argument should list the file the same
as "ls -dils" format (blocks is $2), but as shown below "find -ls"
prints "0" for blocks when it should be "4" (for a long symlink using
"+60c" in my example, I couldn't find any short+external symlinks on a
couple of 8 year old root filesystems):

$ find /etc/alternatives/rmid -type l -size +60c -ls
327877 0 lrwxrwxrwx 1 root root 73 Jan  4  2017 /etc/alternatives/rmid =
-> =
/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.111-0.b15.el6_8.x86_64/jre/bin/rmid

$ ls -dils /etc/alternatives/rmid
327877 4 lrwxrwxrwx 1 root root 73 Jan  4  2017 /etc/alternatives/rmid =
-> =
/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.111-0.b15.el6_8.x86_64/jre/bin/rmid*=



Try the following command instead:

find / -type l -size -60c -print0 | xargs -0r ls -dils | awk '$2 !=3D 0 =
{ print }'


>> This is probably something that e2fsck should check for and fix.
>=20
> Nah the kernel should just support it like it always did.

The reason we changed this code in the first place was because the
old check would repeatedly break when some new reason for storing
blocks on a symlink appeared.  It broke when xattrs were allowed
on symlinks for SELinux.  It broke when bigalloc blocks were added.
It broke when inline_data was added, and it would have broken (and
been really hard to fix efficiently) when large xattrs were added.

We checked old kernels, and old e2fsprogs, and didn't see any cases
where fast (<=3D 60 chars) symlinks were created using external blocks.
It seems that _something_ did create them, and it would be good to
figure that out so we can determine if it is a widespread problem.

I think e2fsck can fix this quite easily, and there really isn't
an easy way to revert to the old method if the large xattr feature
is enabled.  If you are willing to run a new kernel, you should also
be willing to run a new e2fsck.

We could probably add a fallback to the old mechanism (and print
a one-time warning to upgrade to a newer e2fsck) if an external fast
symlink is found and the large xattr  feature is not enabled, which
would give more time to fix this (hopefully rare in the wild) case.

Cheers, Andreas






--Apple-Mail=_BA395DC1-74DB-4331-9DFB-35A22C585C97
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFaF7hapIg59Q01vtYRAmweAKCj0hULqkvlc2YkVqe5ufqTjIZ0DwCfdRLl
lmATYSkP7PQx4jy7R4CQX8M=
=jzC7
-----END PGP SIGNATURE-----

--Apple-Mail=_BA395DC1-74DB-4331-9DFB-35A22C585C97--
