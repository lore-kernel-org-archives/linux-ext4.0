From: Yehuda Sadeh Weinraub <yehuda.sadeh@dreamhost.com>
Subject: Re: ceph and ext4
Date: Sat, 11 Feb 2012 20:05:55 -0800
Message-ID: <CAC-hyiEUGoXSmtRnk8Y5GoEzLfjhWqEJbqXT_MXbn6OVuSj36Q@mail.gmail.com>
References: <4EC10664.1080501@tuxadero.com>
	<CAO47_-9nfO32nwOAQMVdqw6iWGWK+FWb+MD=WeOz_vr4YrrKmw@mail.gmail.com>
	<20111115142246.GA7516@thunk.org>
	<246EA1CC-3C33-4D41-80C0-2331C426EBB0@whamcloud.com>
	<CAO47_-9vGg89HgxjT=dzSSsUxxdbZ=yJoYQk4Qge8WGPjeVmKw@mail.gmail.com>
	<5D6C7B37-1594-48FF-A682-8CC1FE0A6870@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: chb@muc.de,
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Jian Yu <yujian@whamcloud.com>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36123 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab2BLEF4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 11 Feb 2012 23:05:56 -0500
In-Reply-To: <5D6C7B37-1594-48FF-A682-8CC1FE0A6870@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 9, 2011 at 2:24 PM, Andreas Dilger <adilger@whamcloud.com> =
wrote:
>
> On 2011-12-08, at 3:59 PM, Christian Brunner wrote:
> > 2011/11/15 Andreas Dilger <adilger@whamcloud.com>:
> >> Coincidentally, we have someone working in those patches again. Th=
e main obstacle for accepting the previous patch as-is was that Ted wan=
ted to add support for "medium-sized" xattrs that are addressed as a st=
ring of blocks, instead of via an inode.
> >
> > Did you make progress with this. I'm still having serious trouble w=
ith
> > btrfs and would like to try these.
>
> The latest patches are available at http://review.whamcloud.com/1708,=
 but are based on the RHEL6.1 2.6.32 kernel. =A0The work to implement "=
medium-sized" xattrs was more complex than anticipated, and is not fini=
shed yet.
>
> The use of external inode xattrs is working, which allows xattr sizes=
 up to 64kB. =A0The 64kB limit is imposed by the VFS and could potentia=
lly be increased.
>

I was able to get those compile on a recent kernel. One issue that I
see is that it will only use a separate inode for the xattr if the
xattr is big enough. However, it may be that we ran out of enough
space to set a smaller xattr, and in that case we would fail setting
it even though we'd be able to set a larger xattr.
Another related issue, is that the number of xattrs that can be used
is still limited (by what can be indexed in a single block?).

I think that the first issue is substantial, as it exposes unexpected
behavior (getting ENOSPC for small sized attrs, while bigger attrs
succeed). For the second issue, it seems that when only using small
xattrs it doesn't change anything from the old behavior.


Yehuda
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
