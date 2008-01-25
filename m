From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC] Parallelize IO for e2fsck
Date: Fri, 25 Jan 2008 04:09:42 -0700
Message-ID: <20080125110942.GX18433@webber.adilger.int>
References: <9Mo9w-7Ws-23@gated-at.bofh.it> <9OdWm-7uN-25@gated-at.bofh.it>
 <9Oi9A-5EJ-3@gated-at.bofh.it> <9OiMg-6IC-1@gated-at.bofh.it>
 <9OlqL-2xG-3@gated-at.bofh.it> <9Orda-3ub-45@gated-at.bofh.it>
 <E1JI5vz-0001GG-Vs@be1.7eggert.dyndns.org>
 <20080124230809.GA29120@does.not.exist> <20080124234037.GJ15858@mit.edu>
 <1201220742.7557.10.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@MIT.EDU>, Adrian Bunk <bunk@kernel.org>,
	Bodo Eggert <7eggert@gmx.de>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Valdis.Kletnieks@vt.edu,
	David Chinner <dgc@sgi.com>,
	Valerie Henson <val@vahconsulting.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Ric Wheeler <ric@emc.com>
To: Zan Lynx <zlynx@acm.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:61457 "EHLO
	pd4mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759563AbYAYUX7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Jan 2008 15:23:59 -0500
In-reply-to: <1201220742.7557.10.camel@localhost>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jan 24, 2008  17:25 -0700, Zan Lynx wrote:
> Have y'all been following the /dev/mem_notify patches?
> http://article.gmane.org/gmane.linux.kernel/628653

Having the notification be via poll() is a very restrictive processing
model.  Having the notification be via a signal means that any kind of
process (and not just those that are event loop driven) can register
a callback at some arbitrary point in the code and be notified.  I
don't object to the poll() interface, but it would be good to have a
signal mechanism also.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
