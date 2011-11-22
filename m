From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Increase xattr space by allocating contiguous xattr blocks
Date: Mon, 21 Nov 2011 22:53:50 -0600
Message-ID: <4ECB2ADE.3010007@redhat.com>
References: <4EC10664.1080501@tuxadero.com> <CAO47_-9nfO32nwOAQMVdqw6iWGWK+FWb+MD=WeOz_vr4YrrKmw@mail.gmail.com> <20111115142246.GA7516@thunk.org> <246EA1CC-3C33-4D41-80C0-2331C426EBB0@whamcloud.com> <4ECA4282.5020908@whamcloud.com> <401CC4FF-8955-4D5F-B620-5C39AF566123@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Yu Jian <yujian@whamcloud.com>,
	Andreas Dilger <adilger@whamcloud.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9527 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645Ab1KVEx4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Nov 2011 23:53:56 -0500
In-Reply-To: <401CC4FF-8955-4D5F-B620-5C39AF566123@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/21/11 9:08 AM, Theodore Tso wrote:
> Currently, one of the primary xattr tests that is in xfstests (#62)
> doesn't work on ext4 at all, since it assumes that files are returned
> by readdir in file creation order for newly created directory.   So
> the lack of test coverage is something that would have to be
> addressed if we want to do major surgery to the xattr code.  I'd
> suggest creating a new series of test from scratch, since I don't
> believe test #62 can be easily reworked so that it will work under
> ext4.

Are you sure?

# grep supported 062
_supported_fs generic

Hm, but it doesn't actually work does it.  :/

Maybe we could do find | sort | xargs ... but I guess it's explicitly supposed to test the getfattr recursive code.

- -Eric
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJOyyrdAAoJECCuFpLhPd7gjqwP/2ZMeQedGBvsmPLvxlD/oej+
dZ/U8DSV1kKo7A+2Su7LSB04LuuxrQ97AJBsVTfPyqxB8PFiQ+YQMvkqWwO4xEPO
abhr5Y0e9s+L/aOQ40UWQQE+X4LLrHOjakv0b4oXJgor7piuCRMhLiT1lejzml72
Vg6bYNoQ0uDeNZSJyjRscexg14/uJNz052gQ6QDz7jKZpYPbD5EJr0y63i9MadbM
H8do7kvQOzuIg4UtPOlt9ce52pstihsCL4rGrKZNghDFbmqnSN2SLVx74QyphXYc
T1QqxqxYIiuM2QF6wiZP7mXvk7w1OOyBczOxXGWW7WBrlfg+eD2uW93yiCxgpIPD
1Ljbo+dbXRlVGTEb/k9nrkn/KQjU/MqNkfImGVtjZLK3hEOcbWuh9ojEGoSfKnfx
LQ1V6Jqb4VcFxP55Nkrl8ROCp4FahorMWFVRl3hh/lSBZP7h3ogtzE9GCBQfygRP
n0ZPBDOJ2H87L1q5NGnCqkqtwY05dTuVQZD6xdlV8Z/eogOSdVTu4/Icb4k8a6cK
H98X7u+1iVy1meDqtqrvOOOgq0jss3ZvVl7vBToo7OsInhlbDHHXY0fbxBAmfguo
1KP5cMl069KPY7WeydXGjynh2nrYh1F7BGCWp0a93REcg7NTl6E7XONuT4E0ohsO
oPX9piyNcZzgYHDOqfon
=HL4p
-----END PGP SIGNATURE-----
