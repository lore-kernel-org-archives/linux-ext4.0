From: hooanon05@yahoo.co.jp
Subject: Re: [PATCH] ext34: ensure do_split leaves enough free space in both blocks
Date: Tue, 18 Sep 2007 09:16:08 +0900
Message-ID: <E1IXQl6-0000wx-6U@jroun>
References: <46EEA5F4.3030806@redhat.com> <46EEB7A4.9040903@sandeen.net> <20070917133020.5fc4650c.akpm@linux-foundation.org> <20070917205738.GQ2990@schatzie.adilger.int>
To: Andrew Morton <akpm@linux-foundation.org>,
	Eric Sandeen <sandeen@sandeen.net>,
	Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758264AbXIRAQi@vger.kernel.org>
In-Reply-To: <20070917205738.GQ2990@schatzie.adilger.int>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Andreas Dilger:
> > So this looks like 2.6.22 and 2.6.23 material, but the timing is getting
> > pretty squeezy.  Could people please give this change an extra-close
> > review, let me know?
> 
> I already discussed it at length with Eric and inspected the patch, so we
> could add:
> Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
> 
> Haven't actually tested the code myself.

I've just tested the patch on linux-2.6.23-rc6 (i386) with the test
program I posted a few months ago, and found it solved the problem.
Thank you very much Eric Sandeen, Andreas Dilger and all in ML.

Junjiro Okajima
