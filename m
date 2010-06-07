From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: 2.6.35-rc2 regression
Date: Mon, 7 Jun 2010 08:32:46 +0200
Message-ID: <20100607063246.GA1829@arch.tripp.de>
References: <20100606081601.GA1807@arch.tripp.de>
 <DB34C7CA-53EC-47B0-AD31-4C729B983C11@mit.edu>
 <20100606115947.GA1783@arch.tripp.de>
 <20100606172339.GA1778@arch.tripp.de>
 <alpine.LFD.2.00.1006062036240.3515@i5.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@MIT.EDU>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-195.synserver.de ([212.40.180.195]:1032 "HELO
	smtp-out-195.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753912Ab0FGGct (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Jun 2010 02:32:49 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1006062036240.3515@i5.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jun 06, 2010 at 08:38:17PM -0700, Linus Torvalds wrote:
> 
> 
> On Sun, 6 Jun 2010, Markus Trippelsdorf wrote:
> 
> > On Sun, Jun 06, 2010 at 01:59:47PM +0200, Markus Trippelsdorf wrote:
> > > On Sun, Jun 06, 2010 at 07:45:48AM -0400, Theodore Tso wrote:
> > > > 
> > > > On Jun 6, 2010, at 4:16 AM, Markus Trippelsdorf wrote:
> > > > 
> > > > > Commit 1f5a81e41f8b1a782c68d3843e9ec1bfaadf7d72
> > > > > "ext4: Make sure the MOVE_EXT ioctl can't overwrite append-only files"
> > > > > causes the following kernel BUG on my machine (x86_64):
> > > > > 
> > > > > BUG: Bad page map in process mpd  pte:720072000000000 pmd:11d2f7067
> 
> This is the same "VGA pattern": 07200720 is two spaces. 
> 
> It causes lots of trouble, too bad it made it into -rc2. It has nothing to 
> do with ext4.
> 
> And I bet it gets fix by the same vt.c patch that apparently fixed some 
> KMS issues. Look on lkml for a "poison overwritten" subject line.
> 
> Or just revert 962400e8fd29981a7b166e463dd143b6ac6a3e76.

Yes, I applied the patch early this morning and had no issues thus far.

-- 
Markus
