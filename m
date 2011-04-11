From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 32972] EXT4 causes corrupt BitTorrent downloads
Date: Mon, 11 Apr 2011 01:46:59 GMT
Message-ID: <201104110146.p3B1kxZZ001742@demeter1.kernel.org>
References: <bug-32972-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:44398 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab1DKBrA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 10 Apr 2011 21:47:00 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p3B1kxi3001743
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 11 Apr 2011 01:46:59 GMT
In-Reply-To: <bug-32972-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D32972





--- Comment #3 from Theodore Tso <tytso@mit.edu>  2011-04-11 01:46:57 -=
--
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

--=20
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=3Demai=
l
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
