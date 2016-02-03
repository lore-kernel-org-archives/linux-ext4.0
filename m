From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] ext4: add a line break for proc mb_groups display
Date: Wed, 03 Feb 2016 11:38:33 -0800
Message-ID: <1454528313.7291.115.camel@perches.com>
References: <1454505546-4875-1-git-send-email-huaitong.han@intel.com>
	 <20160203181356.GA5842@birch.djwong.org>
	 <1454524232.7291.105.camel@perches.com>
	 <20160203193233.GB5842@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Huaitong Han <huaitong.han@intel.com>, tytso@mit.edu,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160203193233.GB5842@birch.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2016-02-03 at 11:32 -0800, Darrick J. Wong wrote:
> On Wed, Feb 03, 2016 at 10:30:32AM -0800, Joe Perches wrote:
> > On Wed, 2016-02-03 at 10:13 -0800, Darrick J. Wong wrote:
> > > On Wed, Feb 03, 2016 at 09:19:06PM +0800, Huaitong Han wrote:
> > > > This patch adds a line break for proc mb_groups display.
> >=20
> > Using 2 lines for output might break any existing users.
> >=20
> > Are there any?
>=20
> It's a multiline file if you have more than one blockgroup; this just=
 makes it
> so that you don't have to special-case BG 0.

And existing scripts might do that now and might fail
to do properly after this change.

> IOW: mb_groups scripts already had to parse multiple lines, and most =
likely any
> script parsing it would inject a newline after the header.

I've no dog in this fight really. =A0I just wanted to make
it clear that this could cause existing scripts to fail.

proc output is supposed to be unchanging except maybe
adding new fields to existing lines.

Your choice.

cheers, Joe
