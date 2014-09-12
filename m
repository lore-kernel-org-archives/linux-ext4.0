From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 09/25] misc: zero s_jnl_blocks when removing internal
 journal
Date: Fri, 12 Sep 2014 12:43:41 -0700
Message-ID: <20140912194341.GB10150@birch.djwong.org>
References: <BAY406-EAS308E30D9E82235BD5A84A0EFDCD0@phx.gbl>
 <20140912164342.GA10178@birch.djwong.org>
 <BAY179-W471384B15AB594C29D96F9FDCD0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: TR Reardon <thomas_reardon@hotmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37569 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbaILTnp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Sep 2014 15:43:45 -0400
Content-Disposition: inline
In-Reply-To: <BAY179-W471384B15AB594C29D96F9FDCD0@phx.gbl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 12, 2014 at 03:06:23PM -0400, TR Reardon wrote:
> If the change from journal_inode to journal_dev is/was made prior to =
the
> recent change, the s_jnl_blocks will have whatever it last had. =A0So=
 if it
> started with journal_inode and then switched to journal_dev (again, p=
rior to
> your fix) or no journal, the s_jnl_blocks will have the old journal_i=
node
> info, and adding/removing journal_dev does no clear it out. =A0For a =
new fs
> with created only with journal_dev, there is no issue. =A0I'm just ar=
guing that
> *adding* journal_dev should also zero this out.

You would also want to zero out s_jnl_blocks if creating a journal on a=
 mounted
=46S, since there's no way to find the block map/ETB blocks; the best w=
e can do
is hope the user runs e2fsck, which will fix it.

--D
>=20
> +Reardon
>=20
>=20
> ----------------------------------------
> > Date: Fri, 12 Sep 2014 09:43:42 -0700
> > From: darrick.wong@oracle.com
> > To: thomas_reardon@hotmail.com
> > CC: linux-ext4@vger.kernel.org
> > Subject: Re: [PATCH 09/25] misc: zero s_jnl_blocks when removing in=
ternal journal
> >
> > [cc linux-ext4]
> >
> > On Fri, Sep 12, 2014 at 10:09:55AM -0400, TR Reardon wrote:
> >> Note that this only works (zeroes out) when removing inode journal=
=2E Removing
> >> an existing journal_dev leaves s_jnl_blocks untouched. To be absol=
utely
> >> clean, perhaps it should be wiped in all removal cases?
> >
> > s_jnl_blocks shouldn't be set if an external journal is in use.
> >
> > (Unless it is somehow?)
> >
> > --D
>=20
>  		 	   		  --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
