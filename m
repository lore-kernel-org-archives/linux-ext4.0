From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: ext2/3: document conditions when reliable operation is possible
Date: Sat, 29 Aug 2009 14:04:28 +0100
Message-ID: <20090829140428.282c27a4@lxorguk.ukuu.org.uk>
References: <20090312092114.GC6949@elf.ucw.cz>
	<200903121413.04434.rob@landley.net>
	<4A98854E.9020302@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Rob Landley <rob@landley.net>, Pavel Machek <pavel@ucw.cz>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	tytso@mit.edu, rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Robert Hancock <hancockrwd@gmail.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <4A98854E.9020302@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> I've heard rumors of disks that claim to support cache flushes but 
> really just ignore them, but have never heard any specifics of model 
> numbers, etc. which are known to do this, so it may just be legend. If 
> we do have such knowledge then we should really be blacklisting those 
> drives and warning the user that we can't ensure data integrity. (Even 
> powering down the system would be unsafe in this case.)

This should not be the case for any vaguely modern drive. The standard
requires the drive flushes the cache if sent the command and the size of
caches on modern drives rather require it.

Alan
