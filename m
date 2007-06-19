From: Dmitry Monakhov <dmonakhov@sw.ru>
Subject: Re: delayed allocatiou result in Oops
Date: Tue, 19 Jun 2007 13:16:28 +0400
Message-ID: <20070619091628.GB20172@localhost.sw.ru>
References: <20070614072352.GA6517@localhost.sw.ru> <4672202C.4080304@clusterfs.com> <1181949368.3808.7.camel@dyn9047017103.beaverton.ibm.com> <20070616081426.GB14349@localhost.sw.ru> <1182214878.3711.21.camel@dyn9047017103.beaverton.ibm.com> <46778186.9030306@clusterfs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: cmm@us.ibm.com, linux-ext4@vger.kernel.org
To: Alex Tomas <alex@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:39737 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755378AbXFSJPw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Jun 2007 05:15:52 -0400
Content-Disposition: inline
In-Reply-To: <46778186.9030306@clusterfs.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 11:11 =D0=92=D1=82=D1=80 19 =D0=98=D1=8E=D0=BD     , Alex Tomas wrot=
e:
> Mingming Cao wrote:
> >>From the comments it says the page->private is set to 1 to letting
> >commit_write know that it needs block reservation, but I don't see t=
he
> >page->private value being checked in ext4_wb_commit_write(). Instead=
,
> >the PageMappedToDisk(page) flag is being checked.
> >
> >Alex, can you clarify the use of page->private and PagePrivate flag
> >here? Do we still need the page->private for delayed allocation, wit=
h
> >PageBooked flag and PageMappedToDisk page flag?
>=20
> sorry for confusion, we need PagePrivate so that truncate calls our
> ->invalidatepage(). in turn this call is needed to drop unused reserv=
ation.
>=20
> block_read_full_page() must not happen to pages being delayed allocat=
ed
> in the first place - it's uptodate by definition. I think the problem
> began when ext4_wb_commit_write() exited due to -ENOSPC but left not
> uptodate *and* with PG_private. then subsequent access to page turned=
 to
> block_read_full_page() which relies on PG_private and meaningful priv=
ate
> field. Dmitry, could you repeat the test with SetPagePrivate(page) mo=
ved
> to after that if() with ext4_wb_reserve_space_page(), please?
Yes it works. Bug not triggered now.

But whole approach based on using PagePrivate bit and page->private
ptr for special purposes is realy dengerous, and imho wrong,
because avery fs-related code assume that page->private points to
page_buffers. Especially this approach not work for blksize < pgsize.
The best way to store/pass any block related info is buffer_head flags.
This approach works for blksize < pgsize case  too.
>=20
>=20
> as i'm here ... status update: I've been reworking delayed allocation
> patches to support blocksize < PAGE_CACHE_SIZE (and address akpm's re=
quest
> for more generic implementation). the patch isn't ready for review, b=
ut
> hopefully will be in few days.
>=20
>=20
> thanks, Alex
>=20
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
