From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC] ext4: Add pollable sysfs entry for block threshold events
Date: Fri, 13 Mar 2015 11:05:22 -0400
Message-ID: <20150313150522.GA21922@thunk.org>
References: <1426068993-1051-1-git-send-email-b.michalska@samsung.com>
 <1426068993-1051-2-git-send-email-b.michalska@samsung.com>
 <alpine.LFD.2.00.1503111314230.11156@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Beata Michalska <b.michalska@samsung.com>,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
	linux-fsdevel@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1503111314230.11156@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Mar 11, 2015 at 03:12:25PM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
>=20
> I though you were advocating for a solution independent on the file
> system. This is ext4 only solution, but I do not really have
> anything against this.

It would be nice if we could have a fs-independent solution so that we
don't have to support the ext4-specific interface forever.  If we had
the thresholds set in struct super, and the file system were to call a
function defined in struct super_operations when the file system has
gotten too full, this wouldn't be all that hard.

The main issue is what is the proper generic way of notifying
userspace.  Using a pollable sysfs file is one way, although problem
with that is we don't yet have a standardized place to locate where,
given a particular mounted file system / block device, where to find
its hierarchy in the sysfs tree.  Right now we have
/sys/fs/<type>/... but that's owned by the file system and so it get's =
a
bit tricky to do something generic.

Other solutions might be to report file system full (and file system
corruption issues, etc.) via a netlink socket, or if we want to do
things in a systemd-complaint way, we could use the kernel-level dbus
approach which Greg K-H and company are pushing.  :-)

	       	    	    	    	- Ted
