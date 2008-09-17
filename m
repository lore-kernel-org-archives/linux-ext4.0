From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 1/4] vfs: vfs-level fiemap interface
Date: Wed, 17 Sep 2008 16:02:12 +0100
Message-ID: <20080917150212.GD22613@shareable.org>
References: <E1Kea9F-0004L5-Ds@closure.thunk.org> <1221331767-16870-1-git-send-email-tytso@mit.edu> <20080914134711.GA21746@infradead.org> <20080914180132.GC13074@mit.edu> <20080914180843.GA31649@infradead.org> <20080914195811.GE13074@mit.edu> <20080915144754.GA16491@infradead.org> <20080916064514.GH3241@webber.adilger.int> <20080916220346.GB10562@mit.edu> <20080917141840.GB8750@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	akpm@linuxfoundation.org, Mark Fasheh <mfasheh@suse.com>,
	mtk.manpages@gmail.com
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:49084 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbYIQPCY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Sep 2008 11:02:24 -0400
Content-Disposition: inline
In-Reply-To: <20080917141840.GB8750@logfs.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

J=F6rn Engel wrote:
> Apart from the typo above, here is a more discouraging version:
>=20
>   In general, accessing the block device directly is strongly discour=
aged.
>   Exceptions exist mainly in the form of boot loaders like lilo and g=
rub,
>   at a time when the filesystem is not (cannot be) mounted.
>=20
>   If the flag DATA_ENCODED is set, however, even this exception is no
>   longer valid.  The content is encoded in some form.  Details are
>   unknown, it could be compressed, encrypted or something else.

I'm not clear about something from the above description.

If I were writing a journalling / tree-like filesystem, and I did
store data in blocks without encoding, but fsync() only waits for them
to be committed to journal, not their final destination, and also they
might be moved around - should I set DATA_ENCODED or not?  (And should
I return the temporary location in the long-running journal since
that's the only place the data is committed at the time of the call?)

Assume that even reading after unmounting is not 100% safe, because
the data blocks could be relocated after calling FIEMAP (when the
filesystem must be mounted), and before the unmount.

-- Jamie
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
