From: Jan Kara <jack@suse.cz>
Subject: Re: EXT4 regression caused 4eec7
Date: Mon, 13 May 2013 19:01:24 +0200
Message-ID: <20130513170124.GJ400@quack.suse.cz>
References: <6719519.5821368147110937.JavaMail.weblogic@epml17>
 <20130510192747.GA11707@thunk.org>
 <87y5bm53z3.fsf@openvz.org>
 <87txm96fkd.fsf@openvz.org>
 <87mws1eq6y.fsf@openvz.org>
 <20130511230559.GD26298@thunk.org>
 <87a9o01siw.fsf@openvz.org>
 <51911604.2060805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	Theodore Ts'o <tytso@mit.edu>,
	EUNBONG SONG <eunb.song@samsung.com>, Jan Kara <jack@suse.cz>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59080 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912Ab3EMRB3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 May 2013 13:01:29 -0400
Content-Disposition: inline
In-Reply-To: <51911604.2060805@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 13-05-13 11:34:12, Eric Sandeen wrote:
> On 5/12/13 4:01 AM, Dmitry Monakhov wrote:
> > In fact '4eec70' are vexing because I have reviewed and tested this patch before
> > it was marked as Review-by, but missed the bug. This is because xfstests
> > was executed manually logs was full of warnings but tainted flag was not
> > checked at the end. 
> 
> Can you elaborate on this?  What was logged, and is it something we could
> try to pick up post-test in xfstests?
  Generally I think it might be useful if xfstests would fail / warn if
kernel became tainted during the test (e.g. due to WARN_ON or oops, or
something like that). It should be even relatively easy to implement
(just compare /proc/sys/kernel/tainted before and after each test).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
