From: Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 06/12 v2] mm: teach truncate_inode_pages_range() to
 hadnle non page aligned ranges
Date: Fri, 20 Jul 2012 09:07:10 +1000
Message-ID: <20120719230710.GG30524@devil.redhat.com>
References: <1342185555-21146-1-git-send-email-lczerner@redhat.com>
 <1342185555-21146-6-git-send-email-lczerner@redhat.com>
 <alpine.LSU.2.00.1207170114490.1577@eggly.anvils>
 <alpine.LFD.2.00.1207171315330.2402@dhcp-1-248.brq.redhat.com>
 <alpine.LFD.2.00.1207171413350.14869@dhcp-1-248.brq.redhat.com>
 <alpine.LFD.2.00.1207180945390.2291@dhcp-1-248.brq.redhat.com>
 <alpine.LSU.2.00.1207181154410.2160@eggly.anvils>
 <alpine.LFD.2.00.1207190905220.4970@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Hugh Dickins <hughd@google.com>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, achender@linux.vnet.ibm.com
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956Ab2GSXHe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Jul 2012 19:07:34 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1207190905220.4970@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 19, 2012 at 09:15:09AM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> On Wed, 18 Jul 2012, Hugh Dickins wrote:
>=20
> > Date: Wed, 18 Jul 2012 12:36:39 -0700 (PDT)
> > From: Hugh Dickins <hughd@google.com>
> > To: Lukas Czerner <lczerner@redhat.com>
> > Cc: Christoph Hellwig <hch@infradead.org>,
> >     Andrew Morton <akpm@linux-foundation.org>, Theodore Ts'o <tytso=
@mit.edu>,
> >     Dave Chinner <dchinner@redhat.com>, linux-ext4@vger.kernel.org,
> >     linux-fsdevel@vger.kernel.org, achender@linux.vnet.ibm.com
> > Subject: Re: [PATCH 06/12 v2] mm: teach truncate_inode_pages_range(=
) to hadnle
> >      non page aligned ranges
> >=20
> > On Wed, 18 Jul 2012, Lukas Czerner wrote:
> > > On Tue, 17 Jul 2012, Lukas Czerner wrote:
> > > >=20
> > > > My bad, it definitely is not safe without the end offset argume=
nt in
> > > > invalidatepage() aops ..sigh..
> > >=20
> > > So what about having new aop invalidatepage_range and using that =
in
> > > the truncate_inode_pages_range(). We can still BUG_ON if the file
> > > system register invalidatepage, but not invalidatepage_range,
> > > when the range to truncate is not page aligned at the end.
> >=20
> > I had some trouble parsing what you wrote, and have slightly adjust=
ed
> > it (mainly adding a comma) to fit my understanding: shout at me if =
I'm
> > misrepresenting you!
> >=20
> > Yes, I think that's what has to be done.  It's irritating to have t=
wo
> > methods doing the same job, but not nearly so irritating as having =
to
> > change core and all filesystems at the same time.  Then at some fut=
ure
> > date there can be a cleanup to remove the old invalidatepage method=
=2E
>=20
> Agreed!
>=20
> >=20
> > >=20
> > > I am sure more file system than just ext4 can take advantage of
> > > this. Currently only ext4, xfs and ocfs2 support punch hole and I
> > > think that all of them can use truncate_inode_pages_range() which
> > > handles unaligned ranges.
> >=20
> > I expect that they can, but I'm far from sure of it: each filesyste=
m
> > will have its own needs and difficulties, which might delay them fr=
om
> > a quick switchover to invalidatepage_range.
> >=20
> > >=20
> > > Currently ext4 has it's own overcomplicated method of freeing and
> > > zeroing unaligned ranges.
> >=20
> > You're best placed to judge if its overcomplicated, I've not looked=
=2E
> >=20
> > > Xfs seems just truncate the whole file and
> >=20
> > I doubt that can be the case: how would it ever pass testing with
> > the hole-punching fsx if so?  But it is the case that xfs unmaps
> > all the pages from hole onwards, in the exceptional case where the
> > punched file is currently mmap'ed into userspace; and that is wrong=
,
> > and will get fixed, but it's not a huge big deal meanwhile.  (But i=
t
> > does suggest that hole-punching is more difficult to get completely
> > right than people think at first.)
>=20
> Ok, maybe I did not express myself very well, sorry. I meant to say
> that xfs will unmap all mapped pages in the file from start of the
> hole to the end of the file.

It might do that right now, but that's no guarantee that we won't
change it in future. Indeed, we've been considering changing all the
toss/inval page calls to just the required range for a few years,
but never got around to doing it because of we never really
understood how the VM would handle it....

Likewise, those wrappers in fs/xfs/xfs_fs_subr.c need to go away,and
we've been considering that for just as long. It's never happened
because of the above.

If the VM can handle ranged toss/inval regions correctly, then we
can make those changes without concerns of introducing data integrity
regressions....

Cheers,

Dave.
--=20
Dave Chinner
dchinner@redhat.com
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
