From: Jan Kara <jack@suse.cz>
Subject: Re: 2.6.18-mm2: ext3 BUG?
Date: Wed, 11 Oct 2006 12:42:02 +0200
Message-ID: <20061011104201.GD6865@atrey.karlin.mff.cuni.cz>
References: <45257A6C.3060804@gmail.com> <20061005145042.fd62289a.akpm@osdl.org> <4525925C.6060807@gmail.com> <20061005171428.636c087c.akpm@osdl.org> <20061008063330.GA30283@lug-owl.de> <20061010070933.GE30283@lug-owl.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:46040 "EHLO
	atrey.karlin.mff.cuni.cz") by vger.kernel.org with ESMTP
	id S1751175AbWJKKmR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Oct 2006 06:42:17 -0400
To: Andrew Morton <akpm@osdl.org>, Jiri Slaby <jirislaby@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	sct@redhat.com, adilger@clusterfs.com, linux-ext4@vger.kernel.org
Content-Disposition: inline
In-Reply-To: <20061010070933.GE30283@lug-owl.de>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> On Sun, 2006-10-08 08:33:30 +0200, Jan-Benedict Glaw <jbglaw@lug-owl.de> wrote:
> > On Thu, 2006-10-05 17:14:28 -0700, Andrew Morton <akpm@osdl.org> wrote:
> 
> > In one case, there was a test case mentioned. I'll run that on my
> > affected box in a non-productive LV, like this:
> > 
> > dd bs=1M count=200 if=/dev/zero of=test0
> > while :; do
> > 	echo "cp 0-1"; cp test0 test1 || break
> > 	echo "cp 1-2"; cp test1 test2 || break
> > 	echo "cp 2-3"; cp test2 test3 || break
> > 	echo "cp 3-4"; cp test3 test4 || break
> > 	echo "od 0" ; od test0 || break
> > 	echo "rm 1"; rm test1 || break
> > 	echo "rm 2"; rm test2 || break
> > 	echo "rm 3"; rm test3 || break
> > 	echo "rm 4"; rm test4 || break
> > done
> 
> While I could reproduce it with a 200MB file, it seems I can't break
> it with a 10MB file.
  Hmm, I was running the test for several ours without any problem...
The kernel is 2.6.17.6, ext3 in ordered data mode, standard SATA disk. I'm
now running it again and trying my luck ;). What is your testing environment?

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
