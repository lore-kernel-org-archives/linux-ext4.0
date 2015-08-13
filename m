From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: fsync stuck at jbd2_log_wait_commit on NVMe devices
Date: Thu, 13 Aug 2015 09:09:53 -0400
Message-ID: <20150813130953.GA26095@thunk.org>
References: <COL130-W652BF73D365EBB4F3DDF69D67E0@phx.gbl>
 <20150812183750.GB3373@thunk.org>
 <COL130-W95F37DFE0CBD0ED0680AABD67E0@phx.gbl>
 <COL130-W3988F47C3C020C3E2D5C38D67E0@phx.gbl>
 <20150812223456.GC3373@thunk.org>
 <COL130-W737C0A6D747C8E035546EED67E0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Roy Yang <bsdnet@outlook.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56712 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692AbbHMNJ4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Aug 2015 09:09:56 -0400
Content-Disposition: inline
In-Reply-To: <COL130-W737C0A6D747C8E035546EED67E0@phx.gbl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 12, 2015 at 04:34:17PM -0700, Roy Yang wrote:
> Hi Ted,=A0
>=20
> =A0 =A0Appreciate your time, and will get the log from normal work lo=
ad.
>=20
> =A0 =A0BTW, the previous JBD2 log is from the node which is in bad st=
ate.=A0
> =A0 Normal node finish within 3 seconds; while on this node, it takes=
 10 seconds.

Ah, you didn't say that.

If this is a node in a bad state, and we're not seeing any real delays
from the jbd2 logs, then it sounds very much like the problem is a
hardware issue (or maybe an NVMe device driver issue).  You might want
to use blktrace to see how long the underlying I/O operations are
taking to complete.

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
