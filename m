From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] ext4: add a line break for proc mb_groups display
Date: Wed, 3 Feb 2016 12:07:06 -0800
Message-ID: <20160203200706.GG22352@birch.djwong.org>
References: <1454505546-4875-1-git-send-email-huaitong.han@intel.com>
 <20160203181356.GA5842@birch.djwong.org>
 <1454524232.7291.105.camel@perches.com>
 <20160203193233.GB5842@birch.djwong.org>
 <1454528313.7291.115.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Huaitong Han <huaitong.han@intel.com>, tytso@mit.edu,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51897 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264AbcBCUMU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Feb 2016 15:12:20 -0500
Content-Disposition: inline
In-Reply-To: <1454528313.7291.115.camel@perches.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 03, 2016 at 11:38:33AM -0800, Joe Perches wrote:
> On Wed, 2016-02-03 at 11:32 -0800, Darrick J. Wong wrote:
> > On Wed, Feb 03, 2016 at 10:30:32AM -0800, Joe Perches wrote:
> > > On Wed, 2016-02-03 at 10:13 -0800, Darrick J. Wong wrote:
> > > > On Wed, Feb 03, 2016 at 09:19:06PM +0800, Huaitong Han wrote:
> > > > > This patch adds a line break for proc mb_groups display.
> > >=20
> > > Using 2 lines for output might break any existing users.
> > >=20
> > > Are there any?
> >=20
> > It's a multiline file if you have more than one blockgroup; this ju=
st makes it
> > so that you don't have to special-case BG 0.
>=20
> And existing scripts might do that now and might fail
> to do properly after this change.

Or they might have sed -e 's/]#0/]\n#0/g' in which case they won't be a=
ffected.

> > IOW: mb_groups scripts already had to parse multiple lines, and mos=
t likely any
> > script parsing it would inject a newline after the header.
>=20
> I've no dog in this fight really. =A0I just wanted to make
> it clear that this could cause existing scripts to fail.
>=20
> proc output is supposed to be unchanging except maybe
> adding new fields to existing lines.
>=20
> Your choice.

Ted's, really.  I have no idea which scripts do with various per-fs /pr=
oc
files.  Usually poking in mb_groups is only done as part of failure rep=
ort data
collection to see what's mucked up the fs this time.

Anyway, I'll defer to the maintainer. :)

--D

>=20
> cheers, Joe
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
