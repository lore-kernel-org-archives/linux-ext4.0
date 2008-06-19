From: Theodore Tso <tytso@mit.edu>
Subject: Re: Performance of ext4
Date: Thu, 19 Jun 2008 11:56:45 -0400
Message-ID: <20080619155645.GA8582@mit.edu>
References: <18513.345.553912.449710@frecb006361.adech.frec.bull.fr> <Pine.LNX.4.64.0806121154090.27806@diagnostix.dwd.de> <20080612131928.GB18229@mit.edu> <Pine.LNX.4.64.0806121333480.27806@diagnostix.dwd.de> <20080612180605.GD22481@skywalker> <Pine.LNX.4.64.0806121940020.2974@diagnostix.dwd.de> <Pine.LNX.4.64.0806130753100.7097@diagnostix.dwd.de> <20080616175408.GF3279@atrey.karlin.mff.cuni.cz> <20080616181353.GA20686@skywalker> <Pine.LNX.4.64.0806171001200.6307@diagnostix.dwd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Jan Kara <jack@suse.cz>, Solofo.Ramangalahy@bull.net,
	Nick Dokos <nicholas.dokos@hp.com>, linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:45778 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751185AbYFSP6D (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Jun 2008 11:58:03 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0806171001200.6307@diagnostix.dwd.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 17, 2008 at 11:42:36AM +0000, Holger Kiehl wrote:
> Note how the size of file results.24033.helena.dwd.de changes from
> 9230 before the test to 8208 bytes after the test. Also note the
> date both have the same timestamp "2008-06-17 04:35". I have made a
> copy of results.24033.helena.dwd.de before the test and compared it
> with that after the test. The file is just truncated by 1022 bytes
> and there is no garbage.

So the corruption is always a truncation, correct?

Did you notice the problem with ext4 w/o the patch queue?  I have a
suspicion that the problem may have been introduced by the delayed
allocation code, but I don't have hard evidence.  When you rerun your
benchmark (which seems to be the closest thing we have to a
reproduction case), it would be interesting to know if the problem
goes away with -o nodelalloc (again, it would localize where we need
to look).

Thanks, regards,

						- Ted
