From: Stephan Kulow <coolo@suse.de>
Subject: buggy_init_scritps and e2fsprogs 1.41.9
Date: Thu, 10 Sep 2009 14:55:38 +0200
Message-ID: <200909101455.38400.coolo@suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58030 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007AbZIJMzg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Sep 2009 08:55:36 -0400
Received: from relay2.suse.de (mail2.suse.de [195.135.221.8])
	by mx2.suse.de (Postfix) with ESMTP id EDCC986445
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2009 14:55:38 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I face a bug in openSUSE since I updated to 1.41.9: you have
to manually fix your file system if you happened to mount the
file system in the wrong timezone on a machine using localtime
hardware clock.

Now this happens very easily if you boot a live cd and mount
your system from the live cd - but fsck will _not_ correct the
problem ;(

The release notes of 1.41.9 talk only about the exact opposite
case: "Fix e2fsck's buggy_init_scritps=1 so that the if the last 
write and/or last mount times are in the future, they are corrected 
even if buggy_init_scripts is set."

I don't want to set buggy_init_scripts for openSUSE as the init
scripts are not buggy, but a live cd is a live cd and has no idea
what the timezone of the system is configured to and even a ro
mount will destroy your file system ;(

Greetings, Stephan

