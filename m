From: Alexey Fisher <bug-track@fisher-privat.net>
Subject: Re: Formatted/repartitioned wrong disk, arrgh!
Date: Fri, 06 Nov 2009 15:43:56 +0100
Message-ID: <1257518636.19442.8.camel@zwerg>
References: <4AF3F82D.50105@elector.dk>
	 <87a8dc10911060249i16b6da5t21e916811938e5b5@mail.gmail.com>
	 <4AF40D60.1080503@elector.dk>
	 <87a8dc10911060357r27131f36r3351497b38e18a39@mail.gmail.com>
	 <20091106140415.GA26342@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Alexey Salmin <alexey.salmin@gmail.com>,
	Jesper Jensen <linux-ext4_mailinglist@elector.dk>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:55029 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757417AbZKFOnx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Nov 2009 09:43:53 -0500
In-Reply-To: <20091106140415.GA26342@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Am Freitag, den 06.11.2009, 09:04 -0500 schrieb Theodore Tso:
> On Fri, Nov 06, 2009 at 05:57:14PM +0600, Alexey Salmin wrote:
> > I think the only thing I can recommend to you is to "grep for your
> > files and hope for the best" (c)
> > I don't know any automated way to restore files after complete
> > destroying of fs, but there always is grep and hexdump :)
> 
> Unfortunately, there isn't much else that can be done, since the inode
> table has been zero'ed out.

Do _not_ever_ change the disk after crush or what ever you did with it.
Make an image of your partition (dd if=/dev/you_partition
of=backup_of_partition) and try testdisk (photoreck) and/or sleuthkit.

	Alexey 

