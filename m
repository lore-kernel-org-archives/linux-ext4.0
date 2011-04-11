From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [Bug 32972] New: EXT4 causes corrupt BitTorrent downloads
Date: Sun, 10 Apr 2011 21:46:25 -0400
Message-ID: <20110411014625.GA5802@thunk.org>
References: <bug-32972-13602@https.bugzilla.kernel.org/>
 <BANLkTikQa3UaBVVFdrvzwUcdR_qvOPcmFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: bugzilla-daemon@bugzilla.kernel.org, damien@grassart.com,
	feng.tang@intel.com, linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35310 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820Ab1DKBqf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Apr 2011 21:46:35 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTikQa3UaBVVFdrvzwUcdR_qvOPcmFw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 10, 2011 at 10:30:13PM +0800, Yongqiang Yang wrote:
> So the right code should be=EF=BC=9A
>=20
> 	bh->b_state =3D (bh->b_state & ~EXT4_MAP_FLAGS) | map.m_flags;
> 	map_bh(bh, inode->i_sb, map.m_pblk);
> 	if (buffer_unwritten(bh)) {
> 		/* A delayed write to unwritten bh should be marked
> 		 * new and mapped.  Mapped ensures that we don't do
> 		 * get_block multiple times when we write to the same
> 		 * offset and new ensures that we do proper zero out
> 		 * for partial write.
> 		 */
> 		set_buffer_new(bh);
> 	}

Actually, I'm much more comfortable backing out commit 6de9843da
entirely.  The above is *not* equivalent to what we had before ---
consider the case where ext4_map_blocks returns !EXT4_MAP_MAPPED &&=20
!EXT4_MAP_UNWRITTEN.

I don't *think* this should happen in the case where ext4_map_blocks
returns a value > 0, but the fact that it's not obvious, means I'd
much rather keep things the way that they are.  It's not like dropping
the set_buffer_mapped(bh) was saving anything measurable anyway....

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
