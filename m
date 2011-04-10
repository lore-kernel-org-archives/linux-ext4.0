From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [Bug 32972] New: EXT4 causes corrupt BitTorrent downloads
Date: Sun, 10 Apr 2011 22:30:13 +0800
Message-ID: <BANLkTikQa3UaBVVFdrvzwUcdR_qvOPcmFw@mail.gmail.com>
References: <bug-32972-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org, damien@grassart.com,
	feng.tang@intel.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50610 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab1DJOaN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 10 Apr 2011 10:30:13 -0400
Received: by pvg12 with SMTP id 12so1733349pvg.19
        for <linux-ext4@vger.kernel.org>; Sun, 10 Apr 2011 07:30:13 -0700 (PDT)
In-Reply-To: <bug-32972-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ah, it is a wrong fix.

original code:
	map_bh(bh, inode->i_sb, map.m_pblk);
	bh->b_state =3D (bh->b_state & ~EXT4_MAP_FLAGS) | map.m_flags;

	if (buffer_unwritten(bh)) {
		/* A delayed write to unwritten bh should be marked
		 * new and mapped.  Mapped ensures that we don't do
		 * get_block multiple times when we write to the same
		 * offset and new ensures that we do proper zero out
		 * for partial write.
		 */
		set_buffer_new(bh);
		set_buffer_mapped(bh);
	}

after the patch:
	map_bh(bh, inode->i_sb, map.m_pblk);
	bh->b_state =3D (bh->b_state & ~EXT4_MAP_FLAGS) | map.m_flags;

	if (buffer_unwritten(bh)) {
		/* A delayed write to unwritten bh should be marked
		 * new and mapped.  Mapped ensures that we don't do
		 * get_block multiple times when we write to the same
		 * offset and new ensures that we do proper zero out
		 * for partial write.
		 */
		set_buffer_new(bh);
	}

Actually, mapped flag is cleared by statement:
	bh->b_state =3D (bh->b_state & ~EXT4_MAP_FLAGS) | map.m_flags;

So the right code should be=EF=BC=9A

	bh->b_state =3D (bh->b_state & ~EXT4_MAP_FLAGS) | map.m_flags;
	map_bh(bh, inode->i_sb, map.m_pblk);
	if (buffer_unwritten(bh)) {
		/* A delayed write to unwritten bh should be marked
		 * new and mapped.  Mapped ensures that we don't do
		 * get_block multiple times when we write to the same
		 * offset and new ensures that we do proper zero out
		 * for partial write.
		 */
		set_buffer_new(bh);
	}



On Sun, Apr 10, 2011 at 9:44 PM,  <bugzilla-daemon@bugzilla.kernel.org>=
 wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D32972
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Summary: EXT4 causes corrupt BitTo=
rrent downloads
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Product: File System
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Version: 2.5
> =C2=A0 =C2=A0Kernel Version: 2.6.39-rc2+
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Platform: All
> =C2=A0 =C2=A0 =C2=A0 =C2=A0OS/Version: Linux
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Tree: Mainline
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Status: NEW
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Severity: high
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Priority: P1
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Component: ext4
> =C2=A0 =C2=A0 =C2=A0 =C2=A0AssignedTo: fs_ext4@kernel-bugs.osdl.org
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ReportedBy: damien@grassart.com
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0CC: feng.tang@=
intel.com
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Regression: Yes
>
>
> Using the Transmission BitTorrent client (version 2.11) with the most=
 recent
> kernel (2.6.39-rc2+), any torrent I try to download is corrupt. By us=
ing
> Transmission's "Verify Local Data" functionality, I am able to reprod=
uce this
> consistently. During verification, the percent complete will reverse =
itself as
> the verification process invalidates pieces that were just downloaded=
=2E
>
> I was able to bisect the issue and track it down to this commit:
>
> commit 6de9843dab3f2a1d4d66d80aa9e5782f80977d20
> Author: Feng Tang <feng.tang@intel.com>
> Date: =C2=A0 Wed Mar 23 14:05:03 2011 -0400
>
> =C2=A0 =C2=A0ext4: remove redundant set_buffer_mapped() in ext4_da_ge=
t_block_prep()
>
> =C2=A0 =C2=A0The map_bh() call will have already set the buffer_head =
to mapped.
>
> =C2=A0 =C2=A0Signed-off-by: Feng Tang <feng.tang@intel.com>
> =C2=A0 =C2=A0Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index f44307a..dec10e2 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2502,7 +2502,6 @@ static int ext4_da_get_block_prep(struct inode =
*inode,
> sector_t iblock,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * for partial=
 write.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0set_buffer_new=
(bh);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 set_buffer_mapped(=
bh);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;
> =C2=A0}
>
>
> I confirmed that reverting this commit makes the problem go away.
>
> Thanks,
> -Damien
>
> --
> Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=3Dem=
ail
> ------- You are receiving this mail because: -------
> You are watching the assignee of the bug.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
