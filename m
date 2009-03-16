From: Jan Kara <jack@suse.cz>
Subject: Same magic in statfs() call for ext?
Date: Mon, 16 Mar 2009 14:36:16 +0100
Message-ID: <20090316133615.GA10596@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:33499 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539AbZCPNgU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Mar 2009 09:36:20 -0400
Received: from Relay2.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 5C7F55E516
	for <linux-ext4@vger.kernel.org>; Mon, 16 Mar 2009 14:36:17 +0100 (CET)
Received: from duck.suse.cz (duck.suse.cz [10.20.1.74])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.suse.cz (Postfix) with ESMTP id 0A6FB628061
	for <linux-ext4@vger.kernel.org>; Mon, 16 Mar 2009 14:36:17 +0100 (CET)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

  I've just noticed that EXT2_SUPER_MAGIC == EXT3_SUPER_MAGIC ==
EXT4_SUPER_MAGIC. That is just fine for the disk format but as a result we
also return the same magic in statfs() syscall and thus a simple
application has hard time recognizing whether it works on ext2, ext3 or
ext4 (it would have to parse /proc/mounts and that is non-trivial if not
impossible when it comes to bind mounts). So should not we return different
magic numbers depending on how the filesystem is currently mounted?
  Now you may ask why should the application care - and I agree that in the
ideal world it should not. But for example there's a thread on GTK mailing
list [1] where they discuss the problem that with delayed allocation and
ext4, user can easily lose his data after crash (Ted wrote about it here in
some other mail some time ago). So they would like to call fsync() after
the file is written but on ext3 that is quite heavy and because of autosave
saving happens quite often. So they'd do fsync() only if the filesystem
is mounted as ext4...
  So I'm writing here so hear some opinions on returning different magic
numbers from statfs().

								Honza

[1] http://mail.gnome.org/archives/gtk-devel-list/2009-March/msg00082.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
