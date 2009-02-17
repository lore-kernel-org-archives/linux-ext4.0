From: Alex Buell <alex.buell@munted.org.uk>
Subject: Re: EXT4 ENOSPC Bug
Date: Tue, 17 Feb 2009 17:21:15 +0000
Message-ID: <20090217172115.7a42044a@lithium.local.net>
References: <20090216162028.3032666a@lithium.local.net>
	<200811291418.24672.andres@anarazel.de>
	<200812100108.04163.andres@anarazel.de>
	<49994FEF.2020908@anarazel.de>
	<20090216150156.GD22619@mini-me.lan>
	<499985C7.8010302@anarazel.de>
	<20090216190001.GB11788@mini-me.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Andres Freund <andres@anarazel.de>, adilger@sun.com,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	Jonathan Bastien-Filiatrault <joe@x2a.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753707AbZBQRVq@vger.kernel.org>
In-Reply-To: <20090216190001.GB11788@mini-me.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 16 Feb 2009 14:00:01 -0500, I waved a wand and this message
magically appears in front of Theodore Tso:

> On Mon, Feb 16, 2009 at 04:27:03PM +0100, Andres Freund wrote:
> >
> > So, yes, seems to be an inode allocation problem.
> 
> Andres, Alex, others,
> 
> I'm pretty sure the ENOSPC problem which you both found is an inode
> allocation problem.  Some of you seem to have an easier time
> reproducing it than others; could you try this patch, and periodically
> scan your system logs for the message "ext4: find_group_flex failed,
> fallback succeeded"?  If the problem goes away for you, and you find
> the occasional aforemention message in your system log, that will
> confirm what I suspect, which is the bug is in fs/ext4/inode.c's
> find_group_flex() function.  (If I'm wrong, the fallback code will
> activate only when the filesystem is genuinely out of inodes, which
> should be very rare.)

OK, I had to go look through the archives on linux-ext4 mailing list to
see what the context was. For myself, this used to happen at least once
a week with 2.6.26, and less frequently with 2.6.27. I think that 2.6.28
with your patch should get rid of that problem altogether. I will of
course get in touch should I see any more of these find_group_flex
failures as that would mean your patch worked. 

Thanks for your work on tracking this one down!
-- 
http://www.munted.org.uk

Fearsome grindings.
