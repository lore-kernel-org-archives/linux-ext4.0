From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: Does ext4 send FUA to flush disk cache
Date: Sun, 10 Apr 2011 08:17:58 -0400
Message-ID: <DE099CBA-6478-4651-B3E5-F406D0C11C3D@mit.edu>
References: <BANLkTikmryaO5r012VwsNzhcaaVQ_4QfzA@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Mark Busheman <markbusheman@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:48511 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753382Ab1DJMRq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Apr 2011 08:17:46 -0400
In-Reply-To: <BANLkTikmryaO5r012VwsNzhcaaVQ_4QfzA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Apr 8, 2011, at 6:02 PM, Mark Busheman wrote:

> I plan to use data=journal option with ext4. Would like to know if
> ext4 send FUA (Forced Unit Access)
> to flush the disk cache?

FUA doesn't cause a cache flush.   Ext4 does send cache flush commands, or barriers, to make sure the data written to disk is flushed all the way down to the disk platters on transaction commits.

-- Ted

