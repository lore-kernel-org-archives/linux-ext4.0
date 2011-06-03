From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfstests: add support for ext4dev FSTYP
Date: Fri, 3 Jun 2011 12:01:27 +1000
Message-ID: <20110603020127.GY561@dastard>
References: <1306933012-8666-1-git-send-email-amir73il@users.sourceforge.net>
 <20110601232804.GL32466@dastard>
 <BANLkTi=sV5=PyZvNSd=DGNW-V84=27d7Yw@mail.gmail.com>
 <BANLkTimbPWfOJKq6er4mnSYNPcx6VHLcrw@mail.gmail.com>
 <BANLkTimKV3LxugkW6_cE5vutjcmatESXuw@mail.gmail.com>
 <4DE7A557.9040608@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Amir G." <amir73il@users.sourceforge.net>, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	sergey57@gmail.com, Amir Goldstein <amir73il@users.sf.net>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:2336 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753428Ab1FCCBb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Jun 2011 22:01:31 -0400
Content-Disposition: inline
In-Reply-To: <4DE7A557.9040608@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 02, 2011 at 09:59:35AM -0500, Eric Sandeen wrote:
> On 6/2/11 2:16 AM, Amir G. wrote:
>=20
> > OK, after upgrading to newer util-linux and building it from
> > git, which also didn't help, I finally found who to blame - me.
> > I had an old (noauto) entry in /etc/fstab which claimed that
> > /dev/sda5 is ext4.  fsck was picking up that entry and insisting
> > that /dev/sda5 is ext4 (regardless of what it really is) blkid
> > isn't doing that silly thing.
> >=20
> > Amir
>=20
> So where are we at with all this?
>=20
> I don't really mind adding ext4dev to FSTYP case statements, it
> -is- something which blkid could, in theory, still return, and
> making xfstests cope with that and try to invoke fsck -t ext4dev
> doesn't bother me too much.  It is sadly an fs type embedded into
> a few tools.
>=20
> But other than that, I don't think we should be making changes to
> upstream projects based on your current development hacks (I don't
> mean hack in a bad way, just that running sed across ext4 to
> create your custom filesystem for testing should not require
> upstream projects to change...)
>=20
> So I'm ok with sprinkling "ext4|ext4dev" around if necessary.
> Anyone else disagree?

=D0=86f it is ext4 community decides that ext4dev is not deprecated the=
n
I don't have any objection. It won't cause me any PEBKAC problems.
;)

Cheers,

Dave.
--=20
Dave Chinner
david@fromorbit.com
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
