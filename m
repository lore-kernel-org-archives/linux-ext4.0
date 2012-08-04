From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: Re: Use fsck to free the space used by dir?
Date: Sat, 04 Aug 2012 12:25:49 +0800
Message-ID: <501CA44D.2010201@gmail.com>
References: <501BDDE5.8060005@gmail.com> <501BEBE1.5080508@redhat.com> <20120803175727.GB8463@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33450 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab2HDEZ7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 4 Aug 2012 00:25:59 -0400
Received: by pbbrp8 with SMTP id rp8so2368715pbb.19
        for <linux-ext4@vger.kernel.org>; Fri, 03 Aug 2012 21:25:59 -0700 (PDT)
In-Reply-To: <20120803175727.GB8463@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012=E5=B9=B408=E6=9C=8804=E6=97=A5 01:57, Theodore Ts'o wrote:
> On Fri, Aug 03, 2012 at 10:18:57AM -0500, Eric Sandeen wrote:
>> On 8/3/12 9:19 AM, Wang Sheng-Hui wrote:
>>> Dear all,
>>>
>>> I read through the namei.c code recently, but didn't notice any cod=
e to
>>> reduce the size of a dir file (append can increase its size though)=
=2E
>>
>> Right, AFAIK nothing in kernelspace will reduce the size.
>=20
> In theory, if the dir_index (htree) support is enabled, it would be
> possible for the kernel to reorganize the directory dynamically. =20
>=20
> If dir_index is not enabled, reorganizing the directory would would
> break any open readdir() sessions and any NFS server file handles.
> (Which means if the file system has been exported by NFS in the past,
> and expects to be exported by NFS in the future, reorg'ing a director=
y
> will seriously confuse any clients which have cached NFS handles.)
>=20
> For that reason, historically we've never bothered to try to implemen=
t
> ways of decreasing the size of a directory --- especially since in
> most cases, sysadmins can do something like:
>=20
> mkdir foo.new ; mv foo/* foo.new ; mv foo.new foo
>=20
> which while isn't perfect, works most of the time.
>=20
> Regards,
>=20
> 						- Ted

Thanks for your patient explanations, Eric & Ted!

Regards,
Wang Sheng-Hui=20
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
