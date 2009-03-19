From: Ron Peterson <rpeterso@mtholyoke.edu>
Subject: Re: old/new ext3 compatibility
Date: Thu, 19 Mar 2009 18:02:24 -0400
Message-ID: <20090319220224.GM3634@mtholyoke.edu>
References: <20090319184501.GG3634@mtholyoke.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from depot.mtholyoke.edu ([138.110.1.83]:53027 "EHLO
	depot.mtholyoke.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388AbZCSWCf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Mar 2009 18:02:35 -0400
Received: from ice.mtholyoke.edu (ice.mtholyoke.edu [138.110.1.25])
	by depot.mtholyoke.edu (8.13.8/8.13.8/Debian-3) with ESMTP id n2JM2OBv014528
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Thu, 19 Mar 2009 18:02:24 -0400
Received: from chip.mtholyoke.edu (chip.mtholyoke.edu [138.110.1.70])
	by ice.mtholyoke.edu (8.13.4/8.13.4/Debian-3sarge3) with ESMTP id n2JM2O5C015109
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Thu, 19 Mar 2009 18:02:24 -0400
Received: from chip.mtholyoke.edu (rpeterso@localhost [127.0.0.1])
	by chip.mtholyoke.edu (8.13.8/8.13.8/Debian-3) with ESMTP id n2JM2OAw031315
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Thu, 19 Mar 2009 18:02:24 -0400
Received: (from rpeterso@localhost)
	by chip.mtholyoke.edu (8.13.8/8.13.8/Submit) id n2JM2OoN031311
	for linux-ext4@vger.kernel.org; Thu, 19 Mar 2009 18:02:24 -0400
Content-Disposition: inline
In-Reply-To: <20090319184501.GG3634@mtholyoke.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2009-03-19_14:45:02-0400 rpeterso:
> As I understand it, debian lenny's ext3 filesystem uses 256 byte inodes,
> to be forward compatible with ext4.
> 
> I have a production server running debian etch.  It is attached to a
> fiber channel array, on which it has several ext3 filesystems.  I'm
> installing a new server, and I'd like to use lenny.  It will be attached
> to the same array, and I'd like to be able to occasionally use the ext3
> filesystems created previously.  Ideally, I'd also like to go the other
> direction as well.  Is this possible, or just crazy talk?

If I understand what I'm reading correctly, this is a non-problem.  Any
recent 2.6 kernel should understand ext3 filesystems with 256 byte
inodes just fine.  The only thing that has happened is that the latest
debian stable defaults to using 256 byte inodes rather than 128.  Is
that correct?  Are there any gotcha's here that I should be aware of?

TIA

-- 
Ron Peterson
Network & Systems Manager
Mount Holyoke College
http://www.mtholyoke.edu/~rpeterso
facebook: http://tinyurl.com/d63r5c
