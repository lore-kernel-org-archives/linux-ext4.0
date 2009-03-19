From: Ron Peterson <rpeterso@mtholyoke.edu>
Subject: old/new ext3 compatibility
Date: Thu, 19 Mar 2009 14:45:02 -0400
Message-ID: <20090319184501.GG3634@mtholyoke.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from depot.mtholyoke.edu ([138.110.1.83]:46411 "EHLO
	depot.mtholyoke.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbZCSTDo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Mar 2009 15:03:44 -0400
Received: from ice.mtholyoke.edu (ice.mtholyoke.edu [138.110.1.25])
	by depot.mtholyoke.edu (8.13.8/8.13.8/Debian-3) with ESMTP id n2JIj310013729
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Thu, 19 Mar 2009 14:45:08 -0400
Received: from chip.mtholyoke.edu (chip.mtholyoke.edu [138.110.1.70])
	by ice.mtholyoke.edu (8.13.4/8.13.4/Debian-3sarge3) with ESMTP id n2JIj2M2004523
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Thu, 19 Mar 2009 14:45:03 -0400
Received: from chip.mtholyoke.edu (rpeterso@localhost [127.0.0.1])
	by chip.mtholyoke.edu (8.13.8/8.13.8/Debian-3) with ESMTP id n2JIj2iV020229
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Thu, 19 Mar 2009 14:45:02 -0400
Received: (from rpeterso@localhost)
	by chip.mtholyoke.edu (8.13.8/8.13.8/Submit) id n2JIj2AR020165
	for linux-ext4@vger.kernel.org; Thu, 19 Mar 2009 14:45:02 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As I understand it, debian lenny's ext3 filesystem uses 256 byte inodes,
to be forward compatible with ext4.

I have a production server running debian etch.  It is attached to a
fiber channel array, on which it has several ext3 filesystems.  I'm
installing a new server, and I'd like to use lenny.  It will be attached
to the same array, and I'd like to be able to occasionally use the ext3
filesystems created previously.  Ideally, I'd also like to go the other
direction as well.  Is this possible, or just crazy talk?

TIA

-- 
Ron Peterson
Network & Systems Manager
Mount Holyoke College
http://www.mtholyoke.edu/~rpeterso
facebook: http://tinyurl.com/d63r5c
