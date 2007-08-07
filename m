From: Coly Li <coyli@suse.de>
Subject: Re: E2fsprogs git tree
Date: Wed, 08 Aug 2007 00:52:05 +0800
Message-ID: <46B8A335.3070400@suse.de>
References: <E1I7ukw-0001ht-T0@candygram.thunk.org> <46B89C92.5060302@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:48048 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755174AbXHGQvK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Aug 2007 12:51:10 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1IISGt-0002Z5-ID
	for linux-ext4@vger.kernel.org; Tue, 07 Aug 2007 18:51:03 +0200
Received: from 221.222.206.17 ([221.222.206.17])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Tue, 07 Aug 2007 18:51:03 +0200
Received: from coyli by 221.222.206.17 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Tue, 07 Aug 2007 18:51:03 +0200
In-Reply-To: <46B89C92.5060302@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Valerie,

How about this:

git clone git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git

It works for me.

Valerie Clement wrote:
> Theodore Ts'o wrote:
>> People may have noticed that e2fsprogs 1.40 and roughly a week later
>> e2fsprogs 1.40.1 have been released, while there hasn't been any
>> activity at http://thunk.org/hg/e2fsprogs.  That's because right aft=
er
>> e2fsprogs 1.40, I have moved the e2fsprogs development activity over=
 to
>> git.  The public repositories can be found here:
>>
>>     http://www.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
>>     git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
>>
>> and here:
>>
>>     git://repo.or.cz/e2fsprogs.git
>>     http://repo.or.cz/r/e2fsprogs.git
>>
>=20
> Hi Ted,
>=20
> I tried to clone the source tree but it failed.
>=20
> The command "git-clone
> http://www.kernel.org/pub/scm/fs/ext2/e2fsprogs.git" failed with :
> "error: Could not interpret tags/APPLE_UUID_SNAP_1 as something to pu=
ll"
>=20
> The command "git-clone http://repo.or.cz/r/e2fsprogs.git" failed with=
:
> "error: Can't lock ref"
>=20
> Could you have a look at this please?
> Thank you very much,
>    Val=EF=BF=BDrie
>=20
