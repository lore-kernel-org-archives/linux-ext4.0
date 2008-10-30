From: "Curt Wohlgemuth" <curtw@google.com>
Subject: Ext4 patches for 2.6.26?
Date: Thu, 30 Oct 2008 11:49:07 -0700
Message-ID: <6601abe90810301149g72f48f3y8bf3bda864337f92@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:30838 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbYJ3StM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Oct 2008 14:49:12 -0400
Received: from spaceape9.eur.corp.google.com (spaceape9.eur.corp.google.com [172.28.16.143])
	by smtp-out.google.com with ESMTP id m9UInA6X021634
	for <linux-ext4@vger.kernel.org>; Thu, 30 Oct 2008 11:49:11 -0700
Received: from fk-out-0910.google.com (fks18.prod.google.com [10.94.19.18])
	by spaceape9.eur.corp.google.com with ESMTP id m9UIn8nF027582
	for <linux-ext4@vger.kernel.org>; Thu, 30 Oct 2008 11:49:09 -0700
Received: by fk-out-0910.google.com with SMTP id 18so561326fks.7
        for <linux-ext4@vger.kernel.org>; Thu, 30 Oct 2008 11:49:08 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi:

I'm working on a kernel tree based on 2.6.26, with patches from

        http://www2.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/2.6.26-ext4-6/

applied as well.  I'm trying to update our tree to a more recent set
of ext4 patches, and am having difficulty.

Is there a simple recipe for this?  Or am what I'm trying to do (use
latest patches with an older kernel) just asking for trouble?  Trying
to apply the patches at

        http://www2.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/2.6.26-ext4-7/

doesn't work, since this is a superset of what's in 2.6.26-ext4-6,
most of which we have applied already.

Thanks,
Curt
