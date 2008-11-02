From: Theodore Tso <tytso@mit.edu>
Subject: Re: Wrong calculation of space remaining on a 32 bit system.
Date: Sun, 2 Nov 2008 15:43:52 -0500
Message-ID: <20081102204352.GJ8134@mit.edu>
References: <490DBBD9.9040300@tvcablenet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?iso-8859-1?Q?Fran=E7ois?= Valenduc
	<francois.valenduc@tvcablenet.be>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:35075 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753950AbYKBUny (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Nov 2008 15:43:54 -0500
Content-Disposition: inline
In-Reply-To: <490DBBD9.9040300@tvcablenet.be>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 02, 2008 at 03:40:25PM +0100, Fran=E7ois Valenduc wrote:
> I have already filed a bug report (see
> http://bugzilla.kernel.org/show_bug.cgi?id=3D11840) but unfortunately=
,
> nobody seems to care about it.

Hi,

	Sorry no one responded, but while the Bugzilla system is great
for tracking bugs, it's not a good place to call attention to a bug.
In fact, I'm not sure that fs_ext4@kernel-bugs.osdl.org forwards
anywhere sane (I'm checking up on that, though).  In general it's a
good idea by sending e-mail to either linux-kernel@vger.kernel.org or
(preferred) linux-ext4@vger.kernel.org.

	From your description, the ext4 filesystem thought there was
some kind of on-disk corruption or other problem with your filesystem,
and remounted it read-only.  That's consistent with your report of the
messages in the syslog of:

ext4_da_writepages: jbd2_start: 1024 pages, ino 40898; err -30

There should have been something in your logs *before* all of the err
-30 complaints, however.  Was this your root filesystem, or do you
have this saved in logfile in /var/log?  If so, can you search back
for something that occurs before all of the ext4_da_writepages error
messages?

							- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
