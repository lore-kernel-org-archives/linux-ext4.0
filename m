From: Matt Mackall <mpm@selenic.com>
Subject: Re: Add a norecovery option to ext3/4?
Date: Tue, 10 Apr 2007 11:44:51 -0500
Message-ID: <20070410164451.GC10459@waste.org>
References: <20070409000556.GA13980@implementation> <461A5F13.7040705@cfl.rr.com> <461A760B.1040103@redhat.com> <20070410072253.GA28665@lazybastard.org> <20070410112718.GF13650@thunk.org> <20070410120825.GA29487@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Phillip Susi <psusi@cfl.rr.com>,
	Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1031158AbXDJQ60@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070410120825.GA29487@lazybastard.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Apr 10, 2007 at 02:08:26PM +0200, J=F6rn Engel wrote:
> On Tue, 10 April 2007 07:27:18 -0400, Theodore Tso wrote:
> >=20
> > I suppose what you could do is to read in the journal, and use it t=
o
> > create an remapping table so that when you want to read block #5126=
,
> > and block number 5126 is in the journal, to read the journal versio=
n
> > of the block instead of the one on disk.  That would allow for safe
> > access to a filesystem being mounted read-only without the journal
> > being present.
>=20
> Another option would be to access the medium through a mapping inode,
> replay the journal into the mapping inode and _not_ flush the dirty
> pages.  But as long as a remapping table is sufficient for ext3 journ=
al
> format, such a table should be simpler and faster.

Or you could make a snapshot with device-mapper and then mount it.
Requires some free disk space somewhere (or a hack with loop on
tmpfs), but should be doable today.

--=20
Mathematics is the supreme nostalgia of our time.
