From: "news.gmane.org" <francois.valenduc@tvcablenet.be>
Subject: Re: Wrong calculation of space remaining on a 32 bit system.
Date: Sun, 02 Nov 2008 22:46:25 +0100
Message-ID: <490E1FB1.8020100@tvcablenet.be>
References: <490DBBD9.9040300@tvcablenet.be> <20081102204352.GJ8134@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mirapoint7.brutele.be ([212.68.199.151]:7800 "EHLO
	mirapoint7.brutele.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171AbYKBVqt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Nov 2008 16:46:49 -0500
In-Reply-To: <20081102204352.GJ8134@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso a =E9crit :
> On Sun, Nov 02, 2008 at 03:40:25PM +0100, Fran=E7ois Valenduc wrote:
>> I have already filed a bug report (see
>> http://bugzilla.kernel.org/show_bug.cgi?id=3D11840) but unfortunatel=
y,
>> nobody seems to care about it.
>=20
> Hi,
>=20
> 	Sorry no one responded, but while the Bugzilla system is great
> for tracking bugs, it's not a good place to call attention to a bug.
> In fact, I'm not sure that fs_ext4@kernel-bugs.osdl.org forwards
> anywhere sane (I'm checking up on that, though).  In general it's a
> good idea by sending e-mail to either linux-kernel@vger.kernel.org or
> (preferred) linux-ext4@vger.kernel.org.
>=20
> 	From your description, the ext4 filesystem thought there was
> some kind of on-disk corruption or other problem with your filesystem=
,
> and remounted it read-only.  That's consistent with your report of th=
e
> messages in the syslog of:
>=20
> ext4_da_writepages: jbd2_start: 1024 pages, ino 40898; err -30
>=20
> There should have been something in your logs *before* all of the err
> -30 complaints, however.  Was this your root filesystem, or do you
> have this saved in logfile in /var/log?  If so, can you search back
> for something that occurs before all of the ext4_da_writepages error
> messages?
>=20
> 							- Ted

Thanks for your reply.
In fact, the errors I mentionned don't occur anymore. But the problem o=
f
  the diskspace remains. I never managed until now to use more than one
third of a partition on a 32 bit system. After that, I always get a
message saying that the partition is full, which can't be true.

=46ran=E7ois
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
