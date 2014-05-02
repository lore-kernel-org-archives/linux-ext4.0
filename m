From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 37/37] ext5: define new subtype to add features and
 reduce testing complexity
Date: Fri, 2 May 2014 10:04:07 -0400
Message-ID: <20140502140407.GB842@thunk.org>
References: <20140501231222.31890.82860.stgit@birch.djwong.org>
 <20140501231629.31890.34812.stgit@birch.djwong.org>
 <alpine.LFD.2.00.1405021133520.2154@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45758 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbaEBOEN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 May 2014 10:04:13 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1405021133520.2154@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 02, 2014 at 11:45:25AM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> This is definitely NACK by me. I do not like this and there are
> several reasons why.
>=20
> First of all the name. Given the history of ext file system we tend
> to increase then number with the new version of file system. However
> you're saying that this is just for testing features ... in that
> case it does not make any sense to call it ext5, but not just that
> it's stupid to call it ext5 especially since we might actually want
> to release ext5 in the future and this would be really confusing for
> everybody involved.

Yes, the messaging involved with the "ext3" vs "ext4" bump has been
really unfortunate.  If I had to do it all over again, I would have
created "ext3dev", and then when it was stable, I would done a:

	git rm -rf fs/ext3 ; git mv fs/ext3dev fs/ext4

=46or example, it would have avoided the problem with SuSE product
managers refusing to support ext4 for multiple years, etc.

It also would have avoided the problem with people doing comparisons
of ext3 versus xfs, even in April 2014 (see a recent Hacker News
promoted blog article, where in someone kvetched that ext3 didn't
support fallocate).  Sigh....

> What about just simply using mkefs.conf to specify the feature set
> we want and use that?

Yes, it's likely that for 1.43 we'll enable various features by
default.  It's been quite deliberate that I haven't enabled by
default, because I wanted to make 100% sure they were completely
stable before enabling them by default.  Some of them we may have been
able to enable by default earlier, but be that as it may, 1.43 is a
good time to make that change.

				- Ted

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
