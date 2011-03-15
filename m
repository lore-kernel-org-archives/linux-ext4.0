From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: Large directories and poor order correlation
Date: Tue, 15 Mar 2011 07:06:34 -0400
Message-ID: <4C11D2E5-75CD-4A9F-A534-EEC16CDD836B@mit.edu>
References: <4D7E7990.90209@cfl.rr.com> <4D7E7C7F.1040509@redhat.com> <8239molspy.fsf@mid.bfk.de>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>, Phillip Susi <psusi@cfl.rr.com>,
	"linux-ext4\@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Florian Weimer <fweimer@bfk.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-6.MIT.EDU ([18.7.68.35]:57189 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756239Ab1COLGg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Mar 2011 07:06:36 -0400
In-Reply-To: <8239molspy.fsf@mid.bfk.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Mar 15, 2011, at 3:59 AM, Florian Weimer wrote:

> * Eric Sandeen:
>=20
>> No, because htree (dir_index) dirs returns names in hash-value
>> order, not inode number order.  i.e. "at random."
>>=20
>> As you say, sorting by inode number will work much better...
>=20
> The dpkg folks tested this and it turns out that you get better
> results if you open the file and use FIBMAP to get the first block
> number, and sort by that.  You could sort by inode number before the
> open/fstat calls, but it does not seem to help much.

It depends on which problem you are trying to solve.  If this is a cold
cache situation, and the inode cache is empty, then sorting by inode
number will help since otherwise you'll be seeking all over just to
read in the inode structures.   This is true for any kind of readdir+st=
at
combination, whether it's ls -l, or du or readdir + FIBMAP (I'd=20
recommend using FIEMAP these days, though).

However, if you need to suck in the information for a large number of
small files (such as all of the files in /var/lib/dpkg/info), then sure=
, sorting
ont he block number can help reduce seeks on the data blocks side of
things.

So in an absolute cold cache situations, what I'd recommend is readdir,
sort by inode, FIEMAP,  sort by block, and then read in the dpkg files.
Of course an RPM partisan might say, "it would help if you guys had
used a real database instead of ab(using) the file system.  And then=20
the dpkg guys could complain about what happens when RPM has to
deal with corrupted rpm database, and how this allows dpkg to use
shell scripts to access their package information.  Life is full of tra=
deoffs.

-- Ted


>=20
> --=20
> Florian Weimer                <fweimer@bfk.de>
> BFK edv-consulting GmbH       http://www.bfk.de/
> Kriegsstra=DFe 100              tel: +49-721-96201-1
> D-76133 Karlsruhe             fax: +49-721-96201-99
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
