From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix blkdev_issue_flush() failure handling
Date: Mon, 30 Mar 2009 10:25:18 -0400
Message-ID: <20090330142518.GI13356@mit.edu>
References: <200903291928.14451.bzolnier@gmail.com> <49CFB33A.9020406@redhat.com> <20090330022521.GB13356@mit.edu> <49D03AE1.8070009@redhat.com> <1238413667.30488.2.camel@think.oraclecorp.com> <49D0C29C.1060307@uvigo.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Chris Mason <chris.mason@oracle.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao <flvazquez@uvigo.es>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:56089 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181AbZC3OZl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Mar 2009 10:25:41 -0400
Content-Disposition: inline
In-Reply-To: <49D0C29C.1060307@uvigo.es>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 30, 2009 at 10:01:16PM +0900, Fernando Luis V=E1zquez Cao w=
rote:
>
> Chris, I have just sent patches that attempt to fix both ext3 and
> ext4 while also adding a per-device sysfs knob tu disable
> write-flushes. A previous version of this patch set added a new
> generic mount option but comments from Christoph and others
> convinced me to turn it into a per-device tunable. Could you take
> a look at the patches?

=46ernando, see my comments on those patches.  We don't need to issue a
barrier after a call to sync_inode() or ext[34]_force_commit(), since
those functions will issue a barrier for us.  It would probably be a
good idea to use blktrace to test and make sure that we have one and
exactly one barrier op issued for each fsync().

						- Ted

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
