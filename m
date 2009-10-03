From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: kernel BUG at fs/ext4/inode.c:1184!
Date: Sat, 3 Oct 2009 13:15:15 +0200
Message-ID: <20091003111515.GA2032@phenom2.trippelsdorf.de>
References: <4AC71ECC.2020104@infracom.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, tytso@mit.edu,
	adilger@sun.com, linux-ext4@vger.kernel.org,
	torvalds@linux-foundation.org
To: Roberto Oppedisano <roberto.oppedisano@infracom.it>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755201AbZJCLPU@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4AC71ECC.2020104@infracom.it>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Oct 03, 2009 at 11:52:12AM +0200, Roberto Oppedisano wrote:
> This is 100% reproducible on current git kernel.
> After hitting the BUG the machine is still alive, but some processes
> refuse to start and /bin/sync stalls forever.
> Last known good kernel is 2.6.32-rc2-00087-g9c1fe83.
> 
> [   74.971246] ------------[ cut here ]------------
> [   74.971303] kernel BUG at fs/ext4/inode.c:1184!

This is already fixed, see:
http://marc.info/?l=linux-ext4&m=125437926005433&w=4

Unfortunately Linus has not pulled the fix yet.
-- 
Markus
