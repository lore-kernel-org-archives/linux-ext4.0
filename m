From: Christoph Hellwig <hch@infradead.org>
Subject: Re: HUGE slowdown when doing dpkg with ext4 over nbd
Date: Wed, 7 Dec 2016 08:24:22 -0800
Message-ID: <20161207162422.GA11436@infradead.org>
References: <1621417488.8583313.1481030030711.JavaMail.zimbra@online.net>
 <78AEFE7B-685B-4B4E-A15E-E3F6D99DD343@dilger.ca>
 <1339224178.8897979.1481104368542.JavaMail.zimbra@online.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Renaud Mariana <rmariana@online.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41210 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752815AbcLGQYs (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Dec 2016 11:24:48 -0500
Content-Disposition: inline
In-Reply-To: <1339224178.8897979.1481104368542.JavaMail.zimbra@online.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We had a pretty similar issue lately with SCSI, and I suspect it's
something similar.  There are two interrelated issues:

 - dpkg uses fallocate where it absolutely shouldn't - it creates
   new files with typically a single write call, so fallocate doesn't
   help anything, but actively hurts.
 - For small enough regions ext4 does not create unwritten extents
   but zeroes data on disk, and whenever zeroing out the data is
   expensive this really shows up.  The SCSI case was a device
   that has a horrible slow WRITE_SAME implementation, but for nbd
   we'll just write the zero page repeatedly.

Patching out the stupid fallocate in dpkg will speed ext4 up a lot
(especially for small files) and will probably speed XFS up a tiny
bit as well.  But all my mails to the dpkg folks were simply ignored
unfortunately.
